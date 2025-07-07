; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %n = alloca i32, align 4
  store i32 10, i32* %n, align 4
  %i = alloca i32, align 4
  store i32 1, i32* %i, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  %load_lval6 = load i32, i32* %sum, align 4
  ret i32 %load_lval6

for.stmt:                                         ; preds = %for.cond
  %load_lval2 = load i32, i32* %sum, align 4
  %load_lval3 = load i32, i32* %i, align 4
  %add = add i32 %load_lval2, %load_lval3
  store i32 %add, i32* %sum, align 4
  %load_lval4 = load i32, i32* %i, align 4
  %add5 = add i32 %load_lval4, 1
  store i32 %add5, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %load_lval1 = load i32, i32* %n, align 4
  %cmp = icmp sle i32 %load_lval, %load_lval1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur
}
