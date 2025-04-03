import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.RuleNode;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.bytedeco.javacpp.PointerPointer;
import org.bytedeco.llvm.LLVM.*;
import static org.bytedeco.llvm.global.LLVM.*;

public class IRGenerationVisitor extends   SysYParserBaseVisitor<LLVMValueRef> {
    private final LLVMModuleRef module;
    private final LLVMBuilderRef builder;
    public IRGenerationVisitor(LLVMModuleRef module, LLVMBuilderRef builder) {
        this.module = module;
        this.builder = builder;
    }
    @Override
    public LLVMValueRef visitDecl(SysYParser.DeclContext ctx) {
        return super.visitDecl(ctx);
    }

    @Override
    public LLVMValueRef visitBlock(SysYParser.BlockContext ctx) {
        for (SysYParser.BlockItemContext blockItem : ctx.blockItem()) {
                visit(blockItem);
        }
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
        System.out.println("crzzz");

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
        return super.visitConstDecl(ctx);
    }

    @Override
    public LLVMValueRef visitConstDef(SysYParser.ConstDefContext ctx) {
        return super.visitConstDef(ctx);
    }

    @Override
    public LLVMValueRef visitConstExp(SysYParser.ConstExpContext ctx) {
        return super.visitConstExp(ctx);
    }

    @Override
    public LLVMValueRef visitConstInitVal(SysYParser.ConstInitValContext ctx) {
        return super.visitConstInitVal(ctx);
    }

    @Override
    public LLVMValueRef visitExp(SysYParser.ExpContext ctx) {
        if (ctx.number() != null) return visit(ctx.number());
        if (ctx.exp().size() == 1 && ctx.unaryOp() != null) {
            LLVMValueRef val = visit(ctx.exp(0));
            switch (ctx.unaryOp().getText()) {
                case "-" :return LLVMBuildNeg(builder, val, "neg");
                case "!" :return LLVMBuildICmp(builder, LLVMIntEQ, val, LLVMConstInt(LLVMInt32Type(), 0, 0), "not");
                case "+" :return val;
                default :return null;
            }
        }
        if (ctx.exp().size() == 2) {
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
        return null;
    }

    @Override
    public LLVMValueRef visitFuncDef(SysYParser.FuncDefContext ctx) {
        if (!ctx.IDENT().getText().equals("main")) {
            throw new RuntimeException("Only 'main' function is supported.");
        }
        String funcName = ctx.IDENT().getText();
        LLVMTypeRef returnType = LLVMInt32Type();
        PointerPointer<LLVMTypeRef> paramTypes = new PointerPointer<>(0);
        LLVMTypeRef funcType = LLVMFunctionType(returnType, paramTypes, 0, 0);
        LLVMValueRef function = LLVMAddFunction(module, funcName, funcType);
        LLVMBasicBlockRef entry = LLVMAppendBasicBlock(function, funcName + "Entry");
        LLVMPositionBuilderAtEnd(builder, entry);
        visit(ctx.block());
        return null;
    }

    @Override
    public LLVMValueRef visitFuncFParam(SysYParser.FuncFParamContext ctx) {
        return super.visitFuncFParam(ctx);
    }

    @Override
    public LLVMValueRef visitFuncFParams(SysYParser.FuncFParamsContext ctx) {
        return super.visitFuncFParams(ctx);
    }

    @Override
    public LLVMValueRef visitFuncRParams(SysYParser.FuncRParamsContext ctx) {
        return super.visitFuncRParams(ctx);
    }

    @Override
    public LLVMValueRef visitFuncType(SysYParser.FuncTypeContext ctx) {
        return super.visitFuncType(ctx);
    }

    @Override
    public LLVMValueRef visitInitVal(SysYParser.InitValContext ctx) {
        return super.visitInitVal(ctx);
    }

    @Override
    public LLVMValueRef visitLVal(SysYParser.LValContext ctx) {
        return super.visitLVal(ctx);
    }

    @Override
    public LLVMValueRef visitNumber(SysYParser.NumberContext ctx) {
        int value = Integer.decode(ctx.INTEGER_CONST().getText());
        return LLVMConstInt(LLVMInt32Type(), value, 0);
    }

    @Override
    public LLVMValueRef visitParam(SysYParser.ParamContext ctx) {
        return super.visitParam(ctx);
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
                LLVMBuildRet(builder, returnValue);
            }
            else  LLVMBuildRetVoid(builder);
        }
        return null;
    }


    @Override
    public LLVMValueRef visitVarDecl(SysYParser.VarDeclContext ctx) {
        return super.visitVarDecl(ctx);
    }

    @Override
    public LLVMValueRef visitVarDef(SysYParser.VarDefContext ctx) {
        return super.visitVarDef(ctx);
    }

    @Override
    protected LLVMValueRef aggregateResult(LLVMValueRef aggregate, LLVMValueRef nextResult) {
        return super.aggregateResult(aggregate, nextResult);
    }

    @Override
    protected LLVMValueRef defaultResult() {
        return super.defaultResult();
    }

    @Override
    protected boolean shouldVisitNextChild(RuleNode node, LLVMValueRef currentResult) {
        return super.shouldVisitNextChild(node, currentResult);
    }

    @Override
    public LLVMValueRef visit(ParseTree tree) {
        return null;
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
