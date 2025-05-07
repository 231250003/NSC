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
  %not = icmp eq i32 %load_lval2, 0
  %zext_to_i32 = zext i1 %not to i32
  %load_lval3 = load i32, i32* %b, align 4
  %add = add i32 %zext_to_i32, %load_lval3
  %cmp = icmp sge i32 %add, 10
  %zext_to_i324 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %merge5, %mainEntry
  br label %while.cond

if.then:                                          ; preds = %mainEntry
  %load_lval6 = load i32, i32* %a, align 4
  %cmp7 = icmp sle i32 %load_lval6, 10
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool10 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool10, label %if.then9, label %merge5

merge5:                                           ; preds = %if.then
  br label %merge

if.then9:                                         ; preds = %if.then
  ret i32 2

cur:                                              ; preds = %if.then16, %while.cond
  %cnt = alloca i32, align 4
  store i32 0, i32* %cnt, align 4
  br label %while.cond30

while.stmt:                                       ; preds = %while.cond
  %load_lval11 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval11, 2
  store i32 %sub, i32* %a, align 4
  %load_lval13 = load i32, i32* %a, align 4
  %cmp14 = icmp eq i32 %load_lval13, 45
  %zext_to_i3215 = zext i1 %cmp14 to i32
  %to_bool17 = icmp ne i32 %zext_to_i3215, 0
  br i1 %to_bool17, label %if.then16, label %if.else

while.cond:                                       ; preds = %merge12, %merge
  br i1 true, label %while.stmt, label %cur

merge12:                                          ; preds = %merge18
  br label %while.cond

if.then16:                                        ; preds = %while.stmt
  br label %cur

if.else:                                          ; preds = %while.stmt
  %load_lval19 = load i32, i32* %a, align 4
  %cmp20 = icmp eq i32 %load_lval19, 48
  %zext_to_i3221 = zext i1 %cmp20 to i32
  %to_bool23 = icmp ne i32 %zext_to_i3221, 0
  br i1 %to_bool23, label %if.then22, label %merge18

merge18:                                          ; preds = %if.then22, %if.else
  br label %merge12

if.then22:                                        ; preds = %if.else
  %load_lval24 = load i32, i32* %b, align 4
  %sub25 = sub i32 %load_lval24, 3
  store i32 %sub25, i32* %b, align 4
  %load_lval26 = load i32, i32* %a, align 4
  %add27 = add i32 %load_lval26, 1
  store i32 %add27, i32* %a, align 4
  br label %merge18

cur28:                                            ; preds = %if.then39, %while.cond30
  %load_lval94 = load i32, i32* %b, align 4
  %sub95 = sub i32 %load_lval94, 3
  store i32 %sub95, i32* %b, align 4
  %load_lval96 = load i32, i32* %a, align 4
  %add97 = add i32 %load_lval96, 1
  store i32 %add97, i32* %a, align 4
  %load_lval99 = load i32, i32* %a, align 4
  %load_lval100 = load i32, i32* %b, align 4
  %add101 = add i32 %load_lval99, %load_lval100
  %cmp102 = icmp sgt i32 %add101, 50
  %zext_to_i32103 = zext i1 %cmp102 to i32
  %to_bool105 = icmp ne i32 %zext_to_i32103, 0
  br i1 %to_bool105, label %if.then104, label %merge98

while.stmt29:                                     ; preds = %while.cond30
  %load_lval36 = load i32, i32* %cnt, align 4
  %cmp37 = icmp eq i32 %load_lval36, 30
  %zext_to_i3238 = zext i1 %cmp37 to i32
  %to_bool40 = icmp ne i32 %zext_to_i3238, 0
  br i1 %to_bool40, label %if.then39, label %merge35

while.cond30:                                     ; preds = %merge72, %cur
  %load_lval31 = load i32, i32* %b, align 4
  %cmp32 = icmp sgt i32 %load_lval31, 35
  %zext_to_i3233 = zext i1 %cmp32 to i32
  %to_bool34 = icmp ne i32 %zext_to_i3233, 0
  br i1 %to_bool34, label %while.stmt29, label %cur28

merge35:                                          ; preds = %while.stmt29
  %b41 = alloca i32, align 4
  store i32 30, i32* %b41, align 4
  br label %while.cond44

if.then39:                                        ; preds = %while.stmt29
  br label %cur28

cur42:                                            ; preds = %merge45, %while.cond44
  %load_lval56 = load i32, i32* %b, align 4
  %cmp57 = icmp sgt i32 %load_lval56, 70
  %zext_to_i3258 = zext i1 %cmp57 to i32
  %to_bool61 = icmp ne i32 %zext_to_i3258, 0
  br i1 %to_bool61, label %if.then59, label %if.else60

while.stmt43:                                     ; preds = %while.cond44
  %load_lval46 = load i32, i32* %b41, align 4
  %cmp47 = icmp slt i32 %load_lval46, 20
  %zext_to_i3248 = zext i1 %cmp47 to i32
  %to_bool51 = icmp ne i32 %zext_to_i3248, 0
  br i1 %to_bool51, label %if.then49, label %if.else50

while.cond44:                                     ; preds = %merge35
  br i1 true, label %while.stmt43, label %cur42

merge45:                                          ; preds = %if.else50
  br label %cur42

if.then49:                                        ; preds = %while.stmt43
  %load_lval52 = load i32, i32* %b41, align 4
  ret i32 %load_lval52

if.else50:                                        ; preds = %while.stmt43
  %load_lval53 = load i32, i32* %b41, align 4
  %sub54 = sub i32 %load_lval53, 7
  store i32 %sub54, i32* %b41, align 4
  br label %merge45

merge55:                                          ; preds = %merge64, %if.then59
  %load_lval73 = load i32, i32* %b, align 4
  %load_lval74 = load i32, i32* %a, align 4
  %add75 = add i32 %load_lval73, %load_lval74
  %cmp76 = icmp sgt i32 %add75, 40
  %zext_to_i3277 = zext i1 %cmp76 to i32
  %to_bool80 = icmp ne i32 %zext_to_i3277, 0
  br i1 %to_bool80, label %if.then78, label %if.else79

if.then59:                                        ; preds = %cur42
  %load_lval62 = load i32, i32* %b, align 4
  %sub63 = sub i32 %load_lval62, 5
  store i32 %sub63, i32* %b, align 4
  br label %merge55

if.else60:                                        ; preds = %cur42
  %load_lval65 = load i32, i32* %b, align 4
  %cmp66 = icmp sgt i32 %load_lval65, 50
  %zext_to_i3267 = zext i1 %cmp66 to i32
  %to_bool69 = icmp ne i32 %zext_to_i3267, 0
  br i1 %to_bool69, label %if.then68, label %merge64

merge64:                                          ; preds = %if.then68, %if.else60
  br label %merge55

if.then68:                                        ; preds = %if.else60
  %load_lval70 = load i32, i32* %b, align 4
  %sub71 = sub i32 %load_lval70, 7
  store i32 %sub71, i32* %b, align 4
  br label %merge64

merge72:                                          ; preds = %merge83, %if.then78
  %load_lval92 = load i32, i32* %cnt, align 4
  %add93 = add i32 %load_lval92, 1
  store i32 %add93, i32* %cnt, align 4
  br label %while.cond30

if.then78:                                        ; preds = %merge55
  %load_lval81 = load i32, i32* %b, align 4
  %add82 = add i32 %load_lval81, 10
  store i32 %add82, i32* %b, align 4
  br label %merge72

if.else79:                                        ; preds = %merge55
  %load_lval84 = load i32, i32* %b, align 4
  %cmp85 = icmp sgt i32 %load_lval84, 30
  %zext_to_i3286 = zext i1 %cmp85 to i32
  %to_bool89 = icmp ne i32 %zext_to_i3286, 0
  br i1 %to_bool89, label %if.then87, label %if.else88

merge83:                                          ; preds = %if.then87
  br label %merge72

if.then87:                                        ; preds = %if.else79
  %load_lval90 = load i32, i32* %b, align 4
  %sub91 = sub i32 %load_lval90, 1
  store i32 %sub91, i32* %b, align 4
  br label %merge83

if.else88:                                        ; preds = %if.else79
  ret i32 10

merge98:                                          ; preds = %if.then104, %cur28
  %result = alloca i32, align 4
  %load_lval108 = load i32, i32* %a, align 4
  store i32 %load_lval108, i32* %result, align 4
  %load_lval109 = load i32, i32* %result, align 4
  ret i32 %load_lval109

if.then104:                                       ; preds = %cur28
  %load_lval106 = load i32, i32* %a, align 4
  %sub107 = sub i32 %load_lval106, 10
  store i32 %sub107, i32* %a, align 4
  br label %merge98
}
