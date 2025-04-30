import org.bytedeco.llvm.LLVM.*;
import org.bytedeco.llvm.global.LLVM;

public class LLVMIRToRiscv {
    String file_path;
    LLVMModuleRef module;
    int regCount = 0;
    AsmBuilder asm = new AsmBuilder();

    public LLVMIRToRiscv(LLVMModuleRef moduleRef, String file_path){
        this.module = moduleRef;
        this.file_path = file_path;
    }
    public void to_riscv() {
        asm.directive("text");
        asm.directive("globl main");
        asm.label("main");
        asm.instr("addi", "sp", "sp", "0"); // Prologue

        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            String funcName = LLVM.LLVMGetValueName(func).getString();
            if (!"main".equals(funcName)) continue;

            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                String label = LLVM.LLVMGetBasicBlockName(bb).getString();
                asm.label(label.isEmpty() ? "mainEntry" : label);  // fallback name

                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null && !inst.isNull(); inst = LLVM.LLVMGetNextInstruction(inst)) {
                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);

                    if (opcode == LLVM.LLVMRet) {
                        LLVMValueRef retVal = LLVM.LLVMGetOperand(inst, 0);
                        String reg = evaluate(retVal);
                        asm.mv("a0", reg);

                        asm.instr("addi", "sp", "sp", "0"); // Epilogue
                        asm.li("a7", 93);                  // syscall: exit
                        asm.instr("ecall");
                        asm.writeToFile(file_path);
                        return;
                    }
                }
            }
        }
    }

    // 将表达式计算结果放入一个新寄存器，返回寄存器名
    private String evaluate(LLVMValueRef value) {
        if (!LLVM.LLVMIsAConstantInt(value).isNull()) {
            long val = LLVM.LLVMConstIntGetSExtValue(value);
            String reg = freshReg();
            asm.li(reg, val);
            return reg;
        }

        int opcode = LLVM.LLVMGetInstructionOpcode(value);
        int operandNum = LLVM.LLVMGetNumOperands(value);

        if (operandNum == 1) {
            LLVMValueRef op = LLVM.LLVMGetOperand(value, 0);
            String reg = evaluate(op);
            String dest = freshReg();

            switch (opcode) {
                case LLVM.LLVMFNeg:
                case LLVM.LLVMSub:  // 单目负号
                    asm.op2("neg", dest, reg, "");
                    break;
                case LLVM.LLVMAdd:  // 正号
                    asm.mv(dest, reg);
                    break;
                case LLVM.LLVMICmp:  // 仅处理 LLVM IR 中翻译出的 `!` 情况
                    asm.instr("seqz", dest, reg);
                    break;
                default:
                    throw new RuntimeException("Unsupported unary opcode: " + opcode);
            }
            return dest;
        } else if (operandNum == 2) {
            LLVMValueRef lhs = LLVM.LLVMGetOperand(value, 0);
            LLVMValueRef rhs = LLVM.LLVMGetOperand(value, 1);
            String reg1 = evaluate(lhs);
            String reg2 = evaluate(rhs);
            String dest = freshReg();

            switch (opcode) {
                case LLVM.LLVMAdd:
                    asm.op2("add", dest, reg1, reg2);
                    break;
                case LLVM.LLVMSub:
                    asm.op2("sub", dest, reg1, reg2);
                    break;
                case LLVM.LLVMMul:
                    asm.op2("mul", dest, reg1, reg2);
                    break;
                case LLVM.LLVMUDiv:
                case LLVM.LLVMSDiv:
                    asm.op2("div", dest, reg1, reg2);
                    break;
                case LLVM.LLVMSRem:
                    asm.op2("rem", dest, reg1, reg2);
                    break;
                default:
                    throw new RuntimeException("Unsupported binary opcode: " + opcode);
            }
            return dest;
        }

        throw new RuntimeException("Unsupported expression");
    }

    private String freshReg() {
        return "t" + (regCount++ % 7);
    }

}
