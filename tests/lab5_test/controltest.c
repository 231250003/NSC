int x = 56;
int y = 98;

int main() {
    int a = x;
    int b = y;
    while (a<98) {
        a=a+1;
           if (a > b) {
                  //a = a - b;
                  a=a+1;
           }
          /*  else {
                b = b - a;
            }*/
    }
    int result = a;
	return result;
}