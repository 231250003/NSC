package semantic_check;

public class Symbol {
    public Type type;
    public String name;
    public Symbol(String name,Type type){
        this.name=name;
        this.type=type;
    }
    public Symbol(){
    }
}
