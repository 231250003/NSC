; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 100
@y = global i32 2
@z = global i32 3

define void @g() {
gEntry:
  %load_lval = load i32, i32* @x, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @x, align 4
  ret void
}

define i32 @f(i32 %x) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %cmp = icmp eq i32 %load_lval, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %fEntry
  ret i32 0

merge:                                            ; preds = %fEntry
  %load_lval1 = load i32, i32* %param0_addr, align 4
  %sub = sub i32 %load_lval1, 1
  %f = call i32 @f(i32 %sub)
  %add = add i32 %f, 10
  store i32 %add, i32* %param0_addr, align 4
  %load_lval2 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval2
}

define i32 @main() {
mainEntry:
  br label %while.cond

cur:                                              ; preds = %merge52, %while.cond
  %load_lval106 = load i32, i32* @x, align 4
  ret i32 %load_lval106

while.stmt:                                       ; preds = %while.cond
  %f = call i32 @f(i32 200)
  store i32 %f, i32* @x, align 4
  br label %while.cond3

while.cond:                                       ; preds = %merge52, %mainEntry
  br i1 true, label %while.stmt, label %cur

cur1:                                             ; preds = %if.then, %while.cond3
  %load_lval6 = load i32, i32* @x, align 4
  %cmp7 = icmp sge i32 %load_lval6, 100
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool10 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool10, label %if.then9, label %merge11

while.stmt2:                                      ; preds = %while.cond3
  call void @g()
  %load_lval4 = load i32, i32* @x, align 4
  %cmp = icmp sge i32 %load_lval4, 200
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool5 = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool5, label %if.then, label %merge

while.cond3:                                      ; preds = %merge, %while.stmt
  %load_lval = load i32, i32* @x, align 4
  %to_bool = icmp ne i32 %load_lval, 0
  br i1 %to_bool, label %while.stmt2, label %cur1

if.then:                                          ; preds = %while.stmt2
  br label %cur1

merge:                                            ; preds = %while.stmt2
  br label %while.cond3

if.then9:                                         ; preds = %cur1
  %load_lval12 = load i32, i32* @x, align 4
  %cmp13 = icmp slt i32 %load_lval12, 10
  %zext_to_i3214 = zext i1 %cmp13 to i32
  %to_bool16 = icmp ne i32 %zext_to_i3214, 0
  br i1 %to_bool16, label %if.then15, label %if.else

merge11:                                          ; preds = %cur1
  store i32 5000, i32* @x, align 4
  %load_lval47 = load i32, i32* @x, align 4
  %cmp48 = icmp sge i32 %load_lval47, 125
  %zext_to_i3249 = zext i1 %cmp48 to i32
  %to_bool51 = icmp ne i32 %zext_to_i3249, 0
  br i1 %to_bool51, label %if.then50, label %merge52

if.then15:                                        ; preds = %if.then9
  ret i32 0

if.else:                                          ; preds = %if.then9
  %load_lval17 = load i32, i32* @x, align 4
  %cmp18 = icmp sgt i32 %load_lval17, 200
  %zext_to_i3219 = zext i1 %cmp18 to i32
  %to_bool22 = icmp ne i32 %zext_to_i3219, 0
  br i1 %to_bool22, label %if.then20, label %if.else21

if.then20:                                        ; preds = %if.else
  ret i32 2

if.else21:                                        ; preds = %if.else
  %load_lval23 = load i32, i32* @x, align 4
  %cmp24 = icmp sgt i32 %load_lval23, 256
  %zext_to_i3225 = zext i1 %cmp24 to i32
  %to_bool27 = icmp ne i32 %zext_to_i3225, 0
  br i1 %to_bool27, label %if.then26, label %merge28

if.then26:                                        ; preds = %if.else21
  ret i32 3

merge28:                                          ; preds = %if.else21
  %load_lval29 = load i32, i32* @x, align 4
  %add = add i32 %load_lval29, 1
  store i32 %add, i32* @x, align 4
  br label %while.cond32

cur30:                                            ; preds = %merge44, %while.cond32

while.stmt31:                                     ; preds = %while.cond32
  %load_lval37 = load i32, i32* @x, align 4
  %add38 = add i32 %load_lval37, 1
  store i32 %add38, i32* @x, align 4
  %load_lval39 = load i32, i32* @x, align 4
  %cmp40 = icmp slt i32 %load_lval39, 125
  %zext_to_i3241 = zext i1 %cmp40 to i32
  %to_bool43 = icmp ne i32 %zext_to_i3241, 0
  br i1 %to_bool43, label %if.then42, label %merge44

while.cond32:                                     ; preds = %merge44, %merge44, %if.then42, %merge28
  %load_lval33 = load i32, i32* @x, align 4
  %cmp34 = icmp slt i32 %load_lval33, 200
  %zext_to_i3235 = zext i1 %cmp34 to i32
  %to_bool36 = icmp ne i32 %zext_to_i3235, 0
  br i1 %to_bool36, label %while.stmt31, label %cur30

if.then42:                                        ; preds = %while.stmt31
  br label %while.cond32

merge44:                                          ; preds = %while.stmt31
  call void @g()
  %load_lval45 = load i32, i32* @x, align 4
  %add46 = add i32 %load_lval45, 2
  store i32 %add46, i32* @x, align 4
  br label %while.cond32
  br label %cur30
  br label %while.cond32

if.then50:                                        ; preds = %merge11
  %load_lval53 = load i32, i32* @x, align 4
  %cmp54 = icmp slt i32 %load_lval53, 2030
  %zext_to_i3255 = zext i1 %cmp54 to i32
  %to_bool58 = icmp ne i32 %zext_to_i3255, 0
  br i1 %to_bool58, label %if.then56, label %if.else57

merge52:                                          ; preds = %merge11
  %load_lval104 = load i32, i32* @x, align 4
  %sub105 = sub i32 %load_lval104, 100
  br label %cur
  br label %while.cond

if.then56:                                        ; preds = %if.then50
  br label %while.cond61

if.else57:                                        ; preds = %if.then50
  %load_lval81 = load i32, i32* @x, align 4
  %cmp82 = icmp slt i32 %load_lval81, 5000
  %zext_to_i3283 = zext i1 %cmp82 to i32
  %to_bool86 = icmp ne i32 %zext_to_i3283, 0
  br i1 %to_bool86, label %if.then84, label %if.else85

cur59:                                            ; preds = %while.cond61
  %load_lval74 = load i32, i32* @x, align 4
  %cmp75 = icmp sgt i32 %load_lval74, 100
  %zext_to_i3276 = zext i1 %cmp75 to i32
  %to_bool78 = icmp ne i32 %zext_to_i3276, 0
  br i1 %to_bool78, label %if.then77, label %merge79

while.stmt60:                                     ; preds = %while.cond61
  %load_lval66 = load i32, i32* @x, align 4
  %to_bool69 = icmp ne i32 %load_lval66, 0
  br i1 %to_bool69, label %if.then67, label %if.else68

while.cond61:                                     ; preds = %merge71, %if.then56
  %load_lval62 = load i32, i32* @x, align 4
  %cmp63 = icmp sgt i32 %load_lval62, 100
  %zext_to_i3264 = zext i1 %cmp63 to i32
  %to_bool65 = icmp ne i32 %zext_to_i3264, 0
  br i1 %to_bool65, label %while.stmt60, label %cur59

if.then67:                                        ; preds = %while.stmt60
  %load_lval70 = load i32, i32* @x, align 4
  %sub = sub i32 %load_lval70, 1
  store i32 %sub, i32* @x, align 4
  br label %merge71

if.else68:                                        ; preds = %while.stmt60
  %load_lval72 = load i32, i32* @x, align 4
  %sub73 = sub i32 %load_lval72, 2
  store i32 %sub73, i32* @x, align 4
  br label %merge71

merge71:                                          ; preds = %if.else68, %if.then67
  br label %while.cond61

if.then77:                                        ; preds = %cur59
  %load_lval80 = load i32, i32* @x, align 4
  ret i32 %load_lval80

merge79:                                          ; preds = %cur59

if.then84:                                        ; preds = %if.else57
  store i32 5016, i32* @x, align 4
  br label %merge87

if.else85:                                        ; preds = %if.else57
  %load_lval88 = load i32, i32* @x, align 4
  %cmp89 = icmp slt i32 %load_lval88, 231
  %zext_to_i3290 = zext i1 %cmp89 to i32
  %to_bool92 = icmp ne i32 %zext_to_i3290, 0
  br i1 %to_bool92, label %if.then91, label %merge93

merge87:                                          ; preds = %if.then84
  %load_lval96 = load i32, i32* @x, align 4
  %cmp97 = icmp sgt i32 %load_lval96, 10
  %zext_to_i3298 = zext i1 %cmp97 to i32
  %to_bool100 = icmp ne i32 %zext_to_i3298, 0
  br i1 %to_bool100, label %if.then99, label %merge101

if.then91:                                        ; preds = %if.else85
  %load_lval94 = load i32, i32* @x, align 4
  %add95 = add i32 %load_lval94, 1
  ret i32 %add95

merge93:                                          ; preds = %if.else85

if.then99:                                        ; preds = %merge87
  %load_lval102 = load i32, i32* @x, align 4
  %sub103 = sub i32 %load_lval102, 10
  store i32 %sub103, i32* @x, align 4
  br label %merge101

merge101:                                         ; preds = %if.then99, %merge87
}
