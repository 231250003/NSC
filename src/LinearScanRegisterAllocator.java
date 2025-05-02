import java.util.*;

class LinearScanRegisterAllocator implements RegisterAllocator {

    private final Map<String, Interval> varToInterval;
    private final List<String> registers;
    private final Map<String, String> varToLocation = new HashMap<>();
    private final List<Interval> active = new ArrayList<>();
    private final Map<String, Integer> varOffset = new HashMap<>();
    private int nextOffset = 0;

    public LinearScanRegisterAllocator(List<Interval> allIntervals, List<String> registers) {
        this.registers = new ArrayList<>(registers);
        this.varToInterval = new HashMap<>();
        for (Interval interval : allIntervals) {
//            System.out.println("interval");
//            System.out.println(interval.varName);
//            System.out.println(interval.start);
//            System.out.println(interval.end);
            varToInterval.put(interval.varName, interval);
        }
    }

    @Override
    public void processInstruction(int lineNumber, String instruction) {
        expireOldIntervals(lineNumber);
//        System.out.println(lineNumber);
//        System.out.println("variable:");
        for (String var : LLVMIRToRiscv.extractVariables(instruction)) {
            System.out.println(var);
            if(var.equals("load_lval")) System.out.println("crz");
            Interval interval = varToInterval.get(var);
            if (interval == null || varToLocation.containsKey(var)) continue;

            if (!registers.isEmpty()) {
                String reg = registers.remove(0);
                varToLocation.put(var, reg);
                active.add(interval);
                active.sort(Comparator.comparingInt(i -> i.end));
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
        active.removeIf(interval -> {
            if (interval.end >= currentLine) return false;
            String loc = varToLocation.get(interval.varName);
            if (!loc.contains("sp")) {
                registers.add(loc);
            }
            return true;
        });
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
