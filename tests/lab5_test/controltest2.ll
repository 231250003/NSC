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
  %load_lval88 = load i32, i32* %a, align 4
  store i32 %load_lval88, i32* %result, align 4
  %load_lval89 = load i32, i32* %result, align 4
  ret i32 %load_lval89

while.stmt14:                                     ; preds = %while.cond15
  br label %while.cond24

while.cond15:                                     ; preds = %merge78, %cur
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
  %load_lval74 = load i32, i32* %b, align 4
  %sub75 = sub i32 %load_lval74, 3
  store i32 %sub75, i32* %b, align 4
  %load_lval76 = load i32, i32* %a, align 4
  %add77 = add i32 %load_lval76, 1
  store i32 %add77, i32* %a, align 4
  %load_lval79 = load i32, i32* %a, align 4
  %load_lval80 = load i32, i32* %b, align 4
  %add81 = add i32 %load_lval79, %load_lval80
  %cmp82 = icmp sgt i32 %add81, 50
  %zext_to_i3283 = zext i1 %cmp82 to i32
  %to_bool85 = icmp ne i32 %zext_to_i3283, 0
  br i1 %to_bool85, label %if.then84, label %merge78

while.stmt39:                                     ; preds = %while.cond40
  %load_lval45 = load i32, i32* %b, align 4
  %add46 = add i32 %load_lval45, 10
  ret i32 %add46

while.cond40:                                     ; preds = %merge47, %if.then51, %cur22
  %load_lval41 = load i32, i32* %b, align 4
  %cmp42 = icmp sgt i32 %load_lval41, 35
  %zext_to_i3243 = zext i1 %cmp42 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3243, 0
  br i1 %to_bool44, label %while.stmt39, label %cur38

merge47:                                          ; preds = %merge56
  br label %while.cond40

if.then51:                                        ; No predecessors!
  %load_lval54 = load i32, i32* %b, align 4
  %sub55 = sub i32 %load_lval54, 5
  store i32 %sub55, i32* %b, align 4
  br label %while.cond40

if.else52:                                        ; No predecessors!
  %load_lval57 = load i32, i32* %b, align 4
  %cmp58 = icmp sgt i32 %load_lval57, 50
  %zext_to_i3259 = zext i1 %cmp58 to i32
  %to_bool62 = icmp ne i32 %zext_to_i3259, 0
  br i1 %to_bool62, label %if.then60, label %if.else61

merge56:                                          ; preds = %merge65, %if.then60
  br label %merge47

if.then60:                                        ; preds = %if.else52
  %load_lval63 = load i32, i32* %b, align 4
  %sub64 = sub i32 %load_lval63, 7
  store i32 %sub64, i32* %b, align 4
  br label %merge56

if.else61:                                        ; preds = %if.else52
  %load_lval66 = load i32, i32* %b, align 4
  %cmp67 = icmp sgt i32 %load_lval66, 30
  %zext_to_i3268 = zext i1 %cmp67 to i32
  %to_bool71 = icmp ne i32 %zext_to_i3268, 0
  br i1 %to_bool71, label %if.then69, label %if.else70

merge65:                                          ; preds = %if.then69
  br label %merge56

if.then69:                                        ; preds = %if.else61
  %load_lval72 = load i32, i32* %b, align 4
  %sub73 = sub i32 %load_lval72, 1
  store i32 %sub73, i32* %b, align 4
  br label %merge65

if.else70:                                        ; preds = %if.else61
  ret i32 10

merge78:                                          ; preds = %if.then84, %cur38
  br label %while.cond15

if.then84:                                        ; preds = %cur38
  %load_lval86 = load i32, i32* %a, align 4
  %sub87 = sub i32 %load_lval86, 10
  store i32 %sub87, i32* %a, align 4
  br label %merge78
}
