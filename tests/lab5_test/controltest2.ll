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
  %load_lval102 = load i32, i32* %a, align 4
  store i32 %load_lval102, i32* %result, align 4
  %load_lval103 = load i32, i32* %result, align 4
  ret i32 %load_lval103

while.stmt14:                                     ; preds = %while.cond15
  br label %while.cond24

while.cond15:                                     ; preds = %merge92, %cur
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
  %load_lval88 = load i32, i32* %b, align 4
  %sub89 = sub i32 %load_lval88, 3
  store i32 %sub89, i32* %b, align 4
  %load_lval90 = load i32, i32* %a, align 4
  %add91 = add i32 %load_lval90, 1
  store i32 %add91, i32* %a, align 4
  %load_lval93 = load i32, i32* %a, align 4
  %load_lval94 = load i32, i32* %b, align 4
  %add95 = add i32 %load_lval93, %load_lval94
  %cmp96 = icmp sgt i32 %add95, 50
  %zext_to_i3297 = zext i1 %cmp96 to i32
  %to_bool99 = icmp ne i32 %zext_to_i3297, 0
  br i1 %to_bool99, label %if.then98, label %merge92

while.stmt39:                                     ; preds = %while.cond40
  %b45 = alloca i32, align 4
  store i32 30, i32* %b45, align 4
  br label %while.cond48

while.cond40:                                     ; preds = %merge61, %if.then65, %cur22
  %load_lval41 = load i32, i32* %b, align 4
  %cmp42 = icmp sgt i32 %load_lval41, 35
  %zext_to_i3243 = zext i1 %cmp42 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3243, 0
  br i1 %to_bool44, label %while.stmt39, label %cur38

cur46:                                            ; preds = %merge49, %while.cond48
  %load_lval59 = load i32, i32* %b, align 4
  %sub60 = sub i32 %load_lval59, 10
  ret i32 %sub60

while.stmt47:                                     ; preds = %while.cond48
  %load_lval50 = load i32, i32* %b45, align 4
  %cmp51 = icmp slt i32 %load_lval50, 20
  %zext_to_i3252 = zext i1 %cmp51 to i32
  %to_bool55 = icmp ne i32 %zext_to_i3252, 0
  br i1 %to_bool55, label %if.then53, label %if.else54

while.cond48:                                     ; preds = %while.stmt39
  br i1 true, label %while.stmt47, label %cur46

merge49:                                          ; preds = %if.else54
  br label %cur46

if.then53:                                        ; preds = %while.stmt47
  %load_lval56 = load i32, i32* %b45, align 4
  ret i32 %load_lval56

if.else54:                                        ; preds = %while.stmt47
  %load_lval57 = load i32, i32* %b45, align 4
  %sub58 = sub i32 %load_lval57, 7
  store i32 %sub58, i32* %b45, align 4
  br label %merge49

merge61:                                          ; preds = %merge70
  br label %while.cond40

if.then65:                                        ; No predecessors!
  %load_lval68 = load i32, i32* %b, align 4
  %sub69 = sub i32 %load_lval68, 5
  store i32 %sub69, i32* %b, align 4
  br label %while.cond40

if.else66:                                        ; No predecessors!
  %load_lval71 = load i32, i32* %b, align 4
  %cmp72 = icmp sgt i32 %load_lval71, 50
  %zext_to_i3273 = zext i1 %cmp72 to i32
  %to_bool76 = icmp ne i32 %zext_to_i3273, 0
  br i1 %to_bool76, label %if.then74, label %if.else75

merge70:                                          ; preds = %merge79, %if.then74
  br label %merge61

if.then74:                                        ; preds = %if.else66
  %load_lval77 = load i32, i32* %b, align 4
  %sub78 = sub i32 %load_lval77, 7
  store i32 %sub78, i32* %b, align 4
  br label %merge70

if.else75:                                        ; preds = %if.else66
  %load_lval80 = load i32, i32* %b, align 4
  %cmp81 = icmp sgt i32 %load_lval80, 30
  %zext_to_i3282 = zext i1 %cmp81 to i32
  %to_bool85 = icmp ne i32 %zext_to_i3282, 0
  br i1 %to_bool85, label %if.then83, label %if.else84

merge79:                                          ; preds = %if.then83
  br label %merge70

if.then83:                                        ; preds = %if.else75
  %load_lval86 = load i32, i32* %b, align 4
  %sub87 = sub i32 %load_lval86, 1
  store i32 %sub87, i32* %b, align 4
  br label %merge79

if.else84:                                        ; preds = %if.else75
  ret i32 10

merge92:                                          ; preds = %if.then98, %cur38
  br label %while.cond15

if.then98:                                        ; preds = %cur38
  %load_lval100 = load i32, i32* %a, align 4
  %sub101 = sub i32 %load_lval100, 10
  store i32 %sub101, i32* %a, align 4
  br label %merge92
}
