; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  br i1 true, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry
  %c = alloca i32, align 4
  %load_lval2 = load i32, i32* %num, align 4
  store i32 %load_lval2, i32* %c, align 4
  %load_lval4 = load i32, i32* %c, align 4
  %cmp5 = icmp eq i32 %load_lval4, 1
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool8 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool8, label %if.then7, label %merge3

if.then:                                          ; preds = %mainEntry
  store i32 2, i32* %num, align 4
  br label %merge

merge3:                                           ; preds = %if.then7, %merge
  br label %while.cond

if.then7:                                         ; preds = %merge
  %load_lval9 = load i32, i32* %c, align 4
  %add10 = add i32 %load_lval9, 1
  store i32 %add10, i32* %c, align 4
  br label %merge3

cur:                                              ; preds = %while.cond
  %load_lval19 = load i32, i32* %c, align 4
  ret i32 %load_lval19

while.stmt:                                       ; preds = %while.cond
  %load_lval15 = load i32, i32* %num, align 4
  %add16 = add i32 %load_lval15, 1
  store i32 %add16, i32* %num, align 4
  %load_lval17 = load i32, i32* %c, align 4
  %add18 = add i32 %load_lval17, 1
  store i32 %add18, i32* %c, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %merge3
  %load_lval11 = load i32, i32* %num, align 4
  %cmp12 = icmp sle i32 %load_lval11, 10
  %zext_to_i3213 = zext i1 %cmp12 to i32
  %to_bool14 = icmp ne i32 %zext_to_i3213, 0
  br i1 %to_bool14, label %while.stmt, label %cur
}
