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

cur:                                              ; preds = %while.cond
  %result = alloca i32, align 4
  %load_lval75 = load i32, i32* %a, align 4
  store i32 %load_lval75, i32* %result, align 4
  %load_lval76 = load i32, i32* %result, align 4
  ret i32 %load_lval76

while.stmt:                                       ; preds = %while.cond
  %load_lval4 = load i32, i32* %a, align 4
  %cmp5 = icmp ne i32 %load_lval4, 56
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool7 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool7, label %if.then, label %if.else

while.cond:                                       ; preds = %merge65, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval2, %load_lval3
  %cmp = icmp sgt i32 %add, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; No predecessors!
  br label %while.cond14

if.then:                                          ; preds = %while.stmt
  ret i32 1

if.else:                                          ; preds = %while.stmt
  %load_lval8 = load i32, i32* %a, align 4
  %not = icmp eq i32 %load_lval8, 0
  %zext_to_i329 = zext i1 %not to i32
  %load_lval10 = load i32, i32* %b, align 4
  %add11 = add i32 %zext_to_i329, %load_lval10
  ret i32 %add11

cur12:                                            ; preds = %if.else24, %if.then23, %while.cond14
  br label %while.cond29

while.stmt13:                                     ; preds = %while.cond14
  %load_lval20 = load i32, i32* %a, align 4
  %cmp21 = icmp sgt i32 %load_lval20, 40
  %zext_to_i3222 = zext i1 %cmp21 to i32
  %to_bool25 = icmp ne i32 %zext_to_i3222, 0
  br i1 %to_bool25, label %if.then23, label %if.else24

while.cond14:                                     ; preds = %merge19, %merge
  %load_lval15 = load i32, i32* %a, align 4
  %cmp16 = icmp sgt i32 %load_lval15, 10
  %zext_to_i3217 = zext i1 %cmp16 to i32
  %to_bool18 = icmp ne i32 %zext_to_i3217, 0
  br i1 %to_bool18, label %while.stmt13, label %cur12

merge19:                                          ; No predecessors!
  br label %while.cond14

if.then23:                                        ; preds = %while.stmt13
  %load_lval26 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval26, 5
  store i32 %sub, i32* %a, align 4
  br label %cur12

if.else24:                                        ; preds = %while.stmt13
  br label %cur12

cur27:                                            ; preds = %while.cond29
  %load_lval61 = load i32, i32* %b, align 4
  %sub62 = sub i32 %load_lval61, 3
  store i32 %sub62, i32* %b, align 4
  %load_lval63 = load i32, i32* %a, align 4
  %add64 = add i32 %load_lval63, 1
  store i32 %add64, i32* %a, align 4
  %load_lval66 = load i32, i32* %a, align 4
  %load_lval67 = load i32, i32* %b, align 4
  %add68 = add i32 %load_lval66, %load_lval67
  %cmp69 = icmp sgt i32 %add68, 50
  %zext_to_i3270 = zext i1 %cmp69 to i32
  %to_bool72 = icmp ne i32 %zext_to_i3270, 0
  br i1 %to_bool72, label %if.then71, label %merge65

while.stmt28:                                     ; preds = %while.cond29
  %load_lval35 = load i32, i32* %b, align 4
  %cmp36 = icmp sgt i32 %load_lval35, 70
  %zext_to_i3237 = zext i1 %cmp36 to i32
  %to_bool40 = icmp ne i32 %zext_to_i3237, 0
  br i1 %to_bool40, label %if.then38, label %if.else39

while.cond29:                                     ; preds = %merge34, %if.then38, %cur12
  %load_lval30 = load i32, i32* %b, align 4
  %cmp31 = icmp sgt i32 %load_lval30, 35
  %zext_to_i3232 = zext i1 %cmp31 to i32
  %to_bool33 = icmp ne i32 %zext_to_i3232, 0
  br i1 %to_bool33, label %while.stmt28, label %cur27

merge34:                                          ; preds = %merge43
  br label %while.cond29

if.then38:                                        ; preds = %while.stmt28
  %load_lval41 = load i32, i32* %b, align 4
  %sub42 = sub i32 %load_lval41, 5
  store i32 %sub42, i32* %b, align 4
  br label %while.cond29

if.else39:                                        ; preds = %while.stmt28
  %load_lval44 = load i32, i32* %b, align 4
  %cmp45 = icmp sgt i32 %load_lval44, 50
  %zext_to_i3246 = zext i1 %cmp45 to i32
  %to_bool49 = icmp ne i32 %zext_to_i3246, 0
  br i1 %to_bool49, label %if.then47, label %if.else48

merge43:                                          ; preds = %merge52, %if.then47
  br label %merge34

if.then47:                                        ; preds = %if.else39
  %load_lval50 = load i32, i32* %b, align 4
  %sub51 = sub i32 %load_lval50, 7
  store i32 %sub51, i32* %b, align 4
  br label %merge43

if.else48:                                        ; preds = %if.else39
  %load_lval53 = load i32, i32* %b, align 4
  %cmp54 = icmp sgt i32 %load_lval53, 30
  %zext_to_i3255 = zext i1 %cmp54 to i32
  %to_bool58 = icmp ne i32 %zext_to_i3255, 0
  br i1 %to_bool58, label %if.then56, label %if.else57

merge52:                                          ; preds = %if.then56
  br label %merge43

if.then56:                                        ; preds = %if.else48
  %load_lval59 = load i32, i32* %b, align 4
  %sub60 = sub i32 %load_lval59, 1
  store i32 %sub60, i32* %b, align 4
  br label %merge52

if.else57:                                        ; preds = %if.else48
  ret i32 10

merge65:                                          ; preds = %if.then71, %cur27
  br label %while.cond

if.then71:                                        ; preds = %cur27
  %load_lval73 = load i32, i32* %a, align 4
  %sub74 = sub i32 %load_lval73, 10
  store i32 %sub74, i32* %a, align 4
  br label %merge65
}
