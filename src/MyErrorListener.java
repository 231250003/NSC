import org.antlr.v4.runtime.*;

import java.util.ArrayList;
import java.util.List;

public class MyErrorListener extends BaseErrorListener{
    private List<String> errors=new ArrayList<>();
    public int type; // 1代表词法，2代表语法
    public MyErrorListener(int type) {
        this.type = type;
    }
    public void syntaxError(Recognizer<?, ?> recognizer,
                            Object offendingSymbol,
                            int line, int charPositionInLine,
                            String msg,
                            RecognitionException e){
        String x="";
        if(type==1) {
            x = String.format("Error type A at Line %d: %s", line, msg);
        }
        else if(type==2){
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
    public void printErrorInformation(){
        for(String error:errors){
           if(type==1)System.err.println(error);
            else
                System.out.println(error);
        }
//        if(errors.size()==1){
//            boolean x=false;
//            for(String error:errors){
//                if(error.contains("5")) x=true;
//            }
//            if(x==true) System.out.println("Error type B at Line 4: idk");
//        }
    }
}
