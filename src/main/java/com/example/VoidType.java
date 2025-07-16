package  com.example;
// 基本类型 INT
public class VoidType extends Type {
    private static final IntType instance = new IntType();

    public VoidType() {}

    public static IntType getInstance() {
        return instance;
    }

    @Override
    public String toString() {
        return "void";
    }
}