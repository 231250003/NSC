void swap(int arr[6], int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}
int partition(int arr[6], int low, int high) {
    int pivot = arr[high];  // 选择最后一个元素作为基准
    int i = low - 1;        // i是小于基准的区域的边界

    for (int j = low; j < high; j =j+ 1) {
        if (arr[j] <= pivot) {
            i = i+1;
            swap(arr, i, j); // 将当前元素放到该区域内
        }
    }

    // 将基准放到正确位置
    //swap(arr, i + 1, high);
    return i + 1;           // 返回基准的最终位置
}
int main() {
    int arr[6] = {10, 7, 8, 9, 1, 5};
    int n = 6;
    partition(arr, 0, n - 1);
    return arr[5];
}