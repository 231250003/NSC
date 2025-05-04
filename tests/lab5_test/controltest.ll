; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %j = alloca i32, align 4
  store i32 5, i32* %j, align 4
  br label %while.cond7

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %sum, align 4
  %load_lval2 = load i32, i32* %i, align 4
  %add = add i32 %load_lval1, %load_lval2
  store i32 %add, i32* %sum, align 4
  %load_lval3 = load i32, i32* %i, align 4
  %add4 = add i32 %load_lval3, 1
  store i32 %add4, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 3
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur5:                                             ; preds = %while.cond7
  %load_lval16 = load i32, i32* %sum, align 4
  ret i32 %load_lval16

while.stmt6:                                      ; preds = %while.cond7
  %load_lval12 = load i32, i32* %sum, align 4
  %load_lval13 = load i32, i32* %j, align 4
  %add14 = add i32 %load_lval12, %load_lval13
  store i32 %add14, i32* %sum, align 4
  %load_lval15 = load i32, i32* %j, align 4
  %sub = sub i32 %load_lval15, 1
  store i32 %sub, i32* %j, align 4
  br label %while.cond7

while.cond7:                                      ; preds = %while.stmt6, %cur
  %load_lval8 = load i32, i32* %j, align 4
  %cmp9 = icmp sgt i32 %load_lval8, 0
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %to_bool11 = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool11, label %while.stmt6, label %cur5
}
