package  com.example;
import java.util.ArrayList;
import java.util.List;

// 数组类型 ARRAY
public class ArrayType extends Type {
    public Type elementType;
    public List<Integer> dimensions=new ArrayList<>();
    public int dim;
    public ArrayType(Type elementType, List<Integer>  dim) {
        this.elementType = elementType;
        this.dimensions = dim;
    }
    public ArrayType(Type elementType, int  dim) {
        this.elementType = elementType;
        this.dim = dim;
    }
    public  ArrayType(){

    }
    public int getTotalSize() {
        if(!dimensions.isEmpty())return dimensions.stream().reduce(1, (a, b) -> a * b);
        else return 0;
    }

    public Type getElementType() {
        return elementType;
    }

    public int getDim() {
        return dim;
    }

    @Override
    public String toString() {
        return "array"+dim;
    }
}
