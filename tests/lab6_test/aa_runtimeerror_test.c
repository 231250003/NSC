int main() {
    // 基础算术指令测试
    int a = 15;         // li 指令测试
    int b = 3;          // 立即数加载
    int c = 18;      // ADD (18)
    int d = 12;      // SUB (12)
    int e = 45;      // MUL (45)
    int f = 5;      // DIV (5)
    int g = 0;      // REM (0)
    // 循环控制测试
    int sum = 0;
        int n = 0;
         while (n < 5) {
              sum = sum + n;
              n = n + 1;
            }

     int mem_test = 0;
     mem_test = c;
     int load_test = mem_test;

    // 复合条件验证
    return (c - 18)    // 验证加法
         + (d - 12)    // 验证减法
         + (e - 45)    // 验证乘法
         + (sum - 10);  // 验证循环
}