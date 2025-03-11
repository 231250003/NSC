import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.RuleNode;
import org.antlr.v4.runtime.tree.TerminalNode;

public class FormatterVisitor implements SysYParserVisitor<Void> {
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

    @Override
    public Void visitFuncType(SysYParser.FuncTypeContext ctx) {
        return null;
    }

    @Override
    public Void visitFuncFParams(SysYParser.FuncFParamsContext ctx) {
        return null;
    }

    public Void visitDecl(SysYParser.DeclContext ctx) {
        visitChildren(ctx); // 访问声明内容
        return null;
    }

    @Override
    public Void visitConstDecl(SysYParser.ConstDeclContext ctx) {
        return null;
    }

    @Override
    public Void visitBType(SysYParser.BTypeContext ctx) {
        return null;
    }

    @Override
    public Void visitConstDef(SysYParser.ConstDefContext ctx) {
        return null;
    }

    @Override
    public Void visitConstInitVal(SysYParser.ConstInitValContext ctx) {
        return null;
    }

    @Override
    public Void visitVarDecl(SysYParser.VarDeclContext ctx) {
        return null;
    }

    @Override
    public Void visitVarDef(SysYParser.VarDefContext ctx) {
        return null;
    }

    @Override
    public Void visitInitVal(SysYParser.InitValContext ctx) {
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

    @Override
    public Void visitCond(SysYParser.CondContext ctx) {
        return null;
    }

    @Override
    public Void visitLVal(SysYParser.LValContext ctx) {
        return null;
    }

    @Override
    public Void visitNumber(SysYParser.NumberContext ctx) {
        return null;
    }

    @Override
    public Void visitUnaryOp(SysYParser.UnaryOpContext ctx) {
        return null;
    }

    @Override
    public Void visitFuncRParams(SysYParser.FuncRParamsContext ctx) {
        return null;
    }

    @Override
    public Void visitParam(SysYParser.ParamContext ctx) {
        return null;
    }

    @Override
    public Void visitConstExp(SysYParser.ConstExpContext ctx) {
        return null;
    }

    @Override
    public Void visit(ParseTree parseTree) {
        return null;
    }

    @Override
    public Void visitChildren(RuleNode ruleNode) {
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
    public Void visitErrorNode(ErrorNode errorNode) {
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

    @Override
    public Void visitBlockItem(SysYParser.BlockItemContext ctx) {
        return null;
    }
}
