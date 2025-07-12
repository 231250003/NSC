import org.bytedeco.javacpp.PointerPointer;
import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;
import org.bytedeco.llvm.LLVM.LLVMModuleRef;
import org.bytedeco.llvm.LLVM.LLVMTypeRef;
import org.bytedeco.llvm.LLVM.LLVMValueRef;
import org.bytedeco.llvm.global.LLVM;

import java.util.*;
import java.util.stream.Collectors;

public class GraphColoringRegisterAllocator implements RegisterAllocator {
    private Map<String, Set<String>> variable_def_in_block = new HashMap<>();
    private Map<String, Set<String>> variable_use_in_block = new HashMap<>();
    private static Map<String, LLVMBasicBlockRef> name2blockref = new HashMap<>();
    private Map<String, Set<String>> live_variable_block_in = new HashMap<>();
    private Map<String, Set<String>> live_variable_block_out = new HashMap<>();
    private Map<String, Set<String>> graph = new HashMap<>();
    private Map<LLVMValueRef, Set<String>> in_inst = new HashMap<>();
    private static Map<LLVMValueRef, Set<String>> out_inst = new HashMap<>();
    private Map<String, String> valueMap = new HashMap<>();
    private Stack<String> color_order = new Stack<>();
    Map<String, Integer> var_used_num = new HashMap<>();
    List<array_variable> array_variable_ref = new ArrayList<>();//在跨块分析活跃变量时例如定义a[1]后后面访问a[i],a[1]可能是活跃的

    public void cal_def_use(LLVMValueRef func) {
//        int paramCount = LLVM.LLVMCountParams(func);
//        PointerPointer<LLVMValueRef> params = new PointerPointer<>(paramCount);
//        LLVM.LLVMGetParams(func, params);
//        for (int i = 0; i < paramCount; i++) {
//            LLVMValueRef param = new LLVMValueRef(params.get(i));
//            String paramName = LLVM.LLVMGetValueName(param).getString();
//            variable_
//        }

        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            variable_def_in_block.putIfAbsent(LLVM.LLVMGetBasicBlockName(bb).getString(), new HashSet<>());
            variable_use_in_block.putIfAbsent(LLVM.LLVMGetBasicBlockName(bb).getString(), new HashSet<>());
            name2blockref.put(LLVM.LLVMGetBasicBlockName(bb).getString(), bb);
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                String line = LLVM.LLVMPrintValueToString(inst).getString();
                if (line.contains("br") || line.contains("alloca")) continue;
                for (String var : LLVMIRToRiscv.extractVariables(line)) {
                    valueMap.putIfAbsent(var, "");
                    var_used_num.putIfAbsent(var, 0);
                    var_used_num.put(var, var_used_num.get(var) + 1);
                }
                if (LLVM.LLVMGetInstructionOpcode(inst) == LLVM.LLVMGetElementPtr) {
                    String variable_name = LLVM.LLVMGetValueName(inst).getString();
                    LLVMValueRef base_ptr = LLVM.LLVMGetOperand(inst, 0);
                    LLVMTypeRef base_type = LLVM.LLVMTypeOf(base_ptr);
                    LLVMTypeRef array_type = LLVM.LLVMGetElementType(base_type);
                    int array_dim = 0;
                    LLVMTypeRef current = array_type;
                    List<Integer> array_size = new ArrayList<>();
                    int operand_count = LLVM.LLVMGetNumOperands(inst);
                    List<Object> cur_offset = new ArrayList<>();
                    for (int i = 2; i < operand_count; i++) {
                        LLVMValueRef index = LLVM.LLVMGetOperand(inst, i);
                        if (LLVM.LLVMIsAConstant(index) != null) {
                            long val = LLVM.LLVMConstIntGetZExtValue(index);
                            cur_offset.add((int) val);
                        } else {
                            cur_offset.add(index);
                        }
                    }
                    while (LLVM.LLVMGetTypeKind(current) == LLVM.LLVMArrayTypeKind) {
                        long len = LLVM.LLVMGetArrayLength(current);
                        array_size.add((int) len);
                        array_dim++;
                        current = LLVM.LLVMGetElementType(current);
                    }
                    if (operand_count - 2 < array_dim) {
                        valueMap.put(variable_name, "stack");
                    }
                    valueMap.put(LLVM.LLVMGetValueName(base_ptr).getString(), "stack");
                    array_variable av = new array_variable(variable_name, LLVM.LLVMGetValueName(base_ptr).getString(), array_dim, cur_offset, array_size);
                    array_variable_ref.add(av);
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
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                if (LLVM.LLVMGetInstructionOpcode(inst) == LLVM.LLVMGetElementPtr) {
                    String variable_name = LLVM.LLVMGetValueName(inst).getString();
                    array_variable cur = new array_variable();
                    for (array_variable x : array_variable_ref) {
                        if (x.variable_name.equals(variable_name)) {
                            cur = x;
                            break;
                        }
                    }
                    for (array_variable x : array_variable_ref) {
                        if (naive_alias_may_analysis(x, cur) == true)
                            variable_use_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString()).add(x.variable_name);
                    }
                }
            }
        }
        var_used_num = var_used_num.entrySet()
                .stream()
                .sorted(Map.Entry.comparingByValue()) // 按 Value 排序
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (oldVal, newVal) -> oldVal, // 合并冲突时保留旧值
                        LinkedHashMap::new // 使用 LinkedHashMap 保持顺序
                ));
    }

    public static boolean naive_alias_may_analysis(array_variable dest, array_variable src) {
        if (!dest.array_name.equals(src.array_name)) return false;
        for (int i = 0; i < Math.min(dest.cur_offset.size(), src.cur_offset.size()); i++) {
            if ((!(dest.cur_offset.get(i) instanceof Integer)) || (!(src.cur_offset.get(i) instanceof Integer)))
                return true;
            else {
                if (!dest.cur_offset.get(i).equals(src.cur_offset.get(i))) return false;
            }
        }
        return true;
    }

    public void cal_in_out_block(LLVMValueRef func) {
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            live_variable_block_in.put(LLVM.LLVMGetBasicBlockName(bb).getString(), new HashSet<>());
            live_variable_block_out.put(LLVM.LLVMGetBasicBlockName(bb).getString(), new HashSet<>());
        }
        boolean changed;
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

    public void create_graph(LLVMValueRef func) {
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            LLVMValueRef instr = LLVM.LLVMGetLastInstruction(bb);
            out_inst.put(instr, live_variable_block_out.get(LLVM.LLVMGetBasicBlockName(bb).getString()));
            while (instr != null) {
                String line = LLVM.LLVMPrintValueToString(instr).getString();
                String line3;
                if (line.contains("=")) line3 = line.substring(line.indexOf("=") + 1);
                else if (line.contains("store") && line.contains("i32* %")) {
                    line3 = line.substring(0, line.indexOf(","));
                } else if (line.contains("br") && line.contains("label")) {
                    if (line.contains(",")) line3 = line.substring(0, line.indexOf(","));
                    else line3 = "";
                } else line3 = line;
                Set<String> used = new HashSet<>();
                for (String var : LLVMIRToRiscv.extractVariables(line3)) {
                    used.add(var);
                }
                Set<String> def = new HashSet<>();
                if (line.contains("=") || (line.contains("store") && line.contains("i32* %"))) {
                    String line2;
                    if (line.contains("=")) line2 = line.substring(0, line.indexOf("="));
                    else line2 = line.substring(line.indexOf(",") + 1);
                    for (String var : LLVMIRToRiscv.extractVariables(line2)) {
                        def.add(var);
                        break;
                    }
                }
                Set<String> in_instr_live_set = new HashSet<>(out_inst.get(instr));
                in_instr_live_set.removeAll(def);
                in_instr_live_set.addAll(used);
                in_inst.put(instr, in_instr_live_set);
                instr = LLVM.LLVMGetPreviousInstruction(instr);
                if (instr != null) out_inst.put(instr, in_instr_live_set);
            }
            for (Map.Entry<LLVMValueRef, Set<String>> entry : out_inst.entrySet()) {
                Set<String> value = entry.getValue();
                for (String x : value) {
                    for (String y : value) {
                        if (graph.get(x) == null) graph.put(x, new HashSet<>());
                        if (graph.get(y) == null) graph.put(y, new HashSet<>());
                        if (!x.equals(y)) {
                            graph.get(x).add(y);
                            graph.get(y).add(x);
                        }
                    }
                }
            }
            for (String x : live_variable_block_in.get(LLVM.LLVMGetBasicBlockName(bb).getString())) {
                for (String y : live_variable_block_in.get(LLVM.LLVMGetBasicBlockName(bb).getString())) {
                    if (graph.get(x) == null) graph.put(x, new HashSet<>());
                    if (graph.get(y) == null) graph.put(y, new HashSet<>());
                    if (!x.equals(y)) {
                        graph.get(x).add(y);
                        graph.get(y).add(x);
                    }
                }
            }
        }
    }

    void color_no_spill_reg() {
//        for(Map.Entry<String, Set<String>> entry : graph.entrySet()){
//            String key=entry.getKey();
//            Set<String> value=entry.getValue();
//            System.out.print(key);
//            System.out.print(" ");
//            for(String x:value){
//                System.out.print(x);
//                System.out.print(" ");
//            }
//            System.out.println();
//        }
        while (!color_order.isEmpty()) {
            String key = color_order.pop();
            Set<String> value = graph.get(key);
            List<String> can_use_reg = new ArrayList<>(available_register);
            for (String x : value) {
                if (valueMap.get(x) == null) continue;
                if (!valueMap.get(x).equals("stack")) {
                    can_use_reg.remove(valueMap.get(x));
                }
            }
            String reg = can_use_reg.get(0);
            valueMap.put(key, reg);
        }
    }

    public void color_graph() {
        Map<String, Set<String>> part_graph = new HashMap<>();
        for (Map.Entry<String, Set<String>> entry : graph.entrySet()) {
            part_graph.put(entry.getKey(), new HashSet<>(entry.getValue()));
        }
        while (part_graph.size() > 0) {
            boolean need_spill = true;
            for (Map.Entry<String, Set<String>> entry : part_graph.entrySet()) {
                String key = entry.getKey();
                Set<String> value = entry.getValue();
                if ((!"stack".equals(valueMap.get(key))) && value.size() < available_register.size()) {
                    need_spill = false;
                    for (String x : value) {
                        part_graph.get(x).remove(key);
                    }
                    part_graph.remove(key);
                    color_order.push(key);
                    break;
                }
            }
            if (need_spill) {
                for (Map.Entry<String, Integer> entry : var_used_num.entrySet()) {
                    if (part_graph.get(entry.getKey()) != null) {
                        valueMap.put(entry.getKey(), "stack");
                        Set<String> value = graph.get(entry.getKey());
                        for (String x : value) {
                            if (part_graph.get(x) != null) part_graph.get(x).remove(entry.getKey());
                            if (graph.get(x) != null) graph.get(x).remove(entry.getKey());
                        }
                        graph.remove(entry.getKey());
                        part_graph.remove(entry.getKey());
                        break;
                    }
                }
            }
        }
        color_no_spill_reg();
    }

    public static Set<String> get_after_cur_inst_live_variable(LLVMValueRef x) {
        return out_inst.get(x);
    }

    public GraphColoringRegisterAllocator(LLVMValueRef func) {
        variable_def_in_block = new HashMap<>();
        variable_use_in_block = new HashMap<>();
        name2blockref = new HashMap<>();
        live_variable_block_in = new HashMap<>();
        live_variable_block_out = new HashMap<>();
        graph = new HashMap<>();
        in_inst = new HashMap<>();
        out_inst = new HashMap<>();
        valueMap = new HashMap<>();
        var_used_num = new HashMap<>();
        color_order = new Stack<>();
        array_variable_ref = new ArrayList<>();
        cal_def_use(func);
        cal_in_out_block(func);
        create_graph(func);
        color_graph();
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)){
            System.out.println();
            System.out.println();
            System.out.println();
            System.out.println(LLVM.LLVMGetBasicBlockName(bb).getString());
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)){
                System.out.println(LLVM.LLVMPrintValueToString(inst).getString());
                for(String x:out_inst.get(inst)){
                    System.out.print(x);
                    System.out.print(" ");
                }
                System.out.println();
            }
        }
//        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)){
//            System.out.println();
//            System.out.println(LLVM.LLVMGetBasicBlockName(bb).getString());
//            System.out.println("in");
//            for(String x:live_variable_block_in.get(LLVM.LLVMGetBasicBlockName(bb).getString())){
//                    System.out.print(x);
//                    System.out.print(" ");
//            }
//            System.out.println();
//            System.out.println("out");
//            for(String x:live_variable_block_out.get(LLVM.LLVMGetBasicBlockName(bb).getString())){
//                System.out.print(x);
//                System.out.print(" ");
//            }
//            System.out.println();
//
//        }
//        for (Map.Entry<String, String> entry : valueMap.entrySet()) {
//            System.out.print(entry.getKey());
//            System.out.print(" ");
//            System.out.println(entry.getValue());
//        }
    }

    public String allocate(String varName) {
        if (valueMap.containsKey(varName)) return valueMap.get(varName);
        else return null;
    }

}
