int main() {
    int sum = 0;
    int i = 0;
    while (i < 3) {
        sum = sum + i;
        i = i + 1;
    }

    int j = 5;
    while (j > 0) {
        sum = sum + j;
        j = j - 1;
    }

    return sum;
}
