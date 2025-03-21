import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.RuleNode;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.*;

import semantic_check.*;
public class SemanticVisitor extends SysYParserBaseVisitor<Void> {
    public SymbolTable symbolTable=new SymbolTable();
    public Void visitProgram(SysYParser.ProgramContext ctx) {
        if (ctx.compUnit() != null) {
            visitCompUnit(ctx.compUnit());
        }
        return null;
    }
    public Void visitCompUnit(SysYParser.CompUnitContext ctx) {
        if(ctx.decl()!=null) {
            for (SysYParser.DeclContext decl : ctx.decl()) {
                visitDecl(decl);
            }
        }
        if(ctx.funcDef()!=null){
            for (SysYParser.FuncDefContext funcDef : ctx.funcDef()) {
                visitFuncDef(funcDef);
            }
        }
        return null;
    }
    @Override
    public Void visitFuncDef(SysYParser.FuncDefContext ctx) {
        String ret = getFuncType(ctx.funcType());
        Type retType;
        if (ret == "int") {
            retType=new IntType();
        }
        else{
            retType=new VoidType();
        }
        String funcName = ctx.IDENT().getText();
        if(symbolTable.isGlobal(funcName) ){
            OutputHelper.printSemanticError(ErrorType.REPEATED_FUNCTION_DEFINITION,ctx.IDENT().getSymbol().getLine());
            return null;
        }
        List<Symbol> params=null;
        if(ctx.funcFParams()!=null){
            params=new ArrayList<>(getFuncFParams(ctx.funcFParams()));
            System.out.println("cr");
        }
        FunctionType functionType = new FunctionType(retType, params);
        symbolTable.addGlobal(new Symbol(funcName,functionType));
        visit_block(ctx.block(),params);
        return null;
    }

    public String getFuncType(SysYParser.FuncTypeContext ctx) {
        return ctx.getText();
    }

    public  List<Symbol>  getFuncFParams(SysYParser.FuncFParamsContext ctx) {
        List<SysYParser.FuncFParamContext> funcFParams = ctx.funcFParam(); // 获取所有 funcFParam 节点
        List< AbstractMap.SimpleEntry<String,Type>> paramsType=new ArrayList<>();
        for (int i = 0; i < funcFParams.size(); i++) {
            SysYParser.FuncFParamContext funcFParam = funcFParams.get(i);
            AbstractMap.SimpleEntry<String, Type> result=getFuncFParam(funcFParam);
            paramsType.add(result);
        }
        Set<String> seenKeys = new HashSet<>();
        List<Symbol> result = new ArrayList<>();
        for (AbstractMap.SimpleEntry<String, Type> entry : paramsType) {
            if (seenKeys.add(entry.getKey())) {
                result.add(new Symbol(entry.getKey(), entry.getValue()));
            }
        }
        return result;
    }

    public AbstractMap.SimpleEntry<String,Type> getFuncFParam(SysYParser.FuncFParamContext ctx) {
        Type type;
        String name=ctx.IDENT().getText();
        if (ctx.L_BRACKT().size() > 0) {
            type=new ArrayType(new IntType(),1);
        }
        else type=new IntType();
        return new AbstractMap.SimpleEntry<>(name,type);
    }

    @Override
    public Void visitDecl(SysYParser.DeclContext ctx) {
        if (ctx.constDecl() != null) {
            visit(ctx.constDecl());
        }
        else if (ctx.varDecl() != null) {
            visitVarDecl(ctx.varDecl());
        }
        return null;
    }

    @Override
    public Void visitConstDecl(SysYParser.ConstDeclContext ctx) {
        List<Symbol> symbols=new ArrayList<>();
        for (int i = 0; i < ctx.constDef().size(); i++) {
            SysYParser.ConstDefContext constdef = ctx.constDef().get(i);
            Symbol x = getConstdef(constdef);
            if(x!=null)symbols.add(x);
        }
        for(Symbol symbol:symbols){
            if(symbolTable.is_cur_scopeGlobal()){
                if(symbolTable.isGlobal(symbol.name)){
                    OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
                }
                else if(symbolTable.cur_scope_has_same_symbol(symbol.name)){
                    OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
                }
            }
        }
        Set<String> seenKeys = new HashSet<>();
        List<Symbol> result = new ArrayList<>();
        for (Symbol x: symbols) {
            if (seenKeys.add(x.name)) {
                result.add(x);
            }
            else{
                OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
            }
        }
        for(Symbol x:result){
            symbolTable.put(x);
        }
        return null;
    }

    public Symbol getConstdef(SysYParser.ConstDefContext ctx) {
       Symbol symbol=new Symbol();
       symbol.name=ctx.IDENT().getText();
        if(ctx.constExp()!=null) {//gurantee that assignof the array on the right side always correct
            symbol.type=new ArrayType();
            ((ArrayType)symbol.type).dim= ctx.constExp().size();
            ((ArrayType)symbol.type).elementType=new IntType();
            for (int i = 0; i < ctx.constExp().size(); i++) {
                if(getConstExp(ctx.constExp().get(i))==null) return null;//null means there is an error in constEXP,ele return the expTYPE
            }
        }
        else{
            if(!(getConstinitvalue(ctx.constInitVal()) instanceof IntType)){
                OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_ASSIGNMENT,ctx.getStart().getLine());
            }
        }
        return symbol;
    }

    public Type getConstinitvalue(SysYParser.ConstInitValContext ctx) {
        if(ctx.constExp()!=null) {
            return getConstExp(ctx.constExp());
        }
        else{
           return new ArrayType();
        }
    }

    @Override
    public Void visitVarDecl(SysYParser.VarDeclContext ctx) {
        List<Symbol> symbols=new ArrayList<>();
        for (int i = 0; i < ctx.varDef().size(); i++) {
            SysYParser.VarDefContext vardef = ctx.varDef().get(i);
            Symbol x = getVardef(vardef);
            if(x!=null)symbols.add(x);
        }
        for(Symbol symbol:symbols){
            if(symbolTable.is_cur_scopeGlobal()){
                if(symbolTable.isGlobal(symbol.name)){
                    OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
                }
                else if(symbolTable.cur_scope_has_same_symbol(symbol.name)){
                    OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
                }
            }
        }
        Set<String> seenKeys = new HashSet<>();
        List<Symbol> result = new ArrayList<>();
        for (Symbol x: symbols) {
            if (seenKeys.add(x.name)) {
                result.add(x);
            }
            else{
                OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
            }
        }
        for(Symbol x:result){
            symbolTable.put(x);
        }
        return null;
    }

    public Symbol getVardef(SysYParser.VarDefContext ctx) {
        Symbol symbol=new Symbol();
        symbol.name=ctx.IDENT().getText();
        if(ctx.initVal()==null) {
            if (ctx.constExp() != null) {
                symbol.type = new ArrayType();
                ((ArrayType) symbol.type).dim = ctx.constExp().size();
                ((ArrayType) symbol.type).elementType = new IntType();
                for (int i = 0; i < ctx.constExp().size(); i++) {
                    if (getConstExp(ctx.constExp().get(i)) == null) return null;
                }
            }
        }
        else{
            if(ctx.constExp()!=null) {
                symbol.type=new ArrayType();
                ((ArrayType)symbol.type).dim= ctx.constExp().size();
                ((ArrayType)symbol.type).elementType=new IntType();
                for (int i = 0; i < ctx.constExp().size(); i++) {
                    if(getConstExp(ctx.constExp().get(i))==null) return null;
                }
            }
            else{
                if(!(getinitvalue(ctx.initVal()) instanceof IntType)){
                    OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_ASSIGNMENT,ctx.getStart().getLine());
                }
            }
        }
        return symbol;
    }

    public Type getinitvalue(SysYParser.InitValContext ctx) {
        if(ctx.exp()!=null) {
            return getExp(ctx.exp());
        }
        else{
            return new ArrayType();
        }
    }

    public Void visitStmt(SysYParser.StmtContext ctx) {
        if (ctx.lVal() != null && ctx.exp() != null) {
           Type left=getlVal(ctx.lVal());//lval guarantees that it is an var or array like a,a[],a[][]
           Type right=getExp(ctx.exp());
           if(left!=null || right!=null){
                if(left!=right){
                    OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_ASSIGNMENT,ctx.getStart().getLine());
                }
                if(left instanceof FunctionType){
                    OutputHelper.printSemanticError(ErrorType.INVALID_ASSIGNMENT_TARGET,ctx.getStart().getLine());
                }
                else if(left instanceof ArrayType && right instanceof ArrayType ){
                    if(((ArrayType)left).dim!=((ArrayType)right).dim) {
                        OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_ASSIGNMENT,ctx.getStart().getLine());
                    }
                }
           }
        }
        else if (ctx.block() != null) {
            visit_block(ctx.block());
        }
        else if (ctx.IF() != null) {
            getCond(ctx.cond());
            for(int i=0;i<ctx.stmt().size();i++){
                visit(ctx.stmt(i));
            }
        }
        else if (ctx.WHILE() != null) {
            getCond(ctx.cond());
            for(int i=0;i<ctx.stmt().size();i++){
                visit(ctx.stmt(i));
            }
        }
        else if (ctx.BREAK() != null) {
           return null;
        }
        else if (ctx.CONTINUE() != null) {
            return null;
        }
        else if (ctx.RETURN() != null) {
            Type stmt_return_type=symbolTable.get_cur_scope_return_type();
            if(ctx.exp()!=null){
                if(!(getExp(ctx.exp()) instanceof IntType)){
                    OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_RETURN,ctx.getStart().getLine());
                }
            }
            else{
                if(stmt_return_type instanceof IntType){
                    OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_RETURN,ctx.getStart().getLine());
                }
            }
        }
        else if (ctx.SEMICOLON() != null) {
            if(ctx.exp()!=null){
                getExp(ctx.exp());
                return null;
            }
        }
        return null;
    }
    public Type getExp(SysYParser.ExpContext ctx) {
        if (ctx.IDENT() != null) {
            Symbol x=symbolTable.get_name_matched_symbol(ctx.IDENT().getText());
            if(x==null){
                OutputHelper.printSemanticError(ErrorType.UNDECLARED_FUNCTION,ctx.getStart().getLine());
                return null;
            }
            else if(x.type instanceof IntType || x.type instanceof ArrayType){
                OutputHelper.printSemanticError(ErrorType.CALLING_NON_FUNCTION,ctx.getStart().getLine());
                return null;
            }
            else{
                List<Type> r_params=getFuncRParams(ctx.funcRParams());
                List<Symbol> f_params=((FunctionType)(x.type)).getparams();
                if(r_params==null) return null;
                if(r_params.size()!=f_params.size()){
                    OutputHelper.printSemanticError(ErrorType.FUNCTION_ARGUMENT_MISMATCH,ctx.getStart().getLine());
                    return null;
                }
                for(int i=0;i<r_params.size();i++){
                    if(!f_params.get(i).type.equals(r_params.get(i))){
                        OutputHelper.printSemanticError(ErrorType.FUNCTION_ARGUMENT_MISMATCH,ctx.getStart().getLine());
                        return null;
                    }
                }
            }
            return ((FunctionType)(x.type)).getReturnType();
        }
        else if (ctx.unaryOp() != null) {
            if(!(getExp(ctx.exp(0)) instanceof IntType)){
                OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_OPERATOR,ctx.getStart().getLine());
            }
            return new IntType();
        }
        else if (ctx.lVal() != null) {
            return getlVal(ctx.lVal());
        }
        else if (ctx.number() != null) {
            return new IntType();
        }
        else if (ctx.L_PAREN() != null) {
            return getExp(ctx.exp(0));
        }
        else if (ctx.exp().size() == 2) {
            if((!(getExp(ctx.exp(0)) instanceof IntType) ) || (!(getExp(ctx.exp(1)) instanceof  IntType))){
                OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_OPERATOR,ctx.getStart().getLine());
                return null;
            }
            return new IntType();
        }
        assert(false);
        return null;
    }
    public List<Type> getFuncRParams(SysYParser.FuncRParamsContext ctx) {
        List<SysYParser.ParamContext> params = ctx.param();
        List<Type> types=new ArrayList<>();
        for (int i = 0; i < params.size(); i++) {
            Type x=getRParam(params.get(i));
            if(x==null) return null;
            else types.add(x);
        }
        return types;
    }
    public Type getRParam(SysYParser.ParamContext ctx) {
        return getExp(ctx.exp());
    }

    public Type getCond(SysYParser.CondContext ctx) {
        if (ctx.exp() != null) {
            return getExp(ctx.exp());
        } else if (ctx.cond().size() == 2) {
            Type x=getCond(ctx.cond(0));
            Type y=getCond(ctx.cond(1));
            if(x!=null&&y!=null){
                if(!x.equals(y)){
                    OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_OPERATOR,ctx.getStart().getLine());
                    return null;
                }
            }
        }
        return null;
    }

    public Type getlVal(SysYParser.LValContext ctx) {
        String name=ctx.IDENT().getText();
        Symbol s=symbolTable.get_name_matched_symbol(name);
        if(s==null){
            OutputHelper.printSemanticError(ErrorType.UNDECLARED_VARIABLE,ctx.getStart().getLine());
            return null;
        }
        if(ctx.exp()!=null) {
            if(s.type instanceof IntType){
                OutputHelper.printSemanticError(ErrorType.INDEXING_NON_ARRAY,ctx.getStart().getLine());
                return null;
            }
            else{
                for (SysYParser.ExpContext expCtx : ctx.exp()) {
                    Type x=getExp(expCtx);
                    if(x==null) return null;
                }
                int dim=ctx.L_BRACKT().size();
                int org_dim=((ArrayType)s.type).dim;
                if(dim>org_dim) {
                    OutputHelper.printSemanticError(ErrorType.UNDECLARED_VARIABLE,ctx.getStart().getLine());
                    return null;
                }
                else if(dim==org_dim) return new IntType();
                else{
                    int ans_dim=org_dim-dim;
                    return new ArrayType(new IntType(),ans_dim);
                }
            }
        }
        else{
            return s.type;
        }
    }

    public Type getConstExp(SysYParser.ConstExpContext ctx) {
        return getExp(ctx.exp());
    }


    @Override
    public Void visitTerminal(TerminalNode node) {
        if (node.getSymbol().getType() == Token.EOF || node.getSymbol().getType() == SysYLexer.LINE_COMMENT){
            return null;  // 不打印 EOF
        }
        System.out.print(node.getText());
        return null;
    }

    @Override
    public Void visitErrorNode(ErrorNode errorNode) {
       // Token token = errorNode.getSymbol();
        //int line = token.getLine();
        //String msg = errorNode.getText();
        //String errorMessage = String.format("Error type B at Line %d: %s", line, msg);
        //System.out.println(errorMessage);
        return null;
    }

    public Void visit_block(SysYParser.BlockContext ctx) {
        symbolTable.enterScope();
        for(int i=0;i<ctx.blockItem().size();i++){
            visit(ctx.blockItem(i));
        }
        symbolTable.exitScope();
        return null;
    }
    public Void visit_block(SysYParser.BlockContext ctx,List<Symbol> symbols) {
        symbolTable.enterScope();
        if(symbols!=null){
            for(Symbol symbol:symbols){
                symbolTable.put(symbol);
            }
        }
        for(int i=0;i<ctx.blockItem().size();i++){
            visit(ctx.blockItem(i));
        }
        symbolTable.exitScope();
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
