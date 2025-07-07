import java.util.ArrayList;
import java.util.List;

// 抽象基类 Type
public abstract class Type {
    public boolean equals(Object obj) {
        if(this instanceof IntType&& obj instanceof IntType){
            return true;
        }
        if(this instanceof ArrayType && obj instanceof ArrayType){
            if(((ArrayType)obj).dim==((ArrayType)this).dim){
                return true;
            }
        }
        return false;
    }
}

