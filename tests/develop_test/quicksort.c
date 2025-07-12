// 交换数组中的两个元素（不使用指针）
void swap(int arr[6], int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

// 分区函数
int partition(int arr[6], int low, int high) {
    int pivot = arr[high];  // 选择最后一个元素作为基准
    int i = low - 1;        // i是小于基准的区域的边界

    for (int j = low; j < high; j =j+ 1) {
        // 如果当前元素小于或等于基准
        if (arr[j] <= pivot) {
            i = i+1;         // 扩大小于基准的区域
            swap(arr, i, j); // 将当前元素放到该区域内
        }
    }

    // 将基准放到正确位置
    swap(arr, i + 1, high);
    return i + 1;           // 返回基准的最终位置
}

// 快速排序主函数
void quickSort(int arr[6], int low, int high) {
    if (low < high) {
        // 找到分区点
        int pi = partition(arr, low, high);

        // 递归排序分区
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

// 打印数组
// 测试代码
int main() {
    int arr[6] = {10, 7, 8, 9, 1, 5};
    int n = 6;
    quickSort(arr, 1, n - 1);
    return arr[5];
    //return 0;
}