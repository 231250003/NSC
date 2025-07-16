; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @f([5 x i32]* %a) {
fEntry:
  %elemPtr = getelementptr [5 x i32], [5 x i32]* %a, i32 0, i32 2
  store i32 1, i32* %elemPtr, align 4
  ret i32 2
}

define i32 @main() {
mainEntry:
  %a = alloca [5 x [5 x i32]], align 4
  %elemPtr10 = getelementptr [5 x [5 x i32]], [5 x [5 x i32]]* %a, i32 0, i32 2, i32 0
  store i32 0, i32* %elemPtr10, align 4
  %elemPtr11 = getelementptr [5 x [5 x i32]], [5 x [5 x i32]]* %a, i32 0, i32 2, i32 1
  store i32 0, i32* %elemPtr11, align 4
  %elemPtr12 = getelementptr [5 x [5 x i32]], [5 x [5 x i32]]* %a, i32 0, i32 2, i32 2
  store i32 0, i32* %elemPtr12, align 4
  %elemPtr13 = getelementptr [5 x [5 x i32]], [5 x [5 x i32]]* %a, i32 0, i32 2, i32 3
  store i32 0, i32* %elemPtr13, align 4
  %elemPtr14 = getelementptr [5 x [5 x i32]], [5 x [5 x i32]]* %a, i32 0, i32 2, i32 4
  store i32 0, i32* %elemPtr14, align 4
  %elemPtr26 = getelementptr [5 x [5 x i32]], [5 x [5 x i32]]* %a, i32 0, i32 2
  %f = call i32 @f([5 x i32]* %elemPtr26)
  ret i32 1
}
