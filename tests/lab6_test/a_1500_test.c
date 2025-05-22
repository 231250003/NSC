int main() {
    int n, i, sum;
    n   = 20;    // 读入 n
    i   = 1;
    sum = 0;
    while (i <= n) {   // 唯一的 while 循环
        sum = sum + i;
        i   = i + 1;
    }
    putint(sum);       // 输出结果
    return 0;
}