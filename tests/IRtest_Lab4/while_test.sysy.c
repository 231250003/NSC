int x=10;
int z;
int g(int x,int y){
    y=y+1;
    z=z+1;
    return y+1;
}
int main(){
    int y=10;
    z=y;
    if(x>50 || y/2==0){
        while(1){
            g(2,3);
            if(x<50){
                x=2;
                g(10,2);
                continue;
            }
            if(x>100) break;
        }
    }
    return x;
}