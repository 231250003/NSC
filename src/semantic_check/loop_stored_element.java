package semantic_check;

import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.bytedeco.javacpp.PointerPointer;
import org.antlr.v4.runtime.tree.RuleNode;
import org.bytedeco.llvm.LLVM.*;


import java.util.*;

import static org.bytedeco.llvm.global.LLVM.*;
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
