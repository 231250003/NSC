int x = 56;
int y = 98;

int main() {
    int a = x;
    int b = y;
    while (b != 0) {
        if (a > b) {
            a = a - b;
        } else {
            b = b - a;
        }
    }
    if(a!=!x+3) a=a+1;
    int result = a;
	return result;
}