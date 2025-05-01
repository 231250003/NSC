import org.bytedeco.llvm.LLVM.*;
import org.bytedeco.llvm.global.LLVM;
import java.util.*;

public class LLVMIRToRiscv {
    String file_path;
    LLVMModuleRef module;
    AsmBuilder asm = new AsmBuilder();
    RegisterAllocator allocator = new StackOnlyRegisterAllocator();
    Map<LLVMValueRef, String> valueMap = new HashMap<>();  // IR value → stack addr or reg

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

                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);

                    if (opcode == LLVM.LLVMAlloca) {
                        String addr = allocator.allocate(getValueKey(inst).toString());
                        valueMap.put(inst, addr);

                    } else if (opcode == LLVM.LLVMStore) {
                        LLVMValueRef val = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 1);
                        String valReg = evaluate(val);
                        String addr = valueMap.get(ptr);
                        asm.instr("sw", valReg, addr);

                    } else if (opcode == LLVM.LLVMLoad) {
                        LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 0);
                        String addr = valueMap.get(ptr);
                        String reg = freshReg();
                        asm.instr("lw", reg, addr);
                        valueMap.put(inst, addr);  // 可选：也可以保存为 reg

                    } else if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                            opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                            opcode == LLVM.LLVMSRem) {
                        LLVMValueRef lhs = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef rhs = LLVM.LLVMGetOperand(inst, 1);
                        System.out.println();
                        if(lhs!=null )System.out.println("crzzz");
                        if(rhs!=null) System.out.println("12121");
                        String reg1 = evaluate(lhs);
                        String reg2 = evaluate(rhs);
                        System.out.println("end-crzzz");
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
                        valueMap.put(inst, addr);

                    } else if (opcode == LLVM.LLVMRet) {
                        LLVMValueRef retVal = LLVM.LLVMGetOperand(inst, 0);
                        String reg = evaluate(retVal);
                        asm.mv("a0", reg);
                        asm.li("a7", 93);  // syscall exit
                        asm.instr("ecall");
                        asm.instr("addi", "sp", "sp", "" + stackSize); // Epilogue
                        asm.writeToFile(file_path);
                        return;

                    } else {
                        throw new RuntimeException("Unsupported instruction opcode: " + opcode);
                    }
                }
            }
        }
    }

    private String evaluate(LLVMValueRef val) {
        if (!LLVM.LLVMIsAConstantInt(val).isNull()) {
            long imm = LLVM.LLVMConstIntGetSExtValue(val);
            String reg = freshReg();
            asm.li(reg, imm);
            return reg;
        } else if (valueMap.containsKey(val)) {
            String reg = freshReg();
            asm.instr("lw", reg, valueMap.get(val));
            return reg;
        } else {
            throw new RuntimeException("Unsupported operand: " + val);
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
