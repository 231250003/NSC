; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 10

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @a, align 4
  %cmp = icmp ne i32 %load_lval, 10
  %load_lval1 = load i32, i32* @a, align 4
  %cmp2 = icmp ne i32 %load_lval1, 2
  %left_is_zero = icmp eq i1 %cmp, false
  %short_circuit = select i1 %left_is_zero, i1 false, i1 %cmp2
  br i1 %short_circuit, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry
  %load_lval4 = load i32, i32* @a, align 4
  %cmp5 = icmp eq i32 %load_lval4, 4
  br i1 %cmp5, label %if.then6, label %if.else

if.then:                                          ; preds = %mainEntry
  store i32 2, i32* @a, align 4
  br label %merge

merge3:                                           ; preds = %merge7, %if.then6
  %load_lval17 = load i32, i32* @a, align 4
  %add = add i32 %load_lval17, 1
  store i32 %add, i32* @a, align 4
  %load_lval18 = load i32, i32* @a, align 4
  ret i32 %load_lval18

if.then6:                                         ; preds = %merge
  store i32 5, i32* @a, align 4
  br label %merge3

if.else:                                          ; preds = %merge
  %load_lval8 = load i32, i32* @a, align 4
  %cmp9 = icmp eq i32 %load_lval8, 3
  br i1 %cmp9, label %if.then10, label %if.else11

merge7:                                           ; preds = %merge12, %if.then10
  br label %merge3

if.then10:                                        ; preds = %if.else
  store i32 20, i32* @a, align 4
  br label %merge7

if.else11:                                        ; preds = %if.else
  %load_lval13 = load i32, i32* @a, align 4
  %cmp14 = icmp eq i32 %load_lval13, 6
  br i1 %cmp14, label %if.then15, label %if.else16

merge12:                                          ; preds = %if.else16, %if.then15
  br label %merge7

if.then15:                                        ; preds = %if.else11
  store i32 7, i32* @a, align 4
  br label %merge12

if.else16:                                        ; preds = %if.else11
  store i32 8, i32* @a, align 4
  br label %merge12
}
