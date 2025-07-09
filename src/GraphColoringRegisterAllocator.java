import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;
import org.bytedeco.llvm.LLVM.LLVMModuleRef;
import org.bytedeco.llvm.LLVM.LLVMValueRef;
import org.bytedeco.llvm.global.LLVM;

import java.util.*;

public class GraphColoringRegisterAllocator implements RegisterAllocator {
    private List<String> total_registers;
    private List<String> freed_register;
    private Map<String, Set<String>> variable_def_in_block = new HashMap<>();
    private Map<String, Set<String>> variable_use_in_block = new HashMap<>();
    private static Map<String, LLVMBasicBlockRef> name2blockref = new HashMap<>();
    private static int nextOffset = 0;
    private static final Map<String, Integer> varOffset = new HashMap<>();
    private LLVMModuleRef module;
    private Map<String, Set<String>> live_variable_block_in = new HashMap<>();
    private Map<String, Set<String>> live_variable_block_out = new HashMap<>();
    private Map<String, Set<String>> inference_graph = new HashMap<>();

    public void cal_def_use() {
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                variable_def_in_block.put(LLVM.LLVMGetBasicBlockName(bb).getString(), new HashSet<>());
                variable_use_in_block.put(LLVM.LLVMGetBasicBlockName(bb).getString(), new HashSet<>());
                name2blockref.put(LLVM.LLVMGetBasicBlockName(bb).getString(), bb);
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                    String line = LLVM.LLVMPrintValueToString(inst).getString();
                    if (line.contains("br") || line.contains("alloca")) continue;
                    for (String var : LLVMIRToRiscv.extractVariables(line)) {
                        if (!varOffset.containsKey(var)) {
                            nextOffset += 4;
                            varOffset.put(var, nextOffset);
                        }
                    }
                    String line3;
                    if (line.contains("=")) line3 = line.substring(line.indexOf("=") + 1);
                    else if (line.contains("store") && line.contains("i32* %")) {
                        line3 = line.substring(0, line.indexOf(","));
                    } else line3 = line;
                    for (String var : LLVMIRToRiscv.extractVariables(line3)) {
                        Set<String> variables = variable_use_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString());
                        if (!variable_def_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString()).contains(var)) {
                            variables.add(var);
                        }
                    }
                    if (line.contains("=") || (line.contains("store") && line.contains("i32* %"))) {
                        String line2;
                        if (line.contains("=")) line2 = line.substring(0, line.indexOf("="));
                        else line2 = line.substring(line.indexOf(",") + 1);
                        for (String var : LLVMIRToRiscv.extractVariables(line2)) {
                            Set<String> variables = variable_def_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString());
                            if (!variable_use_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString()).contains(var)) {
                                variables.add(var);
                            }
                            break;
                        }
                    }
                }
            }
        }
    }

    public void cal_in_out_block() {
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                variable_def_in_block.put(LLVM.LLVMGetBasicBlockName(bb).getString(), new HashSet<>());
                variable_use_in_block.put(LLVM.LLVMGetBasicBlockName(bb).getString(), new HashSet<>());
            }
        }
        boolean changed;
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            do {
                changed = false;
                for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                    Set<String> out = new HashSet<>();
                    int numSuccessors = LLVM.LLVMGetNumSuccessors(LLVM.LLVMGetLastInstruction(bb));
                    for (int i = 0; i < numSuccessors; i++) {
                        LLVMBasicBlockRef succ = LLVM.LLVMGetSuccessor(LLVM.LLVMGetLastInstruction(bb), i);
                        String succName = LLVM.LLVMGetBasicBlockName(succ).getString();
                        out.addAll(live_variable_block_in.get(succName));
                    }
                    if (!out.equals(live_variable_block_out.get(LLVM.LLVMGetBasicBlockName(bb).getString()))) {
                        live_variable_block_out.put(LLVM.LLVMGetBasicBlockName(bb).getString(), out);
                        changed = true;
                    }
                    Set<String> in = new HashSet<>(variable_use_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString()));
                    Set<String> outMinusDef = new HashSet<>(out);
                    outMinusDef.removeAll(variable_def_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString()));
                    in.addAll(outMinusDef);
                    if (!in.equals(live_variable_block_in.get(LLVM.LLVMGetBasicBlockName(bb).getString()))) {
                        live_variable_block_in.put(LLVM.LLVMGetBasicBlockName(bb).getString(), in);
                        changed = true;
                    }
                }
            } while (changed);
        }
    }

    public void create_graph() {

    }

    public GraphColoringRegisterAllocator(LLVMModuleRef moduleRef, List<String> reg_list) {
        this.module = moduleRef;
        total_registers = new ArrayList<>(reg_list);
        freed_register = new ArrayList<>(reg_list);
    }

    public String allocate(String varName) {
        return null;
    }

}
