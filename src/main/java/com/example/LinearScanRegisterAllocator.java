package  com.example;
import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;

import java.util.*;

class LinearScanRegisterAllocator implements RegisterAllocator {

    private final Map<String, Interval> varToInterval;
    private final List<String> registers;
    public static Map<String, String> varToLocation = new HashMap<>();
    //private final List<Interval> active = new ArrayList<>();
    private final Map<String, Integer> varOffset = new HashMap<>();
    private int nextOffset = 0;
    AsmBuilder asm;
    public LinearScanRegisterAllocator(List<Interval> allIntervals, List<String> registers,AsmBuilder asmBuilder) {
        this.registers = new ArrayList<>(registers);
        this.varToInterval = new HashMap<>();
        for (Interval interval : allIntervals) {
            varToInterval.put(interval.varName, interval);
        }
        this.asm=asmBuilder;
    }
//    public void preprocess_blobk(LLVMBasicBlockRef bb){
//        return;
//    }
//    @Override
//    public void processInstruction(int lineNumber, String instruction) {
//        expireOldIntervals(lineNumber);
//        Map<String,Integer> used_reg_list=new HashMap<>();
//        for (String var : LLVMIRToRiscv.extractVariables(instruction)) {
//            Interval interval = varToInterval.get(var);
//            if (interval == null || varToLocation.containsKey(var)) continue;
//            if (!registers.isEmpty()) {
//                String reg = registers.remove(0);
//                varToLocation.put(var, reg);
//            } else {
//                int var_end_line=interval.end;
//                String spill_reg="";
//                String var_spill_name=var;
//                for (Map.Entry<String, Interval> entry : varToInterval.entrySet()) {
//                    String key = entry.getKey();
//                    Interval value = entry.getValue();
//                    if(varToLocation.get(key)!=null&&(!varToLocation.get(key).contains("sp"))&&value.end>var_end_line&&used_reg_list.get(varToLocation.get(key))==null){
//                        spill_reg=varToLocation.get(key);
//                        var_end_line=value.end;
//                        var_spill_name=key;
//                    }
//                }
//                if(!spill_reg.isEmpty()){
//                    if (!varOffset.containsKey(var_spill_name)) {
//                        nextOffset += 4;
//                        varOffset.put(var_spill_name, nextOffset);
//                    }
//                    varToLocation.put(var_spill_name, String.format("%d(sp)", varOffset.get(var_spill_name)));
//                    LLVMIRToRiscv.valueMap.put(var_spill_name,varToLocation.get(var_spill_name));
//                    asm.instr("sw",spill_reg,varToLocation.get(var_spill_name));
//                    used_reg_list.put(spill_reg,1);
//                    if (varOffset.containsKey(var)) {
//                        asm.instr("lw", spill_reg, String.format("%d(sp)", varOffset.get(var)));
//                    }
//                    varToLocation.put(var,spill_reg);
//                    LLVMIRToRiscv.valueMap.put(var,spill_reg);
//                }
//                else
//                {
//                    if (!varOffset.containsKey(var)) {
//                        nextOffset += 4;
//                        varOffset.put(var, nextOffset);
//                    }
//                    varToLocation.put(var, String.format("%d(sp)", varOffset.get(var)));
//                    LLVMIRToRiscv.valueMap.put(var,varToLocation.get(var));
//                }
//            }
//        }
//    }
//
//    public void expireOldIntervals(int currentLine) {
//        for (Map.Entry<String, Interval> entry : varToInterval.entrySet()) {
//            String var = entry.getKey();
//            Interval interval = entry.getValue();
//            if(currentLine>interval.end && varToLocation.containsKey(var)&&(!varToLocation.get(var).contains("sp"))) {
//                registers.add(varToLocation.get(var));
//                varToLocation.remove(var);
//            }
//        }
////        active.removeIf(interval -> {
////            if (interval.end >= currentLine) return false;
////            String loc = varToLocation.get(interval.varName);
////            if (!loc.contains("sp")) {
////                registers.add(loc);
////            }
////            return true;
////        });
//    }

    @Override
    public String allocate(String varName) {
        return varToLocation.get(varName);
    }
}
