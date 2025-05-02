import org.bytedeco.llvm.LLVM.*;
import org.bytedeco.llvm.global.LLVM;
import java.util.*;
import java.util.regex.*;
public class LLVMIRToRiscv {
    String file_path;
    LLVMModuleRef module;
    AsmBuilder asm = new AsmBuilder();
    //RegisterAllocator allocator = new StackOnlyRegisterAllocator();
    RegisterAllocator allocator;
    Map<String, String> valueMap = new HashMap<>();  // IR value → stack addr or reg
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
        int lineNum=0;
        emitGlobalVariables();
        Map<String, Integer> firstUse = new HashMap<>();
        Map<String, Integer> lastUse = new HashMap<>();
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)){
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                    String line = LLVM.LLVMPrintValueToString(inst).getString();
                    for (String var : extractVariables(line)) {
                        firstUse.putIfAbsent(var, lineNum);
                        lastUse.put(var, lineNum);
                    }
                    lineNum++;
                }
            }
        }
        List<Interval> intervals = new ArrayList<>();
        for (String var : firstUse.keySet()) {
            intervals.add(new Interval(var, firstUse.get(var), lastUse.get(var)));
        }
        List<String> reg_list=new ArrayList<>();
        for(int i=0;i<32;i++){
            if(i!=0&&i!=2&&i!=5&&i!=6&&i!=7) reg_list.add("x"+i);
        }
        allocator = new LinearScanRegisterAllocator(intervals, reg_list);
        //allocator=new StackOnlyRegisterAllocator();
        asm.directive("text");
        asm.directive("globl main");
        lineNum=0;
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            String funcName = LLVM.LLVMGetValueName(func).getString();
            if (!"main".equals(funcName)) continue;
            asm.label("main");
            // Prologue
            int stackSize = 512;
            asm.instr("addi", "sp", "sp", "-" + stackSize);

            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                String label = LLVM.LLVMGetBasicBlockName(bb).getString();
                asm.label(label.isEmpty() ? "mainEntry" : label);

                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb);
                     inst != null && !inst.isNull();
                     inst = LLVM.LLVMGetNextInstruction(inst)) {
                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                    allocator.processInstruction(lineNum,LLVM.LLVMPrintValueToString(inst).getString());
                    lineNum++;
                    if (opcode == LLVM.LLVMAlloca) {
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        valueMap.put(LLVM.LLVMGetValueName(inst).getString(), addr);
                    } else if (opcode == LLVM.LLVMStore) {
                        LLVMValueRef val = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 1);
                        String valReg = evaluate(val);
                        String addr = valueMap.get(LLVM.LLVMGetValueName(ptr).getString());
                        if(addr!=null){
                            if(addr.contains("sp")) asm.instr("sw", valReg, addr);
                            else asm.instr("mv",addr,valReg);
                        }
                        else{
                            String reg=freshReg();
                            asm.instr("la",reg,(LLVM.LLVMGetValueName(ptr).getString()));
                            asm.instr("sw",valReg,"0("+reg+")");
                        }
                    } else if (opcode == LLVM.LLVMLoad) {
                        LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 0);
                        String addr = valueMap.get(LLVM.LLVMGetValueName(ptr).getString());
                        if(addr==null) {
                            //System.out.println("LLVMTOIR");
                            //System.out.println(LLVM.LLVMGetValueName(inst).getString());
                            String reg = freshReg();
                            asm.instr("la",reg,(LLVM.LLVMGetValueName(ptr).getString()));
                            asm.instr("lw",reg,"0("+reg+")");
                            String lval_addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                            if(lval_addr.contains("sp")) asm.instr("sw",reg,lval_addr);
                            else asm.instr("mv",lval_addr,reg);
                            valueMap.put(LLVM.LLVMGetValueName(inst).getString(), lval_addr);
                        }
                        else if(addr.contains("sp")){
                            String reg = freshReg();
                            String lval_addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                            asm.instr("lw",reg,addr);
                            if(lval_addr.contains("sp")) asm.instr("sw",reg,lval_addr);
                            else asm.instr("mv",lval_addr,reg);
                            valueMap.put(LLVM.LLVMGetValueName(inst).getString(), lval_addr);
                            //valueMap.put(LLVM.LLVMGetValueName(ptr).getString(), addr);  // 可选：也可以保存为 reg
                        }
                        else{
                            String lval_addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                            if(lval_addr.contains("sp")) asm.instr("sw",addr,lval_addr);
                            else asm.instr("mv",lval_addr,addr);
                            valueMap.put(LLVM.LLVMGetValueName(inst).getString(), lval_addr);
                        }
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
                        //System.out.println(LLVM.LLVMGetValueName(inst).getString());
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        if(addr.contains("sp")) asm.instr("sw", destReg, addr);
                        else asm.instr("mv",addr,destReg);
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
                    else if (opcode == LLVM.LLVMZExt) {
                        LLVMValueRef operand = LLVM.LLVMGetOperand(inst, 0);
                        String srcReg = evaluate(operand);
                        String destReg = freshReg();
                        asm.mv(destReg, srcReg);
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        if(addr.contains("sp")) asm.instr("sw", destReg, addr);
                        else asm.instr("mv",addr,destReg);
                        valueMap.put(LLVM.LLVMGetValueName(inst).getString(), addr);
                    }
                    else if (opcode == LLVM.LLVMICmp) {
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
                        if(addr.contains("sp"))asm.instr("sw", destReg, addr);
                        else asm.instr("mv", addr,destReg);
                        valueMap.put(LLVM.LLVMGetValueName(inst).getString(), addr);
                    }
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
            if(valueMap.get(LLVM.LLVMGetValueName(val).getString()).contains("sp")) {
                String reg = freshReg();
                asm.instr("lw", reg, valueMap.get(LLVM.LLVMGetValueName(val).getString()));
                return reg;
            }
            else return valueMap.get(LLVM.LLVMGetValueName(val).getString());
        }
        else if (LLVM.LLVMIsAGlobalVariable(val) != null) {
            String reg = freshReg();
            String name = LLVM.LLVMGetValueName(val).getString();
            asm.instr("la", reg, name);
            asm.instr("lw", reg, "0(" + reg + ")");
            return reg;
        }
        else {
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
