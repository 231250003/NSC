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

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @x, align 4
  %cmp = icmp sge i32 %load_lval, 100
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %cur, %mainEntry
  %load_lval36 = load i32, i32* @x, align 4
  %cmp37 = icmp sge i32 %load_lval36, 125
  %zext_to_i3238 = zext i1 %cmp37 to i32
  %to_bool40 = icmp ne i32 %zext_to_i3238, 0
  br i1 %to_bool40, label %if.then39, label %merge35

if.then:                                          ; preds = %mainEntry
  %load_lval2 = load i32, i32* @x, align 4
  %cmp3 = icmp slt i32 %load_lval2, 10
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool6 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool6, label %if.then5, label %if.else

merge1:                                           ; preds = %merge7, %if.then5
  %load_lval20 = load i32, i32* @x, align 4
  %add = add i32 %load_lval20, 1
  store i32 %add, i32* @x, align 4
  br label %while.cond

if.then5:                                         ; preds = %if.then
  ret i32 0
  br label %merge1

if.else:                                          ; preds = %if.then
  %load_lval8 = load i32, i32* @x, align 4
  %cmp9 = icmp sgt i32 %load_lval8, 200
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %to_bool13 = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool13, label %if.then11, label %if.else12

merge7:                                           ; preds = %merge14, %if.then11
  br label %merge1

if.then11:                                        ; preds = %if.else
  ret i32 2
  br label %merge7

if.else12:                                        ; preds = %if.else
  %load_lval15 = load i32, i32* @x, align 4
  %cmp16 = icmp sgt i32 %load_lval15, 256
  %zext_to_i3217 = zext i1 %cmp16 to i32
  %to_bool19 = icmp ne i32 %zext_to_i3217, 0
  br i1 %to_bool19, label %if.then18, label %merge14

merge14:                                          ; preds = %if.then18, %if.else12
  br label %merge7

if.then18:                                        ; preds = %if.else12
  ret i32 3
  br label %merge14

cur:                                              ; preds = %merge27, %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %load_lval25 = load i32, i32* @x, align 4
  %add26 = add i32 %load_lval25, 1
  store i32 %add26, i32* @x, align 4
  %load_lval28 = load i32, i32* @x, align 4
  %cmp29 = icmp slt i32 %load_lval28, 125
  %zext_to_i3230 = zext i1 %cmp29 to i32
  %to_bool32 = icmp ne i32 %zext_to_i3230, 0
  br i1 %to_bool32, label %if.then31, label %merge27

while.cond:                                       ; preds = %merge27, %merge27, %if.then31, %merge1
  %load_lval21 = load i32, i32* @x, align 4
  %cmp22 = icmp slt i32 %load_lval21, 200
  %zext_to_i3223 = zext i1 %cmp22 to i32
  %to_bool24 = icmp ne i32 %zext_to_i3223, 0
  br i1 %to_bool24, label %while.stmt, label %cur

merge27:                                          ; preds = %if.then31, %while.stmt
  call void @g()
  %load_lval33 = load i32, i32* @x, align 4
  %add34 = add i32 %load_lval33, 2
  store i32 %add34, i32* @x, align 4
  br label %while.cond
  br label %cur
  br label %while.cond

if.then31:                                        ; preds = %while.stmt
  br label %while.cond
  br label %merge27

merge35:                                          ; preds = %merge87, %merge
  %load_lval95 = load i32, i32* @x, align 4
  ret i32 %load_lval95

if.then39:                                        ; preds = %merge
  %load_lval42 = load i32, i32* @x, align 4
  %cmp43 = icmp slt i32 %load_lval42, 2030
  %zext_to_i3244 = zext i1 %cmp43 to i32
  %to_bool47 = icmp ne i32 %zext_to_i3244, 0
  br i1 %to_bool47, label %if.then45, label %if.else46

merge41:                                          ; preds = %merge72, %merge65
  %load_lval88 = load i32, i32* @x, align 4
  %cmp89 = icmp sgt i32 %load_lval88, 10
  %zext_to_i3290 = zext i1 %cmp89 to i32
  %to_bool92 = icmp ne i32 %zext_to_i3290, 0
  br i1 %to_bool92, label %if.then91, label %merge87

if.then45:                                        ; preds = %if.then39
  br label %while.cond50

if.else46:                                        ; preds = %if.then39
  %load_lval73 = load i32, i32* @x, align 4
  %cmp74 = icmp slt i32 %load_lval73, 5000
  %zext_to_i3275 = zext i1 %cmp74 to i32
  %to_bool78 = icmp ne i32 %zext_to_i3275, 0
  br i1 %to_bool78, label %if.then76, label %if.else77

cur48:                                            ; preds = %while.cond50
  %load_lval66 = load i32, i32* @x, align 4
  %cmp67 = icmp sgt i32 %load_lval66, 100
  %zext_to_i3268 = zext i1 %cmp67 to i32
  %to_bool70 = icmp ne i32 %zext_to_i3268, 0
  br i1 %to_bool70, label %if.then69, label %merge65

while.stmt49:                                     ; preds = %while.cond50
  %load_lval56 = load i32, i32* @x, align 4
  %to_bool59 = icmp ne i32 %load_lval56, 0
  br i1 %to_bool59, label %if.then57, label %if.else58

while.cond50:                                     ; preds = %merge55, %if.then45
  %load_lval51 = load i32, i32* @x, align 4
  %cmp52 = icmp sgt i32 %load_lval51, 100
  %zext_to_i3253 = zext i1 %cmp52 to i32
  %to_bool54 = icmp ne i32 %zext_to_i3253, 0
  br i1 %to_bool54, label %while.stmt49, label %cur48

merge55:                                          ; preds = %if.else58, %if.then57
  %load_lval63 = load i32, i32* @x, align 4
  %add64 = add i32 %load_lval63, 5
  store i32 %add64, i32* @x, align 4
  br label %while.cond50

if.then57:                                        ; preds = %while.stmt49
  %load_lval60 = load i32, i32* @x, align 4
  %sub = sub i32 %load_lval60, 1
  store i32 %sub, i32* @x, align 4
  br label %merge55

if.else58:                                        ; preds = %while.stmt49
  %load_lval61 = load i32, i32* @x, align 4
  %sub62 = sub i32 %load_lval61, 2
  store i32 %sub62, i32* @x, align 4
  br label %merge55

merge65:                                          ; preds = %if.then69, %cur48
  br label %merge41

if.then69:                                        ; preds = %cur48
  %load_lval71 = load i32, i32* @x, align 4
  ret i32 %load_lval71
  br label %merge65

merge72:                                          ; preds = %merge79, %if.then76
  br label %merge41

if.then76:                                        ; preds = %if.else46
  store i32 5016, i32* @x, align 4
  br label %merge72

if.else77:                                        ; preds = %if.else46
  %load_lval80 = load i32, i32* @x, align 4
  %cmp81 = icmp slt i32 %load_lval80, 231
  %zext_to_i3282 = zext i1 %cmp81 to i32
  %to_bool84 = icmp ne i32 %zext_to_i3282, 0
  br i1 %to_bool84, label %if.then83, label %merge79

merge79:                                          ; preds = %if.then83, %if.else77
  br label %merge72

if.then83:                                        ; preds = %if.else77
  %load_lval85 = load i32, i32* @x, align 4
  %add86 = add i32 %load_lval85, 1
  ret i32 %add86
  br label %merge79

merge87:                                          ; preds = %if.then91, %merge41
  br label %merge35

if.then91:                                        ; preds = %merge41
  %load_lval93 = load i32, i32* @x, align 4
  %sub94 = sub i32 %load_lval93, 10
  store i32 %sub94, i32* @x, align 4
  br label %merge87
}
