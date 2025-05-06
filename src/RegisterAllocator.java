import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;

public interface RegisterAllocator {

    String allocate(String varName);
    int getStackSize();
    public void processInstruction(int lineNumber, String instruction);
}
