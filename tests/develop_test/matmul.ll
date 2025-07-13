; ModuleID = 'my_module'
source_filename = "my_module"

@ROWS_A = global i32 2
@COLS_A = global i32 3
@ROWS_B = global i32 3
@COLS_B = global i32 2

define void @matrix_multiply([2 x [2 x i32]]* %result) {
matrix_multiplyEntry:
  %elemPtr = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  %elemPtr2 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  %load_lval = load i32, i32* %elemPtr2, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* %elemPtr1, align 4
  ret void
}

define i32 @main() {
mainEntry:
  %matrix_a = alloca [2 x [3 x i32]], align 4
  %elemPtr = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 0, i32 0
  store i32 1, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 0, i32 1
  store i32 2, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 0, i32 2
  store i32 3, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 1, i32 0
  store i32 4, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 1, i32 1
  store i32 5, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 1, i32 2
  store i32 6, i32* %elemPtr5, align 4
  %matrix_b = alloca [3 x [2 x i32]], align 4
  %elemPtr6 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 0, i32 0
  store i32 7, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 0, i32 1
  store i32 8, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 1, i32 0
  store i32 9, i32* %elemPtr8, align 4
  %elemPtr9 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 1, i32 1
  store i32 10, i32* %elemPtr9, align 4
  %elemPtr10 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 2, i32 0
  store i32 11, i32* %elemPtr10, align 4
  %elemPtr11 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 2, i32 1
  store i32 12, i32* %elemPtr11, align 4
  %result = alloca [2 x [2 x i32]], align 4
  %elemPtr12 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr12, align 4
  %elemPtr13 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 0, i32 1
  store i32 0, i32* %elemPtr13, align 4
  %elemPtr14 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr14, align 4
  %elemPtr15 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr15, align 4
  %elemPtr16 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0
  call void @matrix_multiply([2 x [2 x i32]]* %elemPtr16)
  %elemPtr17 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  %load_lval = load i32, i32* %elemPtr17, align 4
  ret i32 %load_lval
}
