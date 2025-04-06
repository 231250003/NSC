; ModuleID = 'my_module'
source_filename = "my_module"

@y = global i32 0

define i32 @g(i32 %x, i32 %y) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %y, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %add = add i32 %load_lval, 1
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %t = alloca i32, align 4
  store i32 100, i32* %t, align 4
  %x = alloca i32, align 4
  store i32 5, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 100, i32* %y, align 4
  %z = alloca i32, align 4
  %load_lval = load i32, i32* %y, align 4
  %add = add i32 %load_lval, 100
  store i32 %add, i32* %z, align 4
  %load_lval1 = load i32, i32* %x, align 4
  %lhs_bool = icmp ne i32 %load_lval1, 0
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %merge14, %or.merge5
  %load_lval36 = load i32, i32* %x, align 4
  ret i32 %load_lval36

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
  %load_lval15 = load i32, i32* %x, align 4
  %not = icmp eq i32 %load_lval15, 0
  %zext_to_i3216 = zext i1 %not to i32
  %lhs_bool17 = icmp ne i32 %zext_to_i3216, 0
  br i1 %lhs_bool17, label %and.rhs18, label %and.merge19

merge14:                                          ; preds = %if.else, %if.then26
  br label %merge

and.rhs18:                                        ; preds = %if.then
  %load_lval20 = load i32, i32* %x, align 4
  %div21 = sdiv i32 %load_lval20, 0
  %cmp = icmp eq i32 %div21, 0
  %zext_to_i3222 = zext i1 %cmp to i32
  %rhs_bool23 = icmp ne i32 %zext_to_i3222, 0
  br label %and.merge19

and.merge19:                                      ; preds = %and.rhs18, %if.then
  %and_result24 = phi i1 [ false, %if.then ], [ %rhs_bool23, %and.rhs18 ]
  %zext_to_i3225 = zext i1 %and_result24 to i32
  %to_bool27 = icmp ne i32 %zext_to_i3225, 0
  br i1 %to_bool27, label %if.then26, label %if.else

if.then26:                                        ; preds = %and.merge19
  %load_lval28 = load i32, i32* %x, align 4
  %add29 = add i32 %load_lval28, 1
  store i32 %add29, i32* %x, align 4
  br label %merge14

if.else:                                          ; preds = %and.merge19
  %load_lval30 = load i32, i32* %z, align 4
  %load_lval31 = load i32, i32* %y, align 4
  %sub = sub i32 %load_lval30, %load_lval31
  %load_lval32 = load i32, i32* %x, align 4
  %div33 = sdiv i32 %load_lval32, 2
  %add34 = add i32 %sub, %div33
  %add35 = add i32 %add34, 1
  store i32 %add35, i32* %x, align 4
  br label %merge14
}
