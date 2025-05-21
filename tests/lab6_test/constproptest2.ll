; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  %c = alloca i32, align 4
  %load_lval = load i32, i32* %num, align 4
  store i32 %load_lval, i32* %c, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval3 = load i32, i32* %num, align 4
  %load_lval4 = load i32, i32* %num, align 4
  %mul = mul i32 %load_lval3, %load_lval4
  %load_lval5 = load i32, i32* %c, align 4
  %add6 = add i32 %mul, %load_lval5
  ret i32 %add6

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* %num, align 4
  %add = add i32 %load_lval2, 1
  store i32 %add, i32* %num, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval1 = load i32, i32* %num, align 4
  %cmp = icmp sle i32 %load_lval1, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
