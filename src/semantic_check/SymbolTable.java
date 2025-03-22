package semantic_check;

import javax.swing.plaf.PanelUI;
import java.util.*;

public class SymbolTable {
    private Stack<List<Symbol>> scopeStack;

    public SymbolTable() {
        scopeStack = new Stack<>();
        enterScope(); // 初始化全局作用域
    }

    // 进入新作用域
    public void enterScope() {
        scopeStack.push(new ArrayList<>());
    }

    // 退出当前作用域
    public void exitScope() {
        if (!scopeStack.isEmpty()) {
            scopeStack.pop();
        }
    }

    // 在当前作用域添加符号
    public void put(Symbol symbol) {
        if (!scopeStack.isEmpty()) {
            scopeStack.peek().add(symbol);
            System.out.println( scopeStack.peek().size());
        }
    }

    // 查找符号类型（从当前作用域向外层作用域查找）
    public boolean cur_scope_has_same_symbol(String name) {
            List<Symbol> curScope=scopeStack.get( scopeStack.size() - 1);
            System.err.println(curScope.size());
            for(int j=0;j<curScope.size();j++)
            {
                System.out.println(curScope.get(j).name);
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
}