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
  %load_lval105 = load i32, i32* %a, align 4
  store i32 %load_lval105, i32* %result, align 4
  %load_lval106 = load i32, i32* %result, align 4
  ret i32 %load_lval106

while.stmt14:                                     ; preds = %while.cond15
  %load_lval23 = load i32, i32* %a, align 4
  %load_lval24 = load i32, i32* %a, align 4
  %add25 = add i32 %load_lval24, 2
  %cmp26 = icmp sge i32 %load_lval23, %add25
  %zext_to_i3227 = zext i1 %cmp26 to i32
  %to_bool29 = icmp ne i32 %zext_to_i3227, 0
  br i1 %to_bool29, label %if.then28, label %merge22

while.cond15:                                     ; preds = %merge95, %cur
  %load_lval16 = load i32, i32* %b, align 4
  %load_lval17 = load i32, i32* %a, align 4
  %add18 = add i32 %load_lval16, %load_lval17
  %cmp19 = icmp sgt i32 %add18, 20
  %zext_to_i3220 = zext i1 %cmp19 to i32
  %to_bool21 = icmp ne i32 %zext_to_i3220, 0
  br i1 %to_bool21, label %while.stmt14, label %cur13

merge22:                                          ; preds = %while.stmt14
  %load_lval30 = load i32, i32* %a, align 4
  %add31 = add i32 %load_lval30, 1
  store i32 %add31, i32* %a, align 4
  %load_lval33 = load i32, i32* %a, align 4
  %load_lval34 = load i32, i32* %a, align 4
  %add35 = add i32 %load_lval34, 1
  %cmp36 = icmp eq i32 %load_lval33, %add35
  %zext_to_i3237 = zext i1 %cmp36 to i32
  %to_bool40 = icmp ne i32 %zext_to_i3237, 0
  br i1 %to_bool40, label %if.then38, label %if.else39

if.then28:                                        ; preds = %while.stmt14
  ret i32 1

merge32:                                          ; No predecessors!
  br label %while.cond43

if.then38:                                        ; preds = %merge22
  ret i32 2

if.else39:                                        ; preds = %merge22
  ret i32 3

cur41:                                            ; preds = %if.else53, %if.then52, %while.cond43
  br label %while.cond59

while.stmt42:                                     ; preds = %while.cond43
  %load_lval49 = load i32, i32* %a, align 4
  %cmp50 = icmp sgt i32 %load_lval49, 40
  %zext_to_i3251 = zext i1 %cmp50 to i32
  %to_bool54 = icmp ne i32 %zext_to_i3251, 0
  br i1 %to_bool54, label %if.then52, label %if.else53

while.cond43:                                     ; preds = %merge48, %merge32
  %load_lval44 = load i32, i32* %a, align 4
  %cmp45 = icmp sgt i32 %load_lval44, 10
  %zext_to_i3246 = zext i1 %cmp45 to i32
  %to_bool47 = icmp ne i32 %zext_to_i3246, 0
  br i1 %to_bool47, label %while.stmt42, label %cur41

merge48:                                          ; No predecessors!
  br label %while.cond43

if.then52:                                        ; preds = %while.stmt42
  %load_lval55 = load i32, i32* %a, align 4
  %sub56 = sub i32 %load_lval55, 5
  store i32 %sub56, i32* %a, align 4
  br label %cur41

if.else53:                                        ; preds = %while.stmt42
  br label %cur41

cur57:                                            ; preds = %while.cond59
  %load_lval91 = load i32, i32* %b, align 4
  %sub92 = sub i32 %load_lval91, 3
  store i32 %sub92, i32* %b, align 4
  %load_lval93 = load i32, i32* %a, align 4
  %add94 = add i32 %load_lval93, 1
  store i32 %add94, i32* %a, align 4
  %load_lval96 = load i32, i32* %a, align 4
  %load_lval97 = load i32, i32* %b, align 4
  %add98 = add i32 %load_lval96, %load_lval97
  %cmp99 = icmp sgt i32 %add98, 50
  %zext_to_i32100 = zext i1 %cmp99 to i32
  %to_bool102 = icmp ne i32 %zext_to_i32100, 0
  br i1 %to_bool102, label %if.then101, label %merge95

while.stmt58:                                     ; preds = %while.cond59
  %load_lval65 = load i32, i32* %b, align 4
  %cmp66 = icmp sgt i32 %load_lval65, 70
  %zext_to_i3267 = zext i1 %cmp66 to i32
  %to_bool70 = icmp ne i32 %zext_to_i3267, 0
  br i1 %to_bool70, label %if.then68, label %if.else69

while.cond59:                                     ; preds = %merge64, %if.then68, %cur41
  %load_lval60 = load i32, i32* %b, align 4
  %cmp61 = icmp sgt i32 %load_lval60, 35
  %zext_to_i3262 = zext i1 %cmp61 to i32
  %to_bool63 = icmp ne i32 %zext_to_i3262, 0
  br i1 %to_bool63, label %while.stmt58, label %cur57

merge64:                                          ; preds = %merge73
  br label %while.cond59

if.then68:                                        ; preds = %while.stmt58
  %load_lval71 = load i32, i32* %b, align 4
  %sub72 = sub i32 %load_lval71, 5
  store i32 %sub72, i32* %b, align 4
  br label %while.cond59

if.else69:                                        ; preds = %while.stmt58
  %load_lval74 = load i32, i32* %b, align 4
  %cmp75 = icmp sgt i32 %load_lval74, 50
  %zext_to_i3276 = zext i1 %cmp75 to i32
  %to_bool79 = icmp ne i32 %zext_to_i3276, 0
  br i1 %to_bool79, label %if.then77, label %if.else78

merge73:                                          ; preds = %merge82, %if.then77
  br label %merge64

if.then77:                                        ; preds = %if.else69
  %load_lval80 = load i32, i32* %b, align 4
  %sub81 = sub i32 %load_lval80, 7
  store i32 %sub81, i32* %b, align 4
  br label %merge73

if.else78:                                        ; preds = %if.else69
  %load_lval83 = load i32, i32* %b, align 4
  %cmp84 = icmp sgt i32 %load_lval83, 30
  %zext_to_i3285 = zext i1 %cmp84 to i32
  %to_bool88 = icmp ne i32 %zext_to_i3285, 0
  br i1 %to_bool88, label %if.then86, label %if.else87

merge82:                                          ; preds = %if.then86
  br label %merge73

if.then86:                                        ; preds = %if.else78
  %load_lval89 = load i32, i32* %b, align 4
  %sub90 = sub i32 %load_lval89, 1
  store i32 %sub90, i32* %b, align 4
  br label %merge82

if.else87:                                        ; preds = %if.else78
  ret i32 10

merge95:                                          ; preds = %if.then101, %cur57
  br label %while.cond15

if.then101:                                       ; preds = %cur57
  %load_lval103 = load i32, i32* %a, align 4
  %sub104 = sub i32 %load_lval103, 10
  store i32 %sub104, i32* %a, align 4
  br label %merge95
}
