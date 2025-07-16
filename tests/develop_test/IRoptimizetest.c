
int f(int a[5]){
    a[2]=1;
    return 2;
}
int main(){
    int a[5][5];
    a[1][1]=1;
    f(a[2]);
    return a[1][1];
}

/*
int main(){
    int x=1;
    x=x+1;
    x=x+1;
    return x;
}
*/