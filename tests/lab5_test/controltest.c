int main() {
    int x = 0;
    int y = 0;
    while (x < 10) {
        if (x % 2 == 0) {
            x = x + 1;
            continue;
        }
        if (x == 7) {
            break;
        }
        y = y + x;
        x = x + 1;
    }
    return y;
}
