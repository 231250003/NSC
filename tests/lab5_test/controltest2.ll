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
  %load_lval87 = load i32, i32* %a, align 4
  store i32 %load_lval87, i32* %result, align 4
  %load_lval88 = load i32, i32* %result, align 4
  ret i32 %load_lval88

while.stmt14:                                     ; preds = %while.cond15
  br label %while.cond24

while.cond15:                                     ; preds = %merge77, %cur
  %load_lval16 = load i32, i32* %b, align 4
  %load_lval17 = load i32, i32* %a, align 4
  %add18 = add i32 %load_lval16, %load_lval17
  %cmp19 = icmp sgt i32 %add18, 20
  %zext_to_i3220 = zext i1 %cmp19 to i32
  %to_bool21 = icmp ne i32 %zext_to_i3220, 0
  br i1 %to_bool21, label %while.stmt14, label %cur13

cur22:                                            ; preds = %if.else34, %if.then33, %while.cond24
  br label %while.cond40

while.stmt23:                                     ; preds = %while.cond24
  %load_lval30 = load i32, i32* %a, align 4
  %cmp31 = icmp sgt i32 %load_lval30, 40
  %zext_to_i3232 = zext i1 %cmp31 to i32
  %to_bool35 = icmp ne i32 %zext_to_i3232, 0
  br i1 %to_bool35, label %if.then33, label %if.else34

while.cond24:                                     ; preds = %merge29, %while.stmt14
  %load_lval25 = load i32, i32* %a, align 4
  %cmp26 = icmp sgt i32 %load_lval25, 10
  %zext_to_i3227 = zext i1 %cmp26 to i32
  %to_bool28 = icmp ne i32 %zext_to_i3227, 0
  br i1 %to_bool28, label %while.stmt23, label %cur22

merge29:                                          ; No predecessors!
  br label %while.cond24

if.then33:                                        ; preds = %while.stmt23
  %load_lval36 = load i32, i32* %a, align 4
  %sub37 = sub i32 %load_lval36, 5
  store i32 %sub37, i32* %a, align 4
  br label %cur22

if.else34:                                        ; preds = %while.stmt23
  br label %cur22

cur38:                                            ; preds = %while.cond40
  %load_lval73 = load i32, i32* %b, align 4
  %sub74 = sub i32 %load_lval73, 3
  store i32 %sub74, i32* %b, align 4
  %load_lval75 = load i32, i32* %a, align 4
  %add76 = add i32 %load_lval75, 1
  store i32 %add76, i32* %a, align 4
  %load_lval78 = load i32, i32* %a, align 4
  %load_lval79 = load i32, i32* %b, align 4
  %add80 = add i32 %load_lval78, %load_lval79
  %cmp81 = icmp sgt i32 %add80, 50
  %zext_to_i3282 = zext i1 %cmp81 to i32
  %to_bool84 = icmp ne i32 %zext_to_i3282, 0
  br i1 %to_bool84, label %if.then83, label %merge77

while.stmt39:                                     ; preds = %while.cond40
  %load_lval45 = load i32, i32* %b, align 4
  ret i32 %load_lval45

while.cond40:                                     ; preds = %merge46, %if.then50, %cur22
  %load_lval41 = load i32, i32* %b, align 4
  %cmp42 = icmp sgt i32 %load_lval41, 35
  %zext_to_i3243 = zext i1 %cmp42 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3243, 0
  br i1 %to_bool44, label %while.stmt39, label %cur38

merge46:                                          ; preds = %merge55
  br label %while.cond40

if.then50:                                        ; No predecessors!
  %load_lval53 = load i32, i32* %b, align 4
  %sub54 = sub i32 %load_lval53, 5
  store i32 %sub54, i32* %b, align 4
  br label %while.cond40

if.else51:                                        ; No predecessors!
  %load_lval56 = load i32, i32* %b, align 4
  %cmp57 = icmp sgt i32 %load_lval56, 50
  %zext_to_i3258 = zext i1 %cmp57 to i32
  %to_bool61 = icmp ne i32 %zext_to_i3258, 0
  br i1 %to_bool61, label %if.then59, label %if.else60

merge55:                                          ; preds = %merge64, %if.then59
  br label %merge46

if.then59:                                        ; preds = %if.else51
  %load_lval62 = load i32, i32* %b, align 4
  %sub63 = sub i32 %load_lval62, 7
  store i32 %sub63, i32* %b, align 4
  br label %merge55

if.else60:                                        ; preds = %if.else51
  %load_lval65 = load i32, i32* %b, align 4
  %cmp66 = icmp sgt i32 %load_lval65, 30
  %zext_to_i3267 = zext i1 %cmp66 to i32
  %to_bool70 = icmp ne i32 %zext_to_i3267, 0
  br i1 %to_bool70, label %if.then68, label %if.else69

merge64:                                          ; preds = %if.then68
  br label %merge55

if.then68:                                        ; preds = %if.else60
  %load_lval71 = load i32, i32* %b, align 4
  %sub72 = sub i32 %load_lval71, 1
  store i32 %sub72, i32* %b, align 4
  br label %merge64

if.else69:                                        ; preds = %if.else60
  ret i32 10

merge77:                                          ; preds = %if.then83, %cur38
  br label %while.cond15

if.then83:                                        ; preds = %cur38
  %load_lval85 = load i32, i32* %a, align 4
  %sub86 = sub i32 %load_lval85, 10
  store i32 %sub86, i32* %a, align 4
  br label %merge77
}
