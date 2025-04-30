import java.io.FileWriter;
import java.io.IOException;

public class AsmBuilder {
    private final StringBuilder buffer = new StringBuilder();

    public void directive(String dir) {
        buffer.append("  .").append(dir).append("\n");
    }

    public void label(String label) {
        buffer.append(label).append(":\n");
    }

    public void comment(String comment) {
        buffer.append("  # ").append(comment).append("\n");
    }

    public void instr(String op, String... args) {
        buffer.append("  ").append(op);
        if (args.length > 0) {
            buffer.append(" ").append(String.join(", ", args));
        }
        buffer.append("\n");
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

    public void writeToFile(String filePath) {
        try (FileWriter fw = new FileWriter(filePath)) {
            fw.write(buffer.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
