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
  %load_lval1 = load i32, i32* %c, align 4
  %cmp = icmp eq i32 %load_lval1, 1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry
  br label %while.cond

if.then:                                          ; preds = %mainEntry
  %load_lval2 = load i32, i32* %c, align 4
  %add = add i32 %load_lval2, 1
  store i32 %add, i32* %c, align 4
  br label %merge

cur:                                              ; preds = %while.cond
  %load_lval9 = load i32, i32* %num, align 4
  %load_lval10 = load i32, i32* %num, align 4
  %mul = mul i32 %load_lval9, %load_lval10
  %load_lval11 = load i32, i32* %c, align 4
  %add12 = add i32 %mul, %load_lval11
  ret i32 %add12

while.stmt:                                       ; preds = %while.cond
  %load_lval7 = load i32, i32* %num, align 4
  %add8 = add i32 %load_lval7, 1
  store i32 %add8, i32* %num, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %merge
  %load_lval3 = load i32, i32* %num, align 4
  %cmp4 = icmp sle i32 %load_lval3, 10
  %zext_to_i325 = zext i1 %cmp4 to i32
  %to_bool6 = icmp ne i32 %zext_to_i325, 0
  br i1 %to_bool6, label %while.stmt, label %cur
}
