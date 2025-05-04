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
  %load_lval86 = load i32, i32* %a, align 4
  store i32 %load_lval86, i32* %result, align 4
  %load_lval87 = load i32, i32* %result, align 4
  ret i32 %load_lval87

while.stmt14:                                     ; preds = %while.cond15
  br label %while.cond24

while.cond15:                                     ; preds = %merge76, %cur
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
  %load_lval72 = load i32, i32* %b, align 4
  %sub73 = sub i32 %load_lval72, 3
  store i32 %sub73, i32* %b, align 4
  %load_lval74 = load i32, i32* %a, align 4
  %add75 = add i32 %load_lval74, 1
  store i32 %add75, i32* %a, align 4
  %load_lval77 = load i32, i32* %a, align 4
  %load_lval78 = load i32, i32* %b, align 4
  %add79 = add i32 %load_lval77, %load_lval78
  %cmp80 = icmp sgt i32 %add79, 50
  %zext_to_i3281 = zext i1 %cmp80 to i32
  %to_bool83 = icmp ne i32 %zext_to_i3281, 0
  br i1 %to_bool83, label %if.then82, label %merge76

while.stmt39:                                     ; preds = %while.cond40
  %load_lval46 = load i32, i32* %b, align 4
  %cmp47 = icmp sgt i32 %load_lval46, 70
  %zext_to_i3248 = zext i1 %cmp47 to i32
  %to_bool51 = icmp ne i32 %zext_to_i3248, 0
  br i1 %to_bool51, label %if.then49, label %if.else50

while.cond40:                                     ; preds = %merge45, %if.then49, %cur22
  %load_lval41 = load i32, i32* %b, align 4
  %cmp42 = icmp sgt i32 %load_lval41, 35
  %zext_to_i3243 = zext i1 %cmp42 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3243, 0
  br i1 %to_bool44, label %while.stmt39, label %cur38

merge45:                                          ; preds = %merge54
  br label %while.cond40

if.then49:                                        ; preds = %while.stmt39
  %load_lval52 = load i32, i32* %b, align 4
  %sub53 = sub i32 %load_lval52, 5
  store i32 %sub53, i32* %b, align 4
  br label %while.cond40

if.else50:                                        ; preds = %while.stmt39
  %load_lval55 = load i32, i32* %b, align 4
  %cmp56 = icmp sgt i32 %load_lval55, 50
  %zext_to_i3257 = zext i1 %cmp56 to i32
  %to_bool60 = icmp ne i32 %zext_to_i3257, 0
  br i1 %to_bool60, label %if.then58, label %if.else59

merge54:                                          ; preds = %merge63, %if.then58
  br label %merge45

if.then58:                                        ; preds = %if.else50
  %load_lval61 = load i32, i32* %b, align 4
  %sub62 = sub i32 %load_lval61, 7
  store i32 %sub62, i32* %b, align 4
  br label %merge54

if.else59:                                        ; preds = %if.else50
  %load_lval64 = load i32, i32* %b, align 4
  %cmp65 = icmp sgt i32 %load_lval64, 30
  %zext_to_i3266 = zext i1 %cmp65 to i32
  %to_bool69 = icmp ne i32 %zext_to_i3266, 0
  br i1 %to_bool69, label %if.then67, label %if.else68

merge63:                                          ; preds = %if.then67
  br label %merge54

if.then67:                                        ; preds = %if.else59
  %load_lval70 = load i32, i32* %b, align 4
  %sub71 = sub i32 %load_lval70, 1
  store i32 %sub71, i32* %b, align 4
  br label %merge63

if.else68:                                        ; preds = %if.else59
  ret i32 10

merge76:                                          ; preds = %if.then82, %cur38
  br label %while.cond15

if.then82:                                        ; preds = %cur38
  %load_lval84 = load i32, i32* %a, align 4
  %sub85 = sub i32 %load_lval84, 10
  store i32 %sub85, i32* %a, align 4
  br label %merge76
}
