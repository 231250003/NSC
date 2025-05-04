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
  %load_lval89 = load i32, i32* %a, align 4
  store i32 %load_lval89, i32* %result, align 4
  %load_lval90 = load i32, i32* %result, align 4
  ret i32 %load_lval90

while.stmt14:                                     ; preds = %while.cond15
  br label %while.cond24

while.cond15:                                     ; preds = %merge79, %cur
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
  %load_lval75 = load i32, i32* %b, align 4
  %sub76 = sub i32 %load_lval75, 3
  store i32 %sub76, i32* %b, align 4
  %load_lval77 = load i32, i32* %a, align 4
  %add78 = add i32 %load_lval77, 1
  store i32 %add78, i32* %a, align 4
  %load_lval80 = load i32, i32* %a, align 4
  %load_lval81 = load i32, i32* %b, align 4
  %add82 = add i32 %load_lval80, %load_lval81
  %cmp83 = icmp sgt i32 %add82, 50
  %zext_to_i3284 = zext i1 %cmp83 to i32
  %to_bool86 = icmp ne i32 %zext_to_i3284, 0
  br i1 %to_bool86, label %if.then85, label %merge79

while.stmt39:                                     ; preds = %while.cond40
  %b45 = alloca i32, align 4
  store i32 30, i32* %b45, align 4
  %load_lval46 = load i32, i32* %b45, align 4
  %sub47 = sub i32 %load_lval46, 10
  ret i32 %sub47

while.cond40:                                     ; preds = %merge48, %if.then52, %cur22
  %load_lval41 = load i32, i32* %b, align 4
  %cmp42 = icmp sgt i32 %load_lval41, 35
  %zext_to_i3243 = zext i1 %cmp42 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3243, 0
  br i1 %to_bool44, label %while.stmt39, label %cur38

merge48:                                          ; preds = %merge57
  br label %while.cond40

if.then52:                                        ; No predecessors!
  %load_lval55 = load i32, i32* %b45, align 4
  %sub56 = sub i32 %load_lval55, 5
  store i32 %sub56, i32* %b45, align 4
  br label %while.cond40

if.else53:                                        ; No predecessors!
  %load_lval58 = load i32, i32* %b45, align 4
  %cmp59 = icmp sgt i32 %load_lval58, 50
  %zext_to_i3260 = zext i1 %cmp59 to i32
  %to_bool63 = icmp ne i32 %zext_to_i3260, 0
  br i1 %to_bool63, label %if.then61, label %if.else62

merge57:                                          ; preds = %merge66, %if.then61
  br label %merge48

if.then61:                                        ; preds = %if.else53
  %load_lval64 = load i32, i32* %b45, align 4
  %sub65 = sub i32 %load_lval64, 7
  store i32 %sub65, i32* %b45, align 4
  br label %merge57

if.else62:                                        ; preds = %if.else53
  %load_lval67 = load i32, i32* %b45, align 4
  %cmp68 = icmp sgt i32 %load_lval67, 30
  %zext_to_i3269 = zext i1 %cmp68 to i32
  %to_bool72 = icmp ne i32 %zext_to_i3269, 0
  br i1 %to_bool72, label %if.then70, label %if.else71

merge66:                                          ; preds = %if.then70
  br label %merge57

if.then70:                                        ; preds = %if.else62
  %load_lval73 = load i32, i32* %b45, align 4
  %sub74 = sub i32 %load_lval73, 1
  store i32 %sub74, i32* %b45, align 4
  br label %merge66

if.else71:                                        ; preds = %if.else62
  ret i32 10

merge79:                                          ; preds = %if.then85, %cur38
  br label %while.cond15

if.then85:                                        ; preds = %cur38
  %load_lval87 = load i32, i32* %a, align 4
  %sub88 = sub i32 %load_lval87, 10
  store i32 %sub88, i32* %a, align 4
  br label %merge79
}
