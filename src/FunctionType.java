import java.util.ArrayList;
import java.util.List;

// 函数类型 FUNCTION
public class FunctionType extends Type {
    private Type returnType;
    private List<Symbol> params;

    public FunctionType(Type returnType, List<Symbol> params) {
        this.returnType = returnType;
        this.params = new ArrayList<>(params);
    }
    public FunctionType() {
    }
    public Type getReturnType() {
        return returnType;
    }

    public List<Symbol> getparams() {
        return params;
    }

    @Override
    public String toString() {
       return  "func";
    }
}
