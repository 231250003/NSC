import java.io.FileWriter;
import java.io.IOException;
public class AsmBuilder {
    private final StringBuilder dataSegment = new StringBuilder();
    private final StringBuilder textSegment = new StringBuilder();
    private StringBuilder current = textSegment;  // 默认在 text 段
    public void switchToText() {
        current = textSegment;
        current.append(".text\n");
    }

    public void switchToData() {
        current = dataSegment;
        current.append(".data\n");
    }

    public void directive(String name, String... args) {
        current.append("."+name);
        for (String arg : args) current.append(" " + arg);
        current.append("\n");
    }

    public void label(String label) {
        current.append(label).append(":\n");
    }

    public void comment(String comment) {
        current.append("  # ").append(comment).append("\n");
    }

    public void instr(String op, String... args) {
        current.append("  ").append(op);
        if (args.length > 0) {
             current.append(" ").append(String.join(", ", args));
        }
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
    public void op2(String op, String dest, String lhs, Integer rhs) {
        instr(op, dest, lhs, String.valueOf(rhs));
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
    public void add_blank_line(){
        current.append("\n");
    }
}
