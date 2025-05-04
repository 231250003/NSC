int x = 56;
int y = 98;

int main() {
    int a = x;
    int b = y;
    while (b+a>20) {
        while(a>10){
            if(a>40){
             a=a-5;
                        break;
              }
             else break;
        }
        if(b>70){
            b=b-5;
            continue;
        }
        b=b-10;
    }
    int result = a;
	return result;
}