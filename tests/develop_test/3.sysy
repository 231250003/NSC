int max(int a,int b){
    if(a>b) return a;
    else return b;
}
int main(){
    int w[7]={2,3,4,7},c[7]={1,3,5,9},f[11][11];
	int n=4,m=10;
	int i=1,v=1;
    while(i<=n)
    {
    	while(v<=m)
    	{
    		if(v>=w[i]) {
    		    return f[i-1][v-w[i]]+c[i];
    		    f[i][v]=max(f[i-1][v-w[i]]+c[i],f[i-1][v]);
    		}
    		else f[i][v]=f[i-1][v];
    		v=v+1;
		}
		i=i+1;
	}
	return f[n][m];
}