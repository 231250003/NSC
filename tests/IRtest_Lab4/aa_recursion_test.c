int f(){
 int f=10;
  return f;
}
int main() {
    int main=10;
    main=main+10;
    return main+f();
}