int main(){
    int f[2][6] = {0};  // 初始化f数组为0，n=4所以需要5行
    int i=0;  // 从0开始
    while(i<2)  // i < n而不是i <= n
    {
        f[i+1][1] =f[i][1];
        i=i+1;
    }
    return f[4][1];
}