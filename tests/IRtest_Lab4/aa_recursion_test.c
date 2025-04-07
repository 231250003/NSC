int g(int x){
 return x+1;
}
int f(){
 int f=10;
  return f;
}
void x(){
    return 23;
}
void t(){
    return 24;
}
int main() {
    int main=f();
    main=main+10+(g((((f())))));
    return main+f()+t(x());
}