import org.bytedeco.llvm.LLVM.*;
import org.bytedeco.llvm.global.LLVM;
import java.util.*;

public class LLVMIRToRiscv {
    String file_path;
    LLVMModuleRef module;
    AsmBuilder asm = new AsmBuilder();
    RegisterAllocator allocator = new StackOnlyRegisterAllocator();
    Map<String, String> valueMap = new HashMap<>();  // IR value → stack addr or reg
    public LLVMIRToRiscv(LLVMModuleRef moduleRef, String file_path) {
        this.module = moduleRef;
        this.file_path = file_path;
    }

    public void to_riscv() {
        emitGlobalVariables();
        asm.directive("text");
        asm.directive("globl main");

        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            String funcName = LLVM.LLVMGetValueName(func).getString();
            if (!"main".equals(funcName)) continue;

            asm.label("main");

            // Prologue
            int stackSize = 128;  // 预留足够空间，或使用 allocator.getStackSize() 替换
            asm.instr("addi", "sp", "sp", "-" + stackSize);

            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                String label = LLVM.LLVMGetBasicBlockName(bb).getString();
                asm.label(label.isEmpty() ? "mainEntry" : label);

                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb);
                     inst != null && !inst.isNull();
                     inst = LLVM.LLVMGetNextInstruction(inst)) {
                    System.out.println(LLVM.LLVMPrintValueToString(inst).getString());
                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);

                    if (opcode == LLVM.LLVMAlloca) {
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        valueMap.put(LLVM.LLVMGetValueName(inst).getString(), addr);
                    } else if (opcode == LLVM.LLVMStore) {
                        LLVMValueRef val = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 1);
                        String valReg = evaluate(val);
                        String addr = valueMap.get(LLVM.LLVMGetValueName(ptr).getString());
                        if(addr!=null){
                            asm.instr("sw", valReg, addr);
                        }
                        else{
                            String reg=freshReg();
                            asm.instr("la",reg,(LLVM.LLVMGetValueName(ptr).getString()));
                            asm.instr("sw",valReg,"0("+reg+")");
                        }
                    } else if (opcode == LLVM.LLVMLoad) {
                        LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 0);
                        String addr = valueMap.get(LLVM.LLVMGetValueName(ptr).getString());
                        String reg = freshReg();
                        if(addr!=null){
                            asm.instr("lw", reg, addr);
                            //valueMap.put(LLVM.LLVMGetValueName(ptr).getString(), addr);  // 可选：也可以保存为 reg
                        }
                        else{
                            asm.instr("la",reg,(LLVM.LLVMGetValueName(ptr).getString()));
                            asm.instr("lw",reg,"0("+reg+")");
                        }
                        String lval_addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        asm.instr("sw",reg,lval_addr);
                        valueMap.put(LLVM.LLVMGetValueName(inst).getString(), lval_addr);
                    } else if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                            opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                            opcode == LLVM.LLVMSRem) {
                        LLVMValueRef lhs = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef rhs = LLVM.LLVMGetOperand(inst, 1);
                        String reg1 = evaluate(lhs);
                        String reg2 = evaluate(rhs);
                        String destReg = freshReg();
                        String op;
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
                            case LLVM.LLVMSRem:
                                op = "rem";
                                break;
                            default:
                                throw new RuntimeException("Unsupported binop");
                        }
                        asm.op2(op, destReg, reg1, reg2);
                        String addr = allocator.allocate(getValueKey(inst).toString());
                        asm.instr("sw", destReg, addr);
                        valueMap.put(LLVM.LLVMGetValueName(inst).getString(), addr);

                    } else if (opcode == LLVM.LLVMRet) {
                        LLVMValueRef retVal = LLVM.LLVMGetOperand(inst, 0);
                        String reg = evaluate(retVal);
                        asm.mv("a0", reg);
                        asm.li("a7", 93);  // syscall exit
                        asm.instr("ecall");
                        asm.instr("addi", "sp", "sp", "" + stackSize); // Epilogue
                        asm.writeToFile(file_path);
                        return;

                    }
//                    else if (opcode == LLVM.LLVMZExt) {
//                        LLVMValueRef operand = LLVM.LLVMGetOperand(inst, 0);
//                        String srcReg = evaluate(operand); // 获取原始寄存器（如 i1）
//                        String destReg = freshReg();
//                        asm.mv(destReg, srcReg);
//                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
//                        asm.instr("sw", destReg, addr);
//                        valueMap.put(LLVM.LLVMGetValueName(inst).getString(), addr);
//                    }
                    else {
                        System.out.println(inst);
                        throw new RuntimeException("Unsupported instruction opcode: " + opcode);
                    }
                }
            }
        }
    }

    private String evaluate(LLVMValueRef val) {
        LLVMValueRef constInt = LLVM.LLVMIsAConstantInt(val);
        if (constInt != null && !constInt.isNull()){
            long imm = LLVM.LLVMConstIntGetSExtValue(constInt);
            String reg = freshReg();
            asm.li(reg, imm);
            return reg;
        } else if (valueMap.containsKey(LLVM.LLVMGetValueName(val).getString())) {
            String reg = freshReg();
            asm.instr("lw", reg, valueMap.get(LLVM.LLVMGetValueName(val).getString()));
            return reg;
        }
        else if (LLVM.LLVMIsAGlobalVariable(val) != null) {
            String reg = freshReg();
            String name = LLVM.LLVMGetValueName(val).getString();
            asm.instr("la", reg, name);
            asm.instr("lw", reg, "0(" + reg + ")");
            return reg;
        }
        else {
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
        return "t" + (regCount++ % 7);
    }

    private static LLVMValueRef getValueKey(LLVMValueRef value) {
        return value; // 可拓展为使用 name 或 id 做 key
    }

    private int regCount = 0;
}
