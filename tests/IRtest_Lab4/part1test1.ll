; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 10

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @a, align 4
  %to_bool = icmp ne i32 %load_lval, 0
  %cmp = icmp ne i1 %to_bool, true
  %lhs_bool = icmp ne i1 %cmp, false
  br i1 %lhs_bool, label %and.rhs, label %and.merge

merge:                                            ; preds = %if.then, %and.merge
  %load_lval5 = load i32, i32* @a, align 4
  %to_bool6 = icmp ne i32 %load_lval5, 0
  %cmp7 = icmp eq i1 %to_bool6, true
  br i1 %cmp7, label %if.then8, label %if.else

and.rhs:                                          ; preds = %mainEntry
  %load_lval1 = load i32, i32* @a, align 4
  %to_bool2 = icmp ne i32 %load_lval1, 0
  %cmp3 = icmp ne i1 %to_bool2, true
  %rhs_bool = icmp ne i1 %cmp3, false
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %mainEntry
  %and_result = phi i1 [ false, %mainEntry ], [ %rhs_bool, %and.rhs ]
  br i1 %and_result, label %if.then, label %merge

if.then:                                          ; preds = %and.merge
  store i32 2, i32* @a, align 4
  br label %merge

merge4:                                           ; preds = %merge9, %if.then8
  %load_lval21 = load i32, i32* @a, align 4
  %add = add i32 %load_lval21, 1
  store i32 %add, i32* @a, align 4
  %load_lval22 = load i32, i32* @a, align 4
  ret i32 %load_lval22

if.then8:                                         ; preds = %merge
  store i32 5, i32* @a, align 4
  br label %merge4

if.else:                                          ; preds = %merge
  %load_lval10 = load i32, i32* @a, align 4
  %to_bool11 = icmp ne i32 %load_lval10, 0
  %cmp12 = icmp eq i1 %to_bool11, true
  br i1 %cmp12, label %if.then13, label %if.else14

merge9:                                           ; preds = %merge15, %if.then13
  br label %merge4

if.then13:                                        ; preds = %if.else
  store i32 20, i32* @a, align 4
  br label %merge9

if.else14:                                        ; preds = %if.else
  %load_lval16 = load i32, i32* @a, align 4
  %to_bool17 = icmp ne i32 %load_lval16, 0
  %cmp18 = icmp eq i1 %to_bool17, true
  br i1 %cmp18, label %if.then19, label %if.else20

merge15:                                          ; preds = %if.else20, %if.then19
  br label %merge9

if.then19:                                        ; preds = %if.else14
  store i32 7, i32* @a, align 4
  br label %merge15

if.else20:                                        ; preds = %if.else14
  store i32 8, i32* @a, align 4
  br label %merge15
}
