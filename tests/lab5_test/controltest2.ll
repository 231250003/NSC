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
  %load_lval90 = load i32, i32* %a, align 4
  store i32 %load_lval90, i32* %result, align 4
  %load_lval91 = load i32, i32* %result, align 4
  ret i32 %load_lval91

while.stmt14:                                     ; preds = %while.cond15
  br label %while.cond24

while.cond15:                                     ; preds = %merge80, %cur
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
  %load_lval76 = load i32, i32* %b, align 4
  %sub77 = sub i32 %load_lval76, 3
  store i32 %sub77, i32* %b, align 4
  %load_lval78 = load i32, i32* %a, align 4
  %add79 = add i32 %load_lval78, 1
  store i32 %add79, i32* %a, align 4
  %load_lval81 = load i32, i32* %a, align 4
  %load_lval82 = load i32, i32* %b, align 4
  %add83 = add i32 %load_lval81, %load_lval82
  %cmp84 = icmp sgt i32 %add83, 50
  %zext_to_i3285 = zext i1 %cmp84 to i32
  %to_bool87 = icmp ne i32 %zext_to_i3285, 0
  br i1 %to_bool87, label %if.then86, label %merge80

while.stmt39:                                     ; preds = %while.cond40
  %b45 = alloca i32, align 4
  store i32 30, i32* %b45, align 4
  %load_lval46 = load i32, i32* %b45, align 4
  ret i32 %load_lval46

while.cond40:                                     ; preds = %merge49, %if.then53, %cur22
  %load_lval41 = load i32, i32* %b, align 4
  %cmp42 = icmp sgt i32 %load_lval41, 35
  %zext_to_i3243 = zext i1 %cmp42 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3243, 0
  br i1 %to_bool44, label %while.stmt39, label %cur38

merge49:                                          ; preds = %merge58
  br label %while.cond40

if.then53:                                        ; No predecessors!
  %load_lval56 = load i32, i32* %b, align 4
  %sub57 = sub i32 %load_lval56, 5
  store i32 %sub57, i32* %b, align 4
  br label %while.cond40

if.else54:                                        ; No predecessors!
  %load_lval59 = load i32, i32* %b, align 4
  %cmp60 = icmp sgt i32 %load_lval59, 50
  %zext_to_i3261 = zext i1 %cmp60 to i32
  %to_bool64 = icmp ne i32 %zext_to_i3261, 0
  br i1 %to_bool64, label %if.then62, label %if.else63

merge58:                                          ; preds = %merge67, %if.then62
  br label %merge49

if.then62:                                        ; preds = %if.else54
  %load_lval65 = load i32, i32* %b, align 4
  %sub66 = sub i32 %load_lval65, 7
  store i32 %sub66, i32* %b, align 4
  br label %merge58

if.else63:                                        ; preds = %if.else54
  %load_lval68 = load i32, i32* %b, align 4
  %cmp69 = icmp sgt i32 %load_lval68, 30
  %zext_to_i3270 = zext i1 %cmp69 to i32
  %to_bool73 = icmp ne i32 %zext_to_i3270, 0
  br i1 %to_bool73, label %if.then71, label %if.else72

merge67:                                          ; preds = %if.then71
  br label %merge58

if.then71:                                        ; preds = %if.else63
  %load_lval74 = load i32, i32* %b, align 4
  %sub75 = sub i32 %load_lval74, 1
  store i32 %sub75, i32* %b, align 4
  br label %merge67

if.else72:                                        ; preds = %if.else63
  ret i32 10

merge80:                                          ; preds = %if.then86, %cur38
  br label %while.cond15

if.then86:                                        ; preds = %cur38
  %load_lval88 = load i32, i32* %a, align 4
  %sub89 = sub i32 %load_lval88, 10
  store i32 %sub89, i32* %a, align 4
  br label %merge80
}
