

import org.bytedeco.javacpp.PointerPointer;
import org.bytedeco.llvm.LLVM.LLVMBasicBlockRef;
import org.bytedeco.llvm.LLVM.LLVMValueRef;

import javax.swing.plaf.PanelUI;
import java.util.*;

public class SymbolTable {
    private Stack<List<Symbol>> scopeStack;
    private Stack<loop_stored_element> is_while_scope;
    public SymbolTable() {
        scopeStack = new Stack<>();
        is_while_scope=new Stack<>();
        enterScope(); // 初始化全局作用域
    }

    // 进入新作用域
    public void enterScope() {
        scopeStack.push(new ArrayList<>());
        is_while_scope.push(null);
    }
    public void enterScope(LLVMBasicBlockRef condblock,LLVMBasicBlockRef mergeblock) {
        scopeStack.push(new ArrayList<>());
        is_while_scope.push(new loop_stored_element(condblock,mergeblock,null));
    }
    public void enterScope(LLVMBasicBlockRef condblock,LLVMBasicBlockRef mergeblock,SysYParser.StmtContext ctx) {
        scopeStack.push(new ArrayList<>());
        is_while_scope.push(new loop_stored_element(condblock,mergeblock,ctx));
    }
    // 退出当前作用域
    public void exitScope() {
        if (!scopeStack.isEmpty()) {
            scopeStack.pop();
        }
        if(!is_while_scope.isEmpty()){
            is_while_scope.pop();
        }
    }

    // 在当前作用域添加符号
    public void put(Symbol symbol) {
        if (!scopeStack.isEmpty()) {
            scopeStack.peek().add(symbol);
        }
    }
    // 查找符号类型（从当前作用域向外层作用域查找）
    public boolean cur_scope_has_same_symbol(String name) {
            List<Symbol> curScope=scopeStack.get( scopeStack.size() - 1);
            //System.err.println(curScope.size());
            for(int j=0;j<curScope.size();j++)
            {
                if(curScope.get(j).name.equals(name)) return true;
            }
        return false; // 未找到
    }
    public boolean isGlobal(String name) {
        if (scopeStack.isEmpty()) return false;
        List<Symbol> Globalscope= scopeStack.get(0);
        for(int j=0;j<Globalscope.size();j++)
        {
            if(Globalscope.get(j).name.equals(name)) return true;
        }
        return false;
    }
    public Symbol get_name_matched_symbol(String name) {
        if (scopeStack.isEmpty()) return null;
        for(int i=scopeStack.size()-1;i>=0;i--){
            List<Symbol> Globalscope= scopeStack.get(i);
            for(int j=0;j<Globalscope.size();j++)
            {
                if(Objects.equals(Globalscope.get(j).name, name) ) return Globalscope.get(j);
            }
        }
        return null;
    }
    public Symbol get_name_matched_function(String name) {
        if (scopeStack.isEmpty()) return null;
        List<Symbol> Globalscope= scopeStack.get(0);
            for(int j=0;j<Globalscope.size();j++)
            {
                if(Objects.equals(Globalscope.get(j).name, name) ) return Globalscope.get(j);
            }
        return null;
    }
    public void addGlobal(Symbol symbol) {
        List<Symbol> Globalscope= scopeStack.get(0);
        Globalscope.add(symbol);
    }
    public boolean is_cur_scopeGlobal(){
        return scopeStack.size()==1;
    }
    public Type get_cur_scope_return_type(){
        List<Symbol> Globalscope= scopeStack.get(0);
        assert(Globalscope.get(Globalscope.size()-1).type instanceof FunctionType);
        assert (((FunctionType)Globalscope.get(Globalscope.size()-1).type).getReturnType() instanceof VoidType || ((FunctionType)Globalscope.get(Globalscope.size()-1).type).getReturnType() instanceof IntType);
        return ((FunctionType)Globalscope.get(Globalscope.size()-1).type).getReturnType();
    }
    public LLVMValueRef get_cur_scope_func(){
        List<Symbol> Globalscope= scopeStack.get(0);
        assert(Globalscope.get(Globalscope.size()-1).type instanceof FunctionType);
        assert (((FunctionType)Globalscope.get(Globalscope.size()-1).type).getReturnType() instanceof VoidType || ((FunctionType)Globalscope.get(Globalscope.size()-1).type).getReturnType() instanceof IntType);
        return (Globalscope.get(Globalscope.size()-1).reference);
    }
    public  loop_stored_element get_current_while(){
        for(int i=is_while_scope.size()-1;i>=0;i--){
            if(is_while_scope.get(i)!=null) return is_while_scope.get(i);
        }
        assert(false);
        return null;
    }
}