int f(){
 int f=10;
  return f;
}
int main() {
    int main=f();
    main=main+10;
    return main+f();
}