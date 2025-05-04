; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 56
@y = global i32 98

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  %load_lval = load i32, i32* @x, align 4
  store i32 %load_lval, i32* %a, align 4
  %b = alloca i32, align 4
  %load_lval1 = load i32, i32* @y, align 4
  store i32 %load_lval1, i32* %b, align 4
  br label %while.cond

cur:                                              ; preds = %if.then, %while.cond
  br label %while.cond15

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval2, 2
  store i32 %sub, i32* %a, align 4
  %load_lval3 = load i32, i32* %a, align 4
  %cmp = icmp eq i32 %load_lval3, 45
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %if.else

while.cond:                                       ; preds = %merge, %mainEntry
  br i1 true, label %while.stmt, label %cur

merge:                                            ; preds = %merge4
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  br label %cur

if.else:                                          ; preds = %while.stmt
  %load_lval5 = load i32, i32* %a, align 4
  %cmp6 = icmp eq i32 %load_lval5, 48
  %zext_to_i327 = zext i1 %cmp6 to i32
  %to_bool9 = icmp ne i32 %zext_to_i327, 0
  br i1 %to_bool9, label %if.then8, label %merge4

merge4:                                           ; preds = %if.then8, %if.else
  br label %merge

if.then8:                                         ; preds = %if.else
  %load_lval10 = load i32, i32* %b, align 4
  %sub11 = sub i32 %load_lval10, 3
  store i32 %sub11, i32* %b, align 4
  %load_lval12 = load i32, i32* %a, align 4
  %add = add i32 %load_lval12, 1
  store i32 %add, i32* %a, align 4
  br label %merge4

cur13:                                            ; preds = %while.cond15
  %result = alloca i32, align 4
  %load_lval93 = load i32, i32* %a, align 4
  store i32 %load_lval93, i32* %result, align 4
  %load_lval94 = load i32, i32* %result, align 4
  ret i32 %load_lval94

while.stmt14:                                     ; preds = %while.cond15
  %load_lval23 = load i32, i32* %a, align 4
  %load_lval24 = load i32, i32* %a, align 4
  %cmp25 = icmp sge i32 %load_lval23, %load_lval24
  %zext_to_i3226 = zext i1 %cmp25 to i32
  %to_bool28 = icmp ne i32 %zext_to_i3226, 0
  br i1 %to_bool28, label %if.then27, label %merge22

while.cond15:                                     ; preds = %merge83, %cur
  %load_lval16 = load i32, i32* %b, align 4
  %load_lval17 = load i32, i32* %a, align 4
  %add18 = add i32 %load_lval16, %load_lval17
  %cmp19 = icmp sgt i32 %add18, 20
  %zext_to_i3220 = zext i1 %cmp19 to i32
  %to_bool21 = icmp ne i32 %zext_to_i3220, 0
  br i1 %to_bool21, label %while.stmt14, label %cur13

merge22:                                          ; preds = %while.stmt14
  br label %while.cond31

if.then27:                                        ; preds = %while.stmt14
  ret i32 1

cur29:                                            ; preds = %if.else41, %if.then40, %while.cond31
  br label %while.cond47

while.stmt30:                                     ; preds = %while.cond31
  %load_lval37 = load i32, i32* %a, align 4
  %cmp38 = icmp sgt i32 %load_lval37, 40
  %zext_to_i3239 = zext i1 %cmp38 to i32
  %to_bool42 = icmp ne i32 %zext_to_i3239, 0
  br i1 %to_bool42, label %if.then40, label %if.else41

while.cond31:                                     ; preds = %merge36, %merge22
  %load_lval32 = load i32, i32* %a, align 4
  %cmp33 = icmp sgt i32 %load_lval32, 10
  %zext_to_i3234 = zext i1 %cmp33 to i32
  %to_bool35 = icmp ne i32 %zext_to_i3234, 0
  br i1 %to_bool35, label %while.stmt30, label %cur29

merge36:                                          ; No predecessors!
  br label %while.cond31

if.then40:                                        ; preds = %while.stmt30
  %load_lval43 = load i32, i32* %a, align 4
  %sub44 = sub i32 %load_lval43, 5
  store i32 %sub44, i32* %a, align 4
  br label %cur29

if.else41:                                        ; preds = %while.stmt30
  br label %cur29

cur45:                                            ; preds = %while.cond47
  %load_lval79 = load i32, i32* %b, align 4
  %sub80 = sub i32 %load_lval79, 3
  store i32 %sub80, i32* %b, align 4
  %load_lval81 = load i32, i32* %a, align 4
  %add82 = add i32 %load_lval81, 1
  store i32 %add82, i32* %a, align 4
  %load_lval84 = load i32, i32* %a, align 4
  %load_lval85 = load i32, i32* %b, align 4
  %add86 = add i32 %load_lval84, %load_lval85
  %cmp87 = icmp sgt i32 %add86, 50
  %zext_to_i3288 = zext i1 %cmp87 to i32
  %to_bool90 = icmp ne i32 %zext_to_i3288, 0
  br i1 %to_bool90, label %if.then89, label %merge83

while.stmt46:                                     ; preds = %while.cond47
  %load_lval53 = load i32, i32* %b, align 4
  %cmp54 = icmp sgt i32 %load_lval53, 70
  %zext_to_i3255 = zext i1 %cmp54 to i32
  %to_bool58 = icmp ne i32 %zext_to_i3255, 0
  br i1 %to_bool58, label %if.then56, label %if.else57

while.cond47:                                     ; preds = %merge52, %if.then56, %cur29
  %load_lval48 = load i32, i32* %b, align 4
  %cmp49 = icmp sgt i32 %load_lval48, 35
  %zext_to_i3250 = zext i1 %cmp49 to i32
  %to_bool51 = icmp ne i32 %zext_to_i3250, 0
  br i1 %to_bool51, label %while.stmt46, label %cur45

merge52:                                          ; preds = %merge61
  br label %while.cond47

if.then56:                                        ; preds = %while.stmt46
  %load_lval59 = load i32, i32* %b, align 4
  %sub60 = sub i32 %load_lval59, 5
  store i32 %sub60, i32* %b, align 4
  br label %while.cond47

if.else57:                                        ; preds = %while.stmt46
  %load_lval62 = load i32, i32* %b, align 4
  %cmp63 = icmp sgt i32 %load_lval62, 50
  %zext_to_i3264 = zext i1 %cmp63 to i32
  %to_bool67 = icmp ne i32 %zext_to_i3264, 0
  br i1 %to_bool67, label %if.then65, label %if.else66

merge61:                                          ; preds = %merge70, %if.then65
  br label %merge52

if.then65:                                        ; preds = %if.else57
  %load_lval68 = load i32, i32* %b, align 4
  %sub69 = sub i32 %load_lval68, 7
  store i32 %sub69, i32* %b, align 4
  br label %merge61

if.else66:                                        ; preds = %if.else57
  %load_lval71 = load i32, i32* %b, align 4
  %cmp72 = icmp sgt i32 %load_lval71, 30
  %zext_to_i3273 = zext i1 %cmp72 to i32
  %to_bool76 = icmp ne i32 %zext_to_i3273, 0
  br i1 %to_bool76, label %if.then74, label %if.else75

merge70:                                          ; preds = %if.then74
  br label %merge61

if.then74:                                        ; preds = %if.else66
  %load_lval77 = load i32, i32* %b, align 4
  %sub78 = sub i32 %load_lval77, 1
  store i32 %sub78, i32* %b, align 4
  br label %merge70

if.else75:                                        ; preds = %if.else66
  ret i32 10

merge83:                                          ; preds = %if.then89, %cur45
  br label %while.cond15

if.then89:                                        ; preds = %cur45
  %load_lval91 = load i32, i32* %a, align 4
  %sub92 = sub i32 %load_lval91, 10
  store i32 %sub92, i32* %a, align 4
  br label %merge83
}
