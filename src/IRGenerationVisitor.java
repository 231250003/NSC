import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.RuleNode;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.bytedeco.javacpp.Pointer;
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
    public static int while_stmt_count=0;
    public static int if_stmt_count=0;
    public static int break_count=0,continue_count=0,block_count=0;
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
    public Void visit_block(SysYParser.BlockContext ctx,LLVMBasicBlockRef condblock,LLVMBasicBlockRef mergeblock) {
        block_count++;
        ParseTree parent = ctx.getParent();
        if ((parent instanceof SysYParser.StmtContext)) {
            SysYParser.StmtContext stmtCtx = (SysYParser.StmtContext) parent;
            ParseTree grandparent = stmtCtx.getParent();
            if (grandparent instanceof SysYParser.StmtContext)
            {
                SysYParser.StmtContext whileStmt = (SysYParser.StmtContext) grandparent;
                if (whileStmt.WHILE() != null) {
                    if (whileStmt.stmt(0) == stmtCtx) {
                        symbolTable.enterScope(condblock,mergeblock);
                    } else {
                        symbolTable.enterScope();
                    }
                }
                else {
                    symbolTable.enterScope();
                }
            }
            else {
                symbolTable.enterScope();
            }
        }
        else symbolTable.enterScope();
        for(int i=0;i<ctx.blockItem().size();i++){
            visit(ctx.blockItem(i));
        }
        symbolTable.exitScope();
        return null;
    }
    public Void visit_block(SysYParser.BlockContext ctx) {
        block_count++;
        symbolTable.enterScope();
        for(int i=0;i<ctx.blockItem().size();i++){
            visit(ctx.blockItem(i));
        }
        symbolTable.exitScope();
        return null;
    }
    public Void visit_block(SysYParser.BlockContext ctx, List<Symbol> symbols) {
        block_count++;
        symbolTable.enterScope();
        if(symbols!=null){
            LLVMValueRef function=symbolTable.get_cur_scope_func();
            int paramCount = LLVMCountParams(function);
            for (int i = 0; i < paramCount; i++) {
                LLVMValueRef param = LLVMGetParam(function, i);
                LLVMTypeRef paramType = LLVMTypeOf(param);
                LLVMValueRef paramAddr = LLVMBuildAlloca(builder, paramType, "param" + i + "_addr");
                LLVMBuildStore(builder, param, paramAddr);
                Symbol symbol = symbols.get(i);
                symbol.reference = paramAddr;
            }
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
    private LLVMValueRef castToI32(LLVMValueRef val) {
        LLVMTypeRef type = LLVMTypeOf(val);
        if (LLVMGetTypeKind(type) == LLVMIntegerTypeKind && LLVMGetIntTypeWidth(type) == 1) {
            return LLVMBuildZExt(builder, val, LLVMInt32Type(), "zext_to_i32");
        }
        return val;
    }
    @Override
    public LLVMValueRef visitExp(SysYParser.ExpContext ctx) {
        if (ctx.number() != null) return visit(ctx.number());
        else if (ctx.IDENT() != null && ctx.L_PAREN() != null) {
            String funcName = ctx.IDENT().getText();
            LLVMValueRef function = LLVMGetNamedFunction(module, funcName);
            if (function == null) {
                throw new RuntimeException("Undefined function: " + funcName);
            }
            PointerPointer<LLVMValueRef> args = new PointerPointer<>(0);;
            int argCount = 0;
//            symbolTable.enterScope();
            if (ctx.funcRParams() != null) {
                args=getFuncRParams(ctx.funcRParams());
                argCount = ctx.funcRParams().param().size();
//                symbolTable.set_r_params(funcName,args);
            }
            if( (((FunctionType)(symbolTable.get_name_matched_function(funcName).type)).getReturnType() ).toString().equals("void")){
                LLVMBuildCall(builder, function, args, argCount, "");
                //symbolTable.exitScope();
                return null;
            }
            //symbolTable.exitScope();
            return castToI32(LLVMBuildCall(builder, function, args, argCount, funcName));
        }
        else if (ctx.exp().size() == 1 && ctx.unaryOp() != null) {
            LLVMValueRef val = visit(ctx.exp(0));
            if (LLVMGetTypeKind(LLVMTypeOf(val)) == LLVMPointerTypeKind) {
                val = LLVMBuildLoad(builder, val, "load_val");
            }
            switch (ctx.unaryOp().getText()) {
                case "-" :return castToI32(LLVMBuildNeg(builder, val, "neg"));
                case "!" :return castToI32(LLVMBuildICmp(builder, LLVMIntEQ, val, LLVMConstInt(LLVMInt32Type(), 0, 0), "not"));
                case "+" :return castToI32(val);
                default :return null;
            }
        }
        else if (ctx.exp().size() == 2) {
            LLVMValueRef left = visit(ctx.exp(0));
            LLVMValueRef right = visit(ctx.exp(1));
            if (LLVMGetTypeKind(LLVMTypeOf(left)) == LLVMPointerTypeKind) {
                left = LLVMBuildLoad(builder, left, "load_left");
            }
            if (LLVMGetTypeKind(LLVMTypeOf(right)) == LLVMPointerTypeKind) {
                right = LLVMBuildLoad(builder, right, "load_right");
            }
            switch (ctx.getChild(1).getText()) {
                 case "+" : return castToI32(LLVMBuildAdd(builder, left, right, "add"));
                 case "-" :return castToI32(LLVMBuildSub(builder, left, right, "sub"));
                 case "*" :return  castToI32(LLVMBuildMul(builder, left, right, "mul"));
                 case "/" :return castToI32(LLVMBuildSDiv(builder, left, right, "div"));
                 case "%" :return castToI32(LLVMBuildSRem(builder, left, right, "mod"));
                 default :return null;
            }
        }
        else if(ctx.L_PAREN()!=null&&ctx.exp()!=null){
            return castToI32(visit(ctx.exp(0)));
        }
        else if(ctx.lVal()!=null){
            LLVMValueRef value = visit(ctx.lVal());
            if (LLVMGetTypeKind(LLVMTypeOf(value)) ==LLVMPointerTypeKind) {
                return castToI32(LLVMBuildLoad(builder, value, "load_lval"));
            } else {
                return castToI32(value);
            }
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
        }
        LLVMBasicBlockRef entry = LLVMAppendBasicBlock(function, funcName + "Entry");
        LLVMPositionBuilderAtEnd(builder, entry);

        FunctionType functionType = new FunctionType(retType, params);
        symbolTable.addGlobal(new Symbol(funcName,functionType,function));
        visit_block(ctx.block(),params);
        if(retType.toString().equals("void"))  LLVMBuildRetVoid(builder);
        if (LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(builder)) == null) {
            LLVMBuildUnreachable(builder);
        }
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
        //LLVMValueRef func =symbolTable.get_cur_scope_func();
        String name=ctx.IDENT().getText();
//        int paramCount = LLVMCountParams(func);
//        for (int i = 0; i < paramCount; i++) {
//            //System.err.println("crzzz");
//            LLVMValueRef param = LLVMGetParam(func, i);
//            //System.err.println(LLVMGetValueName(param).getString());
//            if (LLVMGetValueName(param).getString().equals(name)) {
//                return param;
//            }
//        }
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
    public LLVMValueRef visitCond(SysYParser.CondContext ctx) {
        if(ctx.exp()!=null){
            LLVMValueRef value = visit(ctx.exp());
            return castToI32(value);
        }
        else if (ctx.LT() != null || ctx.GT() != null || ctx.LE() != null || ctx.GE() != null) {
            // 处理 <, >, <=, >=
            LLVMValueRef left = visit(ctx.cond(0));
            LLVMValueRef right = visit(ctx.cond(1));
            if (LLVMGetTypeKind(LLVMTypeOf(left)) == LLVMPointerTypeKind) {
                left = LLVMBuildLoad(builder, left, "load_left");
            }
            if (LLVMGetTypeKind(LLVMTypeOf(right)) == LLVMPointerTypeKind) {
                right = LLVMBuildLoad(builder, right, "load_right");
            }
            int predicate;
            if (ctx.LT() != null) {
                predicate = LLVMIntSLT;
            } else if (ctx.GT() != null) {
                predicate = LLVMIntSGT;
            } else if (ctx.LE() != null) {
                predicate = LLVMIntSLE;
            } else {
                predicate = LLVMIntSGE;
            }
            return castToI32(LLVMBuildICmp(builder, predicate, left, right, "cmp"));
        }
        else if (ctx.EQ() != null || ctx.NEQ() != null) {
            LLVMValueRef left = visit(ctx.cond(0));
            LLVMValueRef right = visit(ctx.cond(1));
            int predicate = (ctx.EQ() != null) ? LLVMIntEQ : LLVMIntNE;
            if (LLVMGetTypeKind(LLVMTypeOf(left)) == LLVMPointerTypeKind) {
                left = LLVMBuildLoad(builder, left, "load_left");
            }
            if (LLVMGetTypeKind(LLVMTypeOf(right)) == LLVMPointerTypeKind) {
                right = LLVMBuildLoad(builder, right, "load_right");
            }
            return  castToI32(LLVMBuildICmp(builder, predicate, left, right, "cmp"));
        }
        else if (ctx.AND() != null) {
            LLVMValueRef lhs = visit(ctx.cond(0));
            if (LLVMGetTypeKind(LLVMTypeOf(lhs)) == LLVMPointerTypeKind) {
                lhs = LLVMBuildLoad(builder, lhs, "load_lhs");
            }
            if (LLVMGetTypeKind(LLVMTypeOf(lhs)) == LLVMIntegerTypeKind &&
                    LLVMGetIntTypeWidth(LLVMTypeOf(lhs)) == 32) {
                lhs = LLVMBuildICmp(builder, LLVMIntNE, lhs,
                        LLVMConstInt(LLVMInt32Type(), 0, 0), "lhs_bool");
            }
           // lhs = LLVMBuildICmp(builder, LLVMIntNE, lhs, LLVMConstInt(LLVMInt1Type(), 0, 0), "lhs_bool");

            // block 准备
            LLVMBasicBlockRef current = LLVMGetInsertBlock(builder);
            LLVMValueRef function = LLVMGetBasicBlockParent(current);
            LLVMBasicBlockRef rhsBlock = LLVMAppendBasicBlock(function, "and.rhs");
            LLVMBasicBlockRef mergeBlock = LLVMAppendBasicBlock(function, "and.merge");

            // 如果 lhs 为 true，跳转 rhs；否则跳 merge（结果为 false）
            LLVMBuildCondBr(builder, lhs, rhsBlock, mergeBlock);

            // ===== rhs block =====
            LLVMPositionBuilderAtEnd(builder, rhsBlock);
            LLVMValueRef rhs = visit(ctx.cond(1));
            if (LLVMGetTypeKind(LLVMTypeOf(rhs)) == LLVMPointerTypeKind) {
                rhs = LLVMBuildLoad(builder, rhs, "load_rhs");
            }
            if (LLVMGetTypeKind(LLVMTypeOf(rhs)) == LLVMIntegerTypeKind &&
                    LLVMGetIntTypeWidth(LLVMTypeOf(rhs)) == 32) {
                rhs = LLVMBuildICmp(builder, LLVMIntNE, rhs,
                        LLVMConstInt(LLVMInt32Type(), 0, 0), "rhs_bool");
            }
            //rhs = LLVMBuildICmp(builder, LLVMIntNE, rhs, LLVMConstInt(LLVMInt1Type(), 0, 0), "rhs_bool");
            LLVMBuildBr(builder, mergeBlock);
            LLVMBasicBlockRef rhsBlockFinal = LLVMGetInsertBlock(builder);

            LLVMPositionBuilderAtEnd(builder, mergeBlock);
            LLVMValueRef phi = LLVMBuildPhi(builder, LLVMInt1Type(), "and_result");

            LLVMValueRef[] incomingValues = new LLVMValueRef[] {
                    LLVMConstInt(LLVMInt1Type(), 0, 0),
                    rhs
            };

            LLVMBasicBlockRef[] incomingBlocks = new LLVMBasicBlockRef[] {
                    current,
                    rhsBlockFinal
            };

            LLVMAddIncoming(phi,
                    new PointerPointer<>(incomingValues),
                    new PointerPointer<>(incomingBlocks),
                    incomingValues.length);
            return castToI32(phi);
        }
        else if (ctx.OR() != null) {
            LLVMValueRef lhs = visit(ctx.cond(0));
            if (LLVMGetTypeKind(LLVMTypeOf(lhs)) == LLVMPointerTypeKind) {
                lhs = LLVMBuildLoad(builder, lhs, "load_lhs");
            }
            if (LLVMGetTypeKind(LLVMTypeOf(lhs)) == LLVMIntegerTypeKind &&
                    LLVMGetIntTypeWidth(LLVMTypeOf(lhs)) == 32) {
                lhs = LLVMBuildICmp(builder, LLVMIntNE, lhs,
                        LLVMConstInt(LLVMInt32Type(), 0, 0), "lhs_bool");
            }
            //lhs = LLVMBuildICmp(builder, LLVMIntNE, lhs, LLVMConstInt(LLVMInt1Type(), 0, 0), "lhs_bool");

            LLVMBasicBlockRef current = LLVMGetInsertBlock(builder);
            LLVMValueRef function = LLVMGetBasicBlockParent(current);

            LLVMBasicBlockRef rhsBlock = LLVMAppendBasicBlock(function, "or.rhs");
            LLVMBasicBlockRef mergeBlock = LLVMAppendBasicBlock(function, "or.merge");

            LLVMBuildCondBr(builder, lhs, mergeBlock, rhsBlock);

            // === 右侧块 ===
            LLVMPositionBuilderAtEnd(builder, rhsBlock);
            LLVMValueRef rhs = visit(ctx.cond(1));
            if (LLVMGetTypeKind(LLVMTypeOf(rhs)) == LLVMPointerTypeKind) {
                rhs = LLVMBuildLoad(builder, rhs, "load_rhs");
            }
            if (LLVMGetTypeKind(LLVMTypeOf(rhs)) == LLVMIntegerTypeKind &&
                    LLVMGetIntTypeWidth(LLVMTypeOf(rhs)) == 32) {
                rhs = LLVMBuildICmp(builder, LLVMIntNE, rhs,
                        LLVMConstInt(LLVMInt32Type(), 0, 0), "rhs_bool");
            }
            //rhs = LLVMBuildICmp(builder, LLVMIntNE, rhs, LLVMConstInt(LLVMInt1Type(), 0, 0), "rhs_bool");
            LLVMBuildBr(builder, mergeBlock);
            LLVMBasicBlockRef rhsBlockFinal = LLVMGetInsertBlock(builder); // 获取真实终点（用于 phi）

            LLVMPositionBuilderAtEnd(builder, mergeBlock);
            LLVMValueRef phi = LLVMBuildPhi(builder, LLVMInt1Type(), "or_result");

            LLVMValueRef[] incomingValues = new LLVMValueRef[] {
                    LLVMConstInt(LLVMInt1Type(), 1, 0),
                    rhs
            };
            LLVMBasicBlockRef[] incomingBlocks = new LLVMBasicBlockRef[] {
                    current,
                    rhsBlockFinal
            };

            LLVMAddIncoming(phi,
                    new PointerPointer<>(incomingValues),
                    new PointerPointer<>(incomingBlocks),
                    incomingValues.length);

            return castToI32(phi);
        }
        else return null;
    }
    @Override
    public LLVMValueRef visitStmt(SysYParser.StmtContext ctx) {
        if (ctx.RETURN() != null) {
            LLVMValueRef returnValue;
            if(ctx.exp() != null || symbolTable.get_cur_scope_return_type() instanceof IntType){
                if(ctx.exp()!=null) {
                    returnValue = visit(ctx.exp());
                    if (LLVMGetTypeKind(LLVMTypeOf(returnValue)) == LLVMPointerTypeKind) {
                        returnValue = LLVMBuildLoad(builder, returnValue, "load_return");
                    }
                }
                else returnValue=zero;
                LLVMBuildRet(builder, returnValue);
            }
            else   LLVMBuildRetVoid(builder);
        }
        else if(ctx.ASSIGN()!=null){
            LLVMValueRef x=visitLVal(ctx.lVal());
            LLVMValueRef y=visitExp(ctx.exp());
            LLVMBuildStore(builder, y, x);
        }
        else if(ctx.exp()!=null){
            visitExp(ctx.exp());
        }
        else if(ctx.block()!=null){
            visit_block(ctx.block());
        }
        else if(ctx.IF()!=null){
            if_stmt_count++;
            LLVMValueRef function = symbolTable.get_cur_scope_func();
            LLVMBasicBlockRef mergeBlock = LLVMAppendBasicBlock(function, "merge");
            LLVMPositionBuilderAtEnd(builder, LLVMGetInsertBlock(builder));
            LLVMValueRef firstCond = visitCond(ctx.cond());
            LLVMBasicBlockRef thenBlock = LLVMAppendBasicBlock(function, "if.then");
            LLVMBasicBlockRef elseBlock = null;
            if (ctx.ELSE() != null) {
                elseBlock = LLVMAppendBasicBlock(function, "if.else");
            }
            LLVMTypeRef condType = LLVMTypeOf(firstCond);
            if (LLVMGetTypeKind(condType) != LLVMIntegerTypeKind || LLVMGetIntTypeWidth(condType) != 1) {
                firstCond = LLVMBuildICmp(builder, LLVMIntNE, firstCond, LLVMConstInt(condType, 0, 0), "to_bool");
            }
            LLVMBuildCondBr(builder, firstCond, thenBlock, elseBlock == null ? mergeBlock : elseBlock);
            LLVMPositionBuilderAtEnd(builder, thenBlock);
            visit(ctx.stmt(0));
            LLVMBuildBr(builder, mergeBlock);
            if (elseBlock != null) {
                LLVMPositionBuilderAtEnd(builder, elseBlock);
                visit(ctx.stmt(1));
               LLVMBuildBr(builder, mergeBlock);
            }
            LLVMPositionBuilderAtEnd(builder, mergeBlock);
        }
        else if(ctx.WHILE()!=null){
            while_stmt_count++;
            LLVMValueRef function = symbolTable.get_cur_scope_func();
            LLVMBasicBlockRef mergeBlock = LLVMAppendBasicBlock(function, "cur");
            LLVMBasicBlockRef thenBlock = LLVMAppendBasicBlock(function, "while.stmt");
            LLVMBasicBlockRef condBlock = LLVMAppendBasicBlock(function, "while.cond");
            LLVMBuildBr(builder,condBlock);
            LLVMPositionBuilderAtEnd(builder, condBlock);
            LLVMValueRef firstCond = visitCond(ctx.cond());
            LLVMTypeRef condType = LLVMTypeOf(firstCond);
            if (LLVMGetTypeKind(condType) != LLVMIntegerTypeKind || LLVMGetIntTypeWidth(condType) != 1) {
                firstCond = LLVMBuildICmp(builder, LLVMIntNE, firstCond, LLVMConstInt(condType, 0, 0), "to_bool");
            }
            LLVMBuildCondBr(builder, firstCond, thenBlock,mergeBlock);
            LLVMPositionBuilderAtEnd(builder, thenBlock);
            if(ctx.stmt(0).block()!=null){
                //System.err.println("1234");
                visit_block(ctx.stmt(0).block(),condBlock,mergeBlock);
            }
            else  visit(ctx.stmt(0));
            LLVMBuildBr(builder, condBlock);
            LLVMPositionBuilderAtEnd(builder, mergeBlock);
        }
        else if(ctx.BREAK()!=null){
            break_count++;
            AbstractMap.SimpleEntry<LLVMBasicBlockRef, LLVMBasicBlockRef> x=symbolTable.get_current_while();
            LLVMBuildBr(builder, x.getValue());
        }
        else if(ctx.CONTINUE()!=null){
            continue_count++;
            AbstractMap.SimpleEntry<LLVMBasicBlockRef, LLVMBasicBlockRef> x=symbolTable.get_current_while();
            LLVMBuildBr(builder, x.getKey());
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
                   // LLVMValueRef undefVal = LLVMGetUndef(i32Type);
                    LLVMBuildStore(builder, LLVMConstInt(i32Type, 64, /* signExtend */ 0), pointer);
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
