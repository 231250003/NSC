int z;
int g(int x,int y){
    z=z+1;
   return 2*2+1;
}
int fib(int n) {
   if (n <= 1) {
    return n;
   }
   int x = fib(n - 1);
   int y = fib(n - 2);
   int z = x + y;
   return z;
}

int main() {
    int z=0;
    int p=((g(1,1)))+z;
    return (p+g(2,2));
}