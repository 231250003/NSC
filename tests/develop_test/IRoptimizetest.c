int main(){
    int i=0;
    int n=6,m=6;
    while(i<n)  // i < n而不是i <= n
    {
        int v=1;  // 每次外层循环都要重置v
        while(v<=m)
        {

            v=v+1;
        }
        i=i+1;
    }
    return 2;
}