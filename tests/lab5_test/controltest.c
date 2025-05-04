int x = 56;
int y = 98;

int main() {
    int a = x;
    int b = y;
    int x = 10;
    int y = 5;
    if (x > 0) {
       x=a;
        if (y > 0) {
            x=x-1;
            y=y-2;
        }
        x=x+10;
        a=a-4;
    }
    int result = x;
	return result;
}