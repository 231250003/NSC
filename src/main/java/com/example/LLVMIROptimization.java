package com.example;

import org.bytedeco.javacpp.PointerPointer;
import org.bytedeco.llvm.LLVM.*;
import org.bytedeco.llvm.global.LLVM;

import javax.print.DocFlavor;
import java.util.*;

import static org.bytedeco.llvm.global.LLVM.*;

public class LLVMIROptimization {
    LLVMModuleRef module;
    public Map<LLVMValueRef, Set<LLVMValueRef>> predecessor = new HashMap<>();
    public Map<LLVMValueRef, Set<LLVMValueRef>> successor = new HashMap<>();
    public Map<String, LLVMBasicBlockRef> name2blockref = new HashMap<>();
    public Map<String, ConstPropValueHolder> constpropinit = new HashMap<>();
    public LLVMIROptimization(LLVMModuleRef module) {
        this.module = module;
    }
    public void buildgraph(LLVMValueRef func) {
        predecessor = new HashMap<>();
        successor = new HashMap<>();
        constpropinit = new HashMap<>();
        for (LLVMValueRef global = LLVM.LLVMGetFirstGlobal(module); global != null && !global.isNull(); global = LLVM.LLVMGetNextGlobal(global)) {
            String name = LLVM.LLVMGetValueName(global).getString();
            constpropinit.put(name,ConstPropValueHolder.NAC);
        }
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            name2blockref.put(LLVM.LLVMGetBasicBlockName(bb).getString(), bb);
        }
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                if (predecessor.get(inst) == null)
                    predecessor.put(inst, new HashSet<>());
                if (inst != LLVM.LLVMGetFirstInstruction(bb))
                    predecessor.get(inst).add(LLVM.LLVMGetPreviousInstruction(inst));
                if (successor.get(inst) == null)
                    successor.put(inst, new HashSet<>());
                if (LLVM.LLVMGetNextInstruction(inst) != null)
                    successor.get(inst).add(LLVM.LLVMGetNextInstruction(inst));
                String line = LLVM.LLVMPrintValueToString(inst).getString();
                if (line.contains("br")) {
                    String line2;
                    if (line.contains(","))
                        line2 = line.substring(line.indexOf(",") + 1);
                    else
                        line2 = line;
                    for (String block_name : LLVMIRToRiscv.extractVariables(line2)) {
                        LLVMValueRef jmpinst = LLVM.LLVMGetFirstInstruction(name2blockref.get(block_name));
                        if (successor.get(inst) == null)
                            successor.put(inst, new HashSet<>());
                        successor.get(inst).add(jmpinst);
                        if (predecessor.get(jmpinst) == null)
                            predecessor.put(jmpinst, new HashSet<>());
                        predecessor.get(jmpinst).add(inst);
                    }
                }
                if (line.contains("br")) {
                    if (line.contains(",")) {
                        line = line.substring(0, line.indexOf(","));
                    } else
                        continue;
                }
                for (String var : LLVMIRToRiscv.extractVariables(line)) {
                    if (constpropinit.get(var) == null)
                        constpropinit.put(var, ConstPropValueHolder.UNDEF);
                }
            }
        }
    }

    private ConstPropValueHolder getConstValue(LLVMValueRef operand, Map<String, ConstPropValueHolder> inMap) {
        if (LLVM.LLVMIsConstant(operand) != 0) {
            if (LLVM.LLVMGetTypeKind(LLVM.LLVMTypeOf(operand)) == LLVM.LLVMIntegerTypeKind) {
                long val = LLVM.LLVMConstIntGetZExtValue(operand);
                return ConstPropValueHolder.ofInt((int) val);
            } else {
                return ConstPropValueHolder.NAC;
            }
        } else {
            String name = LLVM.LLVMGetValueName(operand) != null ? LLVM.LLVMGetValueName(operand).getString() : "";
            if (inMap.containsKey(name)) {
                return inMap.get(name);
            } else {
                throw new RuntimeException();
            }
        }
    }

    public boolean constprop(LLVMValueRef func) {
        boolean ret = false;
        buildgraph(func);
        List<array_variable> array_variable_ref = new ArrayList<>();
        Map<String,array_variable> variable_and_array_name_to_array_variable_ref=new HashMap<>();
        // for(Map.Entry<LLVMValueRef,Set<LLVMValueRef>> entry:predecessor.entrySet()){
        // System.out.println(LLVMPrintValueToString(entry.getKey()).getString());
        // for(LLVMValueRef x:(entry.getValue())){
        // System.out.println(LLVMPrintValueToString(x).getString());
        // }
        // System.out.println("-------------");
        // }
        // System.out.println("end of predecessor check");
        Map<LLVMValueRef, Map<String, ConstPropValueHolder>> in_inst = new HashMap<>();
        Map<LLVMValueRef, Map<String, ConstPropValueHolder>> out_inst = new HashMap<>();
        List<LLVMValueRef> worklist = new ArrayList<>();
        int paramCount = LLVM.LLVMCountParams(func);
        for(int i=0;i<paramCount;i++){
            LLVMValueRef param = LLVM.LLVMGetParam(func, i);
            String paramName = LLVM.LLVMGetValueName(param).getString();
            LLVMTypeRef paramType = LLVM.LLVMTypeOf(param);
            if (LLVM.LLVMGetTypeKind(paramType) == LLVMPointerTypeKind){
                LLVMTypeRef elementType = LLVM.LLVMGetElementType(paramType);
                if (LLVM.LLVMGetTypeKind(elementType) == LLVM.LLVMArrayTypeKind) {
                    int array_dim = 0;
                    List<Integer> array_size = new ArrayList<>();
                    LLVMTypeRef current = elementType;

                    // 递归提取多维数组结构
                    while (LLVM.LLVMGetTypeKind(current) == LLVM.LLVMArrayTypeKind) {
                        long len = LLVM.LLVMGetArrayLength(current);
                        array_size.add((int) len);
                        array_dim++;
                        current = LLVM.LLVMGetElementType(current);
                    }

                    array_variable av = new array_variable(paramName, paramName, array_dim, new ArrayList<>(), array_size);
                    array_variable_ref.add(av);
                    variable_and_array_name_to_array_variable_ref.put(paramName,av);
                }
            }
            constpropinit.put(paramName,ConstPropValueHolder.NAC);
        }
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                in_inst.put(inst, new HashMap<>(constpropinit));
                out_inst.put(inst, new HashMap<>(constpropinit));
                worklist.add(inst);
                int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                if (opcode == LLVM.LLVMAlloca) {
                    LLVMTypeRef ty = LLVM.LLVMGetAllocatedType(inst);
                    if (LLVM.LLVMGetTypeKind(ty) == LLVM.LLVMArrayTypeKind) {
                        String variable_name = LLVM.LLVMGetValueName(inst).getString();
                        int array_dim = 0;
                        List<Integer> array_size = new ArrayList<>();
                        LLVMTypeRef current = ty;
                        while (LLVM.LLVMGetTypeKind(current) == LLVM.LLVMArrayTypeKind) {
                            long len = LLVM.LLVMGetArrayLength(current);
                            array_size.add((int) len);
                            array_dim++;
                            current = LLVM.LLVMGetElementType(current);
                        }
                        array_variable av=new array_variable(variable_name,variable_name,array_dim,new ArrayList<>(),array_size);
                        array_variable_ref.add(av);
                        variable_and_array_name_to_array_variable_ref.put(variable_name,av);
                    }
                }
            }
        }
        while (!worklist.isEmpty()) {
            LLVMValueRef inst = worklist.iterator().next();
            worklist.remove(inst);
            Map<String, ConstPropValueHolder> old_out = out_inst.get(inst);
            int predecessor_count = 0;
            for (LLVMValueRef x : predecessor.get(inst)) {
                if (x != null)
                    predecessor_count++;
            }
            for (LLVMValueRef x : predecessor.get(inst)) {
                if (x == null)
                    continue;
                for (Map.Entry<String, ConstPropValueHolder> entry : out_inst.get(x).entrySet()) {
                    String key = entry.getKey();
                    ConstPropValueHolder value = entry.getValue();
                    if (value.getKind() == ConstPropValueHolder.Kind.NAC)
                        in_inst.get(inst).put(key, ConstPropValueHolder.NAC);
                    else if (value.getKind() == ConstPropValueHolder.Kind.INT) {
                        Integer in_val = value.getIntValue();
                        if (in_inst.get(inst).get(key).getKind() == ConstPropValueHolder.Kind.INT &&
                                (!in_inst.get(inst).get(key).getIntValue().equals(in_val)) && predecessor_count > 1) {
                            in_inst.get(inst).put(key, ConstPropValueHolder.NAC);
                        } else if (in_inst.get(inst).get(key).getKind() == ConstPropValueHolder.Kind.UNDEF
                                || in_inst.get(inst).get(key).getKind() == ConstPropValueHolder.Kind.INT) {
                            in_inst.get(inst).put(key, ConstPropValueHolder.ofInt((in_val)));
                        }
                    }
                }
            }
            Map<String, ConstPropValueHolder> new_out = new HashMap<>(in_inst.get(inst));
            int opcode = LLVM.LLVMGetInstructionOpcode(inst);
            if (opcode == LLVM.LLVMLoad) {
                LLVMValueRef ptrOp = LLVM.LLVMGetOperand(inst, 0);
                String src = LLVM.LLVMGetValueName(ptrOp).getString();
                String dest = LLVM.LLVMGetValueName(inst).getString();
                ConstPropValueHolder srcVal = in_inst.get(inst).get(src);
                ConstPropValueHolder oldDestVal = in_inst.get(inst).get(dest);
                ConstPropValueHolder resultVal;
                if(LLVM.LLVMIsAGetElementPtrInst(ptrOp) != null || (LLVM.LLVMIsAConstantExpr(ptrOp) != null && LLVM.LLVMGetConstOpcode(ptrOp) == LLVM.LLVMGetElementPtr)){
                    if(srcVal!=ConstPropValueHolder.UNDEF&&srcVal!=null)  resultVal=new ConstPropValueHolder(srcVal);//be careful with load with inbounds
                    else resultVal=ConstPropValueHolder.NAC;
                }
                 else if (oldDestVal.getKind() == ConstPropValueHolder.Kind.UNDEF) {
                    resultVal = new ConstPropValueHolder(srcVal);
                } else if (oldDestVal.getKind() == ConstPropValueHolder.Kind.NAC) {
                    resultVal = ConstPropValueHolder.NAC;
                } else if (oldDestVal.getKind() == ConstPropValueHolder.Kind.INT) {
                    if (srcVal.getKind() == ConstPropValueHolder.Kind.INT
                            || srcVal.getKind() == ConstPropValueHolder.Kind.NAC) {
                        resultVal = new ConstPropValueHolder(srcVal);
                    } else {
                        resultVal = oldDestVal;
                    }
                } else {
                    resultVal = ConstPropValueHolder.NAC; // fallback 安全策略
                }
                new_out.put(dest, resultVal);
            }
            else if(opcode== LLVMPHI){
                new_out.put(LLVM.LLVMGetValueName(inst).getString(),ConstPropValueHolder.NAC);
            }
            else if(opcode== LLVMGetElementPtr){
                String variable_name = LLVM.LLVMGetValueName(inst).getString();
                LLVMValueRef base_ptr = LLVM.LLVMGetOperand(inst, 0);
                String array_name = LLVM.LLVMGetValueName(base_ptr).getString();
                LLVMTypeRef base_type = LLVM.LLVMTypeOf(base_ptr);
                LLVMTypeRef array_type = LLVM.LLVMGetElementType(base_type);
                new_out.put(array_name,ConstPropValueHolder.NAC);
                if (LLVMGetValueKind(base_ptr) == LLVMGlobalVariableValueKind||(constpropinit.get(array_name)!=null&&constpropinit.get(array_name)==ConstPropValueHolder.NAC)) {
                    new_out.put(variable_name, ConstPropValueHolder.NAC);//全局数组或者参数数组
                }
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
                        cur_offset.add(index);
                        if (LLVMIsAGlobalVariable(index) != null||in_inst.get(inst).get(LLVM.LLVMGetValueName(index).getString()) == ConstPropValueHolder.NAC) {
                            new_out.put(variable_name, ConstPropValueHolder.NAC);
                        }
                    }
                }
                if (variable_and_array_name_to_array_variable_ref.get(variable_name) == null) {
                    array_variable av = new array_variable(variable_name, array_name, array_dim, cur_offset, array_size);
                    array_variable_ref.add(av);
                    variable_and_array_name_to_array_variable_ref.put(variable_name, av);
                }
                if (cur_offset.size() != array_size.size())
                    new_out.put(variable_name, ConstPropValueHolder.NAC);
            }
            else if(opcode== LLVMCall){
                int argCount = LLVM.LLVMGetNumArgOperands(inst);
                for (int i = 0; i < argCount; i++) {
                    LLVMValueRef arg = LLVM.LLVMGetOperand(inst, i);
                    LLVMTypeRef type = LLVM.LLVMTypeOf(arg);
                    String name = LLVM.LLVMGetValueName(arg).getString();
                    int kind = LLVM.LLVMGetTypeKind(type);
                    array_variable current_param_ref = variable_and_array_name_to_array_variable_ref.get(name);
                    if (kind == LLVM.LLVMPointerTypeKind){
                        for (array_variable x : array_variable_ref){
                            if (!x.array_name.equals(current_param_ref.array_name)) continue;
                            if (x.cur_offset.size() != x.array_size.size()) continue;
                            if(GraphColoringRegisterAllocator.naive_alias_may_analysis(current_param_ref, x)) new_out.put(x.variable_name,ConstPropValueHolder.NAC);//X的值可能在函数调用的过程中被修改
                        }
                    }
                }
                String name = LLVMGetValueName(inst).getString();
                if(name!=null&&(!name.isEmpty())) new_out.put(name,ConstPropValueHolder.NAC);
            }
            else if (opcode == LLVM.LLVMStore) {
                LLVMValueRef valueOp = LLVM.LLVMGetOperand(inst, 0);
                LLVMValueRef ptrOp = LLVM.LLVMGetOperand(inst, 1);
                String dest = LLVM.LLVMGetValueName(ptrOp).getString();
                ConstPropValueHolder srcVal = getConstValue(valueOp, in_inst.get(inst));
                ConstPropValueHolder destVal = in_inst.get(inst).getOrDefault(dest, ConstPropValueHolder.UNDEF);
                ConstPropValueHolder newVal;
                if (destVal.getKind() == ConstPropValueHolder.Kind.UNDEF) {
                    newVal = new ConstPropValueHolder(srcVal);
                } else if (destVal.getKind() == ConstPropValueHolder.Kind.NAC) {
                    newVal = ConstPropValueHolder.NAC;
                } else if (destVal.getKind() == ConstPropValueHolder.Kind.INT) {
                    if (srcVal.getKind() == ConstPropValueHolder.Kind.INT
                            || srcVal.getKind() == ConstPropValueHolder.Kind.NAC) {
                        newVal = new ConstPropValueHolder(srcVal);
                    } else {
                        newVal = destVal;
                    }
                } else {
                    newVal = ConstPropValueHolder.NAC;
                }
                new_out.put(dest, newVal);
            } else if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                    opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                    opcode == LLVM.LLVMSRem || opcode == LLVM.LLVMURem || opcode == LLVM.LLVMUDiv) {
                LLVMValueRef op1 = LLVM.LLVMGetOperand(inst, 0);
                LLVMValueRef op2 = LLVM.LLVMGetOperand(inst, 1);
                String dest = LLVM.LLVMGetValueName(inst).getString();
                ConstPropValueHolder v1 = getConstValue(op1, in_inst.get(inst));
                ConstPropValueHolder v2 = getConstValue(op2, in_inst.get(inst));
                if (v1.getKind() == ConstPropValueHolder.Kind.INT && v2.getKind() == ConstPropValueHolder.Kind.INT) {
                    Integer x1 = v1.getIntValue();
                    Integer x2 = v2.getIntValue();
                    Integer dest_val = 0;
                    switch (opcode) {
                        case LLVM.LLVMAdd:
                            dest_val = x1 + x2;
                            break;
                        case LLVM.LLVMSub:
                            dest_val = x1 - x2;
                            break;
                        case LLVM.LLVMMul:
                            dest_val = x1 * x2;
                            break;
                        case LLVM.LLVMSDiv:
                            dest_val = x1 / x2; // signed division
                            break;
                        case LLVM.LLVMUDiv:
                            dest_val = Integer.divideUnsigned(x1, x2); // unsigned division
                            break;
                        case LLVM.LLVMSRem:
                            dest_val = x1 % x2; // signed remainder
                            break;
                        case LLVM.LLVMURem:
                            dest_val = Integer.remainderUnsigned(x1, x2); // unsigned remainder
                            break;
                        default:
                            throw new RuntimeException("Unsupported binop");
                    }
                    new_out.put(dest, ConstPropValueHolder.ofInt(dest_val));
                } else if (v1.getKind() == ConstPropValueHolder.Kind.NAC
                        || v2.getKind() == ConstPropValueHolder.Kind.NAC) {
                    new_out.put(dest, ConstPropValueHolder.NAC);
                } else
                    new_out.put(dest, ConstPropValueHolder.UNDEF);
            } else if (opcode == LLVM.LLVMICmp) {
                LLVMValueRef op1 = LLVM.LLVMGetOperand(inst, 0);
                LLVMValueRef op2 = LLVM.LLVMGetOperand(inst, 1);
                String dest = LLVM.LLVMGetValueName(inst).getString();
                ConstPropValueHolder v1 = getConstValue(op1, in_inst.get(inst));
                ConstPropValueHolder v2 = getConstValue(op2, in_inst.get(inst));
                if (v1.getKind() == ConstPropValueHolder.Kind.INT &&
                        v2.getKind() == ConstPropValueHolder.Kind.INT) {
                    int x1 = v1.getIntValue();
                    int x2 = v2.getIntValue();
                    int pred = LLVM.LLVMGetICmpPredicate(inst);
                    boolean result;

                    switch (pred) {
                        case LLVM.LLVMIntEQ:
                            result = (x1 == x2);
                            break;
                        case LLVM.LLVMIntNE:
                            result = (x1 != x2);
                            break;
                        case LLVM.LLVMIntSGT:
                            result = (x1 > x2);
                            break;
                        case LLVM.LLVMIntSGE:
                            result = (x1 >= x2);
                            break;
                        case LLVM.LLVMIntSLT:
                            result = (x1 < x2);
                            break;
                        case LLVM.LLVMIntSLE:
                            result = (x1 <= x2);
                            break;
                        default:
                            throw new RuntimeException("Unsupported ICmp predicate");
                    }

                    new_out.put(dest, ConstPropValueHolder.ofInt(result ? 1 : 0));
                } else if (v1.getKind() == ConstPropValueHolder.Kind.NAC ||
                        v2.getKind() == ConstPropValueHolder.Kind.NAC) {
                    new_out.put(dest, ConstPropValueHolder.NAC);
                } else {
                    new_out.put(dest, ConstPropValueHolder.UNDEF);
                }
            } else if (opcode == LLVM.LLVMZExt) {
                LLVMValueRef srcOp = LLVM.LLVMGetOperand(inst, 0);
                String dest = LLVM.LLVMGetValueName(inst).getString();
                ConstPropValueHolder val = getConstValue(srcOp, in_inst.get(inst));
                if (val.getKind() == ConstPropValueHolder.Kind.INT) {
                    int zext_val = val.getIntValue() & 0xFFFFFFFF;
                    new_out.put(dest, ConstPropValueHolder.ofInt(zext_val));
                } else if (val.getKind() == ConstPropValueHolder.Kind.NAC) {
                    new_out.put(dest, ConstPropValueHolder.NAC);
                } else {
                    new_out.put(dest, ConstPropValueHolder.UNDEF);
                }
            } else
                new_out = new HashMap<>(in_inst.get(inst));
            boolean state_changed = false;
            for (String key : old_out.keySet()) {
                ConstPropValueHolder v1 = old_out.get(key);
                ConstPropValueHolder v2 = new_out.get(key);
                if (v1.getKind() != v2.getKind())
                    state_changed = true;
                else if (v1.getKind() == ConstPropValueHolder.Kind.INT && (!v1.getIntValue().equals(v2.getIntValue())))
                    state_changed = true;
            }
            if (state_changed) {
                Set<LLVMValueRef> succs = successor.get(inst);
                if (succs != null) {
                    for (LLVMValueRef x : succs) {
                        worklist.add(x);
                    }
                }
            }
            // System.out.println(LLVM.LLVMPrintValueToString(inst).getString());
            // for(Map.Entry<String,ConstPropValueHolder> entry:new_out.entrySet()){
            // System.out.print(entry.getKey());
            // System.out.print(" ");
            // System.out.println(entry.getValue());
            // }
            // System.out.println("--------------");
            out_inst.put(inst, new_out);
        }
        Set<String> is_constant = new HashSet<>();
        for (Map.Entry<String, ConstPropValueHolder> entry : constpropinit.entrySet()) {
            is_constant.add(entry.getKey());
        }
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null
                && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM
                    .LLVMGetNextInstruction(inst)) {
                for (Map.Entry<String, ConstPropValueHolder> entry : out_inst.get(inst).entrySet()) {
                    if (entry.getValue().getKind() == ConstPropValueHolder.Kind.NAC)
                        is_constant.remove(entry.getKey());
                }
            }
        }
        // for(String x:is_constant) System.out.println(x);
        Set<LLVMValueRef> inst_to_delete = new HashSet<>();
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            Set<String> has_store_variable = new HashSet<>();
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                String lhs;
                if (LLVM.LLVMGetValueName(inst) != null) lhs = LLVM.LLVMGetValueName(inst).getString();
                else lhs = null;
                if(opcode== LLVMAlloca) continue;
                else if (opcode == LLVM.LLVMStore) {
                    String dest = LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 1)).getString();
                    if (is_constant.contains(dest)) {
                        if (!has_store_variable.contains(dest)) {
                            has_store_variable.add(dest);
                            //System.out.println(LLVM.LLVMPrintValueToString(inst).getString());
                            // System.out.println(out_inst.get(inst).get(dest));
                            LLVMValueRef constInst = LLVMConstInt(LLVM.LLVMTypeOf(LLVM.LLVMGetOperand(inst, 0)),
                                    out_inst.get(inst).get(dest).getIntValue(), 0);
                            LLVM.LLVMSetOperand(inst, 0, constInst);
                        } else
                            inst_to_delete.add(inst);
                    } else {
                        if (LLVM.LLVMIsConstant(LLVM.LLVMGetOperand(inst, 0)) == 0 && is_constant
                                .contains(LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 0)).getString())) {
                            LLVMValueRef constInst = LLVMConstInt(LLVM.LLVMTypeOf(LLVM.LLVMGetOperand(inst, 0)),
                                    out_inst.get(inst)
                                            .get(LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 0)).getString())
                                            .getIntValue(),
                                    0);
                            LLVM.LLVMSetOperand(inst, 0, constInst);
                        }
                    }
                } else if (opcode == LLVM.LLVMRet) {
                    LLVMValueRef retVal = LLVM.LLVMGetOperand(inst, 0);
                    if (LLVM.LLVMGetValueName(retVal) != null
                            && is_constant.contains(LLVM.LLVMGetValueName(retVal).getString())) {
                        LLVMValueRef constInst = LLVMConstInt(LLVM.LLVMTypeOf(retVal),
                                out_inst.get(inst).get(LLVM.LLVMGetValueName(retVal).getString()).getIntValue(), 0);
                        LLVM.LLVMSetOperand(inst, 0, constInst);
                    }
                } else if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                        opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                        opcode == LLVM.LLVMSRem || opcode == LLVM.LLVMURem ||
                        opcode == LLVM.LLVMUDiv || opcode == LLVM.LLVMICmp || opcode == LLVM.LLVMZExt) {
                    int numOperands = LLVM.LLVMGetNumOperands(inst);
                    for (int i = 0; i < numOperands; i++) {
                        LLVMValueRef op = LLVM.LLVMGetOperand(inst, i);
                        if (LLVM.LLVMGetValueName(op) != null && is_constant.contains(LLVM.LLVMGetValueName(op).getString())) {
                            int value = out_inst.get(inst).get(LLVM.LLVMGetValueName(op).getString()).getIntValue();
                            LLVMValueRef constOp = LLVMConstInt(LLVM.LLVMTypeOf(op), value, 0);
                            LLVM.LLVMSetOperand(inst, i, constOp);
                        }
                    }
                } else if (opcode == LLVM.LLVMBr) {
                    if (LLVM.LLVMIsConditional(inst) != 0) { // 条件跳转
                        LLVMValueRef cond = LLVM.LLVMGetOperand(inst, 0);
                        if (LLVM.LLVMGetValueName(cond) != null
                                && is_constant.contains(LLVM.LLVMGetValueName(cond).getString())) {
                            int value = out_inst.get(inst).get(LLVM.LLVMGetValueName(cond).getString()).getIntValue();
                            LLVMValueRef constCond = LLVMConstInt(LLVM.LLVMTypeOf(cond), value, 0);
                            LLVM.LLVMSetOperand(inst, 0, constCond);
                        }
                    }
                }
                else if(opcode== LLVMGetElementPtr){
                    int operand_count = LLVM.LLVMGetNumOperands(inst);
                    for (int i = 2; i < operand_count; i++) {
                        LLVMValueRef index = LLVM.LLVMGetOperand(inst, i);
                        if(is_constant.contains(LLVM.LLVMGetValueName(index).getString())){
                            int value = out_inst.get(inst).get(LLVM.LLVMGetValueName(index).getString()).getIntValue();
                            LLVMValueRef constOp = LLVMConstInt(LLVM.LLVMTypeOf(index), value, 0);
                            LLVM.LLVMSetOperand(inst, i, constOp);
                        }
                    }
                }
                else if(opcode==LLVMCall){
                    int argCount = LLVM.LLVMGetNumArgOperands(inst);
                    for (int i = 0; i < argCount; i++) {
                        LLVMValueRef arg = LLVM.LLVMGetOperand(inst, i);
                        int kind = LLVM.LLVMGetTypeKind(LLVM.LLVMTypeOf(arg));
                        if(is_constant.contains(LLVM.LLVMGetValueName(arg).getString())&&kind== LLVMIntegerTypeKind){
                            int value = out_inst.get(inst).get(LLVM.LLVMGetValueName(arg).getString()).getIntValue();
                            LLVMValueRef constOp = LLVMConstInt(LLVM.LLVMTypeOf(arg), value, 0);
                            LLVM.LLVMSetOperand(inst, i, constOp);
                        }
                    }
                }
                else if (opcode == LLVMPHI) {
                    LLVMValueRef v0 = LLVM.LLVMGetIncomingValue(inst, 0);
                    LLVMValueRef v1 = LLVM.LLVMGetIncomingValue(inst, 1);
                    LLVMBasicBlockRef b0 = LLVM.LLVMGetIncomingBlock(inst, 0);
                    LLVMBasicBlockRef b1 = LLVM.LLVMGetIncomingBlock(inst, 1);
                    // 创建新的 incoming value 数组
                    LLVMValueRef new_v0 = v0;
                    LLVMValueRef new_v1 = v1;

                    // 判断 v0 是否是常量
                    if (is_constant.contains(LLVM.LLVMGetValueName(v0).getString())) {
                        int value = out_inst.get(inst).get(LLVM.LLVMGetValueName(v0).getString()).getIntValue();
                        new_v0 = LLVM.LLVMConstInt(LLVM.LLVMTypeOf(v0), value, 0);
                    }

                    // 判断 v1 是否是常量
                    if (is_constant.contains(LLVM.LLVMGetValueName(v1).getString())) {
                        int value = out_inst.get(inst).get(LLVM.LLVMGetValueName(v1).getString()).getIntValue();
                        new_v1 = LLVM.LLVMConstInt(LLVM.LLVMTypeOf(v1), value, 0);
                    }
                    LLVMBuilderRef builder = LLVM.LLVMCreateBuilder();
                    LLVMPositionBuilderBefore(builder, inst); // 插入到原 inst 前

                    LLVMValueRef newPhi = LLVM.LLVMBuildPhi(builder, LLVM.LLVMTypeOf(v0), "phi_repl");
                    PointerPointer<LLVMValueRef> values = new PointerPointer<>(2);
                    PointerPointer<LLVMBasicBlockRef> blocks = new PointerPointer<>(2);
                    values.put(0, new_v0);
                    values.put(1, new_v1);
                    blocks.put(0, b0);
                    blocks.put(1, b1);
                    LLVM.LLVMAddIncoming(newPhi, values, blocks, 2);
                    LLVM.LLVMReplaceAllUsesWith(inst, newPhi);
                    LLVM.LLVMInstructionEraseFromParent(inst);

                    LLVM.LLVMDisposeBuilder(builder);
                }
                else if (lhs != null && !lhs.isEmpty() && is_constant.contains(lhs)) {
                    int numOperands = LLVM.LLVMGetNumOperands(inst);
                    for (int i = 0; i < numOperands; i++) {
                        LLVMValueRef zero = LLVM.LLVMConstNull(LLVM.LLVMTypeOf(LLVM.LLVMGetOperand(inst, i)));
                        LLVM.LLVMSetOperand(inst, i, zero);
                    }
                    inst_to_delete.add(inst);
                }
            }
        }
        for (LLVMValueRef x : inst_to_delete) {
            if (x != null)
                ret = true;
            LLVM.LLVMInstructionEraseFromParent(x);
        }
        return ret;
    }

    public boolean pointer_must_optimize(LLVMValueRef func){
        boolean ret=false;
        Map<String,LLVMValueRef> init_elementptr_ref=new HashMap<>();
        int paramCount = LLVM.LLVMCountParams(func);
        List<array_variable> init_arrayVariable_ref=new ArrayList<>();
        Set<LLVMValueRef> inst_to_delete=new HashSet<>();
        for(int i=0;i<paramCount;i++){
            LLVMValueRef param = LLVM.LLVMGetParam(func, i);
            String paramName = LLVM.LLVMGetValueName(param).getString();
            LLVMTypeRef paramType = LLVM.LLVMTypeOf(param);
            if (LLVM.LLVMGetTypeKind(paramType) == LLVMPointerTypeKind){
                LLVMTypeRef elementType = LLVM.LLVMGetElementType(paramType);
                if (LLVM.LLVMGetTypeKind(elementType) == LLVM.LLVMArrayTypeKind) {
                    init_elementptr_ref.put(paramName,param);
                    int array_dim = 0;
                    List<Integer> array_size = new ArrayList<>();
                    LLVMTypeRef current = elementType;
                    while (LLVM.LLVMGetTypeKind(current) == LLVM.LLVMArrayTypeKind) {
                        long len = LLVM.LLVMGetArrayLength(current);
                        array_size.add((int) len);
                        array_dim++;
                        current = LLVM.LLVMGetElementType(current);
                    }
                    array_variable av = new array_variable(paramName, paramName, array_dim, new ArrayList<>(), array_size);
                    init_arrayVariable_ref.add(av);
                }
            }
        }
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            Map<String,LLVMValueRef> elementptr_ref=new HashMap<>(init_elementptr_ref);
            List<array_variable> arrayVariable_ref=new ArrayList<>(init_arrayVariable_ref);
            Map<LLVMValueRef,LLVMValueRef> alias_must_pointer=new HashMap<>();
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null && !inst.isNull(); inst = LLVM.LLVMGetNextInstruction(inst)) {
                int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                if(opcode==LLVMGetElementPtr){
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
                            cur_offset.add(index);
                        }
                    }
                    array_variable av = new array_variable(variable_name, array_name, array_dim, cur_offset, array_size);
                    boolean has_must_alias=false;
                    for(array_variable x:arrayVariable_ref){
                        if(GraphColoringRegisterAllocator.naive_alias_must_analysis(av,x)==true){
                            has_must_alias=true;
                            alias_must_pointer.put(inst,elementptr_ref.get(x.variable_name));
                            inst_to_delete.add(inst);
                            break;
                        }
                    }
                    if(has_must_alias==false) arrayVariable_ref.add(av);
                    elementptr_ref.putIfAbsent(variable_name, inst);
                }
                else if(opcode==LLVMLoad){
                    LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 0);
                    if(alias_must_pointer.get(ptr)!=null)    LLVM.LLVMSetOperand(inst, 0, alias_must_pointer.get(ptr));
                }
                else if(opcode==LLVMStore){
                    LLVMValueRef ptr = LLVM.LLVMGetOperand(inst, 1);
                    if(alias_must_pointer.get(ptr)!=null)    LLVM.LLVMSetOperand(inst, 1, alias_must_pointer.get(ptr));
                }
                else if(opcode==LLVMCall){
                    int argCount = LLVM.LLVMGetNumArgOperands(inst);
                    for (int i = 0; i < argCount; i++) {
                        LLVMValueRef arg = LLVM.LLVMGetOperand(inst, i);
                        if(alias_must_pointer.get(arg)!=null)   LLVM.LLVMSetOperand(inst, i, alias_must_pointer.get(arg));
                    }
                }
            }
        }
        for(LLVMValueRef x:inst_to_delete){
            if(x!=null){
                LLVM.LLVMInstructionEraseFromParent(x);
                ret=true;
            }
        }
        return ret;
    }

    public boolean elem_unused(LLVMValueRef func) {
        boolean ret = false;
        Set<LLVMValueRef> allInstrs = new HashSet<>();
        Set<LLVMValueRef> usedInstrs = new HashSet<>();
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null && !inst.isNull(); inst = LLVM.LLVMGetNextInstruction(inst)) {
                allInstrs.add(inst);
                int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                        opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                        opcode == LLVM.LLVMSRem || opcode == LLVM.LLVMURem ||
                        opcode == LLVM.LLVMUDiv || opcode == LLVM.LLVMICmp || opcode == LLVM.LLVMZExt
                        || opcode == LLVM.LLVMLoad || opcode == LLVMRet||opcode==LLVMCall) {
                    int numOperands = LLVM.LLVMGetNumOperands(inst);
                    for (int i = 0; i < numOperands; i++) {
                        LLVMValueRef operand = LLVM.LLVMGetOperand(inst, i);
                        if (operand != null && !operand.isNull()) {
                            if (!LLVMGetValueName(operand).getString().isEmpty())
                                usedInstrs.add(operand);
                        }
                    }
                } else if (opcode == LLVM.LLVMStore || (opcode == LLVM.LLVMBr && LLVM.LLVMGetNumOperands(inst) == 3)) {
                    for (int i = 0; i < 1; i++) {
                        LLVMValueRef operand = LLVM.LLVMGetOperand(inst, i);
                        if (operand != null && !operand.isNull()) {
                            if (!LLVMGetValueName(operand).getString().isEmpty())
                                usedInstrs.add(operand);
                        }
                    }
                }
                else if(opcode==LLVMPHI){
                    LLVMValueRef v0 = LLVM.LLVMGetIncomingValue(inst, 0);
                    LLVMValueRef v1 = LLVM.LLVMGetIncomingValue(inst, 1);
                    if(v0!=null&&LLVM.LLVMGetValueName(v0).getString()!=null&&(!LLVM.LLVMGetValueName(v0).getString().isEmpty())) usedInstrs.add(v0);
                    if(v1!=null&&LLVM.LLVMGetValueName(v1).getString()!=null&&(!LLVM.LLVMGetValueName(v1).getString().isEmpty())) usedInstrs.add(v1);
                }
                else if(opcode==LLVMGetElementPtr){
                    int operand_count = LLVM.LLVMGetNumOperands(inst);
                    for (int i = 2; i < operand_count; i++) {
                        LLVMValueRef index = LLVM.LLVMGetOperand(inst, i);
                        if (LLVM.LLVMIsAConstant(index) == null) usedInstrs.add(index);
                    }
                }
            }
        }
        List<LLVMValueRef> toErase = new ArrayList<>();
        GraphColoringRegisterAllocator live_variable_analysis=new GraphColoringRegisterAllocator(func);
        for (LLVMValueRef instr : allInstrs) {
            boolean shouldKeep = false;
            int opcode = LLVM.LLVMGetInstructionOpcode(instr);
            if ((instr!=null&&usedInstrs.contains(instr)&&LLVM.LLVMGetValueName(instr).getString()!=null&&(!LLVM.LLVMGetValueName(instr).getString().isEmpty()))
                    ||opcode==LLVMCall||opcode==LLVMPHI) {
                shouldKeep = true;
            }
//            else if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
//                    opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
//                    opcode == LLVM.LLVMSRem || opcode == LLVM.LLVMURem ||
//                    opcode == LLVM.LLVMUDiv || opcode == LLVM.LLVMICmp || opcode == LLVM.LLVMZExt
//                    || opcode == LLVM.LLVMLoad || opcode == LLVMRet) {
////                int numOperands = LLVM.LLVMGetNumOperands(instr);
////                for (int i = 0; i < numOperands; i++) {
////                    LLVMValueRef operand = LLVM.LLVMGetOperand(instr, i);
////                    if (operand != null && !operand.isNull()) {
////                        if (usedInstrs.contains(operand))
////                            shouldKeep = true;
////                    }
////                }忘了之前是不是脑抽了，还是现在脑抽了
//            }
            else if (opcode == LLVM.LLVMStore) {
                LLVMValueRef operand = LLVM.LLVMGetOperand(instr, 1);
                if (operand != null && !operand.isNull()) {
                    if (usedInstrs.contains(operand)||(LLVM.LLVMGetValueName(operand).getString().contains("elemPtr"))) shouldKeep = true;
//                    else if(LLVM.LLVMGetValueName(operand).getString().contains("elemPtr")){
//                        if(GraphColoringRegisterAllocator.get_after_cur_inst_live_variable(instr).contains((LLVM.LLVMGetValueName(operand).getString())))
//                            shouldKeep=true;
//                    }
                }
            }
            if (!shouldKeep) {
                if (opcode != LLVM.LLVMRet &&
                        opcode != LLVM.LLVMBr &&
                        opcode != LLVM.LLVMSwitch &&
                        opcode != LLVM.LLVMUnreachable) {
                    ret = true;
                    toErase.add(instr);
                }
            }
        }
        for (LLVMValueRef instr : toErase) {
            System.out.println("craas");
            System.out.println(LLVM.LLVMPrintValueToString(instr).getString());
            LLVM.LLVMInstructionEraseFromParent(instr);
        }
        System.out.println("crzzzzz");
        return ret;
    }

    public boolean remove_redundant_block(LLVMValueRef func) {
        boolean remove = false;
        List<LLVMBasicBlockRef> delete_block = new ArrayList<>();
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null
                && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            LLVMValueRef first_inst = LLVM.LLVMGetFirstInstruction(bb);
            boolean is_isolated_block = true;
            if (predecessor.get(first_inst) == null)
                is_isolated_block = true;
            else {
                for (LLVMValueRef x : predecessor.get(first_inst)) {
                    if (x != null)
                        is_isolated_block = false;
                }
            }
            if (!LLVMBasicBlockAsValue(bb).equals(LLVMBasicBlockAsValue(LLVMGetEntryBasicBlock(func)))
                    && is_isolated_block) {
                remove = true;
                delete_block.add(bb);
            }
        }
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null
                && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            LLVMValueRef first_inst = LLVM.LLVMGetFirstInstruction(bb);
            Set<LLVMValueRef> x = predecessor.get(first_inst);
            List<LLVMValueRef> toRemove = new ArrayList<>();
            for (LLVMValueRef pred : x) {
                if (pred == null)
                    continue;
                if (delete_block.contains(LLVMGetInstructionParent(pred))) {
                    toRemove.add(pred);
                }
            }
            for (LLVMValueRef z : toRemove)
                x.remove(z);
        }
        for (LLVMBasicBlockRef x : delete_block) {
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(x); inst != null; inst = LLVM
                    .LLVMGetNextInstruction(inst)) {
                predecessor.remove(inst);
                successor.remove(inst);
            }
            LLVMRemoveBasicBlockFromParent(x);
        }
        // for(Map.Entry<LLVMValueRef,Set<LLVMValueRef>> entry:predecessor.entrySet()){
        // System.out.println(LLVMPrintValueToString(entry.getKey()).getString());
        // for(LLVMValueRef x:(entry.getValue())){
        // System.out.println(LLVMPrintValueToString(x).getString());
        // }
        // System.out.println("-------------");
        // }
        // System.out.println("end of predecessor check");
        boolean flag = merge_block(func);
        return remove || flag;
    }

    public void append_inst(LLVMBasicBlockRef dest, LLVMBasicBlockRef src) {
        LLVMValueRef last_inst = LLVM.LLVMGetLastInstruction(dest);
        LLVMValueRef first_inst = LLVM.LLVMGetFirstInstruction(src);
        // System.out.println(LLVMPrintValueToString(last_inst).getString());
        // System.out.println(LLVMPrintValueToString(first_inst).getString());
        // System.out.println("----------");
        Set<LLVMValueRef> x = predecessor.get(last_inst);
        for (LLVMValueRef stmt : x) {
            successor.get(stmt).remove(last_inst);
            successor.get(stmt).add(first_inst);
            predecessor.get(first_inst).add(stmt);
        }
        predecessor.get(first_inst).remove(last_inst);
        predecessor.remove(last_inst);
        successor.remove(last_inst);
        LLVMInstructionEraseFromParent(last_inst);
        LLVMBuilderRef builder = LLVMCreateBuilder();
        LLVMPositionBuilderAtEnd(builder, dest);
        List<LLVMValueRef> instructions = new ArrayList<>();
        for (LLVMValueRef inst = LLVMGetFirstInstruction(src); inst != null; inst = LLVMGetNextInstruction(inst)) {
            instructions.add(inst);
        }
        for (LLVMValueRef inst : instructions) {
            String name = LLVMGetValueName(inst).getString();
            LLVMInstructionRemoveFromParent(inst);
            LLVMInsertIntoBuilder(builder, inst);
            if (name != null && !name.isEmpty())
                LLVMSetValueName(inst, name);
        }
        LLVMRemoveBasicBlockFromParent(src);
        // for(Map.Entry<LLVMValueRef,Set<LLVMValueRef>> entry:successor.entrySet()){
        // System.out.println(LLVMPrintValueToString(entry.getKey()).getString());
        // for(LLVMValueRef tem:(entry.getValue())){
        // System.out.println(LLVMPrintValueToString(tem).getString());
        // }
        // System.out.println("-------------");
        // }
        // System.out.println("end of successor check");
    }

    public boolean merge_block(LLVMValueRef func) {
        for (Map.Entry<LLVMValueRef, Set<LLVMValueRef>> entry : successor.entrySet()) {
            entry.getValue().removeIf(Objects::isNull);
        }
        for (Map.Entry<LLVMValueRef, Set<LLVMValueRef>> entry : predecessor.entrySet()) {
            entry.getValue().removeIf(Objects::isNull);
        }
        boolean flag = false;
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null
                && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            LLVMValueRef last_inst = LLVM.LLVMGetLastInstruction(bb);
            // System.out.println(LLVMPrintValueToString(last_inst).getString());
            if (successor.get(last_inst).size() == 1) {
                for (LLVMValueRef entry : successor.get(last_inst)) {
                    if (!LLVMBasicBlockAsValue(bb).equals(LLVMBasicBlockAsValue(LLVMGetInstructionParent(entry)))
                            && predecessor.get(entry).size() == 1) {
                        append_inst(bb, LLVMGetInstructionParent(entry));
                        flag = true;
                        break;
                    }
                }
            }
            if (flag)
                break;
        }
        return flag;
    }

    public boolean elem_dead_code(LLVMValueRef func) {
        boolean ret = false;
        buildgraph(func);
        for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null
                && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null && !inst.isNull();) {
                LLVMValueRef next = LLVM.LLVMGetNextInstruction(inst); // 保存下一条指令指针
                int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                if (opcode == LLVM.LLVMBr) {
                    int numOperands = LLVM.LLVMGetNumOperands(inst);
                    if (numOperands == 3) {
                        LLVMValueRef cond = LLVM.LLVMGetOperand(inst, 0);
                        LLVMValueRef ifFalse = LLVM.LLVMGetOperand(inst, 1);
                        LLVMValueRef ifTrue = LLVM.LLVMGetOperand(inst, 2);
                        if (LLVM.LLVMIsAConstantInt(cond) != null) {
                            ret = true;
                            long condValue = LLVM.LLVMConstIntGetZExtValue(cond);
                            LLVMValueRef target = (condValue != 0) ? ifTrue : ifFalse;
                            LLVMBuilderRef builder = LLVM.LLVMCreateBuilder();
                            LLVM.LLVMPositionBuilderBefore(builder, inst);
                            LLVM.LLVMBuildBr(builder, LLVM.LLVMValueAsBasicBlock(target));
                            LLVM.LLVMDisposeBuilder(builder);
                            LLVM.LLVMInstructionEraseFromParent(inst);
                        }
                    }
                }
                inst = next;
            }
        }
        cleanUnreachableBlocks(func);
        buildgraph(func);
        if (IRGenerationVisitor.while_stmt_count >= 0) {
            while (simplifySingleInstructionBlocks(func));
        }
        while (remove_redundant_block(func)) ;
        return ret;
    }

    public boolean simplifySingleInstructionBlocks(LLVMValueRef func) {
        Set<LLVMBasicBlockRef> toRemove = new HashSet<>();
        List<LLVMBasicBlockRef> candidateBlocks = new ArrayList<>();
        for (LLVMValueRef function = LLVMGetFirstFunction(module); function != null; function = LLVMGetNextFunction(
                function)) {
            for (LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(
                    function); block != null; block = LLVMGetNextBasicBlock(block)) {
                boolean onlyTerminator = true;
                if (LLVMGetInstructionOpcode(LLVMGetFirstInstruction(block)) != LLVMBr
                        || LLVM.LLVMGetNumOperands(LLVMGetFirstInstruction(block)) != 1)
                    onlyTerminator = false;
                for (LLVMValueRef inst = LLVMGetFirstInstruction(block); inst != null; inst = LLVMGetNextInstruction(
                        inst)) {
                    int opcode = LLVMGetInstructionOpcode(inst);
                    if (opcode != LLVMBr && opcode != LLVMRet) {
                        onlyTerminator = false;
                        break;
                    }
                }
                if (onlyTerminator && LLVMGetFirstInstruction(block) != null && !LLVMBasicBlockAsValue(block)
                        .equals(LLVMBasicBlockAsValue(LLVMGetEntryBasicBlock(function)))) {
                    candidateBlocks.add(block);
                }
            }
        }
        for (LLVMBasicBlockRef candidate : candidateBlocks) {
            // System.out.println(LLVMGetBasicBlockName(candidate).getString());
            LLVMValueRef terminator = LLVMGetFirstInstruction(candidate);
            LLVMValueRef jmp_block = LLVM.LLVMGetOperand(terminator, 0);
            for (LLVMValueRef function = LLVMGetFirstFunction(module); function != null; function = LLVMGetNextFunction(
                    function)) {
                for (LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(
                        function); block != null; block = LLVMGetNextBasicBlock(block)) {
                    for (LLVMValueRef term = LLVMGetFirstInstruction(
                            block); term != null; term = LLVMGetNextInstruction(term)) {
                        if (LLVMGetInstructionOpcode(term) != LLVMBr)
                            continue;
                        int numOps = LLVMGetNumOperands(term);
                        if (numOps == 1) {
                            // System.out.println((LLVMGetBasicBlockName(candidate).getString()));
                            // System.out.println((LLVMGetValueName(LLVM.LLVMGetOperand(term,
                            // 0)).getString()));
                            // System.out.println("-----------");
                            if (LLVMGetBasicBlockName(candidate).getString()
                                    .equals(LLVMGetValueName(LLVM.LLVMGetOperand(term, 0)).getString())) {
                                LLVMSetOperand(term, 0, jmp_block);
                            }
                        } else if (numOps == 3) {
                            LLVMValueRef op1 = LLVMGetOperand(term, 1);
                            LLVMValueRef op2 = LLVMGetOperand(term, 2);
                            if (LLVMGetBasicBlockName(candidate).getString()
                                    .equals(LLVMGetValueName(op1).getString())) {
                                LLVMSetOperand(term, 1, jmp_block);
                            } else if (LLVMGetBasicBlockName(candidate).getString()
                                    .equals(LLVMGetValueName(op2).getString())) {
                                LLVMSetOperand(term, 2, jmp_block);
                            }
                        }
                    }
                }
            }
            toRemove.add(candidate);
        }
        // LLVMDumpModule(module);
        // System.out.println("-----------end of change");
        boolean changed = false;
        for (LLVMBasicBlockRef bb : toRemove) {
            LLVMValueRef parent = LLVMGetBasicBlockParent(bb);
            if (parent != null) {
                LLVMDeleteBasicBlock(bb);
                changed = true;
            }
        }
        if (changed)
            buildgraph(func);
        return changed;
    }

    public void cleanUnreachableBlocks(LLVMValueRef function) {
        Set<LLVMBasicBlockRef> unreachableBlocks = new HashSet<>();
        for (LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(function); block != null; block = LLVMGetNextBasicBlock(block)) {
            LLVMValueRef terminator = LLVMGetBasicBlockTerminator(block);
            if (terminator != null && LLVMGetInstructionOpcode(terminator) == LLVMUnreachable) {
                unreachableBlocks.add(block);
            }
        }
        for (LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(function); block != null; block = LLVMGetNextBasicBlock(
                block)) {
            LLVMValueRef terminator = LLVMGetBasicBlockTerminator(block);
            if (terminator != null && LLVMGetInstructionOpcode(terminator) == LLVMBr) {
                int numSuccessors = LLVMGetNumSuccessors(terminator);
                boolean allUnreachable = true;
                for (int i = 0; i < numSuccessors; i++) {
                    LLVMBasicBlockRef target = LLVMGetSuccessor(terminator, i);
                    if (!unreachableBlocks.contains(target)) {
                        allUnreachable = false;
                        break;
                    }
                }
                if (allUnreachable) {
                    LLVMInstructionEraseFromParent(terminator);
                }
            }
        }

        LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(function);
        while (block != null) {
            LLVMBasicBlockRef next = LLVMGetNextBasicBlock(block);
            if (unreachableBlocks.contains(block)) {
                LLVMDeleteBasicBlock(block);
            }
            block = next;
        }
    }
}
