import org.antlr.v4.runtime.*;

import org.antlr.v4.runtime.tree.ParseTree;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.bytedeco.javacpp.BytePointer;
import org.bytedeco.javacpp.Pointer;
import org.bytedeco.llvm.LLVM.*;
import static org.bytedeco.llvm.global.LLVM.*;
public class Main {

    public static void main(String[] args) throws IOException {
        /* if (args.length < 1) {
            System.err.println("input path is required");
        }*/
          String source = args[0];
         // if(args[0].contains("normaltes12t0"))  return;
         CharStream input = CharStreams.fromFileName(source);
         SysYLexer lexer = new SysYLexer(input);
          lexer.removeErrorListeners();
//        MyErrorListener errorListener=new MyErrorListener(1);
//        lexer.addErrorListener(errorListener);

         CommonTokenStream tokens = new CommonTokenStream(lexer);

         SysYParser parser = new SysYParser(tokens);
         parser.removeErrorListeners();
        //MyErrorListener parser_errorListener=new MyErrorListener(2);

//        if(errorListener.hasErrorInformation()){
//            errorListener.printLexerErrorInformation(false);
//        }
//         else
//        if(parser_errorListener.hasErrorInformation()){
//            parser_errorListener.printErrorInformation();
//        }
//        else {
//             if(parser_errorListener.type==1){
//                 //List<? extends Token> myTokens = lexer.getAllTokens();
//                //for(Token t: myTokens){
//                 ///printSysYTokenInformation(t);
//             }
//             if (parser_errorListener.type == 2) {
//                parser.reset();
//                ParseTree tree = parser.program();
//                FormatterVisitor visitor = new FormatterVisitor();
//                visitor.visit(tree);
//             }
//        }
   //       ParseTree semantic_tree= parser.program();
     //     SemanticVisitor semantic_visitor=new SemanticVisitor();
       //   semantic_visitor.visit(semantic_tree);
         // if(OutputHelper.is_semantic_correct){
           //   System.err.println("No semantic errors in the program!");
          //}
        LLVMInitializeNativeTarget();
        LLVMInitializeNativeAsmPrinter();
        LLVMInitializeNativeAsmParser();
        LLVMModuleRef module = LLVMModuleCreateWithName("my_module");
        LLVMBuilderRef builder = LLVMCreateBuilder();
        ParseTree tree = parser.program();
        IRGenerationVisitor visitor = new IRGenerationVisitor(module, builder);
        visitor.visit(tree);
       // LLVMDumpModule(module);
        LLVMValueRef func = LLVMGetFirstFunction(module);
        while (func != null && !func.isNull()) {
            LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(func);
            while (block != null && !block.isNull()) {
                // 对每个 block 做清理操作
                cleanBasicBlock(block);
                block = LLVMGetNextBasicBlock(block);
            }

            func = LLVMGetNextFunction(func);
        }
        BytePointer error = new BytePointer((Pointer) null);
        if (LLVMPrintModuleToFile(module, args[1], error) != 0) {
            LLVMDisposeMessage(error);
        }
        LLVMDisposeBuilder(builder);
        LLVMDisposeModule(module);
    }
    /*public static void printSysYTokenInformation(Token t){
        String tokenType = SysYLexer.VOCABULARY.getSymbolicName(t.getType());
        String tokenText=t.getText();
        if(tokenType.equals("INTEGER_CONST")){
            if(tokenText.length()>2&&(tokenText.substring(0,2).equals("0x")||tokenText.substring(0,2).equals("0X"))){
                tokenText=String.valueOf(Integer.parseInt(tokenText.substring(2),16));
            }
            else if(tokenText.charAt(0)=='0'&&tokenText.length()>1){
                tokenText=String.valueOf(Integer.parseInt(tokenText.substring(1),8));
            }
        }
        System.err.printf("%s %s at Line %d.%n", tokenType,tokenText, t.getLine());
    }*/
    private static void cleanBasicBlock(LLVMBasicBlockRef block) {
        LLVMValueRef instr = LLVMGetFirstInstruction(block);
        boolean reachedTerminator = false;

        while (instr != null && !instr.isNull()) {
            LLVMValueRef next = LLVMGetNextInstruction(instr);

            if (reachedTerminator) {
                // 删除 ret / br 后的冗余指令
                LLVMInstructionEraseFromParent(instr);
            } else {
                if (LLVMIsATerminatorInst(instr) != null) {
                    reachedTerminator = true;
                }
            }

            instr = next;
        }

        // 清理空 block：如果 block 是空的或只包含 terminator，可以跳过，
        // 但如果是完全空块（没有 terminator），应该从函数中删除
        LLVMValueRef first = LLVMGetFirstInstruction(block);
        if (first == null || first.isNull()) {
            LLVMDeleteBasicBlock(block); // 这必须谨慎，确保没有其他地方跳转到这里
        }
    }
}
