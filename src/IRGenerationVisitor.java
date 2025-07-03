import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.bytedeco.javacpp.PointerPointer;
import org.antlr.v4.runtime.tree.RuleNode;
import org.bytedeco.llvm.LLVM.*;
import semantic_check.*;

import java.util.*;

import static org.bytedeco.llvm.global.LLVM.*;

public class IRGenerationVisitor extends   SysYParserBaseVisitor<LLVMValueRef> {
    private final LLVMModuleRef module;
    private final LLVMBuilderRef builder;
    private static final LLVMTypeRef i32Type = LLVMInt32Type();
    private static final   LLVMValueRef zero = LLVMConstInt(i32Type, 0, /* signExtend */ 0);
    public static int while_stmt_count=0;
    public static int block_count=0;
    Boolean pointer_need_load=false;
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
    private LLVMTypeRef getLLVMArrayType(ArrayType type) {
        LLVMTypeRef base = LLVMInt32Type();
        List<Integer> dims = type.dimensions;
        for (int i = dims.size() - 1; i >= 0; --i) {
            base = LLVMArrayType(base, dims.get(i));
        }
        return base;
    }
    public void get_indicies(List<Integer> x,int ind,List<Integer> ans){
        int pos=ind%x.get(x.size()-1);
        int next_ind=(ind-pos)/x.get(x.size()-1);
        if(x.size()==1) ans.add(pos);
        else {
            get_indicies(x.subList(0,x.size()-1),next_ind,ans);
            ans.add(pos);
        }
    }
    void get_const_init_val(List<LLVMValueRef> ans, SysYParser.ConstInitValContext constInitValContext){
        if(constInitValContext.constExp()!=null){
            LLVMValueRef val = visitConstExp(constInitValContext.constExp());
            if (val != null && LLVMIsAConstantInt(val) != null) {
                long constVal = LLVMConstIntGetSExtValue(val); // 提取整数值（有符号）
                ans.add(LLVMConstInt(LLVMInt32Type(), constVal, 1));
            }
            else ans.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
        }
        else{
            for(int i=0;i<constInitValContext.constInitVal().size();i++){
                get_const_init_val(ans,constInitValContext.constInitVal(i));
            }
        }
    }
    private LLVMValueRef buildConstArrayInitializer(List<LLVMValueRef> flatVals, List<Integer> dims, int depth) {
        int dim = dims.get(depth);
        int stride = 1;
        for (int i = depth + 1; i < dims.size(); i++) {
            stride *= dims.get(i);
        }

        LLVMValueRef[] nested = new LLVMValueRef[dim];
        for (int i = 0; i < dim; i++) {
            if (depth == dims.size() - 1) {
                nested[i] = flatVals.get(i);
            } else {
                int start = i * stride;
                List<LLVMValueRef> sublist = flatVals.subList(start, start + stride);
                nested[i] = buildConstArrayInitializer(sublist, dims, depth + 1);
            }
        }

        LLVMTypeRef elemTy = (depth == dims.size() - 1)
                ? LLVMInt32Type()
                : getLLVMArrayType(new ArrayType(new IntType(), dims.subList(depth + 1, dims.size())));
        return LLVMConstArray(elemTy, new PointerPointer<>(nested), nested.length);
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
            List<Integer> dims = new ArrayList<>();
            for (SysYParser.NumberContext expCtx : ctx.number()) {
                int dimSize = Integer.decode(expCtx.INTEGER_CONST().getText());
                dims.add(dimSize);
            }
            symbol.type = new ArrayType(new IntType(), dims);
            if (!symbolTable.is_cur_scopeGlobal()) {
                LLVMValueRef pointer = LLVMBuildAlloca(builder, getLLVMArrayType((ArrayType)symbol.type), symbol.name);
                int totalSize=((ArrayType)symbol.type).getTotalSize();
                List<LLVMValueRef> init_val_list=new ArrayList<>();
                get_const_init_val(init_val_list,ctx.constInitVal());
                while(init_val_list.size()<totalSize){
                    init_val_list.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
                }
                for(int i=0;i<totalSize;i++){
                    List<LLVMValueRef> gepIndices = new ArrayList<>();
                    gepIndices.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
                    List<Integer>indices=new ArrayList<>();
                    get_indicies(((ArrayType)symbol.type).dimensions,i,indices);
                    for (int index : indices) {
                        gepIndices.add(LLVMConstInt(LLVMInt32Type(), index, 0));
                    }
                    LLVMValueRef elementPtr = LLVMBuildGEP(builder, pointer,
                            new PointerPointer<>(gepIndices.toArray(new LLVMValueRef[0])), gepIndices.size(), "elemPtr");
                    LLVMBuildStore(builder, init_val_list.get(i), elementPtr);
                }
                symbol.reference = pointer;
            } else {
                ArrayType arrayType = (ArrayType) symbol.type;
                LLVMTypeRef arrTy = getLLVMArrayType(arrayType);
                List<LLVMValueRef> initValList = new ArrayList<>();
                get_const_init_val(initValList, ctx.constInitVal());
                int totalSize = arrayType.getTotalSize();
                while (initValList.size() < totalSize) {
                    initValList.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
                }
                LLVMValueRef init = buildConstArrayInitializer(initValList, arrayType.dimensions, 0);
                LLVMValueRef globalPtr = LLVMAddGlobal(module, arrTy, symbol.name);
                LLVMSetInitializer(globalPtr, init);
                LLVMSetGlobalConstant(globalPtr, 1);
                symbol.reference = globalPtr;
            }
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
            if (ctx.funcRParams() != null) {
                args=getFuncRParams(ctx.funcRParams());
                argCount = ctx.funcRParams().param().size();
            }
            if( (((FunctionType)(symbolTable.get_name_matched_function(funcName).type)).getReturnType() ).toString().equals("void")){
                LLVMBuildCall(builder, function, args, argCount, "");
                return null;
            }
            return castToI32(LLVMBuildCall(builder, function, args, argCount, funcName));
        }
        else if (ctx.exp().size() == 1 && ctx.unaryOp() != null) {
            pointer_need_load=false;
            LLVMValueRef val = visit(ctx.exp(0));
            if (LLVMGetTypeKind(LLVMTypeOf(val)) == LLVMPointerTypeKind&&pointer_need_load) {
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
            pointer_need_load=false;
            LLVMValueRef left = visit(ctx.exp(0));
            if (LLVMGetTypeKind(LLVMTypeOf(left)) == LLVMPointerTypeKind&&pointer_need_load) {
                left = LLVMBuildLoad(builder, left, "load_left");
            }
            pointer_need_load=false;
            LLVMValueRef right = visit(ctx.exp(1));
            if (LLVMGetTypeKind(LLVMTypeOf(right)) == LLVMPointerTypeKind&&pointer_need_load) {
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
            pointer_need_load=false;
            LLVMValueRef value = visit(ctx.lVal());
            if (LLVMGetTypeKind(LLVMTypeOf(value)) ==LLVMPointerTypeKind&&pointer_need_load) {
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
                else if (x.type instanceof ArrayType) {
                    LLVMTypeRef arrTy = getLLVMArrayType((ArrayType) x.type);
                    paramTypeList.add(LLVMPointerType(arrTy, 0));
                }
                else throw new RuntimeException("Unsupported parameter type: " + x.type);
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
        List<Integer> dims = new ArrayList<>();
        for (SysYParser.NumberContext expCtx : ctx.number()) {
            int dimSize = Integer.decode(expCtx.INTEGER_CONST().getText());
            dims.add(dimSize);
        }
        if (ctx.L_BRACKT()!=null&&ctx.L_BRACKT().size() > 0) {
            type=new ArrayType(new IntType(), ctx.L_BRACKT().size());
            ((ArrayType)type).dimensions=new ArrayList<>(dims);
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
            pointer_need_load=false;
            LLVMValueRef argValue = visit(ctx.param(i));
            if (LLVMGetTypeKind(LLVMTypeOf(argValue)) == LLVMPointerTypeKind&&pointer_need_load) {
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
        return null;
    }

    @Override
    public LLVMValueRef visitLVal(SysYParser.LValContext ctx) {
        String name=ctx.IDENT().getText();
        Symbol s = symbolTable.get_name_matched_symbol(name);
        if(s.type instanceof IntType) {
            pointer_need_load=true;
            return s.reference;
        }
        else{
            List<LLVMValueRef> gepIndices = new ArrayList<>();
            gepIndices.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
            for (SysYParser.ExpContext expCtx : ctx.exp()) {
                LLVMValueRef idx = visit(expCtx);
                gepIndices.add(idx);
            }
            if ((ctx.exp().size() == ((ArrayType)s.type).dimensions.size()||ctx.exp().size() == ((ArrayType)s.type).dim)&&ctx.exp().size()!=0) {
                pointer_need_load = true;
            }
            LLVMValueRef elementPtr = LLVMBuildGEP(
                    builder,
                    s.reference,
                    new PointerPointer<>(gepIndices.toArray(new LLVMValueRef[0])),
                    gepIndices.size(),
                    "elemPtr"
            );
            return elementPtr;
        }
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
            pointer_need_load=false;
            LLVMValueRef left = visit(ctx.cond(0));
            if (LLVMGetTypeKind(LLVMTypeOf(left)) == LLVMPointerTypeKind&&pointer_need_load) {
                left = LLVMBuildLoad(builder, left, "load_left");
            }
            pointer_need_load=false;
            LLVMValueRef right = visit(ctx.cond(1));
            System.out.println("crzzz2");
            if(right==null)      System.out.println("crzzz1");
            if (LLVMGetTypeKind(LLVMTypeOf(right)) == LLVMPointerTypeKind&&pointer_need_load) {
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
            pointer_need_load=false;
            LLVMValueRef left = visit(ctx.cond(0));
            int predicate = (ctx.EQ() != null) ? LLVMIntEQ : LLVMIntNE;
            if (LLVMGetTypeKind(LLVMTypeOf(left)) == LLVMPointerTypeKind&&pointer_need_load) {
                left = LLVMBuildLoad(builder, left, "load_left");
            }
            pointer_need_load=false;
            LLVMValueRef right = visit(ctx.cond(1));
            if (LLVMGetTypeKind(LLVMTypeOf(right)) == LLVMPointerTypeKind&&pointer_need_load) {
                right = LLVMBuildLoad(builder, right, "load_right");
            }
            return  castToI32(LLVMBuildICmp(builder, predicate, left, right, "cmp"));
        }
        else if (ctx.AND() != null) {
            pointer_need_load=false;
            LLVMValueRef lhs = visit(ctx.cond(0));
            if (LLVMGetTypeKind(LLVMTypeOf(lhs)) == LLVMPointerTypeKind&&pointer_need_load) {
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
            pointer_need_load=false;
            LLVMValueRef rhs = visit(ctx.cond(1));
            if (LLVMGetTypeKind(LLVMTypeOf(rhs)) == LLVMPointerTypeKind&&pointer_need_load) {
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
            pointer_need_load=false;
            LLVMValueRef lhs = visit(ctx.cond(0));
            if (LLVMGetTypeKind(LLVMTypeOf(lhs)) == LLVMPointerTypeKind&&pointer_need_load) {
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
            pointer_need_load=false;
            LLVMValueRef rhs = visit(ctx.cond(1));
            if (LLVMGetTypeKind(LLVMTypeOf(rhs)) == LLVMPointerTypeKind&&pointer_need_load) {
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
                    pointer_need_load=false;
                    returnValue = visit(ctx.exp());
                    if (LLVMGetTypeKind(LLVMTypeOf(returnValue)) == LLVMPointerTypeKind&&pointer_need_load) {
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
            AbstractMap.SimpleEntry<LLVMBasicBlockRef, LLVMBasicBlockRef> x=symbolTable.get_current_while();
            LLVMBuildBr(builder, x.getValue());
        }
        else if(ctx.CONTINUE()!=null){
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
    void get_init_val(List<LLVMValueRef> ans, SysYParser.InitValContext InitValContext){
        if(InitValContext.exp()!=null){
            LLVMValueRef val = visitExp(InitValContext.exp());
            if (val != null && LLVMIsAConstantInt(val) != null) {
                long constVal = LLVMConstIntGetSExtValue(val); // 提取整数值（有符号）
                ans.add(LLVMConstInt(LLVMInt32Type(), constVal, 1));
            }
            else ans.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
        }
        else{
            for(int i=0;i<InitValContext.initVal().size();i++){
                get_init_val(ans,InitValContext.initVal(i));
            }
        }
    }
    public Symbol getVardef(SysYParser.VarDefContext ctx) {
        Symbol symbol=new Symbol();
        symbol.name=ctx.IDENT().getText();
        if(ctx.initVal()==null) {
            if(ctx.L_BRACKT().isEmpty()) {
                symbol.type = new IntType();
                LLVMValueRef pointer;
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
                List<Integer> dims = new ArrayList<>();
                for (SysYParser.NumberContext expCtx : ctx.number()) {
                    int dimSize = Integer.decode(expCtx.INTEGER_CONST().getText());
                    dims.add(dimSize);
                }
                symbol.type = new ArrayType(new IntType(), dims);
                if(symbolTable.is_cur_scopeGlobal()) {
                    ArrayType arrayType = (ArrayType) symbol.type;
                    LLVMTypeRef arrTy = getLLVMArrayType(arrayType);
                    List<LLVMValueRef> initValList = new ArrayList<>();
                    int totalSize = arrayType.getTotalSize();
                    while (initValList.size() < totalSize) {
                        initValList.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
                    }
                    LLVMValueRef init = buildConstArrayInitializer(initValList, arrayType.dimensions, 0);
                    LLVMValueRef globalPtr = LLVMAddGlobal(module, arrTy, symbol.name);
                    LLVMSetInitializer(globalPtr, init);
                    symbol.reference = globalPtr;
                }
                else{
                    LLVMValueRef pointer = LLVMBuildAlloca(builder, getLLVMArrayType((ArrayType)symbol.type), symbol.name);
                    int totalSize=((ArrayType)symbol.type).getTotalSize();
                    List<LLVMValueRef> init_val_list=new ArrayList<>();
                    while(init_val_list.size()<totalSize){
                        init_val_list.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
                    }
                    for(int i=0;i<totalSize;i++){
                        List<LLVMValueRef> gepIndices = new ArrayList<>();
                        gepIndices.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
                        List<Integer>indices=new ArrayList<>();
                        get_indicies(((ArrayType)symbol.type).dimensions,i,indices);
                        for (int index : indices) {
                            gepIndices.add(LLVMConstInt(LLVMInt32Type(), index, 0));
                        }
                        LLVMValueRef elementPtr = LLVMBuildGEP(builder, pointer,
                                new PointerPointer<>(gepIndices.toArray(new LLVMValueRef[0])), gepIndices.size(), "elemPtr");
                        LLVMBuildStore(builder, init_val_list.get(i), elementPtr);
                    }
                    symbol.reference = pointer;
                }
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
                List<Integer> dims = new ArrayList<>();
                for (SysYParser.NumberContext expCtx : ctx.number()) {
                    int dimSize = Integer.decode(expCtx.INTEGER_CONST().getText());
                    dims.add(dimSize);
                }
                symbol.type = new ArrayType(new IntType(), dims);
                if(symbolTable.is_cur_scopeGlobal()) {
                    ArrayType arrayType = (ArrayType) symbol.type;
                    LLVMTypeRef arrTy = getLLVMArrayType(arrayType);
                    List<LLVMValueRef> initValList = new ArrayList<>();
                    int totalSize = arrayType.getTotalSize();
                    get_init_val(initValList,ctx.initVal());
                    while (initValList.size() < totalSize) {
                        initValList.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
                    }
                    LLVMValueRef init = buildConstArrayInitializer(initValList, arrayType.dimensions, 0);
                    LLVMValueRef globalPtr = LLVMAddGlobal(module, arrTy, symbol.name);
                    LLVMSetInitializer(globalPtr, init);
                    symbol.reference = globalPtr;
                }
                else{
                    LLVMValueRef pointer = LLVMBuildAlloca(builder, getLLVMArrayType((ArrayType)symbol.type), symbol.name);
                    int totalSize=((ArrayType)symbol.type).getTotalSize();
                    List<LLVMValueRef> init_val_list=new ArrayList<>();
                    get_init_val(init_val_list,ctx.initVal());
                    while(init_val_list.size()<totalSize){
                        init_val_list.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
                    }
                    for(int i=0;i<totalSize;i++){
                        List<LLVMValueRef> gepIndices = new ArrayList<>();
                        gepIndices.add(LLVMConstInt(LLVMInt32Type(), 0, 0));
                        List<Integer>indices=new ArrayList<>();
                        get_indicies(((ArrayType)symbol.type).dimensions,i,indices);
                        for (int index : indices) {
                            gepIndices.add(LLVMConstInt(LLVMInt32Type(), index, 0));
                        }
                        LLVMValueRef elementPtr = LLVMBuildGEP(builder, pointer,
                                new PointerPointer<>(gepIndices.toArray(new LLVMValueRef[0])), gepIndices.size(), "elemPtr");
                        LLVMBuildStore(builder, init_val_list.get(i), elementPtr);
                    }
                    symbol.reference = pointer;
                }
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
