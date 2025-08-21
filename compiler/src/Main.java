  
import org.antlr.v4.runtime.*;

import org.antlr.v4.runtime.tree.ParseTree;
import java.nio.file.Path;
import java.nio.file.Paths;
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
import java.io.*;
import java.util.regex.*;
import static org.bytedeco.llvm.global.LLVM.*;
import java.util.HashMap;
import java.util.Map;
public class Main {
    public static final Map<String, Integer> CONSTANTS = new HashMap<>();
    public static boolean is_rars=false;
    public static void main(String[] args) throws IOException {
        boolean cover_file=false;
        if (args.length < 1) {
            System.out.println("input path is required");
            return;
        }
        boolean has_ll=false;
        for (int i = 1; i < args.length; i++) {
            if ("-l".equals(args[i])) {
                has_ll =true;
            } else if ("-c".equals(args[i])) {
                cover_file = true;
            }
            else if ("-t".equals(args[i])) {
                is_rars = true;
            }
        }

        load_constant();
        String source = args[0];
        // CharStream input = CharStreams.fromFileName(source);
        if(args[0].length()<6||(!args[0].endsWith(".sysy"))){
            System.out.println("input file must end with .sysy");
            return;
        }
        CharStream input =loadWithIncludes(source);
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
        PrintStream originalOut = System.out;
        if(cover_file){
            new FileOutputStream(args[0],false).close();
            PrintStream fileOut = new PrintStream(new FileOutputStream(args[0], false));
            System.setOut(fileOut);
            FormatterVisitor formatter_visitor = new FormatterVisitor();
            formatter_visitor.visit(tree);
            System.setOut(originalOut);
        }
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

        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            boolean flag0=true,flag1 = true, flag2=true,flag3 = true;
            while (flag0||flag1 || flag2||flag3 ) {
                flag0=optimization.pointer_must_optimize(func);
                flag1 = optimization.constprop(func);
                flag2 = optimization.elem_unused(func);
                flag3 = optimization.elem_dead_code(func);
            }
        }
        BytePointer error = new BytePointer((Pointer) null);
        if(has_ll){
            if (LLVMPrintModuleToFile(module,args[0].substring(0,args[0].length()-5)+".ll",error) != 0) {
                LLVMDisposeMessage(error);
            }
        }
        LLVMIRToRiscv llvmirToRiscv=new LLVMIRToRiscv(module,args[0].substring(0,args[0].length()-5)+".riscv");
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

    public static void load_constant() {
        try {
            String filePath = "config.h";
            BufferedReader reader = new BufferedReader(new FileReader(filePath));
            String line;
            Pattern pattern = Pattern.compile("#define\\s+(\\w+)\\s+(.+)");
            while ((line = reader.readLine()) != null) {
                Matcher matcher = pattern.matcher(line.trim());
                if (matcher.find()) {
                    String key = matcher.group(1);
                    String value = matcher.group(2).split("\\s+")[0]; // 去掉注释
                    if (value.matches("\\d+")) {
                        CONSTANTS.put(key, Integer.parseInt(value));
                    } 
                }
            }
            reader.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public static String loadFile(Path filePath, Set<String> visited) throws IOException {
        filePath = filePath.toAbsolutePath();

        // 避免重复 include
        if (!visited.add(filePath.toString())) {
            return "";
        }

        String source = Files.readString(filePath);
        // 匹配 #include <xxx.h>
        Pattern p = Pattern.compile("^#include\\s*<([^>]+)>", Pattern.MULTILINE);
        Matcher m = p.matcher(source);

        StringBuilder result = new StringBuilder();
        int lastEnd = 0;

        while (m.find()) {
            // 先拷贝 include 前的代码
            result.append(source, lastEnd, m.start());

            // include 的路径
            String headerPath = m.group(1);

            // 相对当前文件目录解析
            Path resolved = filePath.getParent().resolve(headerPath);

            // 递归处理头文件
            String headerContent = loadFile(resolved, visited);
            result.append(headerContent);

            lastEnd = m.end();
        }

        // 剩下部分加上
        result.append(source.substring(lastEnd));
        return result.toString();
    }

    /** 封装函数：返回展开后的 CharStream */
    public static CharStream loadWithIncludes(String filePath) throws IOException {
        Set<String> visited = new HashSet<>();
        Path start = Path.of(filePath);
        String combinedSource = loadFile(start, visited);
        return CharStreams.fromString(combinedSource);
    }
}
