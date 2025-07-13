int ROWS_A=2;
int COLS_A=3;
int ROWS_B=3;
int COLS_B=2;

void matrix_multiply(int a[2][3], int b[3][2], int result[2][2]) {
    for (int i = 0; i < ROWS_A; i=i+1) {
        for (int j = 0; j < COLS_B; j=j+1) {
            result[i][j] = 0;
            result[i][j] =result[i][j]+ 1;
        }
    }
}

int main() {
    // 定义两个固定矩阵
    int matrix_a[2][3] = {
        {1, 2, 3},
        {4, 5, 6}
    };

    int matrix_b[3][2] = {
        {7, 8},
        {9, 10},
        {11, 12}
    };

    int result[2][2];

    // 计算矩阵乘法
    matrix_multiply(matrix_a, matrix_b, result);

    return result[1][1];
}