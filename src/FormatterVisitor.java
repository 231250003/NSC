import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.RuleNode;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.List;

public class FormatterVisitor implements SysYParserVisitor<Void> {
    private int indentLevel = 0;
    private void printIndent() {
        for (int i = 0; i < indentLevel; i++) {
            System.out.print("    "); // 每个级别4个空格
        }
    }
    public Void visitProgram(SysYParser.ProgramContext ctx) {
        visitChildren(ctx); // 访问所有子节点
        return null;
    }
    public Void visitCompUnit(SysYParser.CompUnitContext ctx) {
        visitChildren(ctx);
        return null;
    }
    public Void visitFuncDef(SysYParser.FuncDefContext ctx) {
        printIndent();
        visit(ctx.funcType());
        System.out.print(" ");
        System.out.print(ctx.IDENT().getText());
        System.out.print("(");
        if(!ctx.funcFParams().isEmpty()){
            visit(ctx.funcFParams());
        }
        System.out.print(")");
        visit(ctx.block());
        return null;
    }

    @Override
    public Void visitFuncType(SysYParser.FuncTypeContext ctx) {
        System.out.print(ctx.getText());
        return null;
    }

    @Override
    public Void visitFuncFParams(SysYParser.FuncFParamsContext ctx) {
        List<SysYParser.FuncFParamContext> funcFParams = ctx.funcFParam(); // 获取所有 funcFParam 节点
        for (int i = 0; i < funcFParams.size(); i++) {
            SysYParser.FuncFParamContext funcFParam = funcFParams.get(i);
            visit(funcFParam);
            if (i < funcFParams.size() - 1) {
                System.out.print(", ");
            }
        }
        return null;
    }

    public Void visitDecl(SysYParser.DeclContext ctx) {
        printIndent();
        visitChildren(ctx);
        return null;
    }

    @Override
    public Void visitConstDecl(SysYParser.ConstDeclContext ctx) {
        System.out.print(ctx.CONST().getText());
        System.out.print(" ");
        visit(ctx.bType());
        for (int i = 0; i < ctx.constDef().size(); i++) {
            SysYParser.ConstDefContext constdef = ctx.constDef().get(i);
            if(ctx.constDef().size()==1){
                visit(constdef);
                break;
            }
            else{
                visit(constdef);
                if (i < ctx.constDef().size() - 1) {
                    System.out.print(", ");
                }
            }
        }
        System.out.println(ctx.SEMICOLON().getText());
        return null;
    }

    @Override
    public Void visitBType(SysYParser.BTypeContext ctx) {
        System.out.print(ctx.INT().getText());
        System.out.print(" ");
        return null;
    }

    @Override
    public Void visitConstDef(SysYParser.ConstDefContext ctx) {
        System.out.print(ctx.IDENT().getText());
        for(int i=0;i<ctx.constExp().size();i++){
            System.out.print(ctx.L_BRACKT().get(i).getText());
            visit(ctx.constExp().get(i));
            System.out.print(ctx.R_BRACKT().get(i).getText());
        }
        System.out.print(" ");
        System.out.print(ctx.ASSIGN().getText());
        System.out.print(" ");
        visit(ctx.constInitVal());
        return null;
    }

    @Override
    public Void visitConstInitVal(SysYParser.ConstInitValContext ctx) {
        if(ctx.constExp()!=null){
            visit(ctx.constExp());
            System.out.print(ctx.L_BRACE().getText());
            for (int i = 0; i < ctx.constInitVal().size(); i++) {
                SysYParser.ConstInitValContext const_init_val = ctx.constInitVal().get(i);
                if(ctx.constInitVal().size()==1){
                    visit(const_init_val);
                    break;
                }
                else{
                    visit(const_init_val);
                    if (i < ctx.constInitVal().size() - 1) {
                        System.out.print(", ");
                    }
                }
            }
            System.out.print(ctx.R_BRACE().getText());
        }
        return null;
    }

    @Override
    public Void visitVarDecl(SysYParser.VarDeclContext ctx) {
        visit(ctx.bType());
        for (int i = 0; i < ctx.varDef().size(); i++) {
            SysYParser.VarDefContext var_def = ctx.varDef().get(i);
            if(ctx.varDef().size()==1){
                visit(var_def);
                break;
            }
            else{
                visit(var_def);
                if (i < ctx.varDef().size() - 1) {
                    System.out.print(", ");
                }
            }
        }
        System.out.println(";");
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
        int n = ruleNode.getChildCount();
        for (int i = 0; i < n; i++) {
            ruleNode.getChild(i).accept(this);
        }
        return null;
    }

    public Void visitTerminal(TerminalNode node) {

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
       return null;
    }

    @Override
    public Void visitBlockItem(SysYParser.BlockItemContext ctx) {
        return null;
    }
}
