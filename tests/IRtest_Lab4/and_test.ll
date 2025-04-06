; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 10
@z = global i32 0

define i32 @g(i32 %t, i32 %y) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %t, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %y, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param1_addr, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* %param1_addr, align 4
  %load_lval1 = load i32, i32* @z, align 4
  %add2 = add i32 %load_lval1, 1
  store i32 %add2, i32* @z, align 4
  %load_lval3 = load i32, i32* @x, align 4
  %add4 = add i32 %load_lval3, 1
  store i32 %add4, i32* @x, align 4
  %load_lval5 = load i32, i32* %param1_addr, align 4
  %add6 = add i32 %load_lval5, 1
  ret i32 %add6
}

define i32 @main() {
mainEntry:
  store i32 4, i32* @z, align 4
  %load_lval = load i32, i32* @x, align 4
  %cmp = icmp sgt i32 %load_lval, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %cur, %mainEntry
  %load_lval14 = load i32, i32* @x, align 4
  %add = add i32 %load_lval14, 1
  ret i32 %add

if.then:                                          ; preds = %mainEntry
  %p = alloca i32, align 4
  store i32 5, i32* %p, align 4
  br label %while.cond

cur:                                              ; preds = %if.then12, %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* @z, align 4
  %cmp3 = icmp slt i32 %load_lval2, 102
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool5 = icmp ne i32 %zext_to_i324, 0
  br label %while.cond7

while.cond:                                       ; preds = %merge8, %if.then
  br i1 true, label %while.stmt, label %cur

cur1:                                             ; preds = %while.cond7
  %load_lval9 = load i32, i32* @x, align 4
  %cmp10 = icmp sgt i32 %load_lval9, 10
  %zext_to_i3211 = zext i1 %cmp10 to i32
  %to_bool13 = icmp ne i32 %zext_to_i3211, 0
  br i1 %to_bool13, label %if.then12, label %merge8

while.stmt6:                                      ; preds = %while.cond7
  %g = call i32 @g(i32 10, i32 20)
  br label %while.cond7

while.cond7:                                      ; preds = %while.stmt6, %while.stmt
  br i1 %to_bool5, label %while.stmt6, label %cur1

merge8:                                           ; preds = %if.then12, %cur1
  br label %while.cond

if.then12:                                        ; preds = %cur1
  br label %cur
  br label %merge8
}
