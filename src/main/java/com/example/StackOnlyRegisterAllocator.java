package  com.example;
import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;

import java.util.HashMap;
import java.util.Map;

public class StackOnlyRegisterAllocator implements RegisterAllocator {
    private final Map<String, Integer> varOffset = new HashMap<>();
    private int nextOffset = 0;

    @Override
    public String allocate(String varName) {
        if (!varOffset.containsKey(varName)) {
            nextOffset += 4;
            varOffset.put(varName, nextOffset);
        }
        // 以 sp 为基准偏移，栈增长方向向下（负偏移）
        return String.format("%d(sp)", varOffset.get(varName));
    }
}
