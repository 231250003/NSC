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
  %add = add i32 %load_lval2, %load_lval3
  ret i32 %add

cur:                                              ; preds = %if.then, %while.cond
  br label %while.cond18

while.stmt:                                       ; preds = %while.cond
  %load_lval4 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval4, 2
  store i32 %sub, i32* %a, align 4
  %load_lval5 = load i32, i32* %a, align 4
  %cmp = icmp eq i32 %load_lval5, 45
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %if.else

while.cond:                                       ; preds = %merge
  br i1 true, label %while.stmt, label %cur

merge:                                            ; preds = %merge6
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  br label %cur

if.else:                                          ; preds = %while.stmt
  %load_lval7 = load i32, i32* %a, align 4
  %cmp8 = icmp eq i32 %load_lval7, 48
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool11 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool11, label %if.then10, label %merge6

merge6:                                           ; preds = %if.then10, %if.else
  br label %merge

if.then10:                                        ; preds = %if.else
  %load_lval12 = load i32, i32* %b, align 4
  %sub13 = sub i32 %load_lval12, 3
  store i32 %sub13, i32* %b, align 4
  %load_lval14 = load i32, i32* %a, align 4
  %add15 = add i32 %load_lval14, 1
  store i32 %add15, i32* %a, align 4
  br label %merge6

cur16:                                            ; preds = %while.cond18
  %result = alloca i32, align 4
  %load_lval105 = load i32, i32* %a, align 4
  store i32 %load_lval105, i32* %result, align 4
  %load_lval106 = load i32, i32* %result, align 4
  ret i32 %load_lval106

while.stmt17:                                     ; preds = %while.cond18
  br label %while.cond27

while.cond18:                                     ; preds = %merge95, %cur
  %load_lval19 = load i32, i32* %b, align 4
  %load_lval20 = load i32, i32* %a, align 4
  %add21 = add i32 %load_lval19, %load_lval20
  %cmp22 = icmp sgt i32 %add21, 20
  %zext_to_i3223 = zext i1 %cmp22 to i32
  %to_bool24 = icmp ne i32 %zext_to_i3223, 0
  br i1 %to_bool24, label %while.stmt17, label %cur16

cur25:                                            ; preds = %if.else37, %if.then36, %while.cond27
  br label %while.cond43

while.stmt26:                                     ; preds = %while.cond27
  %load_lval33 = load i32, i32* %a, align 4
  %cmp34 = icmp sgt i32 %load_lval33, 40
  %zext_to_i3235 = zext i1 %cmp34 to i32
  %to_bool38 = icmp ne i32 %zext_to_i3235, 0
  br i1 %to_bool38, label %if.then36, label %if.else37

while.cond27:                                     ; preds = %merge32, %while.stmt17
  %load_lval28 = load i32, i32* %a, align 4
  %cmp29 = icmp sgt i32 %load_lval28, 10
  %zext_to_i3230 = zext i1 %cmp29 to i32
  %to_bool31 = icmp ne i32 %zext_to_i3230, 0
  br i1 %to_bool31, label %while.stmt26, label %cur25

merge32:                                          ; No predecessors!
  br label %while.cond27

if.then36:                                        ; preds = %while.stmt26
  %load_lval39 = load i32, i32* %a, align 4
  %sub40 = sub i32 %load_lval39, 5
  store i32 %sub40, i32* %a, align 4
  br label %cur25

if.else37:                                        ; preds = %while.stmt26
  br label %cur25

cur41:                                            ; preds = %while.cond43
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

while.stmt42:                                     ; preds = %while.cond43
  %b48 = alloca i32, align 4
  store i32 30, i32* %b48, align 4
  br label %while.cond51

while.cond43:                                     ; preds = %merge64, %if.then68, %cur25
  %load_lval44 = load i32, i32* %b, align 4
  %cmp45 = icmp sgt i32 %load_lval44, 35
  %zext_to_i3246 = zext i1 %cmp45 to i32
  %to_bool47 = icmp ne i32 %zext_to_i3246, 0
  br i1 %to_bool47, label %while.stmt42, label %cur41

cur49:                                            ; preds = %merge52, %while.cond51
  %load_lval62 = load i32, i32* %b, align 4
  %sub63 = sub i32 %load_lval62, 10
  ret i32 %sub63

while.stmt50:                                     ; preds = %while.cond51
  %load_lval53 = load i32, i32* %b48, align 4
  %cmp54 = icmp slt i32 %load_lval53, 20
  %zext_to_i3255 = zext i1 %cmp54 to i32
  %to_bool58 = icmp ne i32 %zext_to_i3255, 0
  br i1 %to_bool58, label %if.then56, label %if.else57

while.cond51:                                     ; preds = %while.stmt42
  br i1 true, label %while.stmt50, label %cur49

merge52:                                          ; preds = %if.else57
  br label %cur49

if.then56:                                        ; preds = %while.stmt50
  %load_lval59 = load i32, i32* %b48, align 4
  ret i32 %load_lval59

if.else57:                                        ; preds = %while.stmt50
  %load_lval60 = load i32, i32* %b48, align 4
  %sub61 = sub i32 %load_lval60, 7
  store i32 %sub61, i32* %b48, align 4
  br label %merge52

merge64:                                          ; preds = %merge73
  br label %while.cond43

if.then68:                                        ; No predecessors!
  %load_lval71 = load i32, i32* %b, align 4
  %sub72 = sub i32 %load_lval71, 5
  store i32 %sub72, i32* %b, align 4
  br label %while.cond43

if.else69:                                        ; No predecessors!
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

merge95:                                          ; preds = %if.then101, %cur41
  br label %while.cond18

if.then101:                                       ; preds = %cur41
  %load_lval103 = load i32, i32* %a, align 4
  %sub104 = sub i32 %load_lval103, 10
  store i32 %sub104, i32* %a, align 4
  br label %merge95
}
