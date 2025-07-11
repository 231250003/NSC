; ModuleID = 'my_module'
source_filename = "my_module"

@z = global i32 3

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
  store i32 4, i32* %elemPtr3, align 4
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  %load_lval10 = load i32, i32* %sum, align 4
  ret i32 %load_lval10

for.stmt:                                         ; preds = %for.cond
  %load_lval4 = load i32, i32* %sum, align 4
  %load_lval5 = load i32, i32* %i, align 4
  %elemPtr6 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 %load_lval5
  %load_lval7 = load i32, i32* %elemPtr6, align 4
  %add = add i32 %load_lval4, %load_lval7
  store i32 %add, i32* %sum, align 4
  %load_lval8 = load i32, i32* %i, align 4
  %add9 = add i32 %load_lval8, 1
  store i32 %add9, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 3
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur
}
