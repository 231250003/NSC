import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
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
        if (ctx.compUnit() != null) {
            visitCompUnit(ctx.compUnit());
        }
        return null;
    }
    public Void visitCompUnit(SysYParser.CompUnitContext ctx) {
        for (SysYParser.FuncDefContext funcDef : ctx.funcDef()) {
            visitFuncDef(funcDef);
        }
        for (SysYParser.DeclContext decl : ctx.decl()) {
            System.out.println("12123342423");
            visitDecl(decl);
        }
        return null;
    }
    public Void visitFuncDef(SysYParser.FuncDefContext ctx) {
        int currentLine = ctx.getStart().getLine();
        if(currentLine!=1){
            System.out.println();
        }
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
        if (ctx.constDecl() != null) {
            visitConstDecl(ctx.constDecl());
        } else if (ctx.varDecl() != null) {
            visitVarDecl(ctx.varDecl());
        }
        System.out.println();
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
        System.out.print(ctx.SEMICOLON().getText());
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
        System.out.print(";");
        return null;
    }

    @Override
    public Void visitVarDef(SysYParser.VarDefContext ctx) {
        for (int i = 0; i < ctx.L_BRACKT().size(); i++) {
            System.out.print("[");
            visit(ctx.constExp(i));
            System.out.print("]");
        }
        if (ctx.ASSIGN() != null) {
            System.out.print(" = ");
            visit(ctx.initVal());
        }
        return null;
    }

    @Override
    public Void visitInitVal(SysYParser.InitValContext ctx) {
        if (ctx.exp() != null) {
            visit(ctx.exp());
        } else {
            System.out.print("{");
            for (int i = 0; i < ctx.initVal().size(); i++) {
                if (i > 0) {
                    System.out.print(", ");
                }
                visit(ctx.initVal(i));
            }
            System.out.print("}");
        }
        return null;
    }

    public Void visitStmt(SysYParser.StmtContext ctx) {
        if (ctx.lVal() != null && ctx.exp() != null) {
            printIndent();
            visit(ctx.lVal());
            System.out.print(" = ");
            visit(ctx.exp());
            System.out.println(";");
        }
        else if (ctx.exp() != null) {
            printIndent();
            visit(ctx.exp());
            System.out.println(";");
        }
        else if (ctx.block() != null) {
            printIndent();
            visit(ctx.block());
            System.out.println();
        }
        else if (ctx.IF() != null) {
            printIndent();
            System.out.print("if (");
            visit(ctx.cond());
            System.out.print(") ");
            if(ctx.stmt(0).block()==null){
                indentLevel++;
                System.out.println();
                visit(ctx.stmt(0));
                indentLevel--;
                System.out.println();
            }
            else visit(ctx.stmt(0));
            if (ctx.stmt().size() > 1) {
                System.out.print("else ");
                if(ctx.stmt(1).IF()!=null);
                else {
                    if(ctx.stmt(1).block()==null){
                        indentLevel++;
                        System.out.println();
                        visit(ctx.stmt(0));
                        indentLevel--;
                        System.out.println();
                    }
                    else visit(ctx.stmt(0));
                }
            }
        }
        else if (ctx.WHILE() != null) {
            printIndent();
            System.out.print("while (");
            visit(ctx.cond());
            System.out.print(") ");
            if(ctx.stmt(0).block()==null){
                indentLevel++;
                System.out.println();
                visit(ctx.stmt(0));
                indentLevel--;
                System.out.println();
            }
            else  visit(ctx.stmt(0));
        }
        else if (ctx.BREAK() != null) {
            printIndent();
            System.out.println("break;");
        }
        else if (ctx.CONTINUE() != null) {
            printIndent();
            System.out.println("continue;");
        }
        else if (ctx.RETURN() != null) {
            printIndent();
            System.out.print("return");
            if (ctx.exp() != null) {
                System.out.print(" ");
                visit(ctx.exp());
            }
            System.out.println(";");
        }
        return null;
    }
    public Void visitExp(SysYParser.ExpContext ctx) {
        if (ctx.L_PAREN() != null) {
            System.out.print("(");
            visit(ctx.exp(0));
            System.out.print(")");
        } else if (ctx.lVal() != null) {
            visit(ctx.lVal());
        } else if (ctx.number() != null) {
            visit(ctx.number());
        } else if (ctx.IDENT() != null) {
            System.out.print(ctx.IDENT().getText() + "(");
            if (ctx.funcRParams() != null) {
                visit(ctx.funcRParams());
            }
            System.out.print(")");
        } else if (ctx.unaryOp() != null) {
            visit(ctx.unaryOp());
            visit(ctx.exp(0));
        } else if (ctx.exp().size() == 2) {
            visit(ctx.exp(0));
            System.out.print(" " + ctx.getChild(1).getText() + " ");
            visit(ctx.exp(1));
        }
        return null;
    }

    @Override
    public Void visitCond(SysYParser.CondContext ctx) {
        if (ctx.exp() != null) {
            visit(ctx.exp());
        } else if (ctx.cond().size() == 2) {
            visit(ctx.cond(0));
            System.out.print(" " + ctx.getChild(1).getText() + " ");
            visit(ctx.cond(1));
        }
        return null;
    }

    @Override
    public Void visitLVal(SysYParser.LValContext ctx) {
        System.out.print(ctx.IDENT().getText());
        for (SysYParser.ExpContext expCtx : ctx.exp()) {
            System.out.print("[");
            visit(expCtx);
            System.out.print("]");
        }

        return null;
    }

    @Override
    public Void visitNumber(SysYParser.NumberContext ctx) {
        System.out.print(ctx.INTEGER_CONST());
        return null;
    }

    @Override
    public Void visitUnaryOp(SysYParser.UnaryOpContext ctx) {
        System.out.print(ctx.getText());
        return null;
    }

    @Override
    public Void visitFuncRParams(SysYParser.FuncRParamsContext ctx) {
        List<SysYParser.ParamContext> params = ctx.param();
        for (int i = 0; i < params.size(); i++) {
            visit(params.get(i)); // 访问参数
            if (i != params.size() - 1) {
                System.out.print(", "); // 逗号分隔
            }
        }
        return null;
    }

    @Override
    public Void visitParam(SysYParser.ParamContext ctx) {
        visit(ctx.exp());
        return null;
    }

    @Override
    public Void visitConstExp(SysYParser.ConstExpContext ctx) {
        visit(ctx.exp());
        return null;
    }

    @Override
    public Void visit(ParseTree parseTree) {
        if (parseTree instanceof SysYParser.ProgramContext) {
            return visitProgram((SysYParser.ProgramContext) parseTree);
        } else if (parseTree instanceof RuleNode) {
            return visitChildren((RuleNode) parseTree);
        } else if (parseTree instanceof TerminalNode) {
            return visitTerminal((TerminalNode) parseTree);
        }
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
        System.out.print(node.getText());
        return null;
    }

    @Override
    public Void visitErrorNode(ErrorNode errorNode) {
        Token token = errorNode.getSymbol();
        int line = token.getLine();
        String msg = errorNode.getText();
        String errorMessage = String.format("Error type B at Line %d: %s", line, msg);
        System.out.println(errorMessage);
        return null;
    }

    @Override
    public Void visitFuncFParam(SysYParser.FuncFParamContext ctx) {
        visit(ctx.bType());
        System.out.print(" " + ctx.IDENT().getText());
        if (ctx.L_BRACKT().size() > 0) {
            System.out.print("[]");
            for (int i = 1; i < ctx.L_BRACKT().size(); i++) {
                System.out.print("[");
                visit(ctx.exp(i - 1));
                System.out.print("]");
            }
        }
        return null;
    }
    @Override
    public Void visitBlock(SysYParser.BlockContext ctx) {
        ParserRuleContext parent = ctx.getParent();
        if(parent instanceof SysYParser.StmtContext|| parent instanceof SysYParser.FuncDefContext){
            System.out.print(" {");
        }
        else {
            System.out.println("{");
        }
        indentLevel++;
        for (SysYParser.BlockItemContext item : ctx.blockItem()) {
            visit(item);
        }
        indentLevel--;
        System.out.println("}");
       return null;
    }

    @Override
    public Void visitBlockItem(SysYParser.BlockItemContext ctx) {
        if (ctx.decl() != null) {
            visit(ctx.decl());
        }
        else if (ctx.stmt() != null) {
            visit(ctx.stmt());
        }
        return null;
    }
}
