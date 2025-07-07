// 基本类型 INT
public class IntType extends Type {
    private static final IntType instance = new IntType();

    public IntType() {}

    public static IntType getInstance() {
        return instance;
    }

    @Override
    public String toString() {
        return "int";
    }
}
