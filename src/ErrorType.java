public enum ErrorType {
    UNDECLARED_VARIABLE(1, "变量未声明"),
    UNDECLARED_FUNCTION(2, "函数未定义"),
    REPEATED_VARIABLE_DECLARATION(3, "变量重复声明"),
    REPEATED_FUNCTION_DEFINITION(4, "函数重复定义"),
    TYPE_MISMATCH_ASSIGNMENT(5, "赋值号两侧类型不匹配"),
    TYPE_MISMATCH_OPERATOR(6, "运算符需求类型与提供类型不匹配"),
    TYPE_MISMATCH_RETURN(7, "返回值类型不匹配"),
    FUNCTION_ARGUMENT_MISMATCH(8, "函数参数不适用"),
    INDEXING_NON_ARRAY(9, "对非数组使用下标运算符"),
    CALLING_NON_FUNCTION(10, "对变量使用函数调用"),
    INVALID_ASSIGNMENT_TARGET(11, "赋值号左侧非变量或数组元素");

    private final int errorCode;
    private final String message;

    ErrorType(int errorCode, String message) {
        this.errorCode = errorCode;
        this.message = message;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public String getMessage() {
        return message;
    }
}
