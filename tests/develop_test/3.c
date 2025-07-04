int max(int a,int b){
    if(a>b) return a;
    else return b;
}
int main()
    int m,n,w[1001]={2,3,4,7},c[1001]={1,3,5,9},f[101][1001];
	int n=10;m=4;
	int i=1,j=1;
    while(i<=n)
    {
    	while(j<=m)
    	{
    		if(v>=w[i]) f[i][v]=max(f[i-1][v-w[i]]+c[i],f[i-1][v]);
    		else f[i][v]=f[i-1][v];
    		j++;
		}
		i++;
	}
	return f[n][m];
}