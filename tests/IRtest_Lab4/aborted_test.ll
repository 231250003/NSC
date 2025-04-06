; ModuleID = 'my_module'
source_filename = "my_module"

@y = global i32 0

define i32 @f(i32 %x) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %add = add i32 %load_lval, 100
  ret i32 %add
}

define i32 @g(i32 %x, i32 %y) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %y, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %f = call i32 @f(i32 %load_lval)
  ret i32 %f
}

define i32 @main() {
mainEntry:
  %t = alloca i32, align 4
  store i32 100, i32* %t, align 4
  %x = alloca i32, align 4
  %g = call i32 @g(i32 2, i32 4)
  store i32 %g, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 100, i32* %y, align 4
  %z = alloca i32, align 4
  %load_lval = load i32, i32* %y, align 4
  %add = add i32 %load_lval, 100
  store i32 %add, i32* %z, align 4
  %load_lval1 = load i32, i32* %x, align 4
  %lhs_bool = icmp ne i32 %load_lval1, 0
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %cur, %or.merge5
  %load_lval39 = load i32, i32* %x, align 4
  ret i32 %load_lval39

or.rhs:                                           ; preds = %mainEntry
  %load_lval2 = load i32, i32* %x, align 4
  %mod = srem i32 %load_lval2, 0
  %rhs_bool = icmp ne i32 %mod, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mainEntry
  %or_result = phi i1 [ true, %mainEntry ], [ %rhs_bool, %or.rhs ]
  %zext_to_i32 = zext i1 %or_result to i32
  %lhs_bool3 = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool3, label %or.merge5, label %or.rhs4

or.rhs4:                                          ; preds = %or.merge
  %load_lval6 = load i32, i32* %x, align 4
  %div = sdiv i32 %load_lval6, 0
  %lhs_bool7 = icmp ne i32 %div, 0
  br i1 %lhs_bool7, label %and.rhs, label %and.merge

or.merge5:                                        ; preds = %and.merge, %or.merge
  %or_result12 = phi i1 [ true, %or.merge ], [ %rhs_bool11, %and.merge ]
  %zext_to_i3213 = zext i1 %or_result12 to i32
  %to_bool = icmp ne i32 %zext_to_i3213, 0
  br i1 %to_bool, label %if.then, label %merge

and.rhs:                                          ; preds = %or.rhs4
  %load_lval8 = load i32, i32* %x, align 4
  %rhs_bool9 = icmp ne i32 %load_lval8, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %or.rhs4
  %and_result = phi i1 [ false, %or.rhs4 ], [ %rhs_bool9, %and.rhs ]
  %zext_to_i3210 = zext i1 %and_result to i32
  %rhs_bool11 = icmp ne i32 %zext_to_i3210, 0
  br label %or.merge5

if.then:                                          ; preds = %or.merge5
  %y14 = alloca i32, align 4
  store i32 100, i32* %y14, align 4
  %x15 = alloca i32, align 4
  store i32 5, i32* %x15, align 4
  br label %while.cond

cur:                                              ; preds = %merge21, %while.cond
  %load_lval37 = load i32, i32* %y14, align 4
  %add38 = add i32 %load_lval37, 5
  store i32 %add38, i32* %x, align 4
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %load_lval19 = load i32, i32* %x15, align 4
  %add20 = add i32 %load_lval19, 5
  store i32 %add20, i32* %x15, align 4
  %load_lval22 = load i32, i32* %x15, align 4
  %cmp23 = icmp slt i32 %load_lval22, 100
  %zext_to_i3224 = zext i1 %cmp23 to i32
  %to_bool26 = icmp ne i32 %zext_to_i3224, 0
  br i1 %to_bool26, label %if.then25, label %if.else

while.cond:                                       ; preds = %merge21, %if.then33, %if.then25, %if.then
  %load_lval16 = load i32, i32* %x15, align 4
  %cmp = icmp sgt i32 %load_lval16, 0
  %zext_to_i3217 = zext i1 %cmp to i32
  %to_bool18 = icmp ne i32 %zext_to_i3217, 0
  br i1 %to_bool18, label %while.stmt, label %cur

merge21:                                          ; preds = %merge29, %if.then25
  br label %cur
  br label %while.cond

if.then25:                                        ; preds = %while.stmt
  %load_lval27 = load i32, i32* %y14, align 4
  %add28 = add i32 %load_lval27, 1
  store i32 %add28, i32* %y14, align 4
  br label %while.cond
  br label %merge21

if.else:                                          ; preds = %while.stmt
  %load_lval30 = load i32, i32* %x15, align 4
  %cmp31 = icmp slt i32 %load_lval30, 50
  %zext_to_i3232 = zext i1 %cmp31 to i32
  %to_bool34 = icmp ne i32 %zext_to_i3232, 0
  br i1 %to_bool34, label %if.then33, label %merge29

merge29:                                          ; preds = %if.then33, %if.else
  br label %merge21

if.then33:                                        ; preds = %if.else
  %load_lval35 = load i32, i32* %y14, align 4
  %add36 = add i32 %load_lval35, 1
  store i32 %add36, i32* %y14, align 4
  br label %while.cond
  br label %merge29
}
