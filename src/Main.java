import org.antlr.v4.runtime.*;

import org.antlr.v4.runtime.tree.ParseTree;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class Main {

    public static void main(String[] args) throws IOException {
        if (args.length < 1) {
            System.err.println("input path is required");
        }
        String source = args[0];
        CharStream input = CharStreams.fromFileName(source);
        SysYLexer lexer = new SysYLexer(input);
//        lexer.removeErrorListeners();
//        MyErrorListener errorListener=new MyErrorListener(1);
//        lexer.addErrorListener(errorListener);

        CommonTokenStream tokens = new CommonTokenStream(lexer);

        SysYParser parser = new SysYParser(tokens);
        parser.removeErrorListeners();
        MyErrorListener parser_errorListener=new MyErrorListener(2);
        parser.addErrorListener(parser_errorListener);
        parser.compUnit();

//        if(errorListener.hasErrorInformation()){
//            errorListener.printLexerErrorInformation(false);
//        }
//         else
        if(parser_errorListener.hasErrorInformation()){
            parser_errorListener.printLexerErrorInformation(true);
        }
        else{
            ParseTree tree = parser.program();
            FormatterVisitor visitor = new FormatterVisitor();
            visitor.visit(tree);
//            List<? extends Token> myTokens = lexer.getAllTokens();
//            for(Token t: myTokens){
//                printSysYTokenInformation(t);
//            }
        }
    }
    public static void printSysYTokenInformation(Token t){
        String tokenType = SysYLexer.VOCABULARY.getSymbolicName(t.getType());
        String tokenText=t.getText();
        if(tokenType.equals("INTEGER_CONST")){
            if(tokenText.length()>2&&(tokenText.substring(0,2).equals("0x")||tokenText.substring(0,2).equals("0X"))){
                tokenText=String.valueOf(Integer.parseInt(tokenText.substring(2),16));
            }
            else if(tokenText.charAt(0)=='0'&&tokenText.length()>1){
                tokenText=String.valueOf(Integer.parseInt(tokenText.substring(1),8));
            }
        }
        System.err.printf("%s %s at Line %d.%n", tokenType,tokenText, t.getLine());
    }
}
