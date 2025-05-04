int x = 56;
int y = 98;

int main() {
    int a = x;
    int b = y;
    while (b > 0) {
           if (a > b) {
                            b=b-a;
                      }
            else {
                b = b - a;
            }
    }
    int result = a;
	return result;
}