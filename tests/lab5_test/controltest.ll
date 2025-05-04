; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 0, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 0, i32* %y, align 4
  br label %while.cond

cur:                                              ; preds = %if.then10, %while.cond
  %load_lval17 = load i32, i32* %y, align 4
  ret i32 %load_lval17

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %x, align 4
  %mod = srem i32 %load_lval1, 2
  %cmp2 = icmp eq i32 %mod, 0
  %zext_to_i323 = zext i1 %cmp2 to i32
  %to_bool4 = icmp ne i32 %zext_to_i323, 0
  br i1 %to_bool4, label %if.then, label %merge

while.cond:                                       ; preds = %merge6, %if.then, %mainEntry
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp slt i32 %load_lval, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %while.stmt
  %load_lval7 = load i32, i32* %x, align 4
  %cmp8 = icmp eq i32 %load_lval7, 7
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool11 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool11, label %if.then10, label %merge6

if.then:                                          ; preds = %while.stmt
  %load_lval5 = load i32, i32* %x, align 4
  %add = add i32 %load_lval5, 1
  store i32 %add, i32* %x, align 4
  br label %while.cond

merge6:                                           ; preds = %merge
  %load_lval12 = load i32, i32* %y, align 4
  %load_lval13 = load i32, i32* %x, align 4
  %add14 = add i32 %load_lval12, %load_lval13
  store i32 %add14, i32* %y, align 4
  %load_lval15 = load i32, i32* %x, align 4
  %add16 = add i32 %load_lval15, 1
  store i32 %add16, i32* %x, align 4
  br label %while.cond

if.then10:                                        ; preds = %merge
  br label %cur
}
