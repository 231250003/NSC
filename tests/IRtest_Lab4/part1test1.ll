; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 10

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @a, align 4
  %cmp = icmp ne i32 %load_lval, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  %lhs_bool1 = icmp ne i1 %lhs_bool, false
  br i1 %lhs_bool1, label %and.rhs, label %and.merge

merge:                                            ; preds = %if.then, %and.merge
  %load_lval8 = load i32, i32* @a, align 4
  %cmp9 = icmp eq i32 %load_lval8, 4
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %to_bool12 = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool12, label %if.then11, label %if.else

and.rhs:                                          ; preds = %mainEntry
  %load_lval2 = load i32, i32* @a, align 4
  %cmp3 = icmp ne i32 %load_lval2, 2
  %zext_to_i324 = zext i1 %cmp3 to i32
  %rhs_bool = icmp ne i32 %zext_to_i324, 0
  %rhs_bool5 = icmp ne i1 %rhs_bool, false
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %mainEntry
  %and_result = phi i1 [ false, %mainEntry ], [ %rhs_bool5, %and.rhs ]
  %zext_to_i326 = zext i1 %and_result to i32
  %to_bool = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %and.merge
  store i32 2, i32* @a, align 4
  br label %merge

merge7:                                           ; preds = %merge13, %if.then11
  %load_lval27 = load i32, i32* @a, align 4
  %add = add i32 %load_lval27, 1
  store i32 %add, i32* @a, align 4
  %load_lval28 = load i32, i32* @a, align 4
  ret i32 %load_lval28

if.then11:                                        ; preds = %merge
  store i32 5, i32* @a, align 4
  br label %merge7

if.else:                                          ; preds = %merge
  %load_lval14 = load i32, i32* @a, align 4
  %cmp15 = icmp eq i32 %load_lval14, 3
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %to_bool19 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool19, label %if.then17, label %if.else18

merge13:                                          ; preds = %merge20, %if.then17
  br label %merge7

if.then17:                                        ; preds = %if.else
  store i32 20, i32* @a, align 4
  br label %merge13

if.else18:                                        ; preds = %if.else
  %load_lval21 = load i32, i32* @a, align 4
  %cmp22 = icmp eq i32 %load_lval21, 6
  %zext_to_i3223 = zext i1 %cmp22 to i32
  %to_bool26 = icmp ne i32 %zext_to_i3223, 0
  br i1 %to_bool26, label %if.then24, label %if.else25

merge20:                                          ; preds = %if.else25, %if.then24
  br label %merge13

if.then24:                                        ; preds = %if.else18
  store i32 7, i32* @a, align 4
  br label %merge20

if.else25:                                        ; preds = %if.else18
  store i32 8, i32* @a, align 4
  br label %merge20
}
