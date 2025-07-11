import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public interface RegisterAllocator {
    //List<String> available_register= Arrays.asList("x8","x9","x11","x12");
   //List<String> available_register= new ArrayList<>();
    List<String> available_register= Arrays.asList("x8","x9","x11","x12","x13","x14","x15","x16","x17","x18","x19","x20","x21","x22","x23","x24","x25","x26","x27","x28","x29","x30","x31");

    String allocate(String varName);
}
