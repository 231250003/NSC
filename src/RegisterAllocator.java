import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public interface RegisterAllocator {
    List<String> available_register= Arrays.asList("x8","x9","x11","x12","x13","x14","x15","x16");
    String allocate(String varName);
}
