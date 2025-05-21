int global_var = 1;

int main() {
    int num = 1;
    if(num!=1) num=num*2;
    num=3;
    int x=global_var;
    x=3;
    x=global_var;
    return num+x;
}