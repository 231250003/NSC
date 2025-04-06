; ModuleID = 'my_module'
source_filename = "my_module"

@y = global i32 0

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 5, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 100, i32* %y, align 4
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp sge i32 %load_lval, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

merge:                                            ; preds = %merge29, %and.merge7
  %load_lval39 = load i32, i32* %x, align 4
  ret i32 %load_lval39

and.rhs:                                          ; preds = %mainEntry
  %load_lval1 = load i32, i32* %y, align 4
  %cmp2 = icmp sgt i32 %load_lval1, 0
  %zext_to_i323 = zext i1 %cmp2 to i32
  %rhs_bool = icmp ne i32 %zext_to_i323, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %mainEntry
  %and_result = phi i1 [ false, %mainEntry ], [ %rhs_bool, %and.rhs ]
  %zext_to_i324 = zext i1 %and_result to i32
  %lhs_bool5 = icmp ne i32 %zext_to_i324, 0
  br i1 %lhs_bool5, label %and.rhs6, label %and.merge7

and.rhs6:                                         ; preds = %and.merge
  %load_lval8 = load i32, i32* %y, align 4
  %div = sdiv i32 %load_lval8, 0
  %cmp9 = icmp eq i32 %div, 0
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %rhs_bool11 = icmp ne i32 %zext_to_i3210, 0
  br label %and.merge7

and.merge7:                                       ; preds = %and.rhs6, %and.merge
  %and_result12 = phi i1 [ false, %and.merge ], [ %rhs_bool11, %and.rhs6 ]
  %zext_to_i3213 = zext i1 %and_result12 to i32
  %to_bool = icmp ne i32 %zext_to_i3213, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %and.merge7
  %load_lval15 = load i32, i32* %x, align 4
  %cmp16 = icmp slt i32 %load_lval15, 6
  %zext_to_i3217 = zext i1 %cmp16 to i32
  %to_bool19 = icmp ne i32 %zext_to_i3217, 0
  br i1 %to_bool19, label %if.then18, label %merge14

merge14:                                          ; preds = %if.then18, %if.then
  %load_lval30 = load i32, i32* %x, align 4
  %cmp31 = icmp sgt i32 %load_lval30, 7
  %zext_to_i3232 = zext i1 %cmp31 to i32
  %to_bool34 = icmp ne i32 %zext_to_i3232, 0
  br i1 %to_bool34, label %if.then33, label %if.else

if.then18:                                        ; preds = %if.then
  %load_lval20 = load i32, i32* %x, align 4
  %not = icmp eq i32 %load_lval20, 0
  %zext_to_i3221 = zext i1 %not to i32
  %load_lval22 = load i32, i32* %x, align 4
  %not23 = icmp eq i32 %load_lval22, 0
  %zext_to_i3224 = zext i1 %not23 to i32
  %add = add i32 %zext_to_i3221, %zext_to_i3224
  %load_lval25 = load i32, i32* %x, align 4
  %not26 = icmp eq i32 %load_lval25, 0
  %zext_to_i3227 = zext i1 %not26 to i32
  %add28 = add i32 %add, %zext_to_i3227
  store i32 %add28, i32* %x, align 4
  br label %merge14

merge29:                                          ; preds = %if.else, %if.then33
  br label %merge

if.then33:                                        ; preds = %merge14
  %load_lval35 = load i32, i32* %x, align 4
  %add36 = add i32 %load_lval35, 1
  store i32 %add36, i32* %x, align 4
  br label %merge29

if.else:                                          ; preds = %merge14
  %load_lval37 = load i32, i32* %x, align 4
  %add38 = add i32 %load_lval37, 100
  store i32 %add38, i32* %x, align 4
  br label %merge29
}
