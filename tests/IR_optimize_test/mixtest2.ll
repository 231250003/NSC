; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 0, i32* %num, align 4
  %c = alloca i32, align 4
  store i32 2, i32* %c, align 4
  store i32 0, i32* %c, align 4
  store i32 1, i32* %c, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval12 = load i32, i32* %c, align 4
  %load_lval13 = load i32, i32* %num, align 4
  %add14 = add i32 %load_lval12, %load_lval13
  ret i32 %add14

while.stmt:                                       ; preds = %while.cond
  %load_lval8 = load i32, i32* %num, align 4
  %add9 = add i32 %load_lval8, 1
  store i32 %add9, i32* %num, align 4
  %load_lval10 = load i32, i32* %c, align 4
  %add11 = add i32 %load_lval10, 1
  store i32 %add11, i32* %c, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval4 = load i32, i32* %num, align 4
  %cmp5 = icmp sle i32 %load_lval4, 10
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool7 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool7, label %while.stmt, label %cur
}
