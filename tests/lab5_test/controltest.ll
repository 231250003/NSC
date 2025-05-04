; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 0, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 0, i32* %y, align 4
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp eq i32 %load_lval, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %cur, %mainEntry
  %load_lval6 = load i32, i32* %y, align 4
  ret i32 %load_lval6

if.then:                                          ; preds = %mainEntry
  br label %while.cond

cur:                                              ; preds = %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %load_lval5 = load i32, i32* %y, align 4
  %add = add i32 %load_lval5, 1
  store i32 %add, i32* %y, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %if.then
  %load_lval1 = load i32, i32* %y, align 4
  %cmp2 = icmp slt i32 %load_lval1, 5
  %zext_to_i323 = zext i1 %cmp2 to i32
  %to_bool4 = icmp ne i32 %zext_to_i323, 0
  br i1 %to_bool4, label %while.stmt, label %cur
}
