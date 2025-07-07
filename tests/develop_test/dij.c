int e[15][15],dis[15],book[15];
int main()
{
	for(int i=0;i<14;i=i+1){
	    book[i]=0;
	}
	int n=6,m=9,a,b,c;
    for(int i=1;i<=n;i=i+1)
    {
    	for(int j=1;j<=n;j=j+1)
    	{
    		if(i==j) e[i][j]=0;
    		else e[i][j]=9999;
		}
	}
    e[1][2]=1;
    e[1][3]=12;
    e[2][3]=9;
    e[2][4]=3;
    e[3][5]=5;
    e[4][3]=4;
    e[4][5]=13;
    e[4][6]=15;
    e[5][6]=4;
	for(int i=1;i<=n;i=i+1)
	{
		dis[i]=e[1][i];
	}
	int t,min=99999;
	for(int i=1;i<=n;i=i+1)
	{
		min=99999;
	    for(int j=1;j<=n;j=j+1)
		{
		    if(book[j]==0&&dis[j]<min)
			{
				min=dis[j];
				t=j;
			}
		}
		book[t]=1;
		for(int k=1;k<=n;k=k+1)
		{
			if(book[k]==0&&dis[k]>dis[t]+e[t][k])
			{
				dis[k]=dis[t]+e[t][k];
			}
		}
	}
    return dis[2];
}
/*
6 9
1 2 1
1 3 12
2 3 9
2 4 3
3 5 5
4 3 4
4 5 13
4 6 15
5 6 4
*/