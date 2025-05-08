import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;
import org.bytedeco.llvm.LLVM.LLVMModuleRef;
import org.bytedeco.llvm.LLVM.LLVMValueRef;
import org.bytedeco.llvm.global.LLVM;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class LLVMIRInterpreter {
    LLVMModuleRef module;
    private static final Map<String,LLVMBasicBlockRef> name2blockref=new HashMap<>();
    Map<String,Integer> symbol;
    public LLVMIRInterpreter(LLVMModuleRef module){
        this.module=module;
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                name2blockref.put(LLVM.LLVMGetBasicBlockName(bb).getString(),bb);
            }
        }
        symbol=new HashMap<>();
    }
    public static List<String> extractVariables(String line) {
        List<String> variables = new ArrayList<>();
        Pattern pattern = Pattern.compile("%[a-zA-Z0-9_\\.]+");
        Matcher matcher = pattern.matcher(line);
        while (matcher.find()) {
            variables.add(matcher.group().substring(1));
        }
        return variables;
    }
    public int Process_block(LLVMBasicBlockRef bb){
        for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
            String line = LLVM.LLVMPrintValueToString(inst).getString();
            if(line.contains("alloca")) continue;
            else if(line.contains("load")){
                //String src=e
            }
        }
        return 1;
    }
}
