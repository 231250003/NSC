; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %acc = alloca i32, align 4
  store i32 0, i32* %acc, align 4
  br label %while.cond

cur:                                              ; preds = %if.then, %while.cond
  %load_lval9 = load i32, i32* %acc, align 4
  ret i32 %load_lval9

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %acc, align 4
  %load_lval2 = load i32, i32* %i, align 4
  %add = add i32 %load_lval1, %load_lval2
  store i32 %add, i32* %acc, align 4
  %load_lval3 = load i32, i32* %acc, align 4
  %cmp4 = icmp sgt i32 %load_lval3, 10
  %zext_to_i325 = zext i1 %cmp4 to i32
  %to_bool6 = icmp ne i32 %zext_to_i325, 0
  br i1 %to_bool6, label %if.then, label %merge

while.cond:                                       ; preds = %merge, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 6
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %while.stmt
  %load_lval7 = load i32, i32* %i, align 4
  %add8 = add i32 %load_lval7, 1
  store i32 %add8, i32* %i, align 4
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  br label %cur
}
