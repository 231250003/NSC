; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval2 = load i32, i32* %i, align 4
  %cmp3 = icmp eq i32 %load_lval2, 3
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool5 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool5, label %if.then, label %if.else

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %i, align 4
  %add = add i32 %load_lval1, 1
  store i32 %add, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %load_lval, 3
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.else, %if.then
  %load_lval10 = load i32, i32* %i, align 4
  %add11 = add i32 %load_lval10, 3
  store i32 %add11, i32* %i, align 4
  %load_lval12 = load i32, i32* %i, align 4
  ret i32 %load_lval12

if.then:                                          ; preds = %cur
  %load_lval6 = load i32, i32* %i, align 4
  %add7 = add i32 %load_lval6, 1
  store i32 %add7, i32* %i, align 4
  br label %merge

if.else:                                          ; preds = %cur
  %load_lval8 = load i32, i32* %i, align 4
  %add9 = add i32 %load_lval8, 2
  store i32 %add9, i32* %i, align 4
  br label %merge
}
