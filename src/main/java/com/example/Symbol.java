
package  com.example;
import org.bytedeco.llvm.LLVM.LLVMValueRef;

public class Symbol {
    public Type type;
    public String name;
    public LLVMValueRef reference;
    public Symbol(String name,Type type){
        this.name=name;
        this.type=type;
        this.reference=null;
    }
    public Symbol(String name,Type type,LLVMValueRef reference){
        this.name=name;
        this.type=type;
        this.reference=reference;
    }
    public Symbol(){
    }
}
