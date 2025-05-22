int main() {
    int i, sum;
    i = 0;
    sum = 0;
    while (i < 10)
        sum = sum + (i = i + 1);  // 单语句 while，i 先加再加到 sum 中
    return sum;
}