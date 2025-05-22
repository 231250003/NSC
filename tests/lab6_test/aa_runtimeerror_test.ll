; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %result = alloca i32, align 4
  store i32 0, i32* %result, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval29 = load i32, i32* %result, align 4
  ret i32 %load_lval29

while.stmt:                                       ; preds = %while.cond
  %j = alloca i32, align 4
  %load_lval2 = load i32, i32* %i, align 4
  store i32 %load_lval2, i32* %j, align 4
  br label %while.cond5

while.cond:                                       ; preds = %cur3, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 6
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur3:                                             ; preds = %while.stmt4, %while.cond5
  %load_lval27 = load i32, i32* %i, align 4
  %add28 = add i32 %load_lval27, 1
  store i32 %add28, i32* %i, align 4
  br label %while.cond

while.stmt4:                                      ; preds = %while.cond5
  %load_lval11 = load i32, i32* %j, align 4
  %cmp13 = icmp eq i32 %load_lval11, 5
  %zext_to_i3214 = zext i1 %cmp13 to i32
  %to_bool15 = icmp ne i32 %zext_to_i3214, 0
  br i1 %to_bool15, label %cur3, label %merge

while.cond5:                                      ; preds = %merge16, %if.then20, %while.stmt
  %load_lval6 = load i32, i32* %j, align 4
  %cmp8 = icmp slt i32 %load_lval6, 6
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool10 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool10, label %while.stmt4, label %cur3

merge:                                            ; preds = %while.stmt4
  %load_lval17 = load i32, i32* %j, align 4
  %mod = srem i32 %load_lval17, 2
  %cmp18 = icmp eq i32 %mod, 0
  %zext_to_i3219 = zext i1 %cmp18 to i32
  %to_bool21 = icmp ne i32 %zext_to_i3219, 0
  br i1 %to_bool21, label %if.then20, label %merge16

merge16:                                          ; preds = %if.then20, %merge
  %load_lval23 = load i32, i32* %result, align 4
  %add24 = add i32 %load_lval23, 1
  store i32 %add24, i32* %result, align 4
  %load_lval25 = load i32, i32* %j, align 4
  %add26 = add i32 %load_lval25, 1
  store i32 %add26, i32* %j, align 4
  br label %while.cond5

if.then20:                                        ; preds = %merge
  %load_lval22 = load i32, i32* %j, align 4
  %add = add i32 %load_lval22, 1
  store i32 %add, i32* %j, align 4
  br label %while.cond5
  br label %merge16
}
