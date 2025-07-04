int main()
{
	int m,n,w[1001]={2,3,4,7},c[1001]={1,3,5,9},f[101][1001];
	int n=10;=4;
	for(int i=1;i<=n;i++)
	{
		cin>>w[i]>>c[i];
	}
    for(int i=1;i<=n;i++)
    {
    	for(int v=1;v<=m;v++)
    	{
    		if(v>=w[i]) f[i][v]=max(f[i-1][v-w[i]]+c[i],f[i-1][v]);
    		else f[i][v]=f[i-1][v];
		}
	}
	return f[n][m];
}