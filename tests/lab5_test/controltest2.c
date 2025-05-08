int x = 56;
int y = 98;

int main() {
    int a = x;
    int b = y;
     if(a%2==1) a=a+1;
    while (b != 0) {
        if (a > b) {
            a = a - b;
        } else {
            b = b - a;
        }
    }
    int result = a;
	return result;
}