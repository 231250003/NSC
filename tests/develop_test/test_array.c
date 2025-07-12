int max(int a,int b){
    if(a>b) return a;
    else return b;
}
int main(){
    int w[4]={2,3,4,7};  // 改为4个元素，索引0-3
    int c[4]={1,3,5,9};  // 改为4个元素，索引0-3
    int f[5][11] = {0};  // 初始化f数组为0，n=4所以需要5行

    int n=4, m=10;
    int i=0;  // 从0开始
    while(i<n)  // i < n而不是i <= n
    {

            f[i+1][1] =  f[i][1];
         
        i=i+1;
    }
    return f[n][1];
}