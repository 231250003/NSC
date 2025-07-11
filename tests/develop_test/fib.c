int fib(int n){
    if(n==0) return 1;
    else if(n==2) return 2;
    else return fib(n-1)+fib(n-2);
}
int main(){
    return fib(5);
}