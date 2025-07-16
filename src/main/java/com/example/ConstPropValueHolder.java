package  com.example;
public class ConstPropValueHolder {
    public enum Kind {
        INT, NAC, UNDEF
    }

    private Kind kind;
    private Integer intValue; // 仅在 kind == INT 时非 null

    public static final ConstPropValueHolder NAC = new ConstPropValueHolder(Kind.NAC, null);
    public static final ConstPropValueHolder UNDEF = new ConstPropValueHolder(Kind.UNDEF, null);

    private ConstPropValueHolder(Kind kind, Integer intValue) {
        this.kind = kind;
        this.intValue = intValue;
    }
    public ConstPropValueHolder(ConstPropValueHolder other) {
        this.kind = other.kind;
        this.intValue = other.intValue;
    }
    public static ConstPropValueHolder ofInt(int value) {
        return new ConstPropValueHolder(Kind.INT, value);
    }

    public Kind getKind() {
        return kind;
    }

    public Integer getIntValue() {
        if (kind != Kind.INT) {
            throw new IllegalStateException("Not an INT value");
        }
        return intValue;
    }
    @Override
    public String toString() {
        switch (kind) {
            case INT:
                return "INT(" + intValue + ")";
            case NAC:
                return "NAC";
            case UNDEF:
                return "UNDEF";
            default:
                throw new IllegalStateException("Unknown kind: " + kind);
        }
    }
}
