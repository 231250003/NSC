int main() {
    int x = 0;
    int y = 0;
    while (x < 8) {
        if (x == 2) {
            y = y + 3;
        } else if (x == 4) {
            y = y - 1;
        } else {
            y = y + 1;
        }
        x = x + 1;
    }
    return y;
}
