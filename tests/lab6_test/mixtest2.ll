; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 0, i32* %num, align 4
  ret i32 0
  %c = alloca i32, align 4
  store i32 2, i32* %c, align 4
  store i32 0, i32* %c, align 4
  store i32 1, i32* %c, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval8 = load i32, i32* %c, align 4
  %load_lval9 = load i32, i32* %num, align 4
  %add10 = add i32 %load_lval8, %load_lval9
  ret i32 %add10

while.stmt:                                       ; preds = %while.cond
  %load_lval4 = load i32, i32* %num, align 4
  %add5 = add i32 %load_lval4, 1
  store i32 %add5, i32* %num, align 4
  %load_lval6 = load i32, i32* %c, align 4
  %add7 = add i32 %load_lval6, 1
  store i32 %add7, i32* %c, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval3 = load i32, i32* %num, align 4
  %cmp = icmp sle i32 %load_lval3, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
