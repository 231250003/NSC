int x = 56;
int y = 98;

int main() {
  int a = x;
    int b = y;
    while(1){
        a=a-2;
        if(a==45) break;
        else if(a==48){
            b=b-3;
            a=a+1;
         }
    }

    int result = a;
	return result;
}