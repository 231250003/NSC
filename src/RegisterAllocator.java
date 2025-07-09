import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;

public interface RegisterAllocator {

    String allocate(String varName);
}
