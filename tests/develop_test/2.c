void f(int a[3]){
    for(int i=1;i<3;i=i+1){
        a[i]=a[i]+a[i-1];
    }
}
int main() {
    int matrixGrid[2][3]={1,2,3,4,5,6};
    int fixedRow = 1;
    int fixedCol = 2;
    int valueAccessed=0;

    matrixGrid[0][1] = 15;
    matrixGrid[1][0] = 25;
    matrixGrid[1][2] = matrixGrid[0][1] + matrixGrid[1][0];

    valueAccessed = matrixGrid[fixedRow][fixedCol];
    int sum=0;
    for(int i=0;i<2;i=i+1){
        for(int j=1;j<3;j=j+1){
             matrixGrid[i][j] = matrixGrid[i][j-1] + matrixGrid[i][j]+ matrixGrid[1][1];
             f(matrixGrid[i]);
        }
    }
    for(int i=0;i<2;i=i+1){
        for(int j=0;j<3;j=j+1){
            sum=sum+matrixGrid[i][j];
        }
    }
    return sum;
}