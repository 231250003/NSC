package  com.example;
import org.bytedeco.javacpp.BytePointer;
import org.bytedeco.llvm.LLVM.*;
import org.bytedeco.llvm.global.LLVM;

import javax.swing.plaf.nimbus.AbstractRegionPainter;
import java.util.*;
import java.util.regex.*;

import static java.lang.Math.max;
import static org.bytedeco.llvm.global.LLVM.*;

public class LLVMIRToRiscv {
    String file_path;
    LLVMModuleRef module;
    public static AsmBuilder asm = new AsmBuilder();
    RegisterAllocator allocator;
    int next_offset = 0;
    Map<String, String> value_stack_addr = new HashMap<>();
    int phi_val_storage = 1600;

    public LLVMIRToRiscv(LLVMModuleRef moduleRef, String file_path) {
        this.module = moduleRef;
        this.file_path = file_path;
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

    public List<LLVMValueRef> reorderFunctionsWithMainFirst(LLVMModuleRef module) {
        LLVMValueRef mainFunc = LLVM.LLVMGetNamedFunction(module, "main");
        if (mainFunc == null || mainFunc.isNull()) {
            throw new RuntimeException("main function not found");
        }
        List<LLVMValueRef> functions = new ArrayList<>();
        LLVMValueRef mainFunction = null;
        for (LLVMValueRef func = LLVMGetFirstFunction(module);
             func != null;
             func = LLVMGetNextFunction(func)) {
            String name = LLVMGetValueName(func).getString();
            if ("main".equals(name)) {
                mainFunction = func;
            } else {
                functions.add(func);
            }
        }
        List<LLVMValueRef> newOrder = new ArrayList<>();
        newOrder.add(mainFunction);
        newOrder.addAll(functions);
        return newOrder;
    }

    public void pass_param(Map<Integer, Set<Integer>> param_conflict_graph, AsmBuilder asm) {
        if(param_conflict_graph.isEmpty()) return;
        for (Map.Entry<Integer, Set<Integer>> entry : param_conflict_graph.entrySet()) {
            param_conflict_graph.get(entry.getKey()).remove(entry.getKey());

        }
        while(!param_conflict_graph.isEmpty()){
            Map<Integer,Integer> zero_outdegree_edge=new HashMap<>();
            for (Map.Entry<Integer, Set<Integer>> entry : param_conflict_graph.entrySet()) {
                for(Integer x:entry.getValue()){
                    if((!param_conflict_graph.containsKey(x))||param_conflict_graph.get(x).isEmpty()) zero_outdegree_edge.put(entry.getKey(),x);
                }
            }
            if(!zero_outdegree_edge.isEmpty()){
                for (Map.Entry<Integer, Integer> entry : zero_outdegree_edge.entrySet()){
                    asm.mv("x"+entry.getValue(),"x"+entry.getKey());
                    param_conflict_graph.get(entry.getKey()).remove(entry.getValue());
                }
            }
            else{
                Map<Integer,Integer> tmp_graph=new HashMap<>();
                Stack<Integer> reg_saving_sequence=new Stack<>();
                for (Map.Entry<Integer, Set<Integer>> entry : param_conflict_graph.entrySet()) {
                    if(entry.getValue().size()!=1) System.out.println("wrong in reg saving breakpoint 1");
                    for(Integer y:entry.getValue()){
                        tmp_graph.put(entry.getKey(),y);
                    }
                }
                String reg = freshReg();
                List<Map.Entry<Integer, Integer>> entries = new ArrayList<>(tmp_graph.entrySet());
                Integer start_key = entries.get(0).getKey();
                reg_saving_sequence.push(start_key);
                Integer value=start_key;
                while(reg_saving_sequence.search(tmp_graph.get(value))==-1){
                    reg_saving_sequence.push(tmp_graph.get(value));
                    value=tmp_graph.get(value);
                }
                if(!Objects.equals(tmp_graph.get(value), start_key)) System.out.println("wrong in reg saving breakpoint 2");
                asm.mv(reg, "x" + value);
                while(reg_saving_sequence.size()>1){
                    int x=reg_saving_sequence.pop();
                    int y=reg_saving_sequence.pop();
                    param_conflict_graph.get(y).remove(x);
                    asm.mv("x"+x,"x"+y);
                    reg_saving_sequence.push(y);
                }
                asm.mv("x" + start_key, reg);
                param_conflict_graph.get(value).remove(start_key);
            }
            Set<Integer> can_remove=new HashSet<>();
            for (Map.Entry<Integer, Set<Integer>> entry : param_conflict_graph.entrySet()){
                if(entry.getValue().isEmpty()) can_remove.add(entry.getKey());
            }
            for(Integer x:can_remove){
                param_conflict_graph.remove(x);
            }
        }
    }

    public void to_riscv() {
        emitGlobalVariables();
        asm.directive("globl main");
        List<LLVMValueRef> all_function = reorderFunctionsWithMainFirst(module);
        for (LLVMValueRef func : all_function) {
            //TODO function parameter getting
            value_stack_addr = new HashMap<>();
            String funcName = LLVM.LLVMGetValueName(func).getString();
            asm.label(funcName);
            if ("main".equals(funcName)) asm.instr("addi", "sp", "sp", "-" + 2044);
            allocator = new GraphColoringRegisterAllocator(func);
            next_offset = 0;
            Map<String, Integer> block_id_ref_for_phi = new HashMap<>();
            int id = 0;
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                block_id_ref_for_phi.put(LLVM.LLVMGetBasicBlockName(bb).getString(), id);
                id++;
            }
            int paramCount = LLVM.LLVMCountParams(func);
            for (int i = 8; i < paramCount; i++) {
                LLVMValueRef param = LLVM.LLVMGetParam(func, i);
                String paramName = LLVM.LLVMGetValueName(param).getString();
                LLVMTypeRef paramType = LLVM.LLVMTypeOf(param);
                if (LLVM.LLVMGetTypeKind(paramType) == LLVMIntegerTypeKind) {
                    if (allocator.allocate(paramName).contains("x")) {
                        String reg = freshReg();
                        asm.instr("lw", reg, String.format("%d(sp)", next_offset));
                        asm.mv(allocator.allocate(paramName), reg);
                    } else {
                        value_stack_addr.putIfAbsent(paramName, String.format("%d(sp)", next_offset));
                    }
                    next_offset += 4;
                } else if (LLVM.LLVMGetTypeKind(paramType) == LLVMPointerTypeKind) {
                    value_stack_addr.put(paramName, String.valueOf(next_offset));
                    next_offset += 4;
                } else {
                    throw new RuntimeException("Unsupported  param type");
                }
            }
            Map<Integer, Set<Integer>> param_conflict_graph = new HashMap<>();
            for (int i = 0; i < Math.min(8, paramCount); i++) {
                LLVMValueRef param = LLVM.LLVMGetParam(func, i);
                String paramName = LLVM.LLVMGetValueName(param).getString();
                LLVMTypeRef paramType = LLVM.LLVMTypeOf(param);
                if (allocator.allocate(paramName) == null || allocator.allocate(paramName).isEmpty()) continue;
                if (LLVM.LLVMGetTypeKind(paramType) == LLVMIntegerTypeKind) {
                    if (allocator.allocate(paramName).contains("x")) {
                        int dest_reg_num = Integer.parseInt(allocator.allocate(paramName).substring(allocator.allocate(paramName).indexOf("x") + 1));
                        if (dest_reg_num >= 10 && dest_reg_num < 10 + Math.min(8, paramCount)) {
                            param_conflict_graph.putIfAbsent(i + 10, new HashSet<>());
                            param_conflict_graph.get(i + 10).add(dest_reg_num);
                        }
                        else asm.mv(allocator.allocate(paramName), "x1" + i);
                    } else if (!allocator.allocate(paramName).contains("x")) {
                        asm.instr("sw", "x1" + i, String.format("%d(sp)", next_offset));
                        value_stack_addr.putIfAbsent(paramName, String.format("%d(sp)", next_offset));
                        next_offset += 4;
                    }
                } else if (LLVM.LLVMGetTypeKind(paramType) == LLVMPointerTypeKind) {
                    asm.instr("sw", "x1" + i, String.format("%d(sp)", next_offset));
                    value_stack_addr.put(paramName, String.valueOf(next_offset));
                    next_offset += 4;
                } else {
                    throw new RuntimeException("Unsupported  param type");
                }
            }
            pass_param(param_conflict_graph, asm);
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)){
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null && !inst.isNull(); inst = LLVM.LLVMGetNextInstruction(inst)){
                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                    LLVMTypeRef ty = LLVM.LLVMGetAllocatedType(inst);
                    if (opcode == LLVM.LLVMAlloca) {
                        if (LLVM.LLVMGetTypeKind(ty) == LLVM.LLVMArrayTypeKind) {
                            int total = 1;
                            while (LLVM.LLVMGetTypeKind(ty) == LLVM.LLVMArrayTypeKind) {
                                int len = LLVM.LLVMGetArrayLength(ty);
                                total *= len;
                                ty = LLVM.LLVMGetElementType(ty);
                            }
                            if (value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset)) == null)
                                next_offset += total * 4;
                        } else if (allocator.allocate(LLVM.LLVMGetValueName(inst).getString()).equals("stack")) {
                            if (value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset)) == null)
                                next_offset += 4;
                        }
                    }
                }
            }
            asm.j(funcName + "_" + funcName + "Entry");
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                String label = LLVM.LLVMGetBasicBlockName(bb).getString();
                asm.label(funcName + "_" + label);
                List<array_variable> local_array_variable_ref = new ArrayList<>();//在函数调用中参数涉及函数时会用到
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null && !inst.isNull(); inst = LLVM.LLVMGetNextInstruction(inst)) {
                    //System.out.println(LLVMPrintValueToString(inst).getString());
                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                    if (opcode == LLVM.LLVMGetElementPtr) {//注意getelementptr的下标可能是变量
                        if (allocator.allocate(LLVM.LLVMGetValueName(inst).getString()) == null) continue;
                        boolean has_variable_index = false;
                        String variable_name = LLVM.LLVMGetValueName(inst).getString();
                        LLVMValueRef base_ptr = LLVM.LLVMGetOperand(inst, 0);
                        String array_name = LLVM.LLVMGetValueName(base_ptr).getString();
                        LLVMTypeRef base_type = LLVM.LLVMTypeOf(base_ptr);
                        LLVMTypeRef array_type = LLVM.LLVMGetElementType(base_type);
                        int array_dim = 0;
                        List<Integer> array_size = new ArrayList<>();
                        LLVMTypeRef current = array_type;
                        while (LLVM.LLVMGetTypeKind(current) == LLVM.LLVMArrayTypeKind) {
                            long len = LLVM.LLVMGetArrayLength(current);
                            array_size.add((int) len);
                            array_dim++;
                            current = LLVM.LLVMGetElementType(current);
                        }
                        int operand_count = LLVM.LLVMGetNumOperands(inst);
                        List<Object> cur_offset = new ArrayList<>();
                        for (int i = 2; i < operand_count; i++) {
                            LLVMValueRef index = LLVM.LLVMGetOperand(inst, i);
                            if (LLVM.LLVMIsAConstant(index) != null) {
                                long val = LLVM.LLVMConstIntGetZExtValue(index);
                                cur_offset.add((int) val);
                            } else {
                                has_variable_index = true;
                                cur_offset.add(index);
                            }
                        }
                        array_variable av = new array_variable(variable_name, array_name, array_dim, cur_offset, array_size);
                        if(LLVM.LLVMIsAGlobalVariable(base_ptr)==null)local_array_variable_ref.add(av);
                        if(value_stack_addr.get(array_name)==null){//is global array
                            String reg=freshReg();
                            asm.instr("la",reg,array_name);
                            asm.instr("sw",reg,String.format("%d(sp)",next_offset));
                            value_stack_addr.put(array_name,String.valueOf(next_offset));
                            next_offset+=4;
                        }
                        int dim = array_size.size();
                        if (!has_variable_index) {
                            int offset = 0;
                            for (int i = 0; i < cur_offset.size(); i++) {
                                Object index = cur_offset.get(i);
                                int idx = (Integer) index;
                                int multiplier = 1;
                                for (int j = i + 1; j < dim; j++) {
                                    multiplier *= array_size.get(j);
                                }
                                offset += idx * multiplier;//maybe be an array
                            }
                            offset *= 4;
                            if (value_stack_addr.get(array_name).contains("(")) {
                                int start_arr_addr = Integer.parseInt(value_stack_addr.get(array_name).substring(0, value_stack_addr.get(array_name).indexOf("(")));
                                offset = offset + start_arr_addr;
                                value_stack_addr.put(variable_name, String.format("%d(sp)", offset));
                            } else {
                                int start_arr_addr = Integer.parseInt(value_stack_addr.get(array_name));
                                String reg = freshReg();
                                asm.instr("lw", reg, String.format("%d(sp)", start_arr_addr));
                                asm.op2("addi", reg, reg, offset);
                                asm.instr("sw", reg, String.format("%d(sp)", next_offset));
                                value_stack_addr.put(variable_name, String.valueOf(next_offset));
                                next_offset += 4;
                            }
                        } else {
                            String offset_reg = "t2";
                            asm.instr("li", "t2", "0");
                            for (int i = 0; i < cur_offset.size(); i++) {
                                Object index = cur_offset.get(i);
                                if (index instanceof Integer) {
                                    String reg1 = freshReg(2);
                                    int idx = (Integer) index;
                                    int multiplier = 1;
                                    for (int j = i + 1; j < dim; j++) {
                                        multiplier *= array_size.get(j);
                                    }
                                    long offset = idx * multiplier;
                                    asm.li(reg1, offset);
                                    asm.op2("add", offset_reg, offset_reg, reg1);
                                } else {
                                    String reg1 = freshReg(2);
                                    LLVMValueRef var_ref = (LLVMValueRef) index;
                                    String cur_offset_reg = evaluate(var_ref, 2);
                                    int multiplier = 1;
                                    for (int j = i + 1; j < dim; j++) {
                                        multiplier *= array_size.get(j);
                                    }
                                    asm.li(reg1, multiplier);
                                    asm.op2("mul", reg1, cur_offset_reg, reg1);
                                    asm.op2("add", offset_reg, offset_reg, reg1);
                                }
                            }
                            asm.op2("slli", offset_reg, offset_reg, 2);
                            //if(value_stack_addr.get(array_name))
                            if (value_stack_addr.get(array_name).contains("(")) {
                                //System.out.println(array_name);
                                int start_arr_addr = Integer.parseInt(value_stack_addr.get(array_name).substring(0, value_stack_addr.get(array_name).indexOf("(")));
                                String tmp_reg = freshReg(2);
                                asm.li(tmp_reg, start_arr_addr);
                                asm.op2("add", offset_reg, offset_reg, tmp_reg);
                                asm.op2("add", offset_reg, offset_reg, "sp");
                                asm.instr("sw", offset_reg, String.format("%d(sp)", next_offset));
                                value_stack_addr.putIfAbsent(variable_name, String.valueOf(next_offset));
                                next_offset += 4;
                            } else {
                                int start_arr_addr = Integer.parseInt(value_stack_addr.get(array_name));
                                String reg = freshReg(2);
                                asm.instr("lw", reg, String.format("%d(sp)", start_arr_addr));
                                asm.op2("add", offset_reg, offset_reg, reg);
                                asm.instr("sw", offset_reg, String.format("%d(sp)", next_offset));
                                value_stack_addr.putIfAbsent(variable_name, String.valueOf(next_offset));
                                next_offset += 4;
                            }
                        }
                        if (allocator.allocate(LLVM.LLVMGetValueName(inst).getString()).contains("x")) {
                            if (value_stack_addr.get(variable_name).contains("("))
                                asm.instr("lw", allocator.allocate(variable_name), value_stack_addr.get(variable_name));
                            else {
                                asm.instr("lw", allocator.allocate(LLVM.LLVMGetValueName(inst).getString()), String.format("%d(sp),", Integer.parseInt(value_stack_addr.get(variable_name))));
                                asm.instr("lw", allocator.allocate(LLVM.LLVMGetValueName(inst).getString()), "0(" + allocator.allocate(variable_name) + ")");
                            }
                        }
                    }
                    //TODO calling function saving register passing parameter watch out the parameter could be array
                    else if (opcode == LLVMCall) {
                        LLVMValueRef calledFunction = LLVM.LLVMGetCalledValue(inst);
                        String callfuncName = LLVM.LLVMGetValueName(calledFunction).getString();
                        int argCount = LLVM.LLVMGetNumArgOperands(inst);
                        Set<String> live_var = new HashSet<>(GraphColoringRegisterAllocator.get_after_cur_inst_live_variable(inst));
                        Map<String,String>context_stored_in_calling_func=new HashMap<>();//有一些GETELEMENTPTR的问题，即如果用value_stack_addr的MAP会破坏还未被赋值的getelemmentptr,因此新建一个context_stored_in_calling_func
                        //因为GETELEMENTPTR本身既可以是寄存器也可以是地址，因此在每个块访问结束后必须要强制保证GETELEMENTPTR的数据是正确的,即栈（数组）已经正确写入每一个值,通过在LLVMRET和LLVMBR后面存储寄存器的值到栈实现
                        // 在访问块内部时栈可以与寄存器保持不一致，即寄存器中的数据更新
                        for (String x : live_var) {
                            if (allocator.allocate(x) != null && allocator.allocate(x).contains("x")) {
                                asm.instr("sw", allocator.allocate(x), String.format("%d(sp)", next_offset));
                                context_stored_in_calling_func.put(x, String.format("%d(sp)", next_offset));
                                next_offset += 4;
                            }
                        }//采取所有寄存器都由调用者保存的策略
                        asm.instr("sw", "x1", String.format("%d(sp)", next_offset));
                        next_offset += 4;
                        Map<String, Integer> const_param_reg = new HashMap<>();
                        Map<Integer, Set<Integer>> calling_pass_param = new HashMap<>();
                        Map<String, LLVMValueRef> variable_reg = new HashMap<>();
                        for (int i = 0; i < argCount; i++) {
                            LLVMValueRef arg = LLVM.LLVMGetOperand(inst, i);
                            LLVMTypeRef type = LLVM.LLVMTypeOf(arg);
                            String name = LLVM.LLVMGetValueName(arg).getString();
                            int kind = LLVM.LLVMGetTypeKind(type);
                            array_variable current_param_ref = null;
                            if (kind == LLVM.LLVMPointerTypeKind) {
                                for (array_variable param : local_array_variable_ref) {
                                    if (param.variable_name.equals(name)) {
                                        current_param_ref = param;
                                        break;
                                    }
                                }
                                for (array_variable x : local_array_variable_ref) {
                                    if (!x.array_name.equals(current_param_ref.array_name)) continue;
                                    if (x.cur_offset.size() != x.array_size.size()) continue;
                                    boolean need_saved_to_stack = false;
                                    need_saved_to_stack = GraphColoringRegisterAllocator.naive_alias_may_analysis(current_param_ref, x);
                                    //把调用函数可能用到的在寄存器中的数组变量全部写回到数组中去
                                    //注意块内部语句是按顺序访问的
                                    if (need_saved_to_stack) {
                                        if (allocator.allocate(x.variable_name).contains("x")) {
                                            String reg = allocator.allocate(x.variable_name);
                                            if (value_stack_addr.get(x.variable_name).contains("("))
                                                asm.instr("sw", reg, value_stack_addr.get(x.variable_name));
                                            else {
                                                String tmp_reg = freshReg();
                                                int start_arr_addr = Integer.parseInt(value_stack_addr.get(x.variable_name));
                                                asm.instr("lw", tmp_reg, String.format("%d(sp)", start_arr_addr));
                                                asm.instr("sw", reg, "O(" + tmp_reg + ")");
                                            }
                                        }
                                    }
                                }
                            }
                            if (i <= 7) {
                                LLVMValueRef constInt = LLVM.LLVMIsAConstantInt(arg);
                                if (kind == LLVM.LLVMPointerTypeKind) {
                                    if (value_stack_addr.get(name).contains("("))
                                        asm.instr("addi", "x1" + i, "sp", value_stack_addr.get(name).substring(0, value_stack_addr.get(name).indexOf("(")));
                                    else {
                                        int start_arr_addr = Integer.parseInt(value_stack_addr.get(name));
                                        asm.instr("lw", "x1" + i, String.format("%d(sp)", start_arr_addr));
                                    }
                                } else if (constInt != null && !constInt.isNull()) {
                                    //asm.li("x1" + i, LLVM.LLVMConstIntGetSExtValue(constInt));
                                    const_param_reg.put("x1" + i, ((int) LLVM.LLVMConstIntGetSExtValue(constInt)));
                                } else {
                                    if (allocator.allocate(name).contains("x")) {
                                        int src_reg_num = Integer.parseInt(allocator.allocate(name).substring(allocator.allocate(name).indexOf("x") + 1));
//                                        System.out.println(src_reg_num);
//                                        System.out.println(10 + i);
                                        calling_pass_param.putIfAbsent(src_reg_num,new HashSet<>());
                                        calling_pass_param.get(src_reg_num).add(10+i);
                                    } else {
                                        //String reg = evaluate(arg);
                                        //asm.mv("x1" + i, reg);
                                        variable_reg.put("x1" + i, arg);
                                    }
                                }
                            } else {
                                String reg;
                                if (kind == LLVM.LLVMPointerTypeKind) {
                                    reg = freshReg();
                                    if (value_stack_addr.get(name).contains("("))
                                        asm.instr("addi", reg, "sp", value_stack_addr.get(name).substring(0, value_stack_addr.get(name).indexOf("(")));
                                    else {
                                        int start_arr_addr = Integer.parseInt(value_stack_addr.get(name));
                                        asm.instr("lw", reg, String.format("%d(sp)", start_arr_addr));
                                    }
                                } else {
                                    reg = evaluate(arg);
                                }
                                asm.instr("sw", reg, String.format("%d(sp)", next_offset));
                                next_offset += 4;
                            }
                        }
                        pass_param(calling_pass_param, asm);
                        for (Map.Entry<String, Integer> entry : const_param_reg.entrySet()) {
                            asm.li(entry.getKey(), entry.getValue());
                        }
                        for (Map.Entry<String, LLVMValueRef> entry : variable_reg.entrySet()) {
                            String reg = evaluate(entry.getValue());
                            asm.mv(entry.getKey(), reg);
                        }
                        if (argCount > 8) {
                            asm.op2("addi", "sp", "sp", next_offset - (argCount - 8) * 4);
                            asm.instr("jal", "x1", callfuncName);
                            asm.op2("addi", "sp", "sp", -(next_offset - (argCount - 8) * 4));
                            next_offset = next_offset - (argCount - 8) * 4;
                        } else {
                            asm.op2("addi", "sp", "sp", next_offset);
                            asm.instr("jal", "x1", callfuncName);
                            asm.op2("addi", "sp", "sp", -(next_offset));
                        }
                        next_offset -= 4;
                        asm.instr("lw", "x1", String.format("%d(sp)", next_offset));
                        for (String x : live_var) {
                            if (allocator.allocate(x) != null && allocator.allocate(x).contains("x")) {
                                next_offset -= 4;
                                asm.instr("lw", allocator.allocate(x), context_stored_in_calling_func.get(x));
                            }
                        }
                        //TODO GETTING THE RETURN VALUE AND need_saved_to_stack
                        LLVMTypeRef retType = LLVMTypeOf(inst);
                        if (LLVMGetTypeKind(retType) == LLVMIntegerTypeKind) {
                            String name = LLVMGetValueName(inst).getString();
                            if (name == null || name.isEmpty()||allocator.allocate(name) == null || allocator.allocate(name).isEmpty())
                                continue;
                            else if (allocator.allocate(name).contains("x"))
                                asm.instr("mv", allocator.allocate(name), "x10");
                            else {
                                if (value_stack_addr.putIfAbsent(name, String.format("%d(sp)", next_offset)) == null) {
                                    next_offset += 4;
                                }
                                asm.instr("sw", "x10", value_stack_addr.get(name));
                            }
                        }
                    } else if (opcode == LLVM.LLVMAlloca) {
                        continue;
                    } else if (opcode == LLVM.LLVMStore) {
                        LLVMValueRef val = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 1);
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(ptr).getString());
                        if (addr != null && addr.isEmpty()) continue;
                        String valReg = evaluate(val);
                        if (addr != null) {
                            if (addr.contains("stack")) {
                                if (value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(ptr).getString(), String.format("%d(sp)", next_offset)) == null) {
                                    next_offset += 4;
                                }
                                if (value_stack_addr.get(LLVM.LLVMGetValueName(ptr).getString()).contains("("))
                                    asm.instr("sw", valReg, value_stack_addr.get(LLVM.LLVMGetValueName(ptr).getString()));
                                else {
                                    String reg = freshReg();
                                    asm.instr("lw", reg, String.format("%d(sp)", Integer.parseInt(value_stack_addr.get(LLVM.LLVMGetValueName(ptr).getString()))));
                                    asm.instr("sw", valReg, "0(" + reg + ")");
                                }
                            } else asm.instr("mv", addr, valReg);
                        } else {
                            String reg = freshReg();
                            asm.instr("la", reg, (LLVM.LLVMGetValueName(ptr).getString()));
                            asm.instr("sw", valReg, "0(" + reg + ")");
                        }
                    } else if (opcode == LLVM.LLVMLoad) {
                        LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 0);
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(ptr).getString());
                        String lval_addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        if (lval_addr.isEmpty()) continue;
                        if (addr == null) {
                            String reg = "t0";
                            if (LLVM.LLVMIsAGetElementPtrInst(ptr) != null || (LLVM.LLVMIsAConstantExpr(ptr) != null && LLVM.LLVMGetConstOpcode(ptr) == LLVM.LLVMGetElementPtr)) {
                                System.out.println(LLVM.LLVMPrintValueToString(inst).getString());
                                boolean has_variable_index=false;
                                LLVMValueRef base_ptr = LLVM.LLVMGetOperand(ptr, 0);  // 正确：从 GEP 取出 base operand
                                String array_name = LLVM.LLVMGetValueName(base_ptr).getString();  // 可以获取 @result
                                LLVMTypeRef base_type = LLVM.LLVMTypeOf(base_ptr);
                                LLVMTypeRef array_type = LLVM.LLVMGetElementType(base_type);

                                List<Integer> array_size = new ArrayList<>();
                                LLVMTypeRef current = array_type;
                                while (LLVM.LLVMGetTypeKind(current) == LLVM.LLVMArrayTypeKind) {
                                    array_size.add((int) LLVM.LLVMGetArrayLength(current));
                                    current = LLVM.LLVMGetElementType(current);
                                }
                                int operand_count = LLVM.LLVMGetNumOperands(ptr);
                                List<Object> cur_offset = new ArrayList<>();
                                for (int i = 2; i < operand_count; i++) {
                                    LLVMValueRef index = LLVM.LLVMGetOperand(ptr, i);
                                    if (LLVM.LLVMIsAConstant(index) != null) {
                                        long val = LLVM.LLVMConstIntGetZExtValue(index);
                                        cur_offset.add((int) val);
                                    } else {
                                        has_variable_index = true;
                                        cur_offset.add(index);
                                    }
                                }
                                int dim = array_size.size();
                                if (!has_variable_index) {
                                    String address_reg="t1";
                                    int offset = 0;
                                    for (int i = 0; i < cur_offset.size(); i++) {
                                        Object index = cur_offset.get(i);
                                        int idx = (Integer) index;
                                        int multiplier = 1;
                                        for (int j = i + 1; j < dim; j++) {
                                            multiplier *= array_size.get(j);
                                        }
                                        offset += idx * multiplier;//maybe be an array
                                    }
                                    offset *= 4;
                                    if(value_stack_addr.get(array_name)==null) {
                                        asm.instr("la",address_reg,array_name);
                                        asm.op2("addi",address_reg,address_reg,offset);
                                        asm.instr("lw",reg,"0("+address_reg+")");
                                    }
                                    else if (value_stack_addr.get(array_name).contains("(")) {
                                        int start_arr_addr = Integer.parseInt(value_stack_addr.get(array_name).substring(0, value_stack_addr.get(array_name).indexOf("(")));
                                        offset = offset + start_arr_addr;
                                        asm.instr("lw",reg,String.format("%d(sp)",offset));
                                    } else {
                                        int start_arr_addr = Integer.parseInt(value_stack_addr.get(array_name));
                                        asm.instr("lw", address_reg, String.format("%d(sp)", start_arr_addr));
                                        asm.op2("addi", address_reg, address_reg, offset);
                                        asm.instr("lw", reg, "0("+address_reg+")");
                                    }
                                } else {
                                    String offset_reg = "t2";
                                    asm.instr("li", "t2", "0");
                                    for (int i = 0; i < cur_offset.size(); i++) {
                                        Object index = cur_offset.get(i);
                                        if (index instanceof Integer) {
                                            int idx = (Integer) index;
                                            int multiplier = 1;
                                            for (int j = i + 1; j < dim; j++) {
                                                multiplier *= array_size.get(j);
                                            }
                                            long offset = idx * multiplier;
                                            asm.op2("addi", offset_reg, offset_reg, (int)offset);
                                        } else {
                                            LLVMValueRef var_ref = (LLVMValueRef) index;
                                            String cur_offset_reg = evaluate(var_ref, 1);
                                            int multiplier = 1;
                                            for (int j = i + 1; j < dim; j++) {
                                                multiplier *= array_size.get(j);
                                            }
                                            asm.li("t1", multiplier);
                                            asm.op2("mul", "t1", cur_offset_reg, "t1");
                                            asm.op2("add", offset_reg, offset_reg, "t1");
                                        }
                                    }
                                    asm.op2("slli", offset_reg, offset_reg, 2);
                                    if(value_stack_addr.get(array_name)==null) {
                                        asm.instr("la","t1",array_name);
                                        asm.op2("addi","t1","t1",offset_reg);
                                        asm.instr("lw",reg,"0(t1)");
                                    }
                                    //TODO CHECK WRITTEN IN 1AM
                                    else if (value_stack_addr.get(array_name).contains("(")) {
                                        int start_arr_addr = Integer.parseInt(value_stack_addr.get(array_name).substring(0, value_stack_addr.get(array_name).indexOf("(")));
                                        asm.op2("addi", offset_reg, offset_reg, start_arr_addr);
                                        asm.op2("addi", offset_reg, offset_reg, "sp");
                                        asm.instr("lw",reg,"0("+offset_reg+")");
                                    } else {
                                        int start_arr_addr = Integer.parseInt(value_stack_addr.get(array_name));
                                        asm.instr("lw", "t1", String.format("%d(sp)", start_arr_addr));
                                        asm.op2("add", offset_reg, offset_reg, "t1");
                                        asm.instr("lw", reg, "0("+offset_reg+")");
                                    }
                                }
                            }
                            else {
                                asm.instr("la", reg, (LLVM.LLVMGetValueName(ptr).getString()));
                                asm.instr("lw", reg, "0(" + reg + ")");
                            }
                            if (lval_addr.contains("stack")) {
                                if (value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset)) == null)
                                    next_offset += 4;
                                asm.instr("sw", reg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                            } else asm.instr("mv", lval_addr, reg);
                        } else if (addr.contains("stack")) {
                            String reg = freshReg();
                            if (value_stack_addr.get(LLVM.LLVMGetValueName(ptr).getString()).contains("("))
                                asm.instr("lw", reg, value_stack_addr.get(LLVM.LLVMGetValueName(ptr).getString()));
                            else {
                                asm.instr("lw", reg, String.format("%d(sp)", Integer.parseInt(value_stack_addr.get(LLVM.LLVMGetValueName(ptr).getString()))));
                                asm.instr("lw", reg, "0(" + reg + ")");
                            }
                            if (lval_addr.contains("stack")) {
                                if (value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset)) == null)
                                    next_offset += 4;
                                asm.instr("sw", reg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                            } else asm.instr("mv", lval_addr, reg);
                        } else {
                            if (lval_addr.contains("stack")) {
                                if (value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset)) == null)
                                    next_offset += 4;
                                asm.instr("sw", addr, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                            } else asm.instr("mv", lval_addr, addr);
                        }
                    } else if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                            opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                            opcode == LLVM.LLVMSRem || opcode == LLVM.LLVMURem || opcode == LLVM.LLVMUDiv) {
                        LLVMValueRef lhs = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef rhs = LLVM.LLVMGetOperand(inst, 1);
                        String reg1 = evaluate(lhs);
                        String reg2 = evaluate(rhs);
                        String destReg = freshReg();
                        String op = "";
                        switch (opcode) {
                            case LLVM.LLVMAdd:
                                op = "add";
                                break;
                            case LLVM.LLVMSub:
                                op = "sub";
                                break;
                            case LLVM.LLVMMul:
                                op = "mul";
                                break;
                            case LLVM.LLVMSDiv:
                                op = "div";
                                break;
                            case LLVM.LLVMUDiv:
                                op = "divu";
                                break;
                            case LLVM.LLVMSRem:
                                op = "rem";
                                break;
                            case LLVM.LLVMURem:
                                op = "urem";
                                break;
                            default:
                                throw new RuntimeException("Unsupported binop");
                        }
                        asm.op2(op, destReg, reg1, reg2);
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        if (addr.isEmpty()) continue;
                        if (addr.contains("stack")) {
                            if (value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset)) == null)
                                next_offset += 4;
                            asm.instr("sw", destReg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                        } else asm.instr("mv", addr, destReg);
                    } else if (opcode == LLVM.LLVMRet) {
                        for (array_variable x : local_array_variable_ref) {
                            for (String y : GraphColoringRegisterAllocator.get_after_cur_inst_live_variable(LLVM.LLVMGetLastInstruction(bb))) {
                                if (x.variable_name.equals(y) && allocator.allocate(x.variable_name) != null && allocator.allocate(x.variable_name).contains("x")) {
                                    if (value_stack_addr.get(x.variable_name).contains("(")) {
                                        asm.instr("sw", allocator.allocate(x.variable_name), value_stack_addr.get(x.variable_name));
                                    } else {
                                        String reg = freshReg();
                                        asm.instr("lw", reg, String.format("%d(sp)", Integer.parseInt(value_stack_addr.get(x.variable_name))));
                                        asm.instr("sw", allocator.allocate(x.variable_name), "0(" + reg + ")");
                                    }
                                }
                            }
                        }
                        LLVMTypeRef funcType = LLVMGetElementType(LLVMTypeOf(func));
                        LLVMTypeRef retType = LLVMGetReturnType(funcType);
                        if (LLVMGetTypeKind(retType) == LLVMIntegerTypeKind) {
                            LLVMValueRef retVal = LLVM.LLVMGetOperand(inst, 0);
                            String reg = evaluate(retVal);
                            if (LLVM.LLVMGetValueName(func).getString().equals("main")) {
                                asm.mv("x10", reg);
                                asm.instr("addi", "sp", "sp", "" + 2044); // Epilogue
                                asm.li("a7", 93);  // syscall exit
                                asm.instr("ecall");
                            } else {
                                asm.mv("x10", reg);
                                asm.instr("ret");
                            }
                        } else asm.instr("ret");
                    } else if (opcode == LLVM.LLVMZExt) {
                        LLVMValueRef operand = LLVM.LLVMGetOperand(inst, 0);
                        String srcReg = evaluate(operand);
                        String destReg = freshReg();
                        asm.mv(destReg, srcReg);
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        if (addr.isEmpty()) continue;
                        if (addr.contains("stack")) {
                            if (value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset)) == null)
                                next_offset += 4;
                            asm.instr("sw", destReg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                        } else asm.instr("mv", addr, destReg);
                    } else if (opcode == LLVM.LLVMICmp) {
                        int pred = LLVM.LLVMGetICmpPredicate(inst);  // 获取谓词
                        LLVMValueRef lhs = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef rhs = LLVM.LLVMGetOperand(inst, 1);
                        String reg1 = evaluate(lhs);
                        String reg2 = evaluate(rhs);
                        String destReg = freshReg();
                        switch (pred) {
                            case LLVM.LLVMIntEQ:
                                asm.instr("xor", destReg, reg1, reg2);
                                asm.seqz(destReg, destReg);
                                break;
                            case LLVM.LLVMIntNE:
                                asm.instr("xor", destReg, reg1, reg2);
                                asm.snez(destReg, destReg);
                                break;
                            case LLVM.LLVMIntSLT:
                                asm.slt(destReg, reg1, reg2);
                                break;
                            case LLVM.LLVMIntSLE:
                                asm.sgt(destReg, reg1, reg2);
                                asm.seqz(destReg, destReg);
                                break;
                            case LLVM.LLVMIntSGT:
                                asm.sgt(destReg, reg1, reg2);
                                break;
                            case LLVM.LLVMIntSGE:
                                asm.slt(destReg, reg1, reg2);
                                asm.seqz(destReg, destReg);
                                break;
                            default:
                                throw new RuntimeException("Unsupported icmp predicate: " + pred);
                        }
                        String addr = allocator.allocate(LLVM.LLVMGetValueName(inst).getString());
                        if (addr.isEmpty()) continue;
                        if (addr.contains("stack")) {
                            if (value_stack_addr.putIfAbsent(LLVM.LLVMGetValueName(inst).getString(), String.format("%d(sp)", next_offset)) == null)
                                next_offset += 4;
                            asm.instr("sw", destReg, value_stack_addr.get(LLVM.LLVMGetValueName(inst).getString()));
                        } else asm.instr("mv", addr, destReg);
                    } else if (opcode == LLVM.LLVMBr) {
                        int numOperands = LLVM.LLVMGetNumOperands(inst);
                        if (numOperands == 1) {
                            LLVMValueRef dest = LLVM.LLVMGetOperand(inst, 0);
                            String loop_label = LLVM.LLVMGetValueName(dest).getString();
                            for (array_variable x : local_array_variable_ref) {
                                for (String y : GraphColoringRegisterAllocator.get_after_cur_inst_live_variable(LLVM.LLVMGetLastInstruction(bb))) {
                                    if (x.variable_name.equals(y) && allocator.allocate(x.variable_name) != null && allocator.allocate(x.variable_name).contains("x")) {
                                        if (value_stack_addr.get(x.variable_name).contains("(")) {
                                            asm.instr("sw", allocator.allocate(x.variable_name), value_stack_addr.get(x.variable_name));
                                        } else {
                                            String reg = freshReg();
                                            asm.instr("lw", reg, String.format("%d(sp)", Integer.parseInt(value_stack_addr.get(x.variable_name))));
                                            asm.instr("sw", allocator.allocate(x.variable_name), "0(" + reg + ")");
                                        }
                                    }
                                }
                            }
                            String reg = freshReg();
                            asm.li(reg, block_id_ref_for_phi.get(LLVM.LLVMGetBasicBlockName(bb).getString()));
                            asm.instr("sw", reg, String.format("%d(sp)", phi_val_storage));
                            asm.j(funcName + "_" + loop_label);
                        } else if (numOperands == 3) {
                            //System.out.println(LLVM.LLVMPrintValueToString(inst).getString());
                            LLVMValueRef cond = LLVM.LLVMGetOperand(inst, 0);
                            LLVMValueRef ifFalse = LLVM.LLVMGetOperand(inst, 1);
                            LLVMValueRef ifTrue = LLVM.LLVMGetOperand(inst, 2);
                            String condReg = evaluate(cond);
                            String trueLabel = LLVM.LLVMGetValueName(ifTrue).getString();
                            String falseLabel = LLVM.LLVMGetValueName(ifFalse).getString();
                            for (array_variable x : local_array_variable_ref) {
                                for (String y : GraphColoringRegisterAllocator.get_after_cur_inst_live_variable(LLVM.LLVMGetLastInstruction(bb))) {
                                    if (x.variable_name.equals(y) && allocator.allocate(x.variable_name) != null && allocator.allocate(x.variable_name).contains("x")) {
                                        if (value_stack_addr.get(x.variable_name).contains("(")) {
                                            asm.instr("sw", allocator.allocate(x.variable_name), value_stack_addr.get(x.variable_name));
                                        } else {
                                            String reg = freshReg();
                                            asm.instr("lw", reg, String.format("%d(sp)", Integer.parseInt(value_stack_addr.get(x.variable_name))));
                                            asm.instr("sw", allocator.allocate(x.variable_name), "0(" + reg + ")");
                                        }
                                    }
                                }
                            }
                            String reg = freshReg();
                            asm.li(reg, block_id_ref_for_phi.get(LLVM.LLVMGetBasicBlockName(bb).getString()));
                            asm.instr("sw", reg, String.format("%d(sp)", phi_val_storage));
                            asm.bnez(condReg, funcName + "_" + trueLabel);
                            asm.j(funcName + "_" + falseLabel);
                        }
                    } else if (opcode == LLVM.LLVMPHI) {
                        String lval = LLVM.LLVMGetValueName(inst).getString();
                        if (allocator.allocate(lval).isEmpty()) continue;
                        LLVMValueRef v0 = LLVM.LLVMGetIncomingValue(inst, 0);
                        LLVMBasicBlockRef b0 = LLVM.LLVMGetIncomingBlock(inst, 0);
                        LLVMValueRef v1 = LLVM.LLVMGetIncomingValue(inst, 1);
                        LLVMBasicBlockRef b1 = LLVM.LLVMGetIncomingBlock(inst, 1);

                        String name0 = LLVM.LLVMGetBasicBlockName(b0).getString();
                        String name1 = LLVM.LLVMGetBasicBlockName(b1).getString();
                        int id0 = block_id_ref_for_phi.get(name0);
                        int id1 = block_id_ref_for_phi.get(name1);
                        String v0_reg = evaluate(v0, 1);
                        asm.instr("lw", "t1", String.format("%d(sp)", phi_val_storage));
                        asm.op2("xori", "t2", "t1", id0);
                        asm.seqz("t2", "t2");
                        asm.op2("mul", "t2", "t2", v0_reg);
                        String v1_reg = evaluate(v1, 1);
                        asm.op2("xori", "t1", "t1", id1);
                        asm.seqz("t1", "t1");
                        asm.op2("mul", "t1", "t1", v1_reg);
                        asm.op2("add", "t2", "t2", "t1");
                        if (allocator.allocate(lval).contains("x"))
                            asm.mv(allocator.allocate(LLVM.LLVMGetValueName(inst).getString()), "t2");
                        else {
                            if (value_stack_addr.putIfAbsent(lval, String.format("%d(sp)", next_offset)) == null)
                                next_offset += 4;
                            asm.instr("sw", "t2", value_stack_addr.get(lval));
                        }
                    } else {
                        System.out.println(LLVM.LLVMPrintValueToString(inst).getString());
                        throw new RuntimeException("Unsupported instruction opcode: " + opcode);
                    }
                }
            }
        }
        asm.writeToFile(file_path);
    }

    private String evaluate(LLVMValueRef val) {
        LLVMValueRef constInt = LLVM.LLVMIsAConstantInt(val);
        if (constInt != null && !constInt.isNull()) {
            long imm = LLVM.LLVMConstIntGetSExtValue(constInt);
            String reg = freshReg();
            asm.li(reg, imm);
            return reg;
        } else if (allocator.allocate(LLVM.LLVMGetValueName(val).getString()) != null) {
            if (allocator.allocate(LLVM.LLVMGetValueName(val).getString()).contains("stack")) {
                String reg = freshReg();
                if (value_stack_addr.get(LLVM.LLVMGetValueName(val).getString()).contains("("))
                    asm.instr("lw", reg, value_stack_addr.get(LLVM.LLVMGetValueName(val).getString()));
                else {
                    asm.instr("lw", reg, String.format("%d(sp)", Integer.parseInt(value_stack_addr.get(LLVM.LLVMGetValueName(val).getString()))));
                    asm.instr("lw", reg, "0(" + reg + ")");
                }
                return reg;
            } else return allocator.allocate(LLVM.LLVMGetValueName(val).getString());
        } else if (LLVM.LLVMIsAGlobalVariable(val) != null) {
            String reg = freshReg();
            String name = LLVM.LLVMGetValueName(val).getString();
            asm.instr("la", reg, name);
            asm.instr("lw", reg, "0(" + reg + ")");
            return reg;
        } else {
            System.out.println(LLVM.LLVMGetValueName(val).getString());
            String valStr = LLVM.LLVMPrintValueToString(val).getString();
            int kind = LLVM.LLVMGetValueKind(val);
            System.err.println("Unsupported operand:");
            System.err.println("LLVM ValueKind: " + kind);
            System.err.println("LLVM Value: " + valStr);
            throw new RuntimeException("Unsupported operand: " + valStr);
        }
    }

    private String evaluate(LLVMValueRef val, int num) {
        LLVMValueRef constInt = LLVM.LLVMIsAConstantInt(val);
        if (constInt != null && !constInt.isNull()) {
            long imm = LLVM.LLVMConstIntGetSExtValue(constInt);
            String reg = freshReg(num);
            asm.li(reg, imm);
            return reg;
        } else if (allocator.allocate(LLVM.LLVMGetValueName(val).getString()) != null) {
            if (allocator.allocate(LLVM.LLVMGetValueName(val).getString()).contains("stack")) {
                String reg = freshReg(num);
                if (value_stack_addr.get(LLVM.LLVMGetValueName(val).getString()).contains("("))
                    asm.instr("lw", reg, value_stack_addr.get(LLVM.LLVMGetValueName(val).getString()));
                else {
                    asm.instr("lw", reg, String.format("%d(sp)", Integer.parseInt(value_stack_addr.get(LLVM.LLVMGetValueName(val).getString()))));
                    asm.instr("lw", reg, "0(" + reg + ")");
                }
                return reg;
            } else return allocator.allocate(LLVM.LLVMGetValueName(val).getString());
        } else if (LLVM.LLVMIsAGlobalVariable(val) != null) {
            String reg = freshReg(num);
            String name = LLVM.LLVMGetValueName(val).getString();
            asm.instr("la", reg, name);
            asm.instr("lw", reg, "0(" + reg + ")");
            return reg;
        } else {
            System.out.println(LLVM.LLVMGetValueName(val).getString());
            String valStr = LLVM.LLVMPrintValueToString(val).getString();
            int kind = LLVM.LLVMGetValueKind(val);
            System.err.println("Unsupported operand:");
            System.err.println("LLVM ValueKind: " + kind);
            System.err.println("LLVM Value: " + valStr);
            throw new RuntimeException("Unsupported operand: " + valStr);
        }
    }


    private void emitGlobalVariables() {
        asm.switchToData();
        for (LLVMValueRef global = LLVM.LLVMGetFirstGlobal(module); global != null && !global.isNull(); global = LLVM.LLVMGetNextGlobal(global)) {

            String name = LLVM.LLVMGetValueName(global).getString();
            LLVMValueRef init = LLVM.LLVMGetInitializer(global);

            if (init == null || init.isNull()) continue;

            asm.label(name);
            List<Integer> result=new ArrayList<>();
            extractIntegerElements(init,result);
            int total_size= calculateArraySize(LLVM.LLVMGlobalGetValueType(global));
            int cur_size=result.size();
            for(int i=0;i<total_size-cur_size;i++){
                result.add(0);
            }
            String[] stringArgs = result.stream()
                    .map(String::valueOf)
                    .toArray(String[]::new);
            asm.instr(".word",stringArgs);
            asm.directive("globl", name);
            asm.add_blank_line();
        }
        asm.switchToText();
    }
    public static int calculateArraySize(LLVMTypeRef type) {
        if (LLVM.LLVMGetTypeKind(type) == LLVM.LLVMArrayTypeKind) {
            int arrayLength = LLVM.LLVMGetArrayLength(type);
            LLVMTypeRef elementType = LLVM.LLVMGetElementType(type);
            return arrayLength * calculateArraySize(elementType);
        } else if (LLVM.LLVMGetTypeKind(type) == LLVM.LLVMIntegerTypeKind) {
            // 整数类型：返回1（元素个数）
            return 1;
        } else {
            // 其他类型：默认返回1
            return 1;
        }
    }
    public static void extractIntegerElements(LLVMValueRef value, List<Integer> elements) {
        if (value == null || value.isNull()) {
            return;
        }
        if (LLVM.LLVMIsConstant(value) == 1) {
            if (LLVM.LLVMIsAConstantInt(value) != null) {
                long intValue = LLVM.LLVMConstIntGetSExtValue(value);
                elements.add((int) intValue);
            } else if (LLVM.LLVMIsAConstantArray(value) != null) {
                int numOperands = LLVM.LLVMGetNumOperands(value);
                for (int i = 0; i < numOperands; i++) {
                    LLVMValueRef operand = LLVM.LLVMGetOperand(value, i);
                    extractIntegerElements(operand, elements);
                }
            } else if (LLVM.LLVMIsAConstantAggregateZero(value) != null) {
                return;
            } else if (LLVM.LLVMIsAConstantStruct(value) != null) {
                int numOperands = LLVM.LLVMGetNumOperands(value);
                for (int i = 0; i < numOperands; i++) {
                    LLVMValueRef operand = LLVM.LLVMGetOperand(value, i);
                    extractIntegerElements(operand, elements);
                }
            } else if (LLVM.LLVMIsAConstantDataArray(value) != null) {
                int numElements = LLVM.LLVMGetArrayLength(LLVM.LLVMTypeOf(value));
                for (int i = 0; i < numElements; i++) {
                    LLVMValueRef element = LLVM.LLVMGetElementAsConstant(value, i);
                    extractIntegerElements(element, elements);
                }
            } else if (LLVM.LLVMIsAConstantVector(value) != null) {
                int numOperands = LLVM.LLVMGetNumOperands(value);
                for (int i = 0; i < numOperands; i++) {
                    LLVMValueRef operand = LLVM.LLVMGetOperand(value, i);
                    extractIntegerElements(operand, elements);
                }
            } else if (LLVM.LLVMIsAUndefValue(value) != null) {
                return;
            } else {
                System.out.println("未知的常量类型:");
                System.out.println("Value: " + LLVM.LLVMPrintValueToString(value));
                System.out.println("Type: " + LLVM.LLVMPrintTypeToString(LLVM.LLVMTypeOf(value)));

                if (LLVM.LLVMIsAConstantExpr(value) != null) {
                    System.out.println("这是一个常量表达式");
                }
                if (LLVM.LLVMIsAConstantPointerNull(value) != null) {
                    System.out.println("这是一个空指针常量");
                }
                if (LLVM.LLVMIsAConstantTokenNone(value) != null) {
                    System.out.println("这是一个token none常量");
                }
                throw new RuntimeException("unsupported constant type");
            }
        } else {
            System.out.println("非常量值: " + LLVM.LLVMPrintValueToString(value));
        }
    }


    private String freshReg() {
        return "t" + (regCount++ % 3);
    }

    private String freshReg(int num) {
        return "t" + (regCount++ % num);
    }

    private int regCount = 0;
}
