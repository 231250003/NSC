int x = 100, y = 2, z = 3;
int main() {
    if(x>=100){
        if(x<10) return 0;
        else if(x>200) return 2;
        else if(x>0x100) return 3;
        x=x+1;
    }
    return x;
}