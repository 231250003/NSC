; ModuleID = 'my_module'
source_filename = "my_module"

@y = global i32 0

define i32 @f(i32 %x, i32 %t) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %t, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %load_lval1 = load i32, i32* %param1_addr, align 4
  %add = add i32 %load_lval, %load_lval1
  ret i32 %add
}

define i32 @g(i32 %x, i32 %y, i32 %z) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %y, i32* %param1_addr, align 4
  %param2_addr = alloca i32, align 4
  store i32 %z, i32* %param2_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %load_lval1 = load i32, i32* %param2_addr, align 4
  %f = call i32 @f(i32 %load_lval, i32 %load_lval1)
  ret i32 %f
}

define i32 @main() {
mainEntry:
  %t = alloca i32, align 4
  store i32 100, i32* %t, align 4
  %x = alloca i32, align 4
  %load_lval = load i32, i32* %t, align 4
  %g = call i32 @g(i32 2, i32 4, i32 %load_lval)
  store i32 %g, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 100, i32* %y, align 4
  %z = alloca i32, align 4
  %load_lval1 = load i32, i32* %y, align 4
  %add = add i32 %load_lval1, 100
  store i32 %add, i32* %z, align 4
  %load_lval2 = load i32, i32* %x, align 4
  %lhs_bool = icmp ne i32 %load_lval2, 0
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %cur, %or.merge6
  %load_lval42 = load i32, i32* %x, align 4
  ret i32 %load_lval42

or.rhs:                                           ; preds = %mainEntry
  %load_lval3 = load i32, i32* %x, align 4
  %mod = srem i32 %load_lval3, 0
  %rhs_bool = icmp ne i32 %mod, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mainEntry
  %or_result = phi i1 [ true, %mainEntry ], [ %rhs_bool, %or.rhs ]
  %zext_to_i32 = zext i1 %or_result to i32
  %lhs_bool4 = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool4, label %or.merge6, label %or.rhs5

or.rhs5:                                          ; preds = %or.merge
  %load_lval7 = load i32, i32* %x, align 4
  %div = sdiv i32 %load_lval7, 0
  %lhs_bool8 = icmp ne i32 %div, 0
  br i1 %lhs_bool8, label %and.rhs, label %and.merge

or.merge6:                                        ; preds = %and.merge, %or.merge
  %or_result13 = phi i1 [ true, %or.merge ], [ %rhs_bool12, %and.merge ]
  %zext_to_i3214 = zext i1 %or_result13 to i32
  %to_bool = icmp ne i32 %zext_to_i3214, 0
  br i1 %to_bool, label %if.then, label %merge

and.rhs:                                          ; preds = %or.rhs5
  %load_lval9 = load i32, i32* %x, align 4
  %rhs_bool10 = icmp ne i32 %load_lval9, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %or.rhs5
  %and_result = phi i1 [ false, %or.rhs5 ], [ %rhs_bool10, %and.rhs ]
  %zext_to_i3211 = zext i1 %and_result to i32
  %rhs_bool12 = icmp ne i32 %zext_to_i3211, 0
  br label %or.merge6

if.then:                                          ; preds = %or.merge6
  %y15 = alloca i32, align 4
  store i32 100, i32* %y15, align 4
  %x16 = alloca i32, align 4
  store i32 5, i32* %x16, align 4
  br label %while.cond

cur:                                              ; preds = %merge22, %while.cond
  %load_lval38 = load i32, i32* %x, align 4
  %load_lval39 = load i32, i32* %y15, align 4
  %add40 = add i32 %load_lval38, %load_lval39
  %add41 = add i32 %add40, 5
  store i32 %add41, i32* %x, align 4
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %load_lval20 = load i32, i32* %x16, align 4
  %add21 = add i32 %load_lval20, 5
  store i32 %add21, i32* %x16, align 4
  %load_lval23 = load i32, i32* %x16, align 4
  %cmp24 = icmp slt i32 %load_lval23, 100
  %zext_to_i3225 = zext i1 %cmp24 to i32
  %to_bool27 = icmp ne i32 %zext_to_i3225, 0
  br i1 %to_bool27, label %if.then26, label %if.else

while.cond:                                       ; preds = %merge22, %if.then34, %if.then26, %if.then
  %load_lval17 = load i32, i32* %x16, align 4
  %cmp = icmp sgt i32 %load_lval17, 0
  %zext_to_i3218 = zext i1 %cmp to i32
  %to_bool19 = icmp ne i32 %zext_to_i3218, 0
  br i1 %to_bool19, label %while.stmt, label %cur

merge22:                                          ; preds = %merge30, %if.then26
  br label %cur
  br label %while.cond

if.then26:                                        ; preds = %while.stmt
  %load_lval28 = load i32, i32* %y15, align 4
  %add29 = add i32 %load_lval28, 1
  store i32 %add29, i32* %y15, align 4
  br label %while.cond
  br label %merge22

if.else:                                          ; preds = %while.stmt
  %load_lval31 = load i32, i32* %x16, align 4
  %cmp32 = icmp slt i32 %load_lval31, 50
  %zext_to_i3233 = zext i1 %cmp32 to i32
  %to_bool35 = icmp ne i32 %zext_to_i3233, 0
  br i1 %to_bool35, label %if.then34, label %merge30

merge30:                                          ; preds = %if.then34, %if.else
  br label %merge22

if.then34:                                        ; preds = %if.else
  %load_lval36 = load i32, i32* %y15, align 4
  %add37 = add i32 %load_lval36, 1
  store i32 %add37, i32* %y15, align 4
  br label %while.cond
  br label %merge30
}
