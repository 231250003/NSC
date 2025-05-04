int main() {
    int a = 0;
    int b = 0;
    while (a < 4) {
        if (a == 1) {
            b = b + 2;
        } else {
            if (b < 3) {
                b = b + 1;
            } else {
                b = b - 1;
            }
        }
        a = a + 1;
    }
    return b;
}
