; ModuleID = 'my_module'
source_filename = "my_module"

define void @swap([6 x i32]* %arr, i32 %i, i32 %j) {
swapEntry:
  %param1_addr = alloca i32, align 4
  store i32 %i, i32* %param1_addr, align 4
  %param2_addr = alloca i32, align 4
  store i32 %j, i32* %param2_addr, align 4
  %temp = alloca i32, align 4
  %load_lval = load i32, i32* %param1_addr, align 4
  %elemPtr = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 %load_lval
  %load_lval1 = load i32, i32* %elemPtr, align 4
  store i32 %load_lval1, i32* %temp, align 4
  %load_lval2 = load i32, i32* %param1_addr, align 4
  %elemPtr3 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 %load_lval2
  %load_lval4 = load i32, i32* %param2_addr, align 4
  %elemPtr5 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 %load_lval4
  %load_lval6 = load i32, i32* %elemPtr5, align 4
  store i32 %load_lval6, i32* %elemPtr3, align 4
  %load_lval7 = load i32, i32* %param2_addr, align 4
  %elemPtr8 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 %load_lval7
  %load_lval9 = load i32, i32* %temp, align 4
  store i32 %load_lval9, i32* %elemPtr8, align 4
  ret void
}

define i32 @partition([6 x i32]* %arr, i32 %low, i32 %high) {
partitionEntry:
  %param1_addr = alloca i32, align 4
  store i32 %low, i32* %param1_addr, align 4
  %param2_addr = alloca i32, align 4
  store i32 %high, i32* %param2_addr, align 4
  %elemPtr = getelementptr [6 x i32], [6 x i32]* %arr, i32 0
  %load_lval = load i32, i32* %param1_addr, align 4
  %load_lval1 = load i32, i32* %param2_addr, align 4
  call void @swap([6 x i32]* %elemPtr, i32 %load_lval, i32 %load_lval1)
  %load_lval2 = load i32, i32* %param1_addr, align 4
  ret i32 %load_lval2
}

define void @quickSort([6 x i32]* %arr, i32 %low, i32 %high) {
quickSortEntry:
  %param1_addr = alloca i32, align 4
  store i32 %low, i32* %param1_addr, align 4
  %param2_addr = alloca i32, align 4
  store i32 %high, i32* %param2_addr, align 4
  %load_lval = load i32, i32* %param1_addr, align 4
  %load_lval1 = load i32, i32* %param2_addr, align 4
  %cmp = icmp slt i32 %load_lval, %load_lval1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %if.then, %quickSortEntry
  ret void

if.then:                                          ; preds = %quickSortEntry
  %pi = alloca i32, align 4
  %elemPtr = getelementptr [6 x i32], [6 x i32]* %arr, i32 0
  %load_lval2 = load i32, i32* %param1_addr, align 4
  %load_lval3 = load i32, i32* %param2_addr, align 4
  %partition = call i32 @partition([6 x i32]* %elemPtr, i32 %load_lval2, i32 %load_lval3)
  store i32 %partition, i32* %pi, align 4
  br label %merge
}

define i32 @main() {
mainEntry:
  %arr = alloca [6 x i32], align 4
  %elemPtr = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 0
  store i32 10, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 1
  store i32 7, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 2
  store i32 8, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 3
  store i32 9, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 4
  store i32 1, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 5
  store i32 5, i32* %elemPtr5, align 4
  %n = alloca i32, align 4
  store i32 6, i32* %n, align 4
  %elemPtr6 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0
  call void @quickSort([6 x i32]* %elemPtr6, i32 1, i32 5)
  %elemPtr7 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 1
  %load_lval = load i32, i32* %elemPtr7, align 4
  ret i32 %load_lval
}
