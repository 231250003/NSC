; ModuleID = 'my_module'
source_filename = "my_module"

@ROWS_A = global i32 2
@COLS_A = global i32 3
@ROWS_B = global i32 3
@COLS_B = global i32 2

define void @matrix_multiply([2 x [2 x i32]]* %result) {
matrix_multiplyEntry:
  %elemPtr = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  %elemPtr1 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  %load_lval = load i32, i32* %elemPtr1, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* %elemPtr, align 4
  ret void
}

define i32 @main() {
mainEntry:
  %result = alloca [2 x [2 x i32]], align 4
  %elemPtr = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 0, i32 1
  store i32 0, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0
  call void @matrix_multiply([2 x [2 x i32]]* %elemPtr4)
  %elemPtr5 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  %load_lval = load i32, i32* %elemPtr5, align 4
  ret i32 %load_lval
}
