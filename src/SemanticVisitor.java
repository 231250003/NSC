import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.*;

import semantic_check.*;
public class SemanticVisitor extends SysYParserBaseVisitor<Void> {
    private SymbolTable symbolTable=new SymbolTable();
    public Void visitProgram(SysYParser.ProgramContext ctx) {
        if (ctx.compUnit() != null) {
            visitCompUnit(ctx.compUnit());
        }
        return null;
    }
    public Void visitCompUnit(SysYParser.CompUnitContext ctx) {
        for (ParseTree child : ctx.children) {
            if (child instanceof SysYParser.DeclContext) {
                visitDecl((SysYParser.DeclContext) child);
            } else if (child instanceof SysYParser.FuncDefContext) {
                visitFuncDef((SysYParser.FuncDefContext) child);
            }
        }
        return null;
    }
    @Override
    public Void visitFuncDef(SysYParser.FuncDefContext ctx) {
        String ret = getFuncType(ctx.funcType());
        Type retType;
        if (ret.equals("int")) {
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
        List<Symbol> params;
        if(ctx.funcFParams()!=null){
            params=new ArrayList<>(getFuncFParams(ctx.funcFParams()));
        }
        else params=new ArrayList<>();
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
        Map<String,Type> seenKeys = new HashMap<>();
        List<Symbol> result = new ArrayList<>();
        for (AbstractMap.SimpleEntry<String, Type> entry : paramsType) {
            if (seenKeys.get(entry.getKey())==null) {
                seenKeys.put(entry.getKey(),entry.getValue());
                result.add(new Symbol(entry.getKey(), entry.getValue()));
            }
            else{
                OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
            }
        }
        return result;
    }

    public AbstractMap.SimpleEntry<String,Type> getFuncFParam(SysYParser.FuncFParamContext ctx) {
        Type type;
        String name=ctx.IDENT().getText();
        if (ctx.L_BRACKT()!=null&&ctx.L_BRACKT().size() > 0) {
            type=new ArrayType(new IntType(),ctx.L_BRACKT().size());
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
        Set<String> seenKeys = new HashSet<>();
        List<Symbol> result = new ArrayList<>();
        for(Symbol symbol:symbols){
            if(symbolTable.is_cur_scopeGlobal()){
                if(symbolTable.isGlobal(symbol.name)){
                    OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
                    continue;
                }
            }
            else if(symbolTable.cur_scope_has_same_symbol(symbol.name)){
                OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
                continue;
            }
            if (seenKeys.add(symbol.name)) {
                result.add(symbol);
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
        if(!ctx.number().isEmpty()) {//gurantee that assignof the array on the right side always correct
            symbol.type=new ArrayType();
            ((ArrayType)symbol.type).dim= ctx.number().size();
            ((ArrayType)symbol.type).elementType=new IntType();
        }
        else{
            Type y=getConstinitvalue(ctx.constInitVal());
            if(y!=null&&(!(y instanceof IntType))){
                OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_ASSIGNMENT,ctx.getStart().getLine());
            }
            symbol.type=new IntType();
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
        Set<String> seenKeys = new HashSet<>();
        List<Symbol> result = new ArrayList<>();
        for(Symbol symbol:symbols){
            if(symbolTable.is_cur_scopeGlobal()){
                if(symbolTable.isGlobal(symbol.name)){
                    OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
                    continue;
                }
            }
            else if(symbolTable.cur_scope_has_same_symbol(symbol.name)){
                OutputHelper.printSemanticError(ErrorType.REPEATED_VARIABLE_DECLARATION,ctx.getStart().getLine());
                continue;
            }
            if(seenKeys.add(symbol.name)){
                result.add(symbol);
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
            if (!ctx.number().isEmpty()) {
                symbol.type = new ArrayType();
                ((ArrayType) symbol.type).dim = ctx.number().size();
                ((ArrayType) symbol.type).elementType = new IntType();
            }
            else symbol.type=new IntType();
        }
        else{
            if(!ctx.number().isEmpty()) {
                symbol.type=new ArrayType();
                ((ArrayType)symbol.type).dim= ctx.number().size();
                ((ArrayType)symbol.type).elementType=new IntType();
            }
            else{
                symbol.type=new IntType();
                Type x=getinitvalue(ctx.initVal());
                if(x!=null&&(!(x instanceof IntType)))
                {
                    OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_ASSIGNMENT,ctx.getStart().getLine());
                }
            }
        }
        //System.out.println(symbol.name);
        //System.out.println(symbol.type);
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
            if(left instanceof FunctionType){
                OutputHelper.printSemanticError(ErrorType.INVALID_ASSIGNMENT_TARGET,ctx.getStart().getLine());
                return null;
            }
           // System.out.println(ctx.exp());
           Type right=getExp(ctx.exp());
//            System.out.println(left.toString());
//
//            System.out.println(right);
            if(left!=null && right!=null){
                if(!left.equals(right)){
                    OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_ASSIGNMENT,ctx.getStart().getLine());
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
        else if (ctx.FOR()!=null){
            if (ctx.varDecl()!= null) {
                visit(ctx.varDecl());
            }
            if (ctx.stmt()!=null) {
                for(int i=0;i<ctx.stmt().size();i++){
                    visit(ctx.stmt(i));
                }
            }
            if(ctx.cond()!=null) getCond(ctx.cond());
            if(ctx.lVal()!=null){
                Type left=getlVal(ctx.lVal());//lval guarantees that it is an var or array like a,a[],a[][]
                if(left instanceof FunctionType){
                    OutputHelper.printSemanticError(ErrorType.INVALID_ASSIGNMENT_TARGET,ctx.getStart().getLine());
                    return null;
                }
                // System.out.println(ctx.exp());
                Type right=getExp(ctx.exp());
//            System.out.println(left.toString());
//
//            System.out.println(right);
                if(left!=null && right!=null){
                    if(!left.equals(right)){
                        OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_ASSIGNMENT,ctx.getStart().getLine());
                    }
                }
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
                Type y=getExp(ctx.exp());
                if(y!=null &&(   (!(y instanceof IntType))    &&   stmt_return_type instanceof IntType  )){
                    OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_RETURN,ctx.getStart().getLine());
                }
                if(y!=null &&(   (!(y instanceof VoidType))    &&   stmt_return_type instanceof VoidType  )){
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
       // System.out.println(ctx.getText());
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
                List<Type> r_params=new ArrayList<>();
                if(ctx.funcRParams()!=null){
                   if(getFuncRParams(ctx.funcRParams())!=null) r_params=new ArrayList<>(getFuncRParams(ctx.funcRParams()));
                   else return null;
                }
                List<Symbol> f_params=((FunctionType)(x.type)).getparams();
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
            Type x=getExp(ctx.exp(0));
            if(x!=null&&(!(x instanceof IntType))){
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
            Type a=getExp(ctx.exp(0));
            Type b=getExp(ctx.exp(1));
            if( a!=null&& b!=null &&  ( !(a instanceof IntType)  || (!(b instanceof  IntType))))
            {
                OutputHelper.printSemanticError(ErrorType.TYPE_MISMATCH_OPERATOR,ctx.getStart().getLine());
                return null;
            }
            return new IntType();
        }
        //assert(false);
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
        if(!ctx.exp().isEmpty()) {
           // System.out.println(s.type);
            if(s.type instanceof IntType){
//                System.out.println(s.name);
//                System.out.println(s.type);
                OutputHelper.printSemanticError(ErrorType.INDEXING_NON_ARRAY,ctx.getStart().getLine());
                return null;
            }
            else if(s.type instanceof ArrayType){
                for (SysYParser.ExpContext expCtx : ctx.exp()) {
                    Type x=getExp(expCtx);
                    if(x==null) return null;
                }
                int dim=ctx.L_BRACKT().size();
                int org_dim=((ArrayType)s.type).dim;
                if(dim>org_dim) {
                    OutputHelper.printSemanticError(ErrorType.INDEXING_NON_ARRAY,ctx.getStart().getLine());
                    return null;
                }
                else if(dim==org_dim) return new IntType();
                else{
                    int ans_dim=org_dim-dim;
                    return new ArrayType(new IntType(),ans_dim);
                }
            }
            else {
                if(s.type instanceof FunctionType) {
                    OutputHelper.printSemanticError(ErrorType.INDEXING_NON_ARRAY, ctx.getStart().getLine());
                    return null;
                }
                else{
                    return s.type;
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
    public Void visit_block(SysYParser.BlockContext ctx, List<Symbol> symbols) {
        symbolTable.enterScope();
        if(symbols!=null){
            for(Symbol symbol:symbols){
                symbolTable.put(symbol);
            }
        }
       // System.err.println(ctx.blockItem().size());
        //System.err.println("crzzz");
        for(int i=0;i<ctx.blockItem().size();i++){
           // System.err.println(symbolTable.cur_scope_has_same_symbol("x"));
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
