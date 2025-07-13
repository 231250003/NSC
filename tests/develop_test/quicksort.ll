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
  %pivot = alloca i32, align 4
  %load_lval = load i32, i32* %param2_addr, align 4
  %elemPtr = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 %load_lval
  %load_lval1 = load i32, i32* %elemPtr, align 4
  store i32 %load_lval1, i32* %pivot, align 4
  %i = alloca i32, align 4
  %load_lval2 = load i32, i32* %param1_addr, align 4
  %sub = sub i32 %load_lval2, 1
  store i32 %sub, i32* %i, align 4
  %j = alloca i32, align 4
  %load_lval3 = load i32, i32* %param1_addr, align 4
  store i32 %load_lval3, i32* %j, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  %load_lval19 = load i32, i32* %i, align 4
  %add20 = add i32 %load_lval19, 1
  ret i32 %add20

for.stmt:                                         ; preds = %for.cond
  %load_lval6 = load i32, i32* %j, align 4
  %elemPtr7 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 %load_lval6
  %load_lval8 = load i32, i32* %elemPtr7, align 4
  %load_lval9 = load i32, i32* %pivot, align 4
  %cmp10 = icmp sle i32 %load_lval8, %load_lval9
  %zext_to_i3211 = zext i1 %cmp10 to i32
  %to_bool12 = icmp ne i32 %zext_to_i3211, 0
  br i1 %to_bool12, label %if.then, label %merge

for.cond:                                         ; preds = %merge, %partitionEntry
  %load_lval4 = load i32, i32* %j, align 4
  %load_lval5 = load i32, i32* %param2_addr, align 4
  %cmp = icmp slt i32 %load_lval4, %load_lval5
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur

merge:                                            ; preds = %if.then, %for.stmt
  %load_lval17 = load i32, i32* %j, align 4
  %add18 = add i32 %load_lval17, 1
  store i32 %add18, i32* %j, align 4
  br label %for.cond

if.then:                                          ; preds = %for.stmt
  %load_lval13 = load i32, i32* %i, align 4
  %add = add i32 %load_lval13, 1
  store i32 %add, i32* %i, align 4
  %elemPtr14 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0
  %load_lval15 = load i32, i32* %i, align 4
  %load_lval16 = load i32, i32* %j, align 4
  call void @swap([6 x i32]* %elemPtr14, i32 %load_lval15, i32 %load_lval16)
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
  %load_lval = load i32, i32* %n, align 4
  %sub = sub i32 %load_lval, 1
  %partition = call i32 @partition([6 x i32]* %elemPtr6, i32 0, i32 %sub)
  %elemPtr7 = getelementptr [6 x i32], [6 x i32]* %arr, i32 0, i32 1
  %load_lval8 = load i32, i32* %elemPtr7, align 4
  ret i32 %load_lval8
}
