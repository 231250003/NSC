int main() {
    int i, j, k;
    int arr[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};

    // 复杂的三重 for 循环
    for (int i = 0; i < 3; i = i + 1) {
        for (int j = 0; j < 3; j = j + 1) {
            if (i == j) {
                continue;  // 跳过对角线元素
            }
            for (int k = 0; k < 3; k = k + 1) {
                arr[i][j] = arr[i][j] + arr[j][k];  // 矩阵运算
                if (arr[i][j] > 20) {
                    break;  // 提前终止最内层循环
                }
            }
        }
    }

    return arr[2][2];
}