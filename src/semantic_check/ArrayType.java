package semantic_check;

// 数组类型 ARRAY
public class ArrayType extends Type {
    public Type elementType;
    public int dim;

    public ArrayType(Type elementType, int dim) {
        this.elementType = elementType;
        this.dim = dim;
    }
    public ArrayType() {
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
