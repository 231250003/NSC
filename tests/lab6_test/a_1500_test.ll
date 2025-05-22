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
  br label %while.cond

cur:                                              ; preds = %while.cond
  unreachable

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %i, align 4
  %add = add i32 %load_lval1, 1
  store i32 %add, i32* %i, align 4
  %load_lval2 = load i32, i32* %sum, align 4
  %load_lval3 = load i32, i32* %i, align 4
  %add4 = add i32 %load_lval2, %load_lval3
  %add5 = add i32 %add4, 1
  store i32 %add5, i32* %sum, align 4
  %load_lval6 = load i32, i32* %sum, align 4
  ret i32 %load_lval6
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
