import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;
import org.bytedeco.llvm.LLVM.LLVMModuleRef;
import org.bytedeco.llvm.LLVM.LLVMValueRef;
import org.bytedeco.llvm.global.LLVM;

import java.security.Key;
import java.util.*;

class NewControlFlowRegisterAllocator implements RegisterAllocator{

    private static final Map<String, Interval> varToInterval=new HashMap<>();
    private static List<String> total_registers;
    private static List<String> freed_register;
    private static  Map<String, String> varToLocation = new HashMap<>();
    private static final Map<String, Integer> varOffset = new HashMap<>();
    private static  Set<String> changed_variable=new HashSet<>();
    private static int nextOffset = 0;
    private static LLVMModuleRef module;
    private static Set<String> live_variable=new HashSet<>();
    private static Set<String> visited_block=new HashSet<>();
    private static Map<String,Set<String>> variable_def_in_block=new HashMap<>();
    private static Map<String,Set<String>> variable_use_in_block=new HashMap<>();
    private static Map<String,LLVMBasicBlockRef> name2blockref=new HashMap<>();
    public NewControlFlowRegisterAllocator(LLVMModuleRef moduleRef,List<String> reg_list){
        this.module=moduleRef;
        total_registers=new ArrayList<>(reg_list);
        freed_register=new ArrayList<>(reg_list);
    }
    public static void init() {
        for (LLVMValueRef func = LLVM.LLVMGetFirstFunction(module); func != null; func = LLVM.LLVMGetNextFunction(func)) {
            for (LLVMBasicBlockRef bb = LLVM.LLVMGetFirstBasicBlock(func); bb != null && !bb.isNull(); bb = LLVM.LLVMGetNextBasicBlock(bb)) {
                variable_def_in_block.put(LLVM.LLVMGetBasicBlockName(bb).getString(), new HashSet<>());
                variable_use_in_block.put(LLVM.LLVMGetBasicBlockName(bb).getString(), new HashSet<>());
                name2blockref.put(LLVM.LLVMGetBasicBlockName(bb).getString(),bb);
                for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
                    String line = LLVM.LLVMPrintValueToString(inst).getString();
                    if (line.contains("br")||line.contains("alloca")) continue;
                    for (String var : LLVMIRToRiscv.extractVariables(line)) {
                        if(!varOffset.containsKey(var)){
                            nextOffset += 4;
                            varOffset.put(var, nextOffset);
                        }
                    }
                    String line3;
                    if(line.contains("=")) line3= line.substring(line.indexOf("=")+1);
                    else if(line.contains("store")&&line.contains("i32* %")) {
                        line3= line.substring(0,line.indexOf(","));
                    }
                    else line3=line;
                    for (String var : LLVMIRToRiscv.extractVariables(line3)){
                        Set<String> variables=variable_use_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString());
                        if(!variable_def_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString()).contains(var)) {
                            variables.add(var);
                        }
                    }
                    if(line.contains("=")||(line.contains("store")&&line.contains("i32* %"))){
                        String line2;
                        if(line.contains("="))line2 = line.substring(0, line.indexOf("="));
                        else line2=line.substring(line.indexOf(",")+1);
                        for (String var : LLVMIRToRiscv.extractVariables(line2)) {
                            Set<String> variables=variable_def_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString());
                            if(!variable_use_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString()).contains(var)) {
                                variables.add(var);
                            }
                            break;
                        }
                    }
                }
            }
        }
    }
    public static boolean is_live_variable(LLVMBasicBlockRef bb,String var,boolean is_detecting_block){
        if(var.equals("b")) System.out.println("crzzzzssdsds");
        if(visited_block.contains((LLVM.LLVMGetBasicBlockName(bb).getString()))){
            if(variable_use_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString()).contains(var)) return true;
            else return false;
        }
        else if(variable_use_in_block.get(LLVM.LLVMGetBasicBlockName(bb).getString()).contains(var)&&is_detecting_block==false) {
            return true;
        }
        else{
            visited_block.add((LLVM.LLVMGetBasicBlockName(bb).getString()));
            for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)){
                String line = LLVM.LLVMPrintValueToString(inst).getString();
                if(line.contains("br")&&(!line.contains(","))) {
                    for (String block_name : LLVMIRToRiscv.extractVariables(line)) {
                        LLVMBasicBlockRef next_block=name2blockref.get(block_name);
                        return is_live_variable(next_block,var,false);
                    }
                }
                else if(line.contains("br")&&line.contains(",")){
                    line = line.substring(line.indexOf(",")+1);
                    for (String block_name : LLVMIRToRiscv.extractVariables(line)) {
                        LLVMBasicBlockRef next_block=name2blockref.get(block_name);
                        if(is_live_variable(next_block,var,false))return true;
                    }
                }
            }
            return false;
        }
    }
    public static void preprocess_block(LLVMBasicBlockRef bb){
        Map<String, Integer> firstUse = new HashMap<>();
        Map<String, Integer> lastUse = new HashMap<>();
        Map<String,Integer> used_num=new HashMap<>();
        int lineNum=0;
        for (LLVMValueRef inst = LLVM.LLVMGetFirstInstruction(bb); inst != null; inst = LLVM.LLVMGetNextInstruction(inst)) {
            String line = LLVM.LLVMPrintValueToString(inst).getString();
            if (line.contains("br") && !line.contains(",")) {
                lineNum++;
                continue;
            }
            else if (line.contains("br") && line.contains(",")) line = line.substring(0, line.indexOf(","));
            for (String var : LLVMIRToRiscv.extractVariables(line)) {
                firstUse.putIfAbsent(var, lineNum);
                lastUse.put(var, lineNum);
                used_num.put(var, used_num.getOrDefault(var, 0) + 1);
            }
            if(line.contains("=") || (line.contains("store")&&line.contains("i32* %"))){
                String line2;
                if(line.contains("="))line2 = line.substring(0, line.indexOf("="));
                else line2=line.substring(line.indexOf(",")+1);
                for (String var : LLVMIRToRiscv.extractVariables(line2)) {
                    if(var.equals("b")) System.out.println("crzzz");
                    if(is_live_variable(bb,var,true)) {
                        System.out.println(LLVM.LLVMGetBasicBlockName(bb).getString());
                        if(var.equals("b")) System.out.println("crzz1");
                        live_variable.add(var);
                        visited_block=new HashSet<>();
                    }
                    break;
                }
            }
            lineNum++;
        }
        List<Interval> intervals = new ArrayList<>();
        for (String var : firstUse.keySet()) {
            intervals.add(new Interval(var, firstUse.get(var), lastUse.get(var),used_num.get(var)));
        }
        for (Interval interval : intervals) {
            varToInterval.put(interval.varName, interval);
        }
    }
    public  void processInstruction(int lineNumber, String instruction) {
        expireOldIntervals(lineNumber);
        Map<String,Integer> used_reg_list=new HashMap<>();
        Set<String> vars=LLVMIRToRiscv.extractVariables(instruction);
        if(instruction.contains("=")) {
            String instruction2 = instruction.substring(0, instruction.indexOf("="));
            for (String var : LLVMIRToRiscv.extractVariables(instruction2)) {
                changed_variable.add(var);
                break;
            }
        }
        else if(instruction.contains("store")&&instruction.contains("i32* %")) {
            String instruction2 = instruction.substring(instruction.indexOf(",")+1);
            for (String var : LLVMIRToRiscv.extractVariables(instruction2)) {
                changed_variable.add(var);
                break;
            }
        }
        for (String var : vars) {
            Interval interval = varToInterval.get(var);
            if (interval == null || varToLocation.containsKey(var)) continue;
            if (!freed_register.isEmpty()&&(!instruction.contains("br")) &&(!instruction.contains("ret"))) {
                String reg = freed_register.remove(0);
                varToLocation.put(var, reg);
            } else if(instruction.contains("br")||instruction.contains("ret")){
                varToLocation.put(var, String.format("%d(sp)", varOffset.get(var)));
                LLVMIRToRiscv.valueMap.put(var,varToLocation.get(var));
            }
            else{
                int var_end_line=interval.end;
                String spill_reg="";
                String var_spill_name=var;
                for (Map.Entry<String, Interval> entry : varToInterval.entrySet()) {
                    String key = entry.getKey();
                    Interval value = entry.getValue();
                    if(varToLocation.get(key)!=null&&(!varToLocation.get(key).contains("sp"))&&value.end>var_end_line&&used_reg_list.get(varToLocation.get(key))==null){
                        spill_reg=varToLocation.get(key);
                        var_end_line=value.end;
                        var_spill_name=key;
                    }
                }
                if(!spill_reg.isEmpty()){
                    varToLocation.put(var_spill_name, String.format("%d(sp)", varOffset.get(var_spill_name)));
                    LLVMIRToRiscv.valueMap.put(var_spill_name,varToLocation.get(var_spill_name));
                    LLVMIRToRiscv.asm.instr("sw",spill_reg,varToLocation.get(var_spill_name));
                    used_reg_list.put(spill_reg,1);
                    if (varOffset.containsKey(var)) {
                        LLVMIRToRiscv.asm.instr("lw", spill_reg, String.format("%d(sp)", varOffset.get(var)));
                    }
                    varToLocation.put(var,spill_reg);
                    LLVMIRToRiscv.valueMap.put(var,spill_reg);
                }
                else
                {
                    varToLocation.put(var, String.format("%d(sp)", varOffset.get(var)));
                    LLVMIRToRiscv.valueMap.put(var,varToLocation.get(var));
                }
            }
        }
    }

    public void expireOldIntervals(int currentLine) {
        for (Map.Entry<String, Interval> entry : varToInterval.entrySet()) {
            String var = entry.getKey();
            Interval interval = entry.getValue();
            if(currentLine>interval.end && varToLocation.containsKey(var)&&(!varToLocation.get(var).contains("sp"))) {
                freed_register.add(varToLocation.get(var));
                if(changed_variable.contains(var)&&live_variable.contains(var)) LLVMIRToRiscv.asm.instr("sw",varToLocation.get(var),String.format("%d(sp)", varOffset.get(var)));
                varToLocation.remove(var);
                varToLocation.put(var,String.format("%d(sp)", varOffset.get(var)));
            }
        }
    }
    public static void post_process_block(String inst){
//        if((inst.contains("br")&&inst.contains(","))||inst.contains("ret")){
//            if(inst.contains("br")&&inst.contains(","))inst = inst.substring(0, inst.indexOf(","));
//            for (String var : LLVMIRToRiscv.extractVariables(inst)){
//                if(varToLocation.containsKey(var)&&(!varToLocation.get(var).contains("sp"))){
//                    LLVMIRToRiscv.valueMap.put(var,String.format("%d(sp)", varOffset.get(var)));
//                    LLVMIRToRiscv.asm.instr("sw",varToLocation.get(var),String.format("%d(sp)", varOffset.get(var)));
//                    break;
//                }
//            }
//        }
        for (Map.Entry<String, String> entry : varToLocation.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
           if(changed_variable.contains(key)&& (!value.contains("sp"))&&live_variable.contains(key)){
               LLVMIRToRiscv.valueMap.put(key,String.format("%d(sp)", varOffset.get(key)));
               LLVMIRToRiscv.asm.instr("sw",varToLocation.get(key),String.format("%d(sp)", varOffset.get(key)));
           }
        }
        for (Map.Entry<String, String> entry : LLVMIRToRiscv.valueMap.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            if(!value.contains("sp")){
                LLVMIRToRiscv.valueMap.put(key,String.format("%d(sp)", varOffset.get(key)));
            }
        }
        if(inst.isEmpty()) {
            varToLocation = new HashMap<>();
            changed_variable = new HashSet<>();
            freed_register = new ArrayList<>(total_registers);
            live_variable = new HashSet<>();
        }
    }
    @Override
    public String allocate(String varName) {
        return varToLocation.get(varName);
    }

    @Override
    public int getStackSize() {
        return nextOffset;
    }
}
