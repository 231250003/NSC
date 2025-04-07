; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 10

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @a, align 4
  %cmp = icmp ne i32 %load_lval, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

and.rhs:                                          ; preds = %mainEntry
  %load_lval1 = load i32, i32* @a, align 4
  %cmp2 = icmp ne i32 %load_lval1, 2
  %zext_to_i323 = zext i1 %cmp2 to i32
  %rhs_bool = icmp ne i32 %zext_to_i323, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %mainEntry
  %and_result = phi i1 [ false, %mainEntry ], [ %rhs_bool, %and.rhs ]
  %zext_to_i324 = zext i1 %and_result to i32
  %to_bool = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool, label %if.then, <null operand!>

if.then:                                          ; preds = %and.merge
  store i32 2, i32* @a, align 4
  br label %merge

merge:                                            ; preds = %if.then
  %load_lval5 = load i32, i32* @a, align 4
  %cmp6 = icmp eq i32 %load_lval5, 4
  %zext_to_i327 = zext i1 %cmp6 to i32
  %to_bool9 = icmp ne i32 %zext_to_i327, 0
  br i1 %to_bool9, label %if.then8, label %if.else

if.then8:                                         ; preds = %merge
  store i32 5, i32* @a, align 4
  br label %merge10

if.else:                                          ; preds = %merge
  %load_lval11 = load i32, i32* @a, align 4
  %cmp12 = icmp eq i32 %load_lval11, 3
  %zext_to_i3213 = zext i1 %cmp12 to i32
  %to_bool16 = icmp ne i32 %zext_to_i3213, 0
  br i1 %to_bool16, label %if.then14, label %if.else15

merge10:                                          ; preds = %if.then8
  %load_lval25 = load i32, i32* @a, align 4
  %add = add i32 %load_lval25, 1
  store i32 %add, i32* @a, align 4
  %load_lval26 = load i32, i32* @a, align 4
  ret i32 %load_lval26

if.then14:                                        ; preds = %if.else
  store i32 20, i32* @a, align 4
  br label %merge17

if.else15:                                        ; preds = %if.else
  %load_lval18 = load i32, i32* @a, align 4
  %cmp19 = icmp eq i32 %load_lval18, 6
  %zext_to_i3220 = zext i1 %cmp19 to i32
  %to_bool23 = icmp ne i32 %zext_to_i3220, 0
  br i1 %to_bool23, label %if.then21, label %if.else22

merge17:                                          ; preds = %if.then14

if.then21:                                        ; preds = %if.else15
  store i32 7, i32* @a, align 4
  br label %merge24

if.else22:                                        ; preds = %if.else15
  store i32 8, i32* @a, align 4
  br label %merge24
  br label %merge24

merge24:                                          ; preds = %if.else22, %if.else22, %if.then21
}
