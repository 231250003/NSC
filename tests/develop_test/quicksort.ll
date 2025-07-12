; ModuleID = 'my_module'
source_filename = "my_module"

define void @swap([2 x i32]* %arr, i32 %i, i32 %j) {
swapEntry:
  %param1_addr = alloca i32, align 4
  store i32 %i, i32* %param1_addr, align 4
  %param2_addr = alloca i32, align 4
  store i32 %j, i32* %param2_addr, align 4
  %temp = alloca i32, align 4
  %load_lval = load i32, i32* %param1_addr, align 4
  %elemPtr = getelementptr [2 x i32], [2 x i32]* %arr, i32 0, i32 %load_lval
  %load_lval1 = load i32, i32* %elemPtr, align 4
  store i32 %load_lval1, i32* %temp, align 4
  %load_lval2 = load i32, i32* %param1_addr, align 4
  %elemPtr3 = getelementptr [2 x i32], [2 x i32]* %arr, i32 0, i32 %load_lval2
  %load_lval4 = load i32, i32* %param2_addr, align 4
  %elemPtr5 = getelementptr [2 x i32], [2 x i32]* %arr, i32 0, i32 %load_lval4
  %load_lval6 = load i32, i32* %elemPtr5, align 4
  store i32 %load_lval6, i32* %elemPtr3, align 4
  ret void
}

define i32 @main() {
mainEntry:
  %arr = alloca [2 x i32], align 4
  %elemPtr = getelementptr [2 x i32], [2 x i32]* %arr, i32 0, i32 0
  store i32 10, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x i32], [2 x i32]* %arr, i32 0, i32 1
  store i32 1, i32* %elemPtr1, align 4
  %n = alloca i32, align 4
  store i32 2, i32* %n, align 4
  %elemPtr2 = getelementptr [2 x i32], [2 x i32]* %arr, i32 0
  call void @swap([2 x i32]* %elemPtr2, i32 0, i32 1)
  %elemPtr3 = getelementptr [2 x i32], [2 x i32]* %arr, i32 0, i32 0
  %load_lval = load i32, i32* %elemPtr3, align 4
  ret i32 %load_lval
}
