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
  %load_lval101 = load i32, i32* %a, align 4
  store i32 %load_lval101, i32* %result, align 4
  %load_lval102 = load i32, i32* %result, align 4
  ret i32 %load_lval102

while.stmt14:                                     ; preds = %while.cond15
  %load_lval23 = load i32, i32* %a, align 4
  %load_lval24 = load i32, i32* %a, align 4
  %cmp25 = icmp sge i32 %load_lval23, %load_lval24
  %zext_to_i3226 = zext i1 %cmp25 to i32
  %to_bool28 = icmp ne i32 %zext_to_i3226, 0
  br i1 %to_bool28, label %if.then27, label %merge22

while.cond15:                                     ; preds = %merge91, %cur
  %load_lval16 = load i32, i32* %b, align 4
  %load_lval17 = load i32, i32* %a, align 4
  %add18 = add i32 %load_lval16, %load_lval17
  %cmp19 = icmp sgt i32 %add18, 20
  %zext_to_i3220 = zext i1 %cmp19 to i32
  %to_bool21 = icmp ne i32 %zext_to_i3220, 0
  br i1 %to_bool21, label %while.stmt14, label %cur13

merge22:                                          ; preds = %while.stmt14
  %load_lval30 = load i32, i32* %a, align 4
  %load_lval31 = load i32, i32* %a, align 4
  %cmp32 = icmp eq i32 %load_lval30, %load_lval31
  %zext_to_i3233 = zext i1 %cmp32 to i32
  %to_bool36 = icmp ne i32 %zext_to_i3233, 0
  br i1 %to_bool36, label %if.then34, label %if.else35

if.then27:                                        ; preds = %while.stmt14
  ret i32 1

merge29:                                          ; No predecessors!
  br label %while.cond39

if.then34:                                        ; preds = %merge22
  ret i32 2

if.else35:                                        ; preds = %merge22
  ret i32 3

cur37:                                            ; preds = %if.else49, %if.then48, %while.cond39
  br label %while.cond55

while.stmt38:                                     ; preds = %while.cond39
  %load_lval45 = load i32, i32* %a, align 4
  %cmp46 = icmp sgt i32 %load_lval45, 40
  %zext_to_i3247 = zext i1 %cmp46 to i32
  %to_bool50 = icmp ne i32 %zext_to_i3247, 0
  br i1 %to_bool50, label %if.then48, label %if.else49

while.cond39:                                     ; preds = %merge44, %merge29
  %load_lval40 = load i32, i32* %a, align 4
  %cmp41 = icmp sgt i32 %load_lval40, 10
  %zext_to_i3242 = zext i1 %cmp41 to i32
  %to_bool43 = icmp ne i32 %zext_to_i3242, 0
  br i1 %to_bool43, label %while.stmt38, label %cur37

merge44:                                          ; No predecessors!
  br label %while.cond39

if.then48:                                        ; preds = %while.stmt38
  %load_lval51 = load i32, i32* %a, align 4
  %sub52 = sub i32 %load_lval51, 5
  store i32 %sub52, i32* %a, align 4
  br label %cur37

if.else49:                                        ; preds = %while.stmt38
  br label %cur37

cur53:                                            ; preds = %while.cond55
  %load_lval87 = load i32, i32* %b, align 4
  %sub88 = sub i32 %load_lval87, 3
  store i32 %sub88, i32* %b, align 4
  %load_lval89 = load i32, i32* %a, align 4
  %add90 = add i32 %load_lval89, 1
  store i32 %add90, i32* %a, align 4
  %load_lval92 = load i32, i32* %a, align 4
  %load_lval93 = load i32, i32* %b, align 4
  %add94 = add i32 %load_lval92, %load_lval93
  %cmp95 = icmp sgt i32 %add94, 50
  %zext_to_i3296 = zext i1 %cmp95 to i32
  %to_bool98 = icmp ne i32 %zext_to_i3296, 0
  br i1 %to_bool98, label %if.then97, label %merge91

while.stmt54:                                     ; preds = %while.cond55
  %load_lval61 = load i32, i32* %b, align 4
  %cmp62 = icmp sgt i32 %load_lval61, 70
  %zext_to_i3263 = zext i1 %cmp62 to i32
  %to_bool66 = icmp ne i32 %zext_to_i3263, 0
  br i1 %to_bool66, label %if.then64, label %if.else65

while.cond55:                                     ; preds = %merge60, %if.then64, %cur37
  %load_lval56 = load i32, i32* %b, align 4
  %cmp57 = icmp sgt i32 %load_lval56, 35
  %zext_to_i3258 = zext i1 %cmp57 to i32
  %to_bool59 = icmp ne i32 %zext_to_i3258, 0
  br i1 %to_bool59, label %while.stmt54, label %cur53

merge60:                                          ; preds = %merge69
  br label %while.cond55

if.then64:                                        ; preds = %while.stmt54
  %load_lval67 = load i32, i32* %b, align 4
  %sub68 = sub i32 %load_lval67, 5
  store i32 %sub68, i32* %b, align 4
  br label %while.cond55

if.else65:                                        ; preds = %while.stmt54
  %load_lval70 = load i32, i32* %b, align 4
  %cmp71 = icmp sgt i32 %load_lval70, 50
  %zext_to_i3272 = zext i1 %cmp71 to i32
  %to_bool75 = icmp ne i32 %zext_to_i3272, 0
  br i1 %to_bool75, label %if.then73, label %if.else74

merge69:                                          ; preds = %merge78, %if.then73
  br label %merge60

if.then73:                                        ; preds = %if.else65
  %load_lval76 = load i32, i32* %b, align 4
  %sub77 = sub i32 %load_lval76, 7
  store i32 %sub77, i32* %b, align 4
  br label %merge69

if.else74:                                        ; preds = %if.else65
  %load_lval79 = load i32, i32* %b, align 4
  %cmp80 = icmp sgt i32 %load_lval79, 30
  %zext_to_i3281 = zext i1 %cmp80 to i32
  %to_bool84 = icmp ne i32 %zext_to_i3281, 0
  br i1 %to_bool84, label %if.then82, label %if.else83

merge78:                                          ; preds = %if.then82
  br label %merge69

if.then82:                                        ; preds = %if.else74
  %load_lval85 = load i32, i32* %b, align 4
  %sub86 = sub i32 %load_lval85, 1
  store i32 %sub86, i32* %b, align 4
  br label %merge78

if.else83:                                        ; preds = %if.else74
  ret i32 10

merge91:                                          ; preds = %if.then97, %cur53
  br label %while.cond15

if.then97:                                        ; preds = %cur53
  %load_lval99 = load i32, i32* %a, align 4
  %sub100 = sub i32 %load_lval99, 10
  store i32 %sub100, i32* %a, align 4
  br label %merge91
}
