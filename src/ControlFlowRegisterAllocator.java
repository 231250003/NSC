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
        Set<String> vars=LLVMIRToRiscv.extractVariables(instruction);
//        for (Map.Entry<String, Interval> entry : varToInterval.entrySet()) {
//            String var = entry.getKey();
//            Interval interval = entry.getValue();
//            if(interval.start<=lineNumber&&interval.end>=lineNumber) vars.add(var);
//        }
        for (String var : vars) {
            Interval interval = varToInterval.get(var);
            if (interval == null || varToLocation.containsKey(var)) continue;
            if (!registers.isEmpty()) {
                String reg = registers.remove(0);
                varToLocation.put(var, reg);
            } else {
                if (!varOffset.containsKey(var)) {
                    nextOffset += 4;
                    varOffset.put(var, nextOffset);
                }
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
                varToLocation.remove(var);
            }
        }
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
