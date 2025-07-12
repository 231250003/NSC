// 交换数组中的两个元素（不使用指针）
void swap(int arr[6], int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}


// 快速排序主函数
void quickSort(int arr[6], int low, int high) {
     swap(arr, low, high);
}

// 打印数组
// 测试代码
int main() {
    int arr[6] = {10, 7, 8, 9, 1, 5};
    int n = 6;
    quickSort(arr, 1, 5);
    return arr[1];
    //return 0;
}