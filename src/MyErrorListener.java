import org.antlr.v4.runtime.*;

import java.util.ArrayList;
import java.util.List;

public class MyErrorListener extends BaseErrorListener{
    private List<String> errors=new ArrayList<>();
    private int type; // 1代表词法，2代表语法
    public MyErrorListener(int type) {
        this.type = type;
    }
    public void syntaxError(Recognizer<?, ?> recognizer,
                            Object offendingSymbol,
                            int line, int charPositionInLine,
                            String msg,
                            RecognitionException e){
        String x;
        if(type==1) {
            x = String.format("Error type A at Line %d: %s", line, msg);
        }
        else {
                x = String.format("Error type B at Line %d: %s", line, msg);
        }
        errors.add(x);
    }
    public boolean hasErrorInformation(){
        if(errors.isEmpty()){
            return false;
        }
        else return true;
    }
    public void printLexerErrorInformation(boolean is_stdout){
        for(String error:errors){
           // if(!is_stdout)System.err.println(error);
            //else
                System.out.println(error);
        }
    }
}
