import org.bytedeco.llvm.LLVM.*;
import org.bytedeco.llvm.global.LLVM;

import java.util.*;
import java.util.regex.*;

import static java.lang.Math.max;
import static org.bytedeco.llvm.global.LLVM.LLVMGetEntryBasicBlock;
import static org.bytedeco.llvm.global.LLVM.LLVMGetNamedFunction;

public class LLVMIRToRiscv {
    String file_path;
    LLVMModuleRef module;
    public static AsmBuilder asm = new AsmBuilder();
    RegisterAllocator allocator;
    int next_offset = 0;
    Map<String, String> value_stack_addr = new HashMap<>();

    public LLVMIRToRiscv(LLVMModuleRef moduleRef, String file_path) {
        this.module = moduleRef;
        this.file_path = file_path;
    }

    public static Set<String> extractVariables(String line) {
        Set<String> variables = new HashSet<>();
        Pattern pattern = Pattern.compile("%[a-zA-Z0-9_\\.]+");
        Matcher matcher = pattern.matcher(line);
        while (matcher.find()) {
            variables.add(matcher.group().substring(1));
        }
        return variables;
    }

    public void to_riscv() {
        emitGlobalVariables();
        asm.directive("text");
        asm.directive("globl main");
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            value_stack_addr = new HashMap<>();
            String funcName = LLVM.LLVMGetValueName(func).getString();
            asm.label(funcName);
            if ("main".equals(funcName)) asm.instr("addi", "sp", "sp", "-" + 2044);
            allocator = new GraphColoringRegisterAllocator(func);
            List<array_variable> array_variable_ref=new ArrayList<>();//在函数调用中参数涉及函数时会用到
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                String label = LLVM.LLVMGetBasicBlockName(bb).getString();
                asm.label(label);
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null && !inst.isNull(); inst = LLVM.LLVMGetNextInstruction(inst)) {
                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                    if(opcode==LLVM.LLVMGetElementPtr){//注意getelementptr的下标可能是变量
                        if(allocator.allocate(LLVM.LLVMGetValueName(inst).getString())==null) continue;
                        String variable_name = LLVM.LLVMGetValueName(inst).getString();
                        LLVMValueRef base_ptr = LLVM.LLVMGetOperand(inst, 0);
                        String array_name = LLVM.LLVMGetValueName(base_ptr).getString();
                        LLVMTypeRef base_type = LLVM.LLVMTypeOf(base_ptr);
                        LLVMTypeRef array_type = LLVM.LLVMGetElementType(base_type);
                        int array_dim = 0;
                        List<Integer> array_size = new ArrayList<>();
                        LLVMTypeRef current = array_type;
                        while (LLVM.LLVMGetTypeKind(current) == LLVM.LLVMArrayTypeKind) {
                            long len = LLVM.LLVMGetArrayLength(current);
                            array_size.add((int) len);
                            array_dim++;
                            current = LLVM.LLVMGetElementType(current);
                        }
                        int operand_count = LLVM.LLVMGetNumOperands(inst);
                        List<Object> cur_offset = new ArrayList<>();
                        for (int i = 1; i < operand_count; i++) {
                            LLVMValueRef index = LLVM.LLVMGetOperand(inst, i);
                            if (LLVM.LLVMIsAConstant(index) != null) {
                                long val = LLVM.LLVMConstIntGetZExtValue(index);
                                cur_offset.add((int) val);
                            } else {
                                String var_name = LLVM.LLVMGetValueName(index).getString();
                                cur_offset.add(var_name);
                            }
                        }
                        array_variable av = new array_variable(variable_name, array_name, array_dim, cur_offset, array_size);
                        array_variable_ref.add(av);
                    }
                    else if (opcode == LLVM.LLVMAlloca) {
                        LLVMTypeRef ty = LLVM.LLVMGetAllocatedType(inst);
                        if (LLVM.LLVMGetTypeKind(ty) == LLVM.LLVMArrayTypeKind) {
                            int total = 1;
                            while (LLVM.LLVMGetTypeKind(ty) == LLVM.LLVMArrayTypeKind) {
                                int len = LLVM.LLVMGetArrayLength(ty);
                                total *= len;
                                ty = LLVM.LLVMGetElementType(ty);
                            }
                            if(value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", total))==null) next_offset += total;
                        } else if (allocator.allocate(LLVM.LLVMGetValueName(inst).getString()).equals("stack")) {
                            if(value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset))==null) next_offset += 4;
                        }
                    } else if (opcode == LLVM.LLVMStore) {
                        LLVMValueRef val = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 1);
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(ptr).getString());
                        if(addr.isEmpty()) continue;
                        String valReg = evaluate(val);
                        if (addr != null) {
                            if (addr.contains("stack")) {
                                if(value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset))==null) next_offset+=4;
                                asm.instr("sw", valReg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                            } else  asm.instr("mv", addr, valReg);
                        } else {
                            String reg = freshReg();
                            asm.instr("la", reg, (LLVM.LLVMGetValueName(ptr).getString()));
                            asm.instr("sw", valReg, "0(" + reg + ")");
                        }
                    } else if (opcode == LLVM.LLVMLoad) {
                        LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 0);
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(ptr).getString());
                        String lval_addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        if(lval_addr.isEmpty())continue;
                        if (addr == null) {
                            String reg = freshReg();
                            asm.instr("la", reg, (LLVM.LLVMGetValueName(ptr).getString()));
                            asm.instr("lw", reg, "0(" + reg + ")");
                            if (lval_addr.contains("stack")) {
                                if(value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset))==null) next_offset+=4;
                                asm.instr("sw", reg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                            }
                            else asm.instr("mv", lval_addr, reg);
                        } else if (addr.contains("stack")) {
                            String reg = freshReg();
                            asm.instr("lw", reg, addr);
                            if (lval_addr.contains("stack")) {
                                if(value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset))==null) next_offset+=4;
                                asm.instr("sw", reg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                            } else asm.instr("mv", lval_addr, reg);
                        } else {
                            if (lval_addr.contains("stack")) {
                                if(value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset))==null) next_offset+=4;
                                asm.instr("sw", addr, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                            } else asm.instr("mv", lval_addr, addr);
                        }
                    } else if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                            opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                            opcode == LLVM.LLVMSRem || opcode == LLVM.LLVMURem || opcode == LLVM.LLVMUDiv) {
                        LLVMValueRef lhs = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef rhs = LLVM.LLVMGetOperand(inst, 1);
                        String reg1 = evaluate(lhs);
                        String reg2 = evaluate(rhs);
                        String destReg = freshReg();
                        String op = "";
                        switch (opcode) {
                            case LLVM.LLVMAdd:
                                op = "add";
                                break;
                            case LLVM.LLVMSub:
                                op = "sub";
                                break;
                            case LLVM.LLVMMul:
                                op = "mul";
                                break;
                            case LLVM.LLVMSDiv:
                                op = "div";
                                break;
                            case LLVM.LLVMUDiv:
                                op = "divu";
                                break;
                            case LLVM.LLVMSRem:
                                op = "rem";
                                break;
                            case LLVM.LLVMURem:
                                op = "urem";
                                break;
                            default:
                                throw new RuntimeException("Unsupported binop");
                        }
                        asm.op2(op, destReg, reg1, reg2);
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        if(addr.isEmpty()) continue;
                        if (addr.contains("stack")) {
                            if(value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset))==null) next_offset+=4;
                            asm.instr("sw", destReg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                        } else asm.instr("mv", addr, destReg);
                    } else if (opcode == LLVM.LLVMRet) {
                        LLVMValueRef retVal = LLVM.LLVMGetOperand(inst, 0);
                        String reg = evaluate(retVal);
                        if(LLVM.LLVMGetValueName(func).getString().equals("main")) {
                            asm.mv("x10", reg);
                            asm.instr("addi", "sp", "sp", "" + 2044); // Epilogue
                            asm.li("a7", 93);  // syscall exit
                            asm.instr("ecall");
                        }
                        else{
                            asm.mv("x10", reg);
                            asm.instr("ret");
                        }
                    } else if (opcode == LLVM.LLVMZExt) {
                        LLVMValueRef operand = LLVM.LLVMGetOperand(inst, 0);
                        String srcReg = evaluate(operand);
                        String destReg = freshReg();
                        asm.mv(destReg, srcReg);
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        if(addr.isEmpty()) continue;
                        if (addr.contains("stack")) {
                            if(value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset))==null) next_offset+=4;
                            asm.instr("sw", destReg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                        } else asm.instr("mv", addr, destReg);
                    } else if (opcode == LLVM.LLVMICmp) {
                        int pred = LLVM.LLVMGetICmpPredicate(inst);  // 获取谓词
                        LLVMValueRef lhs = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef rhs = LLVM.LLVMGetOperand(inst, 1);
                        String reg1 = evaluate(lhs);
                        String reg2 = evaluate(rhs);
                        String destReg = freshReg();
                        switch (pred) {
                            case LLVM.LLVMIntEQ:
                                asm.instr("xor", destReg, reg1, reg2);
                                asm.seqz(destReg, destReg);
                                break;
                            case LLVM.LLVMIntNE:
                                asm.instr("xor", destReg, reg1, reg2);
                                asm.snez(destReg, destReg);
                                break;
                            case LLVM.LLVMIntSLT:
                                asm.slt(destReg, reg1, reg2);
                                break;
                            case LLVM.LLVMIntSLE:
                                asm.sgt(destReg, reg1, reg2);
                                asm.seqz(destReg, destReg);
                                break;
                            case LLVM.LLVMIntSGT:
                                asm.sgt(destReg, reg1, reg2);
                                break;
                            case LLVM.LLVMIntSGE:
                                asm.slt(destReg, reg1, reg2);
                                asm.seqz(destReg, destReg);
                                break;
                            default:
                                throw new RuntimeException("Unsupported icmp predicate: " + pred);
                        }
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        if(addr.isEmpty()) continue;
                        if (addr.contains("stack")) {
                            if(value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset))==null) next_offset+=4;
                            asm.instr("sw", destReg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                        } else asm.instr("mv", addr, destReg);
                    } else if (opcode == LLVM.LLVMBr) {
                        int numOperands = LLVM.LLVMGetNumOperands(inst);
                        if (numOperands == 1) {
                            LLVMValueRef dest = LLVM.LLVMGetOperand(inst, 0);
                            String loop_label = LLVM.LLVMGetValueName(dest).getString();
                            asm.j(loop_label);
                        } else if (numOperands == 3) {
                            //System.out.println(LLVM.LLVMPrintValueToString(inst).getString());
                            LLVMValueRef cond = LLVM.LLVMGetOperand(inst, 0);
                            LLVMValueRef ifFalse = LLVM.LLVMGetOperand(inst, 1);
                            LLVMValueRef ifTrue = LLVM.LLVMGetOperand(inst, 2);
                            String condReg = evaluate(cond);
                            String trueLabel = LLVM.LLVMGetValueName(ifTrue).getString();
                            String falseLabel = LLVM.LLVMGetValueName(ifFalse).getString();
                            asm.bnez(condReg, trueLabel);
                            asm.j(falseLabel);
                        }
                    } else {
                        System.out.println(LLVM.LLVMPrintValueToString(inst).getString());
                        throw new RuntimeException("Unsupported instruction opcode: " + opcode);
                    }
                }
            }
        }
        asm.writeToFile(file_path);
    }

    private String evaluate(LLVMValueRef val) {
        LLVMValueRef constInt = LLVM.LLVMIsAConstantInt(val);
        if (constInt != null && !constInt.isNull()) {
            long imm = LLVM.LLVMConstIntGetSExtValue(constInt);
            String reg = freshReg();
            asm.li(reg, imm);
            return reg;
        } else if (allocator.allocate(LLVM.LLVMGetValueName(val).getString()) != null) {
            if (allocator.allocate(LLVM.LLVMGetValueName(val).getString()).contains("stack")) {
                String reg = freshReg();
                asm.instr("lw", reg, value_stack_addr.get(LLVM.LLVMGetValueName(val).getString()));
                return reg;
            } else return allocator.allocate(LLVM.LLVMGetValueName(val).getString());
        } else if (LLVM.LLVMIsAGlobalVariable(val) != null) {
            String reg = freshReg();
            String name = LLVM.LLVMGetValueName(val).getString();
            asm.instr("la", reg, name);
            asm.instr("lw", reg, "0(" + reg + ")");
            return reg;
        } else {
            System.out.println(LLVM.LLVMGetValueName(val).getString());
            String valStr = LLVM.LLVMPrintValueToString(val).getString();
            int kind = LLVM.LLVMGetValueKind(val);
            System.err.println("Unsupported operand:");
            System.err.println("LLVM ValueKind: " + kind);
            System.err.println("LLVM Value: " + valStr);
            throw new RuntimeException("Unsupported operand: " + valStr);
        }
    }

    private void emitGlobalVariables() {
        asm.switchToData();
        for (LLVMValueRef global = LLVM.LLVMGetFirstGlobal(module);
             global != null && !global.isNull();
             global = LLVM.LLVMGetNextGlobal(global)) {
            String name = LLVM.LLVMGetValueName(global).getString();
            LLVMValueRef init = LLVM.LLVMGetInitializer(global);
            long val = init.isNull() ? 0 : LLVM.LLVMConstIntGetSExtValue(init);
            asm.directive("data");
            asm.word(name, val);
        }
        asm.switchToText();
    }

    private String freshReg() {
        return "t" + (regCount++ % 3);
    }

    private int regCount = 0;
}
