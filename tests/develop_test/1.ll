; ModuleID = 'my_module'
source_filename = "my_module"

@z = global i32 3

define i32 @print() {
printEntry:
  %load_lval = load i32, i32* @z, align 4
  %load_lval1 = load i32, i32* @z, align 4
  %add = add i32 %load_lval1, 3
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %a = alloca [4 x [4 x i32]], align 4
  %elemPtr = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 0, i32 0
  store i32 1, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 0, i32 1
  store i32 2, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 0, i32 2
  store i32 3, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 0, i32 3
  store i32 3, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 1, i32 0
  store i32 4, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr5, align 4
  %elemPtr6 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 1, i32 2
  store i32 0, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 1, i32 3
  store i32 0, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 2, i32 0
  store i32 0, i32* %elemPtr8, align 4
  %elemPtr9 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 2, i32 1
  store i32 0, i32* %elemPtr9, align 4
  %elemPtr10 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 2, i32 2
  store i32 0, i32* %elemPtr10, align 4
  %elemPtr11 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 2, i32 3
  store i32 0, i32* %elemPtr11, align 4
  %elemPtr12 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 3, i32 0
  store i32 0, i32* %elemPtr12, align 4
  %elemPtr13 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 3, i32 1
  store i32 0, i32* %elemPtr13, align 4
  %elemPtr14 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 3, i32 2
  store i32 0, i32* %elemPtr14, align 4
  %elemPtr15 = getelementptr [4 x [4 x i32]], [4 x [4 x i32]]* %a, i32 0, i32 3, i32 3
  store i32 0, i32* %elemPtr15, align 4
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  ret i32 0
}
