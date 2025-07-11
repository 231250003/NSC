; ModuleID = 'my_module'
source_filename = "my_module"

@z = global i32 3

define i32 @main() {
mainEntry:
  %a = alloca [2 x i32], align 4
  %elemPtr = getelementptr [2 x i32], [2 x i32]* %a, i32 0, i32 0
  store i32 1, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x i32], [2 x i32]* %a, i32 0, i32 1
  store i32 2, i32* %elemPtr1, align 4
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  %load_lval8 = load i32, i32* %sum, align 4
  ret i32 %load_lval8

for.stmt:                                         ; preds = %for.cond
  %load_lval2 = load i32, i32* %sum, align 4
  %load_lval3 = load i32, i32* %i, align 4
  %elemPtr4 = getelementptr [2 x i32], [2 x i32]* %a, i32 0, i32 %load_lval3
  %load_lval5 = load i32, i32* %elemPtr4, align 4
  %add = add i32 %load_lval2, %load_lval5
  store i32 %add, i32* %sum, align 4
  %load_lval6 = load i32, i32* %i, align 4
  %add7 = add i32 %load_lval6, 1
  store i32 %add7, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur
}
