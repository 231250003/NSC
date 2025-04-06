int x=10;
const int z=20;
void g(int x,int y){
    y=y+1;
    z=z+1;
    return;
}
int main(){
    int y=10;
    if(x>50 || y/2==0){
        while(1){
            g(2,3);
            if(x<50){
                x=2;
                g();
                continue;
            }
            if(x>100) break;
        }
    }
    return x;
}