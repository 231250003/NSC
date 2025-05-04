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
  %load_lval97 = load i32, i32* %a, align 4
  store i32 %load_lval97, i32* %result, align 4
  %load_lval98 = load i32, i32* %result, align 4
  ret i32 %load_lval98

while.stmt14:                                     ; preds = %while.cond15
  %load_lval23 = load i32, i32* %a, align 4
  %cmp24 = icmp ne i32 %load_lval23, 56
  %zext_to_i3225 = zext i1 %cmp24 to i32
  %to_bool28 = icmp ne i32 %zext_to_i3225, 0
  br i1 %to_bool28, label %if.then26, label %if.else27

while.cond15:                                     ; preds = %merge87, %cur
  %load_lval16 = load i32, i32* %b, align 4
  %load_lval17 = load i32, i32* %a, align 4
  %add18 = add i32 %load_lval16, %load_lval17
  %cmp19 = icmp sgt i32 %add18, 20
  %zext_to_i3220 = zext i1 %cmp19 to i32
  %to_bool21 = icmp ne i32 %zext_to_i3220, 0
  br i1 %to_bool21, label %while.stmt14, label %cur13

merge22:                                          ; No predecessors!
  br label %while.cond35

if.then26:                                        ; preds = %while.stmt14
  ret i32 1

if.else27:                                        ; preds = %while.stmt14
  %load_lval29 = load i32, i32* %a, align 4
  %not = icmp eq i32 %load_lval29, 0
  %zext_to_i3230 = zext i1 %not to i32
  %load_lval31 = load i32, i32* %b, align 4
  %add32 = add i32 %zext_to_i3230, %load_lval31
  ret i32 %add32

cur33:                                            ; preds = %if.else45, %if.then44, %while.cond35
  br label %while.cond51

while.stmt34:                                     ; preds = %while.cond35
  %load_lval41 = load i32, i32* %a, align 4
  %cmp42 = icmp sgt i32 %load_lval41, 40
  %zext_to_i3243 = zext i1 %cmp42 to i32
  %to_bool46 = icmp ne i32 %zext_to_i3243, 0
  br i1 %to_bool46, label %if.then44, label %if.else45

while.cond35:                                     ; preds = %merge40, %merge22
  %load_lval36 = load i32, i32* %a, align 4
  %cmp37 = icmp sgt i32 %load_lval36, 10
  %zext_to_i3238 = zext i1 %cmp37 to i32
  %to_bool39 = icmp ne i32 %zext_to_i3238, 0
  br i1 %to_bool39, label %while.stmt34, label %cur33

merge40:                                          ; No predecessors!
  br label %while.cond35

if.then44:                                        ; preds = %while.stmt34
  %load_lval47 = load i32, i32* %a, align 4
  %sub48 = sub i32 %load_lval47, 5
  store i32 %sub48, i32* %a, align 4
  br label %cur33

if.else45:                                        ; preds = %while.stmt34
  br label %cur33

cur49:                                            ; preds = %while.cond51
  %load_lval83 = load i32, i32* %b, align 4
  %sub84 = sub i32 %load_lval83, 3
  store i32 %sub84, i32* %b, align 4
  %load_lval85 = load i32, i32* %a, align 4
  %add86 = add i32 %load_lval85, 1
  store i32 %add86, i32* %a, align 4
  %load_lval88 = load i32, i32* %a, align 4
  %load_lval89 = load i32, i32* %b, align 4
  %add90 = add i32 %load_lval88, %load_lval89
  %cmp91 = icmp sgt i32 %add90, 50
  %zext_to_i3292 = zext i1 %cmp91 to i32
  %to_bool94 = icmp ne i32 %zext_to_i3292, 0
  br i1 %to_bool94, label %if.then93, label %merge87

while.stmt50:                                     ; preds = %while.cond51
  %load_lval57 = load i32, i32* %b, align 4
  %cmp58 = icmp sgt i32 %load_lval57, 70
  %zext_to_i3259 = zext i1 %cmp58 to i32
  %to_bool62 = icmp ne i32 %zext_to_i3259, 0
  br i1 %to_bool62, label %if.then60, label %if.else61

while.cond51:                                     ; preds = %merge56, %if.then60, %cur33
  %load_lval52 = load i32, i32* %b, align 4
  %cmp53 = icmp sgt i32 %load_lval52, 35
  %zext_to_i3254 = zext i1 %cmp53 to i32
  %to_bool55 = icmp ne i32 %zext_to_i3254, 0
  br i1 %to_bool55, label %while.stmt50, label %cur49

merge56:                                          ; preds = %merge65
  br label %while.cond51

if.then60:                                        ; preds = %while.stmt50
  %load_lval63 = load i32, i32* %b, align 4
  %sub64 = sub i32 %load_lval63, 5
  store i32 %sub64, i32* %b, align 4
  br label %while.cond51

if.else61:                                        ; preds = %while.stmt50
  %load_lval66 = load i32, i32* %b, align 4
  %cmp67 = icmp sgt i32 %load_lval66, 50
  %zext_to_i3268 = zext i1 %cmp67 to i32
  %to_bool71 = icmp ne i32 %zext_to_i3268, 0
  br i1 %to_bool71, label %if.then69, label %if.else70

merge65:                                          ; preds = %merge74, %if.then69
  br label %merge56

if.then69:                                        ; preds = %if.else61
  %load_lval72 = load i32, i32* %b, align 4
  %sub73 = sub i32 %load_lval72, 7
  store i32 %sub73, i32* %b, align 4
  br label %merge65

if.else70:                                        ; preds = %if.else61
  %load_lval75 = load i32, i32* %b, align 4
  %cmp76 = icmp sgt i32 %load_lval75, 30
  %zext_to_i3277 = zext i1 %cmp76 to i32
  %to_bool80 = icmp ne i32 %zext_to_i3277, 0
  br i1 %to_bool80, label %if.then78, label %if.else79

merge74:                                          ; preds = %if.then78
  br label %merge65

if.then78:                                        ; preds = %if.else70
  %load_lval81 = load i32, i32* %b, align 4
  %sub82 = sub i32 %load_lval81, 1
  store i32 %sub82, i32* %b, align 4
  br label %merge74

if.else79:                                        ; preds = %if.else70
  ret i32 10

merge87:                                          ; preds = %if.then93, %cur49
  br label %while.cond15

if.then93:                                        ; preds = %cur49
  %load_lval95 = load i32, i32* %a, align 4
  %sub96 = sub i32 %load_lval95, 10
  store i32 %sub96, i32* %a, align 4
  br label %merge87
}
