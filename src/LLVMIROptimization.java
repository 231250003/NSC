import org.bytedeco.llvm.LLVM.LLVMModuleRef;

public class LLVMIROptimization {
    LLVMModuleRef module;
    public LLVMIROptimization(LLVMModuleRef module){
        this.module=module;
    }
    public void constprop(){
        return;
    }
}
