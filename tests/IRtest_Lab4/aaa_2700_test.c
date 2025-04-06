int x = 1, y = 2, z = 3;
int A[3][4];
int counter = 0;

int mul(int a, int b) {
    if (a == 0 || b == 0) return 0;
    return a * b;
}

int max(int a, int b) {
    if(a>b) return a;
    else return b;
}

int main() {
    int i = 0, j = 0;
    int sum = 0;
    int x = 5;  // 遮蔽全局变量

    while (i < 3) {
        int x = i;  // 重定义变量遮蔽
        while (j < 4) {
            if ((x + j) % 2 == 0 && !(i == j)) {
                sum = sum + mul(i, j);
            } else if (x != j || i == 0) {
                sum = sum - 1;
            } else {
                sum = sum + 1;
            }
            if ((i + j) > 3 && ((i * j) < 6 || x >= 2)) {
                break;
            }
            j = j + 1;
        }
        j = 0; // reset for next i
        i = i + 1;
    }
    return  counter;
}