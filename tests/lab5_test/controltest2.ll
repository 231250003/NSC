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
  %load_lval2 = load i32, i32* @x, align 4
  %load_lval3 = load i32, i32* @y, align 4
  %add = add i32 %load_lval2, %load_lval3
  store i32 %add, i32* %a, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %result = alloca i32, align 4
  %load_lval77 = load i32, i32* %a, align 4
  store i32 %load_lval77, i32* %result, align 4
  %load_lval78 = load i32, i32* %result, align 4
  ret i32 %load_lval78

while.stmt:                                       ; preds = %while.cond
  %load_lval7 = load i32, i32* %a, align 4
  %cmp8 = icmp ne i32 %load_lval7, 98
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool10 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool10, label %if.then, label %if.else

while.cond:                                       ; preds = %merge67, %mainEntry
  %load_lval4 = load i32, i32* %b, align 4
  %load_lval5 = load i32, i32* %a, align 4
  %add6 = add i32 %load_lval4, %load_lval5
  %cmp = icmp sgt i32 %add6, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; No predecessors!
  br label %while.cond16

if.then:                                          ; preds = %while.stmt
  ret i32 1

if.else:                                          ; preds = %while.stmt
  %load_lval11 = load i32, i32* %a, align 4
  %load_lval12 = load i32, i32* %b, align 4
  %add13 = add i32 %load_lval11, %load_lval12
  ret i32 %add13

cur14:                                            ; preds = %if.else26, %if.then25, %while.cond16
  br label %while.cond31

while.stmt15:                                     ; preds = %while.cond16
  %load_lval22 = load i32, i32* %a, align 4
  %cmp23 = icmp sgt i32 %load_lval22, 40
  %zext_to_i3224 = zext i1 %cmp23 to i32
  %to_bool27 = icmp ne i32 %zext_to_i3224, 0
  br i1 %to_bool27, label %if.then25, label %if.else26

while.cond16:                                     ; preds = %merge21, %merge
  %load_lval17 = load i32, i32* %a, align 4
  %cmp18 = icmp sgt i32 %load_lval17, 10
  %zext_to_i3219 = zext i1 %cmp18 to i32
  %to_bool20 = icmp ne i32 %zext_to_i3219, 0
  br i1 %to_bool20, label %while.stmt15, label %cur14

merge21:                                          ; No predecessors!
  br label %while.cond16

if.then25:                                        ; preds = %while.stmt15
  %load_lval28 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval28, 5
  store i32 %sub, i32* %a, align 4
  br label %cur14

if.else26:                                        ; preds = %while.stmt15
  br label %cur14

cur29:                                            ; preds = %while.cond31
  %load_lval63 = load i32, i32* %b, align 4
  %sub64 = sub i32 %load_lval63, 3
  store i32 %sub64, i32* %b, align 4
  %load_lval65 = load i32, i32* %a, align 4
  %add66 = add i32 %load_lval65, 1
  store i32 %add66, i32* %a, align 4
  %load_lval68 = load i32, i32* %a, align 4
  %load_lval69 = load i32, i32* %b, align 4
  %add70 = add i32 %load_lval68, %load_lval69
  %cmp71 = icmp sgt i32 %add70, 50
  %zext_to_i3272 = zext i1 %cmp71 to i32
  %to_bool74 = icmp ne i32 %zext_to_i3272, 0
  br i1 %to_bool74, label %if.then73, label %merge67

while.stmt30:                                     ; preds = %while.cond31
  %load_lval37 = load i32, i32* %b, align 4
  %cmp38 = icmp sgt i32 %load_lval37, 70
  %zext_to_i3239 = zext i1 %cmp38 to i32
  %to_bool42 = icmp ne i32 %zext_to_i3239, 0
  br i1 %to_bool42, label %if.then40, label %if.else41

while.cond31:                                     ; preds = %merge36, %if.then40, %cur14
  %load_lval32 = load i32, i32* %b, align 4
  %cmp33 = icmp sgt i32 %load_lval32, 35
  %zext_to_i3234 = zext i1 %cmp33 to i32
  %to_bool35 = icmp ne i32 %zext_to_i3234, 0
  br i1 %to_bool35, label %while.stmt30, label %cur29

merge36:                                          ; preds = %merge45
  br label %while.cond31

if.then40:                                        ; preds = %while.stmt30
  %load_lval43 = load i32, i32* %b, align 4
  %sub44 = sub i32 %load_lval43, 5
  store i32 %sub44, i32* %b, align 4
  br label %while.cond31

if.else41:                                        ; preds = %while.stmt30
  %load_lval46 = load i32, i32* %b, align 4
  %cmp47 = icmp sgt i32 %load_lval46, 50
  %zext_to_i3248 = zext i1 %cmp47 to i32
  %to_bool51 = icmp ne i32 %zext_to_i3248, 0
  br i1 %to_bool51, label %if.then49, label %if.else50

merge45:                                          ; preds = %merge54, %if.then49
  br label %merge36

if.then49:                                        ; preds = %if.else41
  %load_lval52 = load i32, i32* %b, align 4
  %sub53 = sub i32 %load_lval52, 7
  store i32 %sub53, i32* %b, align 4
  br label %merge45

if.else50:                                        ; preds = %if.else41
  %load_lval55 = load i32, i32* %b, align 4
  %cmp56 = icmp sgt i32 %load_lval55, 30
  %zext_to_i3257 = zext i1 %cmp56 to i32
  %to_bool60 = icmp ne i32 %zext_to_i3257, 0
  br i1 %to_bool60, label %if.then58, label %if.else59

merge54:                                          ; preds = %if.then58
  br label %merge45

if.then58:                                        ; preds = %if.else50
  %load_lval61 = load i32, i32* %b, align 4
  %sub62 = sub i32 %load_lval61, 1
  store i32 %sub62, i32* %b, align 4
  br label %merge54

if.else59:                                        ; preds = %if.else50
  ret i32 10

merge67:                                          ; preds = %if.then73, %cur29
  br label %while.cond

if.then73:                                        ; preds = %cur29
  %load_lval75 = load i32, i32* %a, align 4
  %sub76 = sub i32 %load_lval75, 10
  store i32 %sub76, i32* %a, align 4
  br label %merge67
}
