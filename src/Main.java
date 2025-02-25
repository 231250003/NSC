import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
public class Main {

    public static void main(String[] args) {
        String filePath = args[0];
        try {
            // 读取整个文件并按行输出
            Files.lines(Paths.get(filePath), StandardCharsets.UTF_8)
                    .forEach(System.out::println);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
