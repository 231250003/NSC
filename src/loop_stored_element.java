import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;
import org.bytedeco.llvm.LLVM.*;


public class loop_stored_element{
    public LLVMBasicBlockRef cond_block;
    public LLVMBasicBlockRef merge_block;
    public SysYParser.StmtContext ctx;
    public loop_stored_element(){}
    public loop_stored_element(LLVMBasicBlockRef cond_block,LLVMBasicBlockRef merge_block,SysYParser.StmtContext ctx){
        this.cond_block=cond_block;
        this.merge_block=merge_block;
        this.ctx=ctx;
    }
}
