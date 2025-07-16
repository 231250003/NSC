package  com.example;
import org.antlr.v4.runtime.*;

import org.antlr.v4.runtime.tree.ParseTree;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.bytedeco.javacpp.BytePointer;
import org.bytedeco.javacpp.Pointer;
import org.bytedeco.llvm.LLVM.*;
import org.bytedeco.llvm.global.LLVM;

import static org.bytedeco.llvm.global.LLVM.*;

public class Main {
    //public static boolean used_interpreter=false;
    public static void main(String[] args) throws IOException {
        /* if (args.length < 1) {
            System.err.println("input path is required");
        }*/
          String source = args[0];
         CharStream input = CharStreams.fromFileName(source);
         SysYLexer lexer = new SysYLexer(input);
          lexer.removeErrorListeners();
        MyErrorListener lexer_errorlistener=new MyErrorListener(errorType.LEXER_ERROR);
        lexer.addErrorListener(lexer_errorlistener);
         CommonTokenStream tokens = new CommonTokenStream(lexer);
        if(lexer_errorlistener.hasErrorInformation()){
            lexer_errorlistener.printErrorInformation();
            return;
        }
         SysYParser parser = new SysYParser(tokens);
         parser.removeErrorListeners();
        MyErrorListener parser_errorListener=new MyErrorListener(errorType.SYNTAX_ERROR);
        parser.addErrorListener(parser_errorListener);
        ParseTree tree = parser.program();
        if(parser_errorListener.hasErrorInformation()){
            parser_errorListener.printErrorInformation();
            return;
        }
        FormatterVisitor formatter_visitor = new FormatterVisitor();
        formatter_visitor.visit(tree);
        SemanticVisitor semantic_visitor=new SemanticVisitor();
        semantic_visitor.visit(tree);
        if(!OutputHelper.is_semantic_correct){
            return;
        }
        LLVMInitializeNativeTarget();
        LLVMInitializeNativeAsmPrinter();
        LLVMInitializeNativeAsmParser();
        LLVMModuleRef module = LLVMModuleCreateWithName("my_module");
        LLVMBuilderRef builder = LLVMCreateBuilder();
        IRGenerationVisitor IR_visitor = new IRGenerationVisitor(module, builder);
        IR_visitor.visit(tree);
       LLVMIROptimization optimization=new LLVMIROptimization(module);
        clean_terminator_inst(module);
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            while (remove_blocks_without_predecessors(func)) ;
        }
       // LLVMDumpModule(module);
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            boolean flag1 = true, flag2=true,flag3 = false, flag4 = false;
            while (flag1 || flag2||flag3 || flag4) {
                flag1 = optimization.constprop(func);
                System.out.println("crzzzzzzzzzzzzzzzzzz");
                flag2=optimization.pointer_must_optimize(func);
               // flag4 = optimization.elem_unused(func);
                //flag4 = optimization.elem_dead_code(func);
                //LLVMDumpModule(module);
            }
        }
        BytePointer error = new BytePointer((Pointer) null);
        if (LLVMPrintModuleToFile(module, args[1], error) != 0) {
            LLVMDisposeMessage(error);
        }
        LLVMIRToRiscv llvmirToRiscv=new LLVMIRToRiscv(module,args[1].substring(0,args[1].length()-3)+".riscv");
        llvmirToRiscv.to_riscv();
        LLVMDisposeBuilder(builder);
        LLVMDisposeModule(module);
    }
    public static void clean_terminator_inst(LLVMModuleRef module){
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func);
                 bb != null && !bb.isNull();
                 bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                boolean seenTerminator = false;
                List<LLVMValueRef> instructions = new ArrayList<>();
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null && !inst.isNull(); inst = LLVM.LLVMGetNextInstruction(inst)) {
                    instructions.add(inst);
                }
                for (LLVMValueRef inst : instructions) {
                    if (seenTerminator) {
                        LLVM.LLVMInstructionEraseFromParent(inst);
                    } else {
                        if (LLVM.LLVMIsATerminatorInst(inst) != null) {
                            seenTerminator = true;
                        }
                    }
                }
            }
        }
    }
    public static boolean remove_blocks_without_predecessors(LLVMValueRef mainFunction) {
        List<LLVMBasicBlockRef> toDelete = new ArrayList<>();
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(mainFunction); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            if (LLVMBasicBlockAsValue(bb).equals(LLVMBasicBlockAsValue(LLVMGetEntryBasicBlock(mainFunction))))continue;
            boolean hasPredecessor = false;
            for (LLVMBasicBlockRef otherBB = LLVM.LLVMGetFirstBasicBlock(mainFunction); otherBB != null && !otherBB.isNull(); otherBB = LLVM.LLVMGetNextBasicBlock(otherBB)) {
                LLVMValueRef terminator = LLVM.LLVMGetBasicBlockTerminator(otherBB);
                if (terminator == null || terminator.isNull()) continue;
                int numSucc = LLVM.LLVMGetNumSuccessors(terminator);
                for (int i = 0; i < numSucc; ++i) {
                    LLVMBasicBlockRef succ = LLVM.LLVMGetSuccessor(terminator, i);
                    if (LLVMBasicBlockAsValue(succ).equals(LLVMBasicBlockAsValue(bb))){
                        hasPredecessor = true;
                        break;
                    }
                }
                if (hasPredecessor) break;
            }
            if (!hasPredecessor) {
                toDelete.add(bb);
            }
        }
        boolean ret=false;
        for (LLVMBasicBlockRef bb : toDelete) {
            if(bb!=null) ret=true;
            LLVM.LLVMDeleteBasicBlock(bb);
        }
        return ret;
    }
}
