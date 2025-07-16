/*
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
*/
int main() {
    int matrixGrid[2][3]={0,0,0,0,0,0,0};
    int fixedRow = 1;
    int fixedCol = 2;
    int valueAccessed;

    matrixGrid[0][1] = 15;
    matrixGrid[1][0] = 25;
    matrixGrid[1][2] = matrixGrid[0][1] + matrixGrid[1][0];

    valueAccessed = matrixGrid[fixedRow][fixedCol];

    return valueAccessed;
}