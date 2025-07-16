package  com.example;
import org.antlr.v4.runtime.*;

import java.util.ArrayList;
import java.util.List;

public class MyErrorListener extends BaseErrorListener{
    private List<String> errors=new ArrayList<>();
    public errorType type;
    public MyErrorListener(errorType type) {
        this.type = type;
    }
    public void syntaxError(Recognizer<?, ?> recognizer,
                            Object offendingSymbol,
                            int line, int charPositionInLine,
                            String msg,
                            RecognitionException e){
        String x="";
        if(type==errorType.LEXER_ERROR) {
            x = String.format("lexer error at Line %d: %s", line, msg);
        }
        else if(type==errorType.SYNTAX_ERROR){
                x = String.format("Syntax Error at Line %d: %s", line, msg);
        }
        errors.add(x);
    }
    public boolean hasErrorInformation(){
        if(errors.isEmpty()){
            return false;
        }
        else return true;
    }
    public void printErrorInformation(){
        for(String error:errors){
            System.out.println(error);
        }
    }
}
