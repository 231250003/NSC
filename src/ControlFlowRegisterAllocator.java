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
//        for(int i=0;i<sortedEntries.size();i++){
//            System.out.println(sortedEntries.get(i).getKey());
//            System.out.println(sortedEntries.get(i).getValue().used_num);
//        }
    }

    @Override
    public void processInstruction(int lineNumber, String instruction) {
        expireOldIntervals(lineNumber);
//        System.out.println(lineNumber);
//        System.out.println("variable:");
        for (String var : LLVMIRToRiscv.extractVariables(instruction)) {
            Interval interval = varToInterval.get(var);
            if (interval == null || varToLocation.containsKey(var)) continue;
            boolean isInTop27 = false;
            int limit = Math.min(27, sortedEntries.size());
            System.out.println(var);
            for (int i = 0; i < limit; i++) {
                System.out.println(sortedEntries.get(i).getKey());
                if (sortedEntries.get(i).getKey().equals(var)) {
                    isInTop27 = true;
                    break;
                }
            }
            System.out.println("end of line");
            if (!registers.isEmpty()&&isInTop27) {
                System.out.println("crzzz");
                String reg = registers.remove(0);
                varToLocation.put(var, reg);
            } else {
                if (!varOffset.containsKey(var)) {
                    nextOffset += 4;
                    varOffset.put(var, nextOffset);
                }
                varToLocation.put(var, String.format("%d(sp)", varOffset.get(var)));
            }
        }
    }

    public void expireOldIntervals(int currentLine) {
//        for (Map.Entry<String, Interval> entry : varToInterval.entrySet()) {
//            String var = entry.getKey();
//            Interval interval = entry.getValue();
//            if(currentLine>interval.end && varToLocation.containsKey(var)&&(!varToLocation.get(var).contains("sp"))) {
//                String reg=varToLocation.get(var);
//                registers.add(varToLocation.get(var));
//                varToLocation.remove(var);
//                if (!varOffset.containsKey(var)) {
//                    nextOffset += 4;
//                    varOffset.put(var, nextOffset);
//                }
//                varToLocation.put(var, String.format("%d(sp)", varOffset.get(var)));
//                asmBuilder.instr("sw",reg,varToLocation.get(var));
//            }
//        }
//        active.removeIf(interval -> {
//            if (interval.end >= currentLine) return false;
//            String loc = varToLocation.get(interval.varName);
//            if (!loc.contains("sp")) {
//                registers.add(loc);
//            }
//            return true;
//        });
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
