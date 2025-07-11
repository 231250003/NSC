import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public interface RegisterAllocator {
    //List<String> available_register= Arrays.asList("x8","x9","x11");
    List<String> available_register=new ArrayList<>();
    String allocate(String varName);
}
