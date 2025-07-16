int z=3;
int print(){
    z=z+3;
    return z+3;
}
int main(){
    int a[4]={1,2,3};
    int x=1;
    int sum=0;
    for(int i=0;a[0]<3;a[0]=a[0]+1){
        print();
        sum=sum+a[i]+z+a[0];
        i=i+1;
        if(i==3) break;
    }
    return sum;
}




/*
int main(){
    int i=0;
    int x=i;
    i=i+1;
    i=i+1;
    return i+x;
}
*/