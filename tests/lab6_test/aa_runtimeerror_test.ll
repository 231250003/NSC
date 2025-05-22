; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  ret i32 0
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval3 = load i32, i32* %i, align 4
  %cmp4 = icmp eq i32 %load_lval3, 3
  %zext_to_i325 = zext i1 %cmp4 to i32
  %to_bool6 = icmp ne i32 %zext_to_i325, 0
  br i1 %to_bool6, label %if.then, label %if.else

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* %i, align 4
  %add = add i32 %load_lval2, 1
  store i32 %add, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval1 = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %load_lval1, 3
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.else, %if.then
  %load_lval11 = load i32, i32* %i, align 4
  ret i32 %load_lval11

if.then:                                          ; preds = %cur
  %load_lval7 = load i32, i32* %i, align 4
  %add8 = add i32 %load_lval7, 1
  store i32 %add8, i32* %i, align 4
  br label %merge

if.else:                                          ; preds = %cur
  %load_lval9 = load i32, i32* %i, align 4
  %add10 = add i32 %load_lval9, 2
  store i32 %add10, i32* %i, align 4
  br label %merge
}
