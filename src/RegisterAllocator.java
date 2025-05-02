public interface RegisterAllocator {

    String allocate(String varName);
    int getStackSize();
    public void processInstruction(int lineNumber, String instruction);
}
