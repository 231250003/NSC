import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.RuleNode;
import org.antlr.v4.runtime.tree.TerminalNode;

public class FormatterVisitor extends SysYParserVisitor<Void> {
    public Void visitProgram(SysYParser.ProgramContext ctx) {
        visitChildren(ctx); // 访问所有子节点
        return null;
    }
    public Void visitCompUnit(SysYParser.CompUnitContext ctx) {
        visitChildren(ctx);
        return null;
    }
    public Void visitFuncDef(SysYParser.FuncDefContext ctx) {
        System.out.println();
        visitChildren(ctx);
        return null;
    }
    public Void visitDecl(SysYParser.DeclContext ctx) {
        visitChildren(ctx); // 访问声明内容
        return null;
    }
    public Void visitStmt(SysYParser.StmtContext ctx) {
        visitChildren(ctx);
        return null;
    }
    public Void visitExp(SysYParser.ExpContext ctx) {
        if (ctx.MUL() != null || ctx.DIV() != null || ctx.PLUS() != null) {
            System.out.print(" ");
        }
        visitChildren(ctx);
        return null;
    }
    public Void visitTerminal(TerminalNode node) {
        String text = node.getText();
        if (text.equals("+") || text.equals("-") || text.equals("*")) {
            System.out.print(" " + text + " ");
        } else {
            System.out.print(text);
        }

        return null;
    }
    @Override
    public Void visitFuncFParam(SysYParser.FuncFParamContext ctx) {
        visitChildren(ctx);
        return null;
    }
    @Override
    public Void visitBlock(SysYParser.BlockContext ctx) {
        System.out.println("{");
        visitChildren(ctx); // 访问block中的内容
        System.out.println("}");
        return null;
    }
}
