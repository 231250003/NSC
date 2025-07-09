import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class array_variable {
    String variable_name;
    String array_name;
    List<Integer> array_size;
    int array_dim;
    List<Objects> cur_offset=new ArrayList<>();
    public array_variable(String variable_name,String array_name,int array_dim,List<Object> cur_offset,List<Integer> array_size){
        this.variable_name=variable_name;
        this.array_name=array_name;
        this.array_dim=array_dim;
        this.cur_offset=new ArrayList<>(cur_offset);
        this.array_size=new ArrayList<>(array_size);
    }
}
