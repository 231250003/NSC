import java.util.*;

class ControlFlowRegisterAllocator implements RegisterAllocator {

    private final Map<String, Interval> varToInterval;
    private final List<String> registers;
    private final Map<String, String> varToLocation = new HashMap<>();
    List<Map.Entry<String, Interval>> sortedEntries=new ArrayList<>();
    private final Map<String, Integer> varOffset = new HashMap<>();
    private int nextOffset = 0;
    private  AsmBuilder asmBuilder;
    public ControlFlowRegisterAllocator(List<Interval> allIntervals, List<String> registers,AsmBuilder asmBuilder) {
        this.registers = new ArrayList<>(registers);
        this.varToInterval = new HashMap<>();
        for (Interval interval : allIntervals) {
            varToInterval.put(interval.varName, interval);
        }
        this.asmBuilder=asmBuilder;
        List<Map.Entry<String, Interval>> sortedEntries = new ArrayList<>(varToInterval.entrySet());
        sortedEntries.sort((e1, e2) -> Integer.compare(e2.getValue().used_num, e1.getValue().used_num));
        this.sortedEntries=sortedEntries;
//        for(int i=0;i<sortedEntries.size();i++){
//            System.out.println(sortedEntries.get(i).getKey());
//            System.out.println(sortedEntries.get(i).getValue().used_num);
//        }
    }

    public void processInstruction(int lineNumber, String instruction) {
        expireOldIntervals(lineNumber);
        Map<String,Integer> used_reg_list=new HashMap<>();
        for (String var : LLVMIRToRiscv.extractVariables(instruction)) {
            Interval interval = varToInterval.get(var);
            if (interval == null || varToLocation.containsKey(var)) continue;
            if (!registers.isEmpty()) {
                String reg = registers.remove(0);
                varToLocation.put(var, reg);
            } else {
                int var_end_line=interval.end;
                String spill_reg="";
                String var_spill_name=var;
                for (Map.Entry<String, Interval> entry : varToInterval.entrySet()) {
                    String key = entry.getKey();
                    Interval value = entry.getValue();
                    if(varToLocation.get(key)!=null&&(!varToLocation.get(key).contains("sp"))&&value.end>var_end_line&&used_reg_list.get(varToLocation.get(key))==null){
                        spill_reg=varToLocation.get(key);
                        var_end_line=value.end;
                        var_spill_name=key;
                    }
                }
                if(!spill_reg.isEmpty()){
                    if (!varOffset.containsKey(var_spill_name)) {
                        nextOffset += 4;
                        varOffset.put(var_spill_name, nextOffset);
                    }
                    varToLocation.put(var_spill_name, String.format("%d(sp)", varOffset.get(var_spill_name)));
                    LLVMIRToRiscv.valueMap.put(var_spill_name,varToLocation.get(var_spill_name));
                    asmBuilder.instr("sw",spill_reg,varToLocation.get(var_spill_name));
                    used_reg_list.put(spill_reg,1);
                    if (varOffset.containsKey(var)) {
                        asmBuilder.instr("lw", spill_reg, String.format("%d(sp)", varOffset.get(var)));
                    }
                    varToLocation.put(var,spill_reg);
                    LLVMIRToRiscv.valueMap.put(var,spill_reg);
                }
                else
                {
                    if (!varOffset.containsKey(var)) {
                        nextOffset += 4;
                        varOffset.put(var, nextOffset);
                    }
                    varToLocation.put(var, String.format("%d(sp)", varOffset.get(var)));
                    LLVMIRToRiscv.valueMap.put(var,varToLocation.get(var));
                }
            }
        }
    }

    public void expireOldIntervals(int currentLine) {
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
