import com.sun.jdi.Value;
import org.bytedeco.llvm.LLVM.*;
import org.bytedeco.llvm.global.LLVM;

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

    public void buildgraph() {
        predecessor = new HashMap<>();
         successor = new HashMap<>();
        constpropinit = new HashMap<>();
        for (LLVMValueRef global = LLVM.LLVMGetFirstGlobal(module);
             global != null && !global.isNull();
             global = LLVM.LLVMGetNextGlobal(global)) {
            String name = LLVM.LLVMGetValueName(global).getString();
            LLVMValueRef init = LLVM.LLVMGetInitializer(global);
            long val = init.isNull() ? 0 : LLVM.LLVMConstIntGetSExtValue(init);
            constpropinit.put(name, ConstPropValueHolder.ofInt((int) val));
        }
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                name2blockref.put(LLVM.LLVMGetBasicBlockName(bb).getString(), bb);
            }
        }
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                    if (predecessor.get(inst) == null) predecessor.put(inst, new HashSet<>());
                    if (inst != LLVM.LLVMGetFirstInstruction(bb)) predecessor.get(inst).add(LLVM.LLVMGetPreviousInstruction(inst));
                    if(successor.get(inst)==null) successor.put(inst,new HashSet<>());
                    if(LLVM.LLVMGetNextInstruction(inst)!=null) successor.get(inst).add(LLVM.LLVMGetNextInstruction(inst));
                    String line = LLVM.LLVMPrintValueToString(inst).getString();
                    if (line.contains("br")) {
                        String line2;
                        if (line.contains(",")) line2 = line.substring(line.indexOf(",") + 1);
                        else line2 = line;
                        for (String block_name : LLVMIRToRiscv.extractVariables(line2)) {
                            LLVMValueRef jmpinst = LLVM.LLVMGetFirstInstruction(name2blockref.get(block_name));
                            if (successor.get(inst) == null) successor.put(inst, new HashSet<>());
                            successor.get(inst).add(jmpinst);
                            if (predecessor.get(jmpinst) == null) predecessor.put(jmpinst, new HashSet<>());
                            predecessor.get(jmpinst).add(inst);
                        }
                    }
                    if (line.contains("br")) {
                        if (line.contains(",")){
                            line = line.substring(0, line.indexOf(","));
                        }
                        else continue;
                    }
                    for (String var : LLVMIRToRiscv.extractVariables(line)) {
                        if (constpropinit.get(var) == null) constpropinit.put(var, ConstPropValueHolder.UNDEF);
                    }
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
    public void constprop() {
        buildgraph();
//        for(Map.Entry<LLVMValueRef,Set<LLVMValueRef>> entry:predecessor.entrySet()){
//            System.out.println(LLVMPrintValueToString(entry.getKey()).getString());
//            for(LLVMValueRef x:(entry.getValue())){
//                System.out.println(LLVMPrintValueToString(x).getString());
//            }
//            System.out.println("-------------");
//        }
//        System.out.println("end of predecessor check");
        Map<LLVMValueRef, Map<String, ConstPropValueHolder>> in_inst = new HashMap<>();
        Map<LLVMValueRef, Map<String, ConstPropValueHolder>> out_inst = new HashMap<>();
        List<LLVMValueRef> worklist = new ArrayList<>();
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                    in_inst.put(inst, new HashMap<>(constpropinit));
                    out_inst.put(inst, new HashMap<>(constpropinit));
                    worklist.add(inst);
                }
            }
        }
        while (!worklist.isEmpty()) {
            LLVMValueRef inst = worklist.iterator().next();
            worklist.remove(inst);
            Map<String, ConstPropValueHolder> old_out = out_inst.get(inst);
            for (LLVMValueRef x : predecessor.get(inst)) {
                if (x == null) continue;
                for (Map.Entry<String, ConstPropValueHolder> entry : out_inst.get(x).entrySet()) {
                    String key = entry.getKey();
                    ConstPropValueHolder value = entry.getValue();
                    if (value.getKind() == ConstPropValueHolder.Kind.NAC)
                        in_inst.get(inst).put(key, ConstPropValueHolder.NAC);
                    else if (value.getKind() == ConstPropValueHolder.Kind.INT) {
                        Integer in_val = value.getIntValue();
                        if (in_inst.get(inst).get(key).getKind() == ConstPropValueHolder.Kind.INT &&
                                (!in_inst.get(inst).get(key).getIntValue().equals(in_val))) {
                            in_inst.get(inst).put(key, ConstPropValueHolder.NAC);
                        } else if (in_inst.get(inst).get(key).getKind() == ConstPropValueHolder.Kind.UNDEF) {
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
                if (oldDestVal.getKind() == ConstPropValueHolder.Kind.UNDEF) {
                    resultVal = new ConstPropValueHolder(srcVal);
                } else if (oldDestVal.getKind() == ConstPropValueHolder.Kind.NAC) {
                    resultVal = ConstPropValueHolder.NAC;
                } else if (oldDestVal.getKind() == ConstPropValueHolder.Kind.INT) {
                    if (srcVal.getKind() == ConstPropValueHolder.Kind.INT||srcVal.getKind() == ConstPropValueHolder.Kind.NAC) {
                            resultVal = new ConstPropValueHolder(srcVal);
                    } else {
                        resultVal = oldDestVal;
                    }
                } else {
                    resultVal = ConstPropValueHolder.NAC; // fallback 安全策略
                }
                new_out.put(dest, resultVal);
            } else if (opcode == LLVM.LLVMStore) {
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
                    if (srcVal.getKind() == ConstPropValueHolder.Kind.INT||srcVal.getKind() == ConstPropValueHolder.Kind.NAC) {
                        newVal =new ConstPropValueHolder(srcVal);
                    }
                    else {
                        newVal =destVal;
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
                } else if (v1.getKind() == ConstPropValueHolder.Kind.NAC || v2.getKind() == ConstPropValueHolder.Kind.NAC) {
                    new_out.put(dest, ConstPropValueHolder.NAC);
                } else new_out.put(dest, ConstPropValueHolder.UNDEF);
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
            }
            else new_out=new HashMap<>(in_inst.get(inst));
            boolean state_changed = false;
            for (String key : old_out.keySet()) {
                ConstPropValueHolder v1 = old_out.get(key);
                ConstPropValueHolder v2 = new_out.get(key);
                if (v1.getKind() != v2.getKind()) state_changed = true;
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
//            System.out.println(LLVM.LLVMPrintValueToString(inst).getString());
//            for(Map.Entry<String,ConstPropValueHolder> entry:new_out.entrySet()){
//                System.out.print(entry.getKey());
//                System.out.print("  ");
//                System.out.println(entry.getValue());
//            }
//            System.out.println("--------------");
            out_inst.put(inst, new_out);
        }
        Set<String> is_constant=new HashSet<>();
        for(Map.Entry<String,ConstPropValueHolder> entry:constpropinit.entrySet()){
            is_constant.add(entry.getKey());
        }
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                    for(Map.Entry<String,ConstPropValueHolder> entry:out_inst.get(inst).entrySet()){
                        if(entry.getValue().getKind()== ConstPropValueHolder.Kind.NAC) is_constant.remove(entry.getKey());
                    }
                }
            }
        }
//        for(String x:is_constant) System.out.println(x);
        Set<LLVMValueRef> inst_to_delete=new HashSet<>();
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                Set<String> has_store_variable=new HashSet<>();
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null;inst=LLVM.LLVMGetNextInstruction(inst)) {
                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                    String lhs;
                    if(LLVM.LLVMGetValueName(inst)!=null) lhs = LLVM.LLVMGetValueName(inst).getString();
                    else lhs=null;
                    if (lhs != null && !lhs.isEmpty() && is_constant.contains(lhs)&&opcode!=LLVM.LLVMAlloca) {
                        int numOperands = LLVM.LLVMGetNumOperands(inst);
                        for (int i = 0; i < numOperands; i++) {
                            LLVMValueRef zero = LLVM.LLVMConstNull(LLVM.LLVMTypeOf(LLVM.LLVMGetOperand(inst, i)));
                            LLVM.LLVMSetOperand(inst, i, zero);
                        }
                        inst_to_delete.add(inst);
                    }
                    else if(opcode==LLVM.LLVMStore){
                        String dest = LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 1)).getString();
                        if(is_constant.contains(dest)) {
                            if (!has_store_variable.contains(dest)) {
                                has_store_variable.add(dest);
                                LLVMValueRef constInst = LLVMConstInt(LLVM.LLVMTypeOf(LLVM.LLVMGetOperand(inst, 0)), out_inst.get(inst).get(dest).getIntValue(), 0);
                                LLVM.LLVMSetOperand(inst, 0, constInst);
                            }
                            else inst_to_delete.add(inst);
                        }
                        else{
                            if(LLVM.LLVMIsConstant(LLVM.LLVMGetOperand(inst, 0))==0&&is_constant.contains(LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 0)).getString())){
                                LLVMValueRef constInst = LLVMConstInt(LLVM.LLVMTypeOf(LLVM.LLVMGetOperand(inst, 0)), out_inst.get(inst).get(LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 0)).getString()).getIntValue(), 0);
                                LLVM.LLVMSetOperand(inst, 0, constInst);
                            }
                        }
                    }
                    else if(opcode==LLVM.LLVMRet){
                        LLVMValueRef retVal = LLVM.LLVMGetOperand(inst, 0);
                        if(LLVM.LLVMGetValueName(retVal)!=null&&is_constant.contains(LLVM.LLVMGetValueName(retVal).getString())){
                            LLVMValueRef constInst = LLVMConstInt(LLVM.LLVMTypeOf(retVal), out_inst.get(inst).get(LLVM.LLVMGetValueName(retVal).getString()).getIntValue(), 0);
                            LLVM.LLVMSetOperand(inst, 0, constInst);
                        }
                    }
                    else if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                                    opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                                    opcode == LLVM.LLVMSRem || opcode == LLVM.LLVMURem ||
                                    opcode == LLVM.LLVMUDiv||opcode == LLVM.LLVMICmp || opcode == LLVM.LLVMZExt) {
                        int numOperands = LLVM.LLVMGetNumOperands(inst);
                        for (int i = 0; i < numOperands; i++) {
                            LLVMValueRef op = LLVM.LLVMGetOperand(inst, i);
                            if (LLVM.LLVMGetValueName(op)!=null&&is_constant.contains(LLVM.LLVMGetValueName(op).getString())) {
                                int value = out_inst.get(inst).get(LLVM.LLVMGetValueName(op).getString()).getIntValue();
                                LLVMValueRef constOp = LLVMConstInt(LLVM.LLVMTypeOf(op), value, 0);
                                LLVM.LLVMSetOperand(inst, i, constOp);
                            }
                        }
                    }
                    else if (opcode == LLVM.LLVMBr) {
                        if (LLVM.LLVMIsConditional(inst) != 0) { // 条件跳转
                            LLVMValueRef cond = LLVM.LLVMGetOperand(inst, 0);
                            if (LLVM.LLVMGetValueName(cond)!=null&&is_constant.contains(LLVM.LLVMGetValueName(cond).getString())) {
                                int value = out_inst.get(inst).get(LLVM.LLVMGetValueName(cond).getString()).getIntValue();
                                LLVMValueRef constCond = LLVMConstInt(LLVM.LLVMTypeOf(cond), value, 0);
                                LLVM.LLVMSetOperand(inst, 0, constCond);
                            }
                        }
                    }
                }
            }
        }
        for(LLVMValueRef x:inst_to_delete) {
            //System.out.println(LLVM.LLVMPrintValueToString(x).getString());
            LLVM.LLVMInstructionEraseFromParent(x);
        }
        //System.out.println("end");
    }
    public void elem_unused(){
        Set<LLVMValueRef> allInstrs = new HashSet<>();
        Set<LLVMValueRef> usedInstrs = new HashSet<>();
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null && !inst.isNull(); inst = LLVM.LLVMGetNextInstruction(inst)) {
                    allInstrs.add(inst);
                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                    if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                            opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                            opcode == LLVM.LLVMSRem || opcode == LLVM.LLVMURem ||
                            opcode == LLVM.LLVMUDiv||opcode == LLVM.LLVMICmp || opcode == LLVM.LLVMZExt||opcode == LLVM.LLVMLoad||opcode== LLVMRet) {
                        int numOperands = LLVM.LLVMGetNumOperands(inst);
                        for (int i = 0; i < numOperands; i++) {
                            LLVMValueRef operand = LLVM.LLVMGetOperand(inst, i);
                            if (operand != null && !operand.isNull()) {
                                if (!LLVMGetValueName(operand).getString().isEmpty()) usedInstrs.add(operand);
                            }
                        }
                    }
                    else if(opcode==LLVM.LLVMStore||(opcode==LLVM.LLVMBr&&LLVM.LLVMGetNumOperands(inst)==1)){
                        for (int i = 0; i<1; i++) {
                            LLVMValueRef operand = LLVM.LLVMGetOperand(inst, i);
                            if (operand != null && !operand.isNull()) {
                                if (!LLVMGetValueName(operand).getString().isEmpty()) usedInstrs.add(operand);
                            }
                        }
                    }
                }
            }
        }
        for (LLVMValueRef instr : allInstrs) {
            boolean shouldKeep = false;
            if (usedInstrs.contains(instr)) {
                shouldKeep = true;
            }
            int numOperands = LLVM.LLVMGetNumOperands(instr);
            for (int i = 0; i < numOperands && !shouldKeep; i++) {
                LLVMValueRef operand = LLVM.LLVMGetOperand(instr, i);
                if (operand != null && !operand.isNull() && usedInstrs.contains(operand)) {
                    shouldKeep = true;
                }
            }
            if (!shouldKeep) {
                int opcode = LLVM.LLVMGetInstructionOpcode(instr);
                if (opcode != LLVM.LLVMRet &&
                        opcode != LLVM.LLVMBr &&
                        opcode != LLVM.LLVMSwitch &&
                        opcode != LLVM.LLVMUnreachable) {
                    LLVM.LLVMInstructionEraseFromParent(instr);
                }
            }
        }
    }
    public boolean remove_redundant_block(){
        boolean remove=false;
        List<LLVMBasicBlockRef> delete_block=new ArrayList<>();
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                LLVMValueRef first_inst= LLVM.LLVMGetFirstInstruction(bb);
                boolean is_isolated_block=true;
                if(predecessor.get(first_inst)==null) is_isolated_block=true;
                else{
                    for(LLVMValueRef x:predecessor.get(first_inst)){
                        if(x!=null) is_isolated_block=false;
                    }
                }
                if(!LLVMBasicBlockAsValue(bb).equals(LLVMBasicBlockAsValue(LLVMGetEntryBasicBlock(func)))&& is_isolated_block){
                    remove=true;
                    delete_block.add(bb);
                }
            }
        }
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                LLVMValueRef first_inst=LLVM.LLVMGetFirstInstruction(bb);
                Set<LLVMValueRef> x=predecessor.get(first_inst);
                List<LLVMValueRef> toRemove = new ArrayList<>();
                for(LLVMValueRef pred : x) {
                    if(pred==null) continue;
                    if(delete_block.contains(LLVMGetInstructionParent(pred))) {
                        toRemove.add(pred);
                    }
                }
                for(LLVMValueRef z:toRemove) x.remove(z);
            }
        }
        for(LLVMBasicBlockRef x:delete_block){
            for(LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(x); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)){
                predecessor.remove(inst);
                successor.remove(inst);
            }
            LLVMRemoveBasicBlockFromParent(x);
        }
//        for(Map.Entry<LLVMValueRef,Set<LLVMValueRef>> entry:predecessor.entrySet()){
//            System.out.println(LLVMPrintValueToString(entry.getKey()).getString());
//            for(LLVMValueRef x:(entry.getValue())){
//                System.out.println(LLVMPrintValueToString(x).getString());
//            }
//            System.out.println("-------------");
//        }
//        System.out.println("end of predecessor check");
         boolean flag=merge_block();
        return remove||flag;
    }
    public void append_inst(LLVMBasicBlockRef dest,LLVMBasicBlockRef src){
        LLVMValueRef last_inst = LLVM.LLVMGetLastInstruction(dest);
        LLVMValueRef first_inst=LLVM.LLVMGetFirstInstruction(src);
        System.out.println(LLVMPrintValueToString(last_inst).getString());
        System.out.println(LLVMPrintValueToString(first_inst).getString());
        System.out.println("----------");
        Set<LLVMValueRef> x=predecessor.get(last_inst);
        for(LLVMValueRef stmt:x){
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
        for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(src); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)){
            LLVMInstructionRemoveFromParent(inst);
            LLVMInsertIntoBuilder(builder, inst);
        }
        LLVMRemoveBasicBlockFromParent(src);
                for(Map.Entry<LLVMValueRef,Set<LLVMValueRef>> entry:predecessor.entrySet()){
            System.out.println(LLVMPrintValueToString(entry.getKey()).getString());
            for(LLVMValueRef x:(entry.getValue())){
                System.out.println(LLVMPrintValueToString(x).getString());
            }
            System.out.println("-------------");
        }
        System.out.println("end of predecessor check");
    }
    public boolean merge_block(){
       for(Map.Entry<LLVMValueRef,Set<LLVMValueRef>> entry:successor.entrySet()){
           entry.getValue().removeIf(Objects::isNull);
       }
        for(Map.Entry<LLVMValueRef,Set<LLVMValueRef>> entry:predecessor.entrySet()){
            entry.getValue().removeIf(Objects::isNull);
        }
        boolean flag=false;
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                LLVMValueRef last_inst = LLVM.LLVMGetLastInstruction(bb);
                if(successor.get(last_inst).size()==1){
                    for(LLVMValueRef entry:successor.get(last_inst)){
                        if(!LLVMBasicBlockAsValue(bb).equals(LLVMBasicBlockAsValue(LLVMGetInstructionParent(entry)))&&predecessor.get(entry).size()==1) {
                            append_inst(bb,LLVMGetInstructionParent(entry));
                            flag=true;
                        }
                    }
                }
                if(flag) break;
            }
        }
        return flag;
    }
    public void elem_dead_code(){
        buildgraph();
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null && !func.isNull(); func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null && !inst.isNull();) {
                    LLVMValueRef next = LLVM.LLVMGetNextInstruction(inst);  // 保存下一条指令指针
                    int opcode = LLVM.LLVMGetInstructionOpcode(inst);
                    if(opcode==LLVM.LLVMBr){
                        int numOperands = LLVM.LLVMGetNumOperands(inst);
                        if(numOperands==3){
                            LLVMValueRef cond = LLVM.LLVMGetOperand(inst, 0);
                            LLVMValueRef ifFalse = LLVM.LLVMGetOperand(inst, 1);
                            LLVMValueRef ifTrue = LLVM.LLVMGetOperand(inst, 2);
                            if (LLVM.LLVMIsAConstantInt(cond) != null) {
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
        }
        cleanUnreachableBlocks();
        buildgraph();
        while(remove_redundant_block());
    }
    public void cleanUnreachableBlocks() {
        Set<LLVMBasicBlockRef> unreachableBlocks = new HashSet<>();
        for (LLVMValueRef function = LLVMGetFirstFunction(module);
             function != null; function = LLVMGetNextFunction(function)) {
            for (LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(function);
                 block != null;
                 block = LLVMGetNextBasicBlock(block)) {

                LLVMValueRef terminator = LLVMGetBasicBlockTerminator(block);
                if (terminator != null && LLVMGetInstructionOpcode(terminator) == LLVMUnreachable) {
                    unreachableBlocks.add(block);
                }
            }
        }
        for (LLVMValueRef function = LLVMGetFirstFunction(module); function != null; function = LLVMGetNextFunction(function)) {
            for (LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(function); block != null; block = LLVMGetNextBasicBlock(block)) {
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
        }
        for (LLVMValueRef function = LLVMGetFirstFunction(module);
             function != null;
             function = LLVMGetNextFunction(function)) {

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
}
