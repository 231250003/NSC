  
public class OutputHelper {
    public static boolean is_semantic_correct=true;
    public static void printSemanticError(ErrorType errorType, int line) {
        is_semantic_correct=false;
        System.err.printf("Error type %d at Line %d:%s\n", errorType.getErrorCode(), line,errorType.getMessage());
    }
}