; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval23 = load i32, i32* %i, align 4
  %load_lval24 = load i32, i32* %j, align 4
  %add25 = add i32 %load_lval23, %load_lval24
  ret i32 %add25

while.stmt:                                       ; preds = %while.cond
  store i32 0, i32* %j, align 4
  br label %while.cond3

while.cond:                                       ; preds = %cur1, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 3
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur1:                                             ; preds = %if.then17, %while.cond3
  %load_lval21 = load i32, i32* %i, align 4
  %add22 = add i32 %load_lval21, 1
  store i32 %add22, i32* %i, align 4
  br label %while.cond

while.stmt2:                                      ; preds = %while.cond3
  %load_lval8 = load i32, i32* %j, align 4
  %cmp9 = icmp eq i32 %load_lval8, 2
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %to_bool11 = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool11, label %if.then, label %merge

while.cond3:                                      ; preds = %merge13, %if.then, %while.stmt
  %load_lval4 = load i32, i32* %j, align 4
  %cmp5 = icmp slt i32 %load_lval4, 5
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool7 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool7, label %while.stmt2, label %cur1

merge:                                            ; preds = %while.stmt2
  %load_lval14 = load i32, i32* %j, align 4
  %cmp15 = icmp eq i32 %load_lval14, 4
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %to_bool18 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool18, label %if.then17, label %merge13

if.then:                                          ; preds = %while.stmt2
  %load_lval12 = load i32, i32* %j, align 4
  %add = add i32 %load_lval12, 1
  store i32 %add, i32* %j, align 4
  br label %while.cond3

merge13:                                          ; preds = %merge
  %load_lval19 = load i32, i32* %j, align 4
  %add20 = add i32 %load_lval19, 1
  store i32 %add20, i32* %j, align 4
  br label %while.cond3

if.then17:                                        ; preds = %merge
  br label %cur1
}
