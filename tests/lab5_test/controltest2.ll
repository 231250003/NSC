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
  %load_lval2 = load i32, i32* %a, align 4
  %load_lval3 = load i32, i32* %b, align 4
  %not = icmp eq i32 %load_lval3, 0
  %zext_to_i32 = zext i1 %not to i32
  %add = add i32 %load_lval2, %zext_to_i32
  %add4 = add i32 %add, 1
  ret i32 %add4

cur:                                              ; preds = %if.then, %while.cond
  br label %while.cond20

while.stmt:                                       ; preds = %while.cond
  %load_lval5 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval5, 2
  store i32 %sub, i32* %a, align 4
  %load_lval6 = load i32, i32* %a, align 4
  %cmp = icmp eq i32 %load_lval6, 45
  %zext_to_i327 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i327, 0
  br i1 %to_bool, label %if.then, label %if.else

while.cond:                                       ; preds = %merge
  br i1 true, label %while.stmt, label %cur

merge:                                            ; preds = %merge8
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  br label %cur

if.else:                                          ; preds = %while.stmt
  %load_lval9 = load i32, i32* %a, align 4
  %cmp10 = icmp eq i32 %load_lval9, 48
  %zext_to_i3211 = zext i1 %cmp10 to i32
  %to_bool13 = icmp ne i32 %zext_to_i3211, 0
  br i1 %to_bool13, label %if.then12, label %merge8

merge8:                                           ; preds = %if.then12, %if.else
  br label %merge

if.then12:                                        ; preds = %if.else
  %load_lval14 = load i32, i32* %b, align 4
  %sub15 = sub i32 %load_lval14, 3
  store i32 %sub15, i32* %b, align 4
  %load_lval16 = load i32, i32* %a, align 4
  %add17 = add i32 %load_lval16, 1
  store i32 %add17, i32* %a, align 4
  br label %merge8

cur18:                                            ; preds = %while.cond20
  %result = alloca i32, align 4
  %load_lval107 = load i32, i32* %a, align 4
  store i32 %load_lval107, i32* %result, align 4
  %load_lval108 = load i32, i32* %result, align 4
  ret i32 %load_lval108

while.stmt19:                                     ; preds = %while.cond20
  br label %while.cond29

while.cond20:                                     ; preds = %merge97, %cur
  %load_lval21 = load i32, i32* %b, align 4
  %load_lval22 = load i32, i32* %a, align 4
  %add23 = add i32 %load_lval21, %load_lval22
  %cmp24 = icmp sgt i32 %add23, 20
  %zext_to_i3225 = zext i1 %cmp24 to i32
  %to_bool26 = icmp ne i32 %zext_to_i3225, 0
  br i1 %to_bool26, label %while.stmt19, label %cur18

cur27:                                            ; preds = %if.else39, %if.then38, %while.cond29
  br label %while.cond45

while.stmt28:                                     ; preds = %while.cond29
  %load_lval35 = load i32, i32* %a, align 4
  %cmp36 = icmp sgt i32 %load_lval35, 40
  %zext_to_i3237 = zext i1 %cmp36 to i32
  %to_bool40 = icmp ne i32 %zext_to_i3237, 0
  br i1 %to_bool40, label %if.then38, label %if.else39

while.cond29:                                     ; preds = %merge34, %while.stmt19
  %load_lval30 = load i32, i32* %a, align 4
  %cmp31 = icmp sgt i32 %load_lval30, 10
  %zext_to_i3232 = zext i1 %cmp31 to i32
  %to_bool33 = icmp ne i32 %zext_to_i3232, 0
  br i1 %to_bool33, label %while.stmt28, label %cur27

merge34:                                          ; No predecessors!
  br label %while.cond29

if.then38:                                        ; preds = %while.stmt28
  %load_lval41 = load i32, i32* %a, align 4
  %sub42 = sub i32 %load_lval41, 5
  store i32 %sub42, i32* %a, align 4
  br label %cur27

if.else39:                                        ; preds = %while.stmt28
  br label %cur27

cur43:                                            ; preds = %while.cond45
  %load_lval93 = load i32, i32* %b, align 4
  %sub94 = sub i32 %load_lval93, 3
  store i32 %sub94, i32* %b, align 4
  %load_lval95 = load i32, i32* %a, align 4
  %add96 = add i32 %load_lval95, 1
  store i32 %add96, i32* %a, align 4
  %load_lval98 = load i32, i32* %a, align 4
  %load_lval99 = load i32, i32* %b, align 4
  %add100 = add i32 %load_lval98, %load_lval99
  %cmp101 = icmp sgt i32 %add100, 50
  %zext_to_i32102 = zext i1 %cmp101 to i32
  %to_bool104 = icmp ne i32 %zext_to_i32102, 0
  br i1 %to_bool104, label %if.then103, label %merge97

while.stmt44:                                     ; preds = %while.cond45
  %b50 = alloca i32, align 4
  store i32 30, i32* %b50, align 4
  br label %while.cond53

while.cond45:                                     ; preds = %merge66, %if.then70, %cur27
  %load_lval46 = load i32, i32* %b, align 4
  %cmp47 = icmp sgt i32 %load_lval46, 35
  %zext_to_i3248 = zext i1 %cmp47 to i32
  %to_bool49 = icmp ne i32 %zext_to_i3248, 0
  br i1 %to_bool49, label %while.stmt44, label %cur43

cur51:                                            ; preds = %merge54, %while.cond53
  %load_lval64 = load i32, i32* %b, align 4
  %sub65 = sub i32 %load_lval64, 10
  ret i32 %sub65

while.stmt52:                                     ; preds = %while.cond53
  %load_lval55 = load i32, i32* %b50, align 4
  %cmp56 = icmp slt i32 %load_lval55, 20
  %zext_to_i3257 = zext i1 %cmp56 to i32
  %to_bool60 = icmp ne i32 %zext_to_i3257, 0
  br i1 %to_bool60, label %if.then58, label %if.else59

while.cond53:                                     ; preds = %while.stmt44
  br i1 true, label %while.stmt52, label %cur51

merge54:                                          ; preds = %if.else59
  br label %cur51

if.then58:                                        ; preds = %while.stmt52
  %load_lval61 = load i32, i32* %b50, align 4
  ret i32 %load_lval61

if.else59:                                        ; preds = %while.stmt52
  %load_lval62 = load i32, i32* %b50, align 4
  %sub63 = sub i32 %load_lval62, 7
  store i32 %sub63, i32* %b50, align 4
  br label %merge54

merge66:                                          ; preds = %merge75
  br label %while.cond45

if.then70:                                        ; No predecessors!
  %load_lval73 = load i32, i32* %b, align 4
  %sub74 = sub i32 %load_lval73, 5
  store i32 %sub74, i32* %b, align 4
  br label %while.cond45

if.else71:                                        ; No predecessors!
  %load_lval76 = load i32, i32* %b, align 4
  %cmp77 = icmp sgt i32 %load_lval76, 50
  %zext_to_i3278 = zext i1 %cmp77 to i32
  %to_bool81 = icmp ne i32 %zext_to_i3278, 0
  br i1 %to_bool81, label %if.then79, label %if.else80

merge75:                                          ; preds = %merge84, %if.then79
  br label %merge66

if.then79:                                        ; preds = %if.else71
  %load_lval82 = load i32, i32* %b, align 4
  %sub83 = sub i32 %load_lval82, 7
  store i32 %sub83, i32* %b, align 4
  br label %merge75

if.else80:                                        ; preds = %if.else71
  %load_lval85 = load i32, i32* %b, align 4
  %cmp86 = icmp sgt i32 %load_lval85, 30
  %zext_to_i3287 = zext i1 %cmp86 to i32
  %to_bool90 = icmp ne i32 %zext_to_i3287, 0
  br i1 %to_bool90, label %if.then88, label %if.else89

merge84:                                          ; preds = %if.then88
  br label %merge75

if.then88:                                        ; preds = %if.else80
  %load_lval91 = load i32, i32* %b, align 4
  %sub92 = sub i32 %load_lval91, 1
  store i32 %sub92, i32* %b, align 4
  br label %merge84

if.else89:                                        ; preds = %if.else80
  ret i32 10

merge97:                                          ; preds = %if.then103, %cur43
  br label %while.cond20

if.then103:                                       ; preds = %cur43
  %load_lval105 = load i32, i32* %a, align 4
  %sub106 = sub i32 %load_lval105, 10
  store i32 %sub106, i32* %a, align 4
  br label %merge97
}
