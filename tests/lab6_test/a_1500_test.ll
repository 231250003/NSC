; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 64, i32* %i, align 4
  %res = alloca i32, align 4
  store i32 64, i32* %res, align 4
  store i32 1, i32* %i, align 4
  store i32 1, i32* %res, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval5 = load i32, i32* %res, align 4
  ret i32 %load_lval5

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* %res, align 4
  %load_lval3 = load i32, i32* %i, align 4
  %mul = mul i32 %load_lval2, %load_lval3
  store i32 %mul, i32* %res, align 4
  %load_lval4 = load i32, i32* %i, align 4
  %add = add i32 %load_lval4, 1
  store i32 %add, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %load_lval, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
