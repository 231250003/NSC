import com.sun.jdi.Value;
import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;
import org.bytedeco.llvm.LLVM.LLVMModuleRef;
import org.bytedeco.llvm.LLVM.LLVMValueRef;
import org.bytedeco.llvm.global.LLVM;

import java.util.*;

public class LLVMIROptimization {
    LLVMModuleRef module;
    public Map<LLVMValueRef, Set<LLVMValueRef>> predecessor = new HashMap<>();
    public Map<LLVMValueRef, Set<LLVMValueRef>> successor = new HashMap<>();
    public Map<String, LLVMBasicBlockRef> name2blockref = new HashMap<>();
    public Map<String, ConstPropValueHolder> constpropinit = new HashMap<>();

    public LLVMIROptimization(LLVMModuleRef module) {
        this.module = module;
        buildgraph();
    }

    public void buildgraph() {
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
                    if (inst != LLVM.LLVMGetFirstInstruction(bb))
                        predecessor.get(inst).add(LLVM.LLVMGetPreviousInstruction(inst));
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
                    } else if (line.contains("ret")) successor.put(inst, new HashSet<>());
                    if (line.contains("br")) {
                        if (line.contains(".")) line = line.substring(0, line.indexOf(","));
                        else continue;
                    }
                    for (String var : LLVMIRToRiscv.extractVariables(line)) {
                        if (constpropinit.get(var) == null) constpropinit.put(var, ConstPropValueHolder.UNDEF);
                    }
                }
            }
        }
    }

    public void constprop() {
        buildgraph();
        Map<LLVMValueRef, Map<String, ConstPropValueHolder>> in_inst = new HashMap<>();
        Map<LLVMValueRef, Map<String, ConstPropValueHolder>> out_inst = new HashMap<>();
        Set<LLVMValueRef> worklist = new HashSet<>();
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
            Map<String, ConstPropValueHolder> new_out = new HashMap<>(old_out);
            for (LLVMValueRef x : predecessor.get(inst)) {
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
            int opcode = LLVM.LLVMGetInstructionOpcode(inst);
             if (opcode == LLVM.LLVMLoad) {
                String src = LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 0)).getString();
                String dest = LLVM.LLVMGetValueName(inst).getString();
                new_out.put(dest, new ConstPropValueHolder(in_inst.get(inst).get(src)));
            } else if (opcode == LLVM.LLVMStore) {
                String src = LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 0)).getString();
                String dest = LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 1)).getString();
                new_out.put(dest, new ConstPropValueHolder(in_inst.get(inst).get(src)));
            } else if (opcode == LLVM.LLVMAdd || opcode == LLVM.LLVMSub ||
                    opcode == LLVM.LLVMMul || opcode == LLVM.LLVMSDiv ||
                    opcode == LLVM.LLVMSRem || opcode == LLVM.LLVMURem || opcode == LLVM.LLVMUDiv) {
                String src1 = LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 0)).getString();
                String src2 = LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 1)).getString();
                String dest = LLVM.LLVMGetValueName(inst).getString();
                if (in_inst.get(inst).get(src1).getKind() == ConstPropValueHolder.Kind.INT && in_inst.get(inst).get(src2).getKind() == ConstPropValueHolder.Kind.INT) {
                    Integer x1 = in_inst.get(inst).get(src1).getIntValue();
                    Integer x2 = in_inst.get(inst).get(src2).getIntValue();
                    Integer dest_val=0;
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
                    new_out.put(dest,ConstPropValueHolder.ofInt(dest_val));
                }
                else if(in_inst.get(inst).get(src1).getKind() == ConstPropValueHolder.Kind.NAC || in_inst.get(inst).get(src2).getKind() == ConstPropValueHolder.Kind.NAC){
                    new_out.put(dest,ConstPropValueHolder.NAC);
                }
                else  new_out.put(dest,ConstPropValueHolder.UNDEF);
            }
            else if (opcode == LLVM.LLVMICmp) {
                String src1 = LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 0)).getString();
                String src2 = LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 1)).getString();
                String dest = LLVM.LLVMGetValueName(inst).getString();

                if (in_inst.get(inst).get(src1).getKind() == ConstPropValueHolder.Kind.INT &&
                        in_inst.get(inst).get(src2).getKind() == ConstPropValueHolder.Kind.INT) {
                    int x1 = in_inst.get(inst).get(src1).getIntValue();
                    int x2 = in_inst.get(inst).get(src2).getIntValue();
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
                } else if (in_inst.get(inst).get(src1).getKind() == ConstPropValueHolder.Kind.NAC ||
                        in_inst.get(inst).get(src2).getKind() == ConstPropValueHolder.Kind.NAC) {
                    new_out.put(dest, ConstPropValueHolder.NAC);
                } else {
                    new_out.put(dest, ConstPropValueHolder.UNDEF);
                }
            }
            else if (opcode == LLVM.LLVMZExt) {
                String src = LLVM.LLVMGetValueName(LLVM.LLVMGetOperand(inst, 0)).getString();
                String dest = LLVM.LLVMGetValueName(inst).getString();

                if (in_inst.get(inst).get(src).getKind() == ConstPropValueHolder.Kind.INT) {
                    int val = in_inst.get(inst).get(src).getIntValue();
                    int zext_val = val & 0xFFFFFFFF;
                    new_out.put(dest, ConstPropValueHolder.ofInt(zext_val));
                } else if (in_inst.get(inst).get(src).getKind() == ConstPropValueHolder.Kind.NAC) {
                    new_out.put(dest, ConstPropValueHolder.NAC);
                } else {
                    new_out.put(dest, ConstPropValueHolder.UNDEF);
                }
            }
            boolean state_changed=false;
            for (String key : old_out.keySet()) {
                ConstPropValueHolder v1 = old_out.get(key);
                ConstPropValueHolder v2 = new_out.get(key);
                if(v1.getKind()!=v2.getKind())state_changed=true;
                else if(v1.getKind()==ConstPropValueHolder.Kind.INT&&v1.getIntValue().equals(v2.getIntValue())) state_changed=true;
            }
            if(state_changed){
                Set<LLVMValueRef> succs = successor.get(inst);
                if (succs != null) {
                    for (LLVMValueRef x : succs) {
                        worklist.add(x);
                    }
                }
            }
        }
    }
}
