; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 10

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @a, align 4
  %cmp = icmp ne i32 %load_lval, 10
  %lhs_bool = icmp ne i1 %cmp, false
  br i1 %lhs_bool, label %and.rhs, label %and.merge

merge:                                            ; preds = %if.then, %and.merge
  %load_lval4 = load i32, i32* @a, align 4
  %to_bool = icmp ne i32 %load_lval4, 0
  %cmp5 = icmp eq i1 %to_bool, true
  br i1 %cmp5, label %if.then6, label %if.else

and.rhs:                                          ; preds = %mainEntry
  %load_lval1 = load i32, i32* @a, align 4
  %cmp2 = icmp ne i32 %load_lval1, 2
  %rhs_bool = icmp ne i1 %cmp2, false
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %mainEntry
  %and_result = phi i1 [ false, %mainEntry ], [ %rhs_bool, %and.rhs ]
  br i1 %and_result, label %if.then, label %merge

if.then:                                          ; preds = %and.merge
  store i32 2, i32* @a, align 4
  br label %merge

merge3:                                           ; preds = %merge7, %if.then6
  %load_lval19 = load i32, i32* @a, align 4
  %add = add i32 %load_lval19, 1
  store i32 %add, i32* @a, align 4
  %load_lval20 = load i32, i32* @a, align 4
  ret i32 %load_lval20

if.then6:                                         ; preds = %merge
  store i32 5, i32* @a, align 4
  br label %merge3

if.else:                                          ; preds = %merge
  %load_lval8 = load i32, i32* @a, align 4
  %to_bool9 = icmp ne i32 %load_lval8, 0
  %cmp10 = icmp eq i1 %to_bool9, true
  br i1 %cmp10, label %if.then11, label %if.else12

merge7:                                           ; preds = %merge13, %if.then11
  br label %merge3

if.then11:                                        ; preds = %if.else
  store i32 20, i32* @a, align 4
  br label %merge7

if.else12:                                        ; preds = %if.else
  %load_lval14 = load i32, i32* @a, align 4
  %to_bool15 = icmp ne i32 %load_lval14, 0
  %cmp16 = icmp eq i1 %to_bool15, true
  br i1 %cmp16, label %if.then17, label %if.else18

merge13:                                          ; preds = %if.else18, %if.then17
  br label %merge7

if.then17:                                        ; preds = %if.else12
  store i32 7, i32* @a, align 4
  br label %merge13

if.else18:                                        ; preds = %if.else12
  store i32 8, i32* @a, align 4
  br label %merge13
}
