; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  %load_lval11 = load i32, i32* %sum, align 4
  ret i32 %load_lval11

for.stmt:                                         ; preds = %for.cond
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond3

for.cond:                                         ; preds = %cur1, %mainEntry
  %load_lval = load i32, i32* %j, align 4
  %cmp = icmp sle i32 %load_lval, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur

cur1:                                             ; preds = %for.stmt2, %for.cond3
  %load_lval9 = load i32, i32* %j, align 4
  %add10 = add i32 %load_lval9, 1
  store i32 %add10, i32* %j, align 4
  br label %for.cond

for.stmt2:                                        ; preds = %for.cond3
  br label %cur1

for.cond3:                                        ; preds = %for.stmt
  %load_lval4 = load i32, i32* %i, align 4
  %cmp5 = icmp sle i32 %load_lval4, 10
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool7 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool7, label %for.stmt2, label %cur1
}
