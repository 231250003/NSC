; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  ret i32 2

while.stmt:                                       ; preds = %while.cond
  %v = alloca i32, align 4
  store i32 1, i32* %v, align 4
  br label %while.cond4

while.cond:                                       ; preds = %cur2, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 6
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur2:                                             ; preds = %while.cond4
  %load_lval11 = load i32, i32* %i, align 4
  %add12 = add i32 %load_lval11, 1
  store i32 %add12, i32* %i, align 4
  br label %while.cond

while.stmt3:                                      ; preds = %while.cond4
  %load_lval10 = load i32, i32* %v, align 4
  %add = add i32 %load_lval10, 1
  store i32 %add, i32* %v, align 4
  br label %while.cond4

while.cond4:                                      ; preds = %while.stmt3, %while.stmt
  %load_lval5 = load i32, i32* %v, align 4
  %cmp7 = icmp sle i32 %load_lval5, 6
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool9 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool9, label %while.stmt3, label %cur2
}
