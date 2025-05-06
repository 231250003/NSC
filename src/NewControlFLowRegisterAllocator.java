import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;
import org.bytedeco.llvm.LLVM.LLVMModuleRef;
import org.bytedeco.llvm.LLVM.LLVMValueRef;
import org.bytedeco.llvm.global.LLVM;

import java.security.Key;
import java.util.*;

class NewControlFlowRegisterAllocator implements RegisterAllocator{

    private static final Map<String, Interval> varToInterval=new HashMap<>();
    private static final List<String> registers=new ArrayList<>();
    private static  Map<String, String> varToLocation = new HashMap<>();
    private static final Map<String, Integer> varOffset = new HashMap<>();
    private static  Set<String> changed_variable=new HashSet<>();
    private static int nextOffset = 0;
    public NewControlFlowRegisterAllocator(){}
    public static void init(LLVMModuleRef module) {
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                    String line = LLVM.LLVMPrintValueToString(inst).getString();
                    if (line.contains("br") && !line.contains(",")) {
                        continue;
                    }
                    else if (line.contains("br") && line.contains(",")) line = line.substring(0, line.indexOf(","));
                    for (String var : LLVMIRToRiscv.extractVariables(line)) {
                        if(!varOffset.containsKey(var)){
                            nextOffset += 4;
                            varOffset.put(var, nextOffset);
                        }
                    }
                }
            }
        }
    }
    public static void preprocess_block(LLVMBasicBlockRef bb){
        Map<String, Integer> firstUse = new HashMap<>();
        Map<String, Integer> lastUse = new HashMap<>();
        Map<String,Integer> used_num=new HashMap<>();
        int lineNum=0;
        for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
            String line = LLVM.LLVMPrintValueToString(inst).getString();
            if (line.contains("br") && !line.contains(",")) {
                lineNum++;
                continue;
            }
            else if (line.contains("br") && line.contains(",")) line = line.substring(0, line.indexOf(","));
            for (String var : LLVMIRToRiscv.extractVariables(line)) {
                firstUse.putIfAbsent(var, lineNum);
                lastUse.put(var, lineNum);
                used_num.put(var, used_num.getOrDefault(var, 0) + 1);
            }
            if(line.contains("=")) {
                System.out.println(line);
                for (String var : LLVMIRToRiscv.extractVariables(line)) {
                    changed_variable.add(var);
                    System.out.println(var);
                    break;
                }
            }
            lineNum++;
        }
        List<Interval> intervals = new ArrayList<>();
        for (String var : firstUse.keySet()) {
            intervals.add(new Interval(var, firstUse.get(var), lastUse.get(var),used_num.get(var)));
        }
        for (Interval interval : intervals) {
            varToInterval.put(interval.varName, interval);
        }
    }
    public  void processInstruction(int lineNumber, String instruction) {
        expireOldIntervals(lineNumber);
        Set<String> vars=LLVMIRToRiscv.extractVariables(instruction);
        for (String var : vars) {
            Interval interval = varToInterval.get(var);
            if (interval == null || varToLocation.containsKey(var)) continue;
            if (!registers.isEmpty()) {
                String reg = registers.remove(0);
                varToLocation.put(var, reg);
            } else {
                varToLocation.put(var, String.format("%d(sp)", varOffset.get(var)));
                LLVMIRToRiscv.valueMap.put(var,varToLocation.get(var));
            }
        }
    }

    public void expireOldIntervals(int currentLine) {
        for (Map.Entry<String, Interval> entry : varToInterval.entrySet()) {
            String var = entry.getKey();
            Interval interval = entry.getValue();
            if(currentLine>interval.end && varToLocation.containsKey(var)&&(!varToLocation.get(var).contains("sp"))) {
                registers.add(varToLocation.get(var));
                if(changed_variable.contains(var)) LLVMIRToRiscv.asm.instr("sw",varToLocation.get(var),String.format("%d(sp)", varOffset.get(var)));
                varToLocation.remove(var);
                varToLocation.put(var,String.format("%d(sp)", varOffset.get(var)));
            }
        }
    }
    public static void post_process_block(){
        for (Map.Entry<String, String> entry : varToLocation.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
           if(changed_variable.contains(key)&& (!value.contains("sp"))){
               LLVMIRToRiscv.valueMap.put(key,String.format("%d(sp)", varOffset.get(key)));
               LLVMIRToRiscv.asm.instr("sw",varToLocation.get(key),String.format("%d(sp)", varOffset.get(key)));
           }
        }
        varToLocation=new HashMap<>();
        changed_variable=new HashSet<>();
    }
    @Override
    public String allocate(String varName) {
        return varToLocation.get(varName);
    }

    @Override
    public int getStackSize() {
        return nextOffset;
    }
}
