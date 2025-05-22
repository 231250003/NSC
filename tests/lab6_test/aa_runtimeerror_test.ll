; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %n = alloca i32, align 4
  store i32 0, i32* %n, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval14 = load i32, i32* %sum, align 4
  %sub15 = sub i32 %load_lval14, 10
  %add16 = add i32 0, %sub15
  ret i32 %add16

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %sum, align 4
  %load_lval2 = load i32, i32* %n, align 4
  %add = add i32 %load_lval1, %load_lval2
  store i32 %add, i32* %sum, align 4
  %load_lval3 = load i32, i32* %n, align 4
  %add4 = add i32 %load_lval3, 1
  store i32 %add4, i32* %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %load_lval, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
