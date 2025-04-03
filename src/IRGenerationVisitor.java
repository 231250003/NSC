import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.RuleNode;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.bytedeco.javacpp.PointerPointer;
import org.bytedeco.llvm.LLVM.*;
import org.bytedeco.llvm.global.LLVM;
import semantic_check.*;

import java.util.*;

import static org.bytedeco.llvm.global.LLVM.*;

public class IRGenerationVisitor extends   SysYParserBaseVisitor<LLVMValueRef> {
    private final LLVMModuleRef module;
    private final LLVMBuilderRef builder;
    private static final LLVMTypeRef i32Type = LLVMInt32Type();
    private static final   LLVMValueRef zero = LLVMConstInt(i32Type, 0, /* signExtend */ 0);
    private SymbolTable symbolTable=new SymbolTable();
    public IRGenerationVisitor(LLVMModuleRef module, LLVMBuilderRef builder) {
        this.module = module;
        this.builder = builder;
    }
    @Override
    public LLVMValueRef visitDecl(SysYParser.DeclContext ctx) {
         if(ctx.varDecl()!=null) visit(ctx.varDecl());
         else visit((ctx.constDecl()));
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
        for(int i=0;i<ctx.blockItem().size();i++){
            visit(ctx.blockItem(i));
        }
        symbolTable.exitScope();
        return null;
    }

    @Override
    public LLVMValueRef visitBlockItem(SysYParser.BlockItemContext ctx) {
        if (ctx.decl() != null)  visit(ctx.decl());
        if (ctx.stmt() != null)  visit(ctx.stmt());
        return null;
    }

    @Override
    public LLVMValueRef visitBType(SysYParser.BTypeContext ctx) {
        return super.visitBType(ctx);
    }

    @Override
    public LLVMValueRef visitCompUnit(SysYParser.CompUnitContext ctx) {

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
    public LLVMValueRef visitCond(SysYParser.CondContext ctx) {
        return super.visitCond(ctx);
    }

    @Override
    public LLVMValueRef visitConstDecl(SysYParser.ConstDeclContext ctx) {
        for (int i = 0; i < ctx.constDef().size(); i++) {
            SysYParser.ConstDefContext constdef = ctx.constDef().get(i);
            Symbol x = getConstDef(constdef);
            symbolTable.put(x);
        }
        return null;
    }

    public Symbol getConstDef(SysYParser.ConstDefContext ctx) {
        Symbol symbol=new Symbol();
        symbol.name=ctx.IDENT().getText();
        if(ctx.L_BRACKT().isEmpty()){
            symbol.type=new IntType();
            if(symbolTable.is_cur_scopeGlobal()){
                LLVMValueRef initval=getconstinitvalue(ctx.constInitVal());
                if(LLVMIsAConstantInt(initval) != null) {
                    LLVMValueRef pointer = LLVMAddGlobal(module, i32Type, symbol.name);
                    LLVMSetInitializer(pointer, LLVMIsAConstantInt(initval));
                    symbol.reference=pointer;
                }
                else assert(false);
            }
            else{
                LLVMValueRef pointer = LLVMBuildAlloca(builder, LLVMInt32Type(), symbol.name);
                LLVMValueRef initval=getconstinitvalue(ctx.constInitVal());
                LLVMBuildStore(builder, initval, pointer);
                symbol.reference=pointer;
            }
        }
        else{
            // TODO  assigning array  to initval, no need in lab4
            assert(false);
        }
        return symbol;
    }

    @Override
    public LLVMValueRef visitConstExp(SysYParser.ConstExpContext ctx) {
        return visit(ctx.exp());
    }

    public LLVMValueRef getconstinitvalue(SysYParser.ConstInitValContext ctx) {
        if(ctx.L_BRACE()==null){
            return visit(ctx.constExp());
        }
        else {
            // TODO  assigning array to initval, no need in lab4
            assert(false);
        }
        return null;
    }

    @Override
    public LLVMValueRef visitExp(SysYParser.ExpContext ctx) {
        if (ctx.number() != null) return visit(ctx.number());
        else if (ctx.IDENT() != null && ctx.L_PAREN() != null) {
            System.err.println("crzasa");
            String funcName = ctx.IDENT().getText();
            LLVMValueRef function = LLVMGetNamedFunction(module, funcName);
            if (function == null) {
                throw new RuntimeException("Undefined function: " + funcName);
            }
            PointerPointer<LLVMValueRef> args = null;
            if (ctx.funcRParams() != null) {
                args=getFuncRParams(ctx.funcRParams());
                symbolTable.set_r_params(funcName,args);
                return LLVMBuildCall(builder, function, args, ctx.funcRParams() == null ? 0 : ctx.funcRParams().param().size(), funcName);
            }
        }
        else if (ctx.exp().size() == 1 && ctx.unaryOp() != null) {
            LLVMValueRef val = visit(ctx.exp(0));
            switch (ctx.unaryOp().getText()) {
                case "-" :return LLVMBuildNeg(builder, val, "neg");
                case "!" :return LLVMBuildICmp(builder, LLVMIntEQ, val, LLVMConstInt(LLVMInt32Type(), 0, 0), "not");
                case "+" :return val;
                default :return null;
            }
        }
        else if (ctx.exp().size() == 2) {
            LLVMValueRef left = visit(ctx.exp(0));
            LLVMValueRef right = visit(ctx.exp(1));
             switch (ctx.getChild(1).getText()) {
                 case "+" : return LLVMBuildAdd(builder, left, right, "add");
                 case "-" :return LLVMBuildSub(builder, left, right, "sub");
                 case "*" :return  LLVMBuildMul(builder, left, right, "mul");
                 case "/" :return LLVMBuildSDiv(builder, left, right, "div");
                 case "%" :return LLVMBuildSRem(builder, left, right, "mod");
                 default :return null;
            }
        }
        else if(ctx.L_PAREN()!=null&&ctx.exp()!=null){
            return visit(ctx.exp(0));
        }
        else if(ctx.lVal()!=null){
            return visit(ctx.lVal());
        }
        return null;
    }

    @Override
    public LLVMValueRef visitFuncDef(SysYParser.FuncDefContext ctx) {
        String funcName = ctx.IDENT().getText();
        LLVMTypeRef returnType;
        Type retType;
        if(ctx.funcType().getText().equals("int")){
            returnType = LLVMInt32Type();
            retType=new IntType();
        }
        else {
            returnType = LLVMVoidType();
            retType=new VoidType();
        }
        List<LLVMTypeRef> paramTypeList = new ArrayList<>();
        List<Symbol> params=new ArrayList<>();
        if(ctx.funcFParams()!=null){
            params=new ArrayList<>(getFuncFParams(ctx.funcFParams()));
            for (Symbol x: params) {
                if(x.type.equals(new IntType())) paramTypeList.add(LLVMInt32Type());
                 //TODO adding array type params
            }
        }
        PointerPointer<LLVMTypeRef> paramTypes = new PointerPointer<>(paramTypeList.size());
        for (int i = 0; i < paramTypeList.size(); i++) {
            paramTypes.put(i, paramTypeList.get(i));
        }
        LLVMTypeRef funcType = LLVMFunctionType(returnType, paramTypes, paramTypeList.size(), 0);
        LLVMValueRef function = LLVMAddFunction(module, funcName, funcType);
        for (int i = 0; i < params.size(); i++) {
            LLVMValueRef param = LLVMGetParam(function, i);
            LLVMSetValueName(param, params.get(i).name);
            //params.get(i).reference = param;
        }
        LLVMBasicBlockRef entry = LLVMAppendBasicBlock(function, funcName + "Entry");
        LLVMPositionBuilderAtEnd(builder, entry);
        FunctionType functionType = new FunctionType(retType, params);
        symbolTable.addGlobal(new Symbol(funcName,functionType,function));
        visit_block(ctx.block(),params);
        return null;
    }

    public Symbol getFuncFParam(SysYParser.FuncFParamContext ctx) {
        Type type;
        String name=ctx.IDENT().getText();
        if (ctx.L_BRACKT().size() > 0) {
            type=new ArrayType(new IntType(),1);
        }
        else type=new IntType();
        return new Symbol(name,type);
    }
    public List<Symbol> getFuncFParams(SysYParser.FuncFParamsContext ctx) {
        List<SysYParser.FuncFParamContext> funcFParams = ctx.funcFParam();
        List<Symbol> result = new ArrayList<>();
        for (int i = 0; i < funcFParams.size(); i++) {
            SysYParser.FuncFParamContext funcFParam = funcFParams.get(i);
            Symbol x=getFuncFParam(funcFParam);
            result.add(x);
        }
        return result;
    }

    public PointerPointer<LLVMValueRef> getFuncRParams(SysYParser.FuncRParamsContext ctx) {
        int paramCount = ctx.param().size();
        PointerPointer<LLVMValueRef> args = new PointerPointer<>(paramCount);
        for (int i = 0; i < paramCount; i++) {
            LLVMValueRef argValue = visit(ctx.param(i));
            if (LLVMGetTypeKind(LLVMTypeOf(argValue)) == LLVMPointerTypeKind) {
                argValue = LLVMBuildLoad(builder, argValue, "arg");
            }
            args.put(i, argValue);
        }
        return args;
    }

    public LLVMValueRef getinitvalue(SysYParser.InitValContext ctx) {
        if(ctx.L_BRACE()==null){
            return visit(ctx.exp());
        }
        else {
            // TODO  assigning array to initval, no need in lab4
            assert(false);
        }
        return null;
    }

    @Override
    public LLVMValueRef visitLVal(SysYParser.LValContext ctx) {
        LLVMValueRef func =symbolTable.get_cur_scope_func();
        String name=ctx.IDENT().getText();
        int paramCount = LLVMCountParams(func);
        for (int i = 0; i < paramCount; i++) {
            //System.err.println("crzzz");
            LLVMValueRef param = LLVMGetParam(func, i);
            //System.err.println(LLVMGetValueName(param).getString());
            if (LLVMGetValueName(param).getString().equals(name)) {
                return param;
            }
        }
        Symbol s=symbolTable.get_name_matched_symbol(name);
        return s.reference;
    }

    @Override
    public LLVMValueRef visitNumber(SysYParser.NumberContext ctx) {
        int value = Integer.decode(ctx.INTEGER_CONST().getText());
        return LLVMConstInt(LLVMInt32Type(), value, 0);
    }

    @Override
    public LLVMValueRef visitParam(SysYParser.ParamContext ctx) {
        return visit(ctx.exp());
    }

    @Override
    public LLVMValueRef visitProgram(SysYParser.ProgramContext ctx) {
        return visit(ctx.compUnit());
    }

    @Override
    public LLVMValueRef visitStmt(SysYParser.StmtContext ctx) {
        if (ctx.RETURN() != null) {
            LLVMValueRef returnValue;
            if(ctx.exp() != null ){
                returnValue = visit(ctx.exp());
                return LLVMBuildRet(builder, returnValue);
            }
            else  return LLVMBuildRetVoid(builder);
        }
        return null;
    }


    @Override
    public LLVMValueRef visitVarDecl(SysYParser.VarDeclContext ctx) {
        for (int i = 0; i < ctx.varDef().size(); i++) {
            SysYParser.VarDefContext vardef = ctx.varDef().get(i);
            Symbol x = getVardef(vardef);
            symbolTable.put(x);
        }
        return null;
    }

    public Symbol getVardef(SysYParser.VarDefContext ctx) {
        Symbol symbol=new Symbol();
        symbol.name=ctx.IDENT().getText();
        if(ctx.initVal()==null) {
            if(ctx.L_BRACKT().isEmpty()) {
                symbol.type = new IntType();
                LLVMValueRef pointer;
                //May be wrong but is in the manual
                if (symbolTable.is_cur_scopeGlobal()) {
                    pointer = LLVMAddGlobal(module, i32Type, symbol.name);
                    LLVMSetInitializer(pointer, zero);
                } else {
                    pointer = LLVMBuildAlloca(builder, i32Type, symbol.name);
                    LLVMValueRef undefVal = LLVMGetUndef(i32Type);
                    LLVMBuildStore(builder, undefVal, pointer);
                }
                symbol.reference = pointer;
            }
            else{
                // TODO adding array to symbol table, no need in lab4
                assert(false);
            }
        }
        else{
            if(ctx.L_BRACKT().isEmpty()){
                symbol.type=new IntType();
                if(symbolTable.is_cur_scopeGlobal()){
                    LLVMValueRef initval=getinitvalue(ctx.initVal());
                    if(LLVMIsAConstantInt(initval) != null) {
                        LLVMValueRef pointer = LLVMAddGlobal(module, i32Type, symbol.name);
                        LLVMSetInitializer(pointer, LLVMIsAConstantInt(initval));
                        symbol.reference=pointer;
                    }
                    else assert(false);
                }
                else{
                    LLVMValueRef pointer = LLVMBuildAlloca(builder, LLVMInt32Type(), symbol.name);
                    LLVMValueRef initval=getinitvalue(ctx.initVal());
                    LLVMBuildStore(builder, initval, pointer);
                    symbol.reference=pointer;
                }
            }
            else{
                // TODO adding array to symbol table, no need in lab4
                assert(false);
            }
        }
        return symbol;
    }

    @Override
    public LLVMValueRef visit(ParseTree tree) {
        if (tree == null) return null;
        return tree.accept(this);
    }

    @Override
    public LLVMValueRef visitChildren(RuleNode node) {
        return super.visitChildren(node);
    }

    @Override
    public LLVMValueRef visitErrorNode(ErrorNode node) {
        return super.visitErrorNode(node);
    }

    @Override
    public LLVMValueRef visitTerminal(TerminalNode node) {
        return super.visitTerminal(node);
    }

}
