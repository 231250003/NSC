; ModuleID = 'my_module'
source_filename = "my_module"

@z = global i32 3

define i32 @print() {
printEntry:
  %load_lval = load i32, i32* @z, align 4
  %add = add i32 %load_lval, 3
  store i32 %add, i32* @z, align 4
  %load_lval1 = load i32, i32* @z, align 4
  %add2 = add i32 %load_lval1, 3
  ret i32 %add2
}

define i32 @main() {
mainEntry:
  %a = alloca [4 x i32], align 4
  %elemPtr = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 0
  store i32 1, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 1
  store i32 2, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 2
  store i32 3, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 3
  store i32 0, i32* %elemPtr3, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

cur:                                              ; preds = %for.stmt, %for.cond
  %load_lval24 = load i32, i32* %sum, align 4
  ret i32 %load_lval24

for.stmt:                                         ; preds = %for.cond
  %print = call i32 @print()
  %load_lval5 = load i32, i32* %sum, align 4
  %load_lval6 = load i32, i32* %i, align 4
  %elemPtr7 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 %load_lval6
  %load_lval8 = load i32, i32* %elemPtr7, align 4
  %add = add i32 %load_lval5, %load_lval8
  %load_lval9 = load i32, i32* @z, align 4
  %add10 = add i32 %add, %load_lval9
  %elemPtr11 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 0
  %load_lval12 = load i32, i32* %elemPtr11, align 4
  %add13 = add i32 %add10, %load_lval12
  store i32 %add13, i32* %sum, align 4
  %load_lval14 = load i32, i32* %i, align 4
  %add15 = add i32 %load_lval14, 1
  store i32 %add15, i32* %i, align 4
  %load_lval16 = load i32, i32* %i, align 4
  %cmp17 = icmp eq i32 %load_lval16, 3
  %zext_to_i3218 = zext i1 %cmp17 to i32
  %to_bool19 = icmp ne i32 %zext_to_i3218, 0
  br i1 %to_bool19, label %cur, label %merge

for.cond:                                         ; preds = %merge, %mainEntry
  %elemPtr4 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 0
  %load_lval = load i32, i32* %elemPtr4, align 4
  %cmp = icmp slt i32 %load_lval, 3
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur

merge:                                            ; preds = %for.stmt
  %elemPtr20 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 0
  %load_lval22 = load i32, i32* %elemPtr20, align 4
  %add23 = add i32 %load_lval22, 1
  store i32 %add23, i32* %elemPtr20, align 4
  br label %for.cond
}
