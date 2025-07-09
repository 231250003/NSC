int z=3;
int print(){
    z=z+3;
    return z+3;
}
int main(){
    int a[4][4]={{1,2,3},{3,4}};
    int x=1;
    int sum=0;
    for(int i=0;i<4;i=i+1){
        sum=sum+a[0][i];
    }
    return sum;
}