int main() {
    int i = 0;
    int acc = 0;
    while (i < 6) {
        acc = acc + i;
        if (acc > 10) {
            break;
        }
        i = i + 1;
    }
    return acc;
}
