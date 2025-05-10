import java.io.FileWriter;
import java.io.IOException;

public class AsmBuilder {
    private final StringBuilder dataSegment = new StringBuilder();
    private final StringBuilder textSegment = new StringBuilder();
    private StringBuilder current = textSegment;  // 默认在 text 段
    public void switchToText() {
        current = textSegment;
    }

    public void switchToData() {
        current = dataSegment;
    }

    public void directive(String dir) {
        current.append("  .").append(dir).append("\n");
    }

    public void label(String label) {
        current.append(label).append(":\n");
    }

    public void comment(String comment) {
        current.append("  # ").append(comment).append("\n");
    }

    public void instr(String op, String... args) {
        boolean flag=false;
//        if(op.equals("lw")){
//            flag=true;
//            String dest = args[0];
//            String addr = args[1];
//            int parenIndex = addr.indexOf('(');
//            String offset = addr.substring(0, parenIndex).trim();
//            String base = addr.substring(parenIndex + 1, addr.length() - 1).trim();
//            op = "LOAD_WORD(";
//            args = new String[]{dest, base, offset};
//        }
//        if(op.equals("sw")&&Main.used_interpreter&&Main.is_run_time_error_test){
//            double randomValue = Math.random();
//            if(randomValue>=0.4) return;
//        }
        if(op.equals("sw")){
            String addr=args[1];
            LLVMIRToRiscv.is_offset_init.put(Integer.parseInt(addr.substring(0,addr.indexOf("("))),true);
        }
        else if(op.equals("lw")){
            String addr=args[1];
            int offset=Integer.parseInt(addr.substring(0,addr.indexOf("(")));
            System.out.println(addr);
            if(offset!=0&&LLVMIRToRiscv.is_offset_init.get(offset)==false){
                current.append("  "+"sw"+"  "+"x0,"+"  "+addr);
                current.append("\n");
            }
        }
        current.append("  ").append(op);
        if (args.length > 0) {
             current.append(" ").append(String.join(", ", args));
        }
        if(flag)current.append(")");
        current.append("\n");
    }

    public void li(String dest, long imm) {
        instr("li", dest, String.valueOf(imm));
    }

    public void mv(String dest, String src) {
        instr("mv", dest, src);
    }

    public void ret() {
        instr("ret");
    }

    public void op2(String op, String dest, String lhs, String rhs) {
        instr(op, dest, lhs, rhs);
    }

    public void word(String label, long value) {
        label(label);
        instr(".word", String.valueOf(value));
    }
    public void seqz(String dest, String src) {
        instr("seqz", dest, src);
    }

    public void snez(String dest, String src) {
        instr("snez", dest, src);
    }

    public void slt(String dest, String lhs, String rhs) {
        instr("slt", dest, lhs, rhs);
    }

    public void sgt(String dest, String lhs, String rhs) {
        instr("sgt", dest, lhs, rhs);
    }
    public void j(String label) {
        instr("j", label);
    }
    public void bnez(String reg, String label) {
        instr("bnez", reg, label);
    }
//    public void macro() {
//        String macroDef =".macro LOAD_WORD(%rd, %rs, %imm)\n" +
//                "    lw %rd, %imm(%rs) \n"+".end_macro\n";
//        textSegment.insert(0, macroDef);
//    }
    public void writeToFile(String filePath) {
        try (FileWriter fw = new FileWriter(filePath)) {
            fw.write(dataSegment.toString());
            fw.write("\n");
            fw.write(textSegment.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
