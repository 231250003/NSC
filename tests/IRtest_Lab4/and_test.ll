; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 10
@z = global i32 0

define i32 @g(i32 %x, i32 %y) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %y, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param1_addr, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* %param1_addr, align 4
  %load_lval1 = load i32, i32* @z, align 4
  %add2 = add i32 %load_lval1, 1
  store i32 %add2, i32* @z, align 4
  %load_lval3 = load i32, i32* %param1_addr, align 4
  %add4 = add i32 %load_lval3, 1
  ret i32 %add4
}

define i32 @main() {
mainEntry:
  %y = alloca i32, align 4
  store i32 10, i32* %y, align 4
  %load_lval = load i32, i32* %y, align 4
  store i32 %load_lval, i32* @z, align 4
  %load_lval1 = load i32, i32* @x, align 4
  %cmp = icmp sgt i32 %load_lval1, 50
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  %lhs_bool2 = icmp ne i1 %lhs_bool, false
  br i1 %lhs_bool2, label %or.merge, label %or.rhs

merge:                                            ; preds = %cur, %or.merge
  %load_lval21 = load i32, i32* @x, align 4
  ret i32 %load_lval21

or.rhs:                                           ; preds = %mainEntry
  %load_lval3 = load i32, i32* %y, align 4
  %div = sdiv i32 %load_lval3, 2
  %cmp4 = icmp eq i32 %div, 0
  %zext_to_i325 = zext i1 %cmp4 to i32
  %rhs_bool = icmp ne i32 %zext_to_i325, 0
  %rhs_bool6 = icmp ne i1 %rhs_bool, false
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mainEntry
  %or_result = phi i1 [ true, %mainEntry ], [ %rhs_bool6, %or.rhs ]
  %zext_to_i327 = zext i1 %or_result to i32
  %to_bool = icmp ne i32 %zext_to_i327, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %or.merge
  br label %while.cond

cur:                                              ; preds = %if.then19, %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %g = call i32 @g(i32 2, i32 3)
  %load_lval9 = load i32, i32* @x, align 4
  %cmp10 = icmp slt i32 %load_lval9, 50
  %zext_to_i3211 = zext i1 %cmp10 to i32
  %to_bool13 = icmp ne i32 %zext_to_i3211, 0
  br i1 %to_bool13, label %if.then12, label %merge8

while.cond:                                       ; preds = %merge15, %if.then12, %if.then
  br i1 true, label %while.stmt, label %cur

merge8:                                           ; preds = %if.then12, %while.stmt
  %load_lval16 = load i32, i32* @x, align 4
  %cmp17 = icmp sgt i32 %load_lval16, 100
  %zext_to_i3218 = zext i1 %cmp17 to i32
  %to_bool20 = icmp ne i32 %zext_to_i3218, 0
  br i1 %to_bool20, label %if.then19, label %merge15

if.then12:                                        ; preds = %while.stmt
  store i32 2, i32* @x, align 4
  %g14 = call i32 @g(i32 10, i32 2)
  br label %while.cond
  br label %merge8

merge15:                                          ; preds = %if.then19, %merge8
  br label %while.cond

if.then19:                                        ; preds = %merge8
  br label %cur
  br label %merge15
}
