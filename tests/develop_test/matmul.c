int ROWS_A=2;
int COLS_A=3;
int ROWS_B=3;
int COLS_B=2;

void b( int result[2][2]) {
      result[1][1]=result[1][1]+ 1;
}

int main() {
    // 定义两个固定矩阵
    int result[2][2];

    // 计算矩阵乘法
    b(result);

    return result[1][1];
}