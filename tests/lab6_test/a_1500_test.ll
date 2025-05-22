; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 64, i32* %i, align 4
  %sum = alloca i32, align 4
  store i32 64, i32* %sum, align 4
  store i32 0, i32* %i, align 4
  store i32 0, i32* %sum, align 4
  ret i32 0
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval8 = load i32, i32* %sum, align 4
  %add9 = add i32 %load_lval8, 5
  ret i32 %add9

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* %i, align 4
  %add = add i32 %load_lval2, 1
  store i32 %add, i32* %i, align 4
  %load_lval3 = load i32, i32* %sum, align 4
  %load_lval4 = load i32, i32* %i, align 4
  %add5 = add i32 %load_lval3, %load_lval4
  %add6 = add i32 %add5, 1
  store i32 %add6, i32* %sum, align 4
  %load_lval7 = load i32, i32* %sum, align 4
  ret i32 %load_lval7
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval1 = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval1, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
