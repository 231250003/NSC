import com.example.Main;
import org.junit.jupiter.api.Test;
import java.io.File;
import java.io.IOException;
public class TestAllFile {
    @Test
    public void testAllSysyFiles() throws IOException {
        File inputDir = new File("tests/develop_test");
        File[] files = inputDir.listFiles((dir, name) -> name.endsWith(".sysy"));

        if (files == null || files.length == 0) {
            throw new IOException("No .sysy files found in " + inputDir.getPath());
        }
        for (File sysyFile : files) {
            String inputPath = sysyFile.getPath();
            String outputPath = inputPath.replace(".sysy", ".ll");
            System.out.println("Running test case: " + inputPath);
            String[] args = {inputPath, outputPath};
            Main.main(args);
        }
    }
    @Test
    public void testAllSysyFiles2() throws IOException{
        File inputDir=new File("tests/IR_generate_test");
        File[] files = inputDir.listFiles((dir, name) -> name.endsWith(".sysy"));
        if (files == null || files.length == 0) {
            throw new IOException("No .sysy files found in " + inputDir.getPath());
        }
        for (File sysyFile : files) {
            String inputPath = sysyFile.getPath();
            String outputPath = inputPath.replace(".sysy", ".ll");
            System.out.println("Running test case: " + inputPath);
            String[] args = {inputPath, outputPath};
            Main.main(args);
        }
    }
}
