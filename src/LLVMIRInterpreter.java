import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;
import org.bytedeco.llvm.LLVM.LLVMModuleRef;
import org.bytedeco.llvm.LLVM.LLVMValueRef;
import org.bytedeco.llvm.global.LLVM;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.bytedeco.llvm.global.LLVM.LLVMGetEntryBasicBlock;
import static org.bytedeco.llvm.global.LLVM.LLVMGetNamedFunction;

public class LLVMIRInterpreter {
    LLVMModuleRef module;
    private static final Map<String,LLVMBasicBlockRef> name2blockref=new HashMap<>();
    Map<String,Integer> symbol;
    String file_path;
    int load_store_inst;
    public LLVMIRInterpreter(LLVMModuleRef module,String file_path){
        this.module=module;
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                name2blockref.put(LLVM.LLVMGetBasicBlockName(bb).getString(), bb);
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                    if (opcode == LLVM.LLVMLoad||opcode==LLVM.LLVMStore) load_store_inst++;
                }
            }
        }
        symbol=new HashMap<>();
        for (LLVMValueRef global = LLVM.LLVMGetFirstGlobal(module);
             global != null && !global.isNull();
             global = LLVM.LLVMGetNextGlobal(global)) {
            String name = LLVM.LLVMGetValueName(global).getString();
            LLVMValueRef init = LLVM.LLVMGetInitializer(global);
            long val = init.isNull() ? 0 : LLVM.LLVMConstIntGetSExtValue(init);
            symbol.put(name,(int)val);
        }
        this.file_path=file_path;
    }
    public int Process_block(LLVMBasicBlockRef bb){
        for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
            int opcode = LLVM.LLVMGetInstructionOpcode(inst);
            if(opcode == LLVM.LLVMAlloca) continue;
            else if(opcode == LLVM.LLVMLoad){
                LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 0);
                int val=evaluate(ptr);
                symbol.put(LLVM.LLVMGetValueName(inst).getString(),val);
            }
            else if(opcode == LLVM.LLVMStore){
                LLVMValueRef val = LLVM.LLVMGetOperand(inst, 0);
                LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 1);
                int evaluate_val = evaluate(val);
                symbol.put(LLVM.LLVMGetValueName(ptr).getString(),evaluate_val);
            }
            else if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                    opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                    opcode == LLVM.LLVMSRem || opcode==LLVM.LLVMURem){
                LLVMValueRef lhs = LLVM.LLVMGetOperand(inst, 0);
                LLVMValueRef rhs = LLVM.LLVMGetOperand(inst, 1);
                int op1 = evaluate(lhs);
                int op2 = evaluate(rhs);
                int ans=0;
                switch (opcode) {
                    case LLVM.LLVMAdd:
                        ans=op1+op2;
                        break;
                    case LLVM.LLVMSub:
                        ans=op1-op2;
                        break;
                    case LLVM.LLVMMul:
                        ans=op1*op2;
                        break;
                    case LLVM.LLVMSDiv:
                        ans=op1/op2;
                        break;
                    case LLVM.LLVMSRem:
                        ans=op1%op2;
                        break;
                    case LLVM.LLVMURem:
                        ans = Integer.remainderUnsigned(op1, op2);
                        break;
                    default:
                        break;
                        //throw new RuntimeException("Unsupported binop");
                }
                symbol.put(LLVM.LLVMGetValueName(inst).getString(),ans);
            }
            else if(opcode == LLVM.LLVMRet) return evaluate(LLVM.LLVMGetOperand(inst, 0));
            else if(opcode == LLVM.LLVMZExt) symbol.put(LLVM.LLVMGetValueName(inst).getString(),evaluate( LLVM.LLVMGetOperand(inst, 0)));
            else if(opcode== LLVM.LLVMICmp) {
                int pred = LLVM.LLVMGetICmpPredicate(inst);  // 获取谓词
                LLVMValueRef lhs = LLVM.LLVMGetOperand(inst, 0);
                LLVMValueRef rhs = LLVM.LLVMGetOperand(inst, 1);
                int reg1 = evaluate(lhs);
                int reg2 = evaluate(rhs);
                int ans = 0;
                switch (pred) {
                    case LLVM.LLVMIntEQ:
                        if(reg1==reg2) ans=1;
                        break;
                    case LLVM.LLVMIntNE:
                        if(reg1!=reg2) ans=1;
                        break;
                    case LLVM.LLVMIntSLT:
                        if(reg1<reg2) ans=1;
                        break;
                    case LLVM.LLVMIntSLE:
                        if(reg1<=reg2) ans=1;
                        break;
                    case LLVM.LLVMIntSGT:
                        if(reg1>reg2) ans=1;
                        break;
                    case LLVM.LLVMIntSGE:
                        if(reg1>=reg2) ans=1;
                        break;
                    default:
                        break;
                        //throw new RuntimeException("Unsupported icmp predicate: " + pred);
                }
                symbol.put(LLVM.LLVMGetValueName(inst).getString(),ans);
            }
            else if(opcode == LLVM.LLVMBr){
                int numOperands = LLVM.LLVMGetNumOperands(inst);
                if (numOperands == 1) {
                    LLVMValueRef dest = LLVM.LLVMGetOperand(inst, 0);
                    String loop_label = LLVM.LLVMGetValueName(dest).getString();
                    return Process_block(name2blockref.get(loop_label));
                } else if (numOperands == 3) {
                    LLVMValueRef cond = LLVM.LLVMGetOperand(inst, 0);
                    LLVMValueRef ifFalse = LLVM.LLVMGetOperand(inst, 1);
                    LLVMValueRef ifTrue = LLVM.LLVMGetOperand(inst, 2);
                    int condReg = evaluate(cond);
                    String trueLabel = LLVM.LLVMGetValueName(ifTrue).getString();
                    String falseLabel = LLVM.LLVMGetValueName(ifFalse).getString();
                    if(condReg!=0) return Process_block(name2blockref.get(trueLabel));
                    return Process_block(name2blockref.get(falseLabel));
                }
            }
             else {
                break;
                //throw new RuntimeException("Unsupported instruction opcode: " + opcode);
            }
        }
        return 0;
    }
    private int evaluate(LLVMValueRef val) {
        LLVMValueRef constInt = LLVM.LLVMIsAConstantInt(val);
        if (constInt != null && !constInt.isNull()) {
            long imm = LLVM.LLVMConstIntGetSExtValue(constInt);
            return (int)imm;
        }
        else{
            if(symbol.get(LLVM.LLVMGetValueName(val).getString())==null) {
               // throw new RuntimeException();
                return 0;
            }
            else return symbol.get(LLVM.LLVMGetValueName(val).getString());
        }
    }
    public void to_riscv(){
        AsmBuilder asm=new AsmBuilder();
        int retval=Process_block(LLVMGetEntryBasicBlock(LLVMGetNamedFunction(module, "main")));
        asm.directive("text");
        asm.directive("globl main");
        asm.label("main");
        asm.instr("addi", "sp", "sp", "-" + 4);
        asm.label( "mainEntry");
        asm.li("a0",  retval);
        asm.instr("addi", "sp", "sp", "" + 4); // Epilogue
        asm.li("a7", 93);  // syscall exit
        asm.instr("ecall");
        asm.writeToFile(file_path);
    }
}
