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
  %cmp = icmp eq i32 %zext_to_i32, 56
  %zext_to_i323 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i323, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %mainEntry
  br label %while.cond

if.then:                                          ; preds = %mainEntry
  %load_lval4 = load i32, i32* %a, align 4
  %load_lval5 = load i32, i32* %b, align 4
  %not6 = icmp eq i32 %load_lval5, 0
  %zext_to_i327 = zext i1 %not6 to i32
  %add = add i32 %load_lval4, %zext_to_i327
  %add8 = add i32 %add, 1
  ret i32 %add8

cur:                                              ; preds = %if.then14, %while.cond
  br label %while.cond28

while.stmt:                                       ; preds = %while.cond
  %load_lval9 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval9, 2
  store i32 %sub, i32* %a, align 4
  %load_lval11 = load i32, i32* %a, align 4
  %cmp12 = icmp eq i32 %load_lval11, 45
  %zext_to_i3213 = zext i1 %cmp12 to i32
  %to_bool15 = icmp ne i32 %zext_to_i3213, 0
  br i1 %to_bool15, label %if.then14, label %if.else

while.cond:                                       ; preds = %merge10, %merge
  br i1 true, label %while.stmt, label %cur

merge10:                                          ; preds = %merge16
  br label %while.cond

if.then14:                                        ; preds = %while.stmt
  br label %cur

if.else:                                          ; preds = %while.stmt
  %load_lval17 = load i32, i32* %a, align 4
  %cmp18 = icmp eq i32 %load_lval17, 48
  %zext_to_i3219 = zext i1 %cmp18 to i32
  %to_bool21 = icmp ne i32 %zext_to_i3219, 0
  br i1 %to_bool21, label %if.then20, label %merge16

merge16:                                          ; preds = %if.then20, %if.else
  br label %merge10

if.then20:                                        ; preds = %if.else
  %load_lval22 = load i32, i32* %b, align 4
  %sub23 = sub i32 %load_lval22, 3
  store i32 %sub23, i32* %b, align 4
  %load_lval24 = load i32, i32* %a, align 4
  %add25 = add i32 %load_lval24, 1
  store i32 %add25, i32* %a, align 4
  br label %merge16

cur26:                                            ; preds = %while.cond28
  %result = alloca i32, align 4
  %load_lval115 = load i32, i32* %a, align 4
  store i32 %load_lval115, i32* %result, align 4
  %load_lval116 = load i32, i32* %result, align 4
  ret i32 %load_lval116

while.stmt27:                                     ; preds = %while.cond28
  br label %while.cond37

while.cond28:                                     ; preds = %merge105, %cur
  %load_lval29 = load i32, i32* %b, align 4
  %load_lval30 = load i32, i32* %a, align 4
  %add31 = add i32 %load_lval29, %load_lval30
  %cmp32 = icmp sgt i32 %add31, 20
  %zext_to_i3233 = zext i1 %cmp32 to i32
  %to_bool34 = icmp ne i32 %zext_to_i3233, 0
  br i1 %to_bool34, label %while.stmt27, label %cur26

cur35:                                            ; preds = %if.else47, %if.then46, %while.cond37
  br label %while.cond53

while.stmt36:                                     ; preds = %while.cond37
  %load_lval43 = load i32, i32* %a, align 4
  %cmp44 = icmp sgt i32 %load_lval43, 40
  %zext_to_i3245 = zext i1 %cmp44 to i32
  %to_bool48 = icmp ne i32 %zext_to_i3245, 0
  br i1 %to_bool48, label %if.then46, label %if.else47

while.cond37:                                     ; preds = %merge42, %while.stmt27
  %load_lval38 = load i32, i32* %a, align 4
  %cmp39 = icmp sgt i32 %load_lval38, 10
  %zext_to_i3240 = zext i1 %cmp39 to i32
  %to_bool41 = icmp ne i32 %zext_to_i3240, 0
  br i1 %to_bool41, label %while.stmt36, label %cur35

merge42:                                          ; No predecessors!
  br label %while.cond37

if.then46:                                        ; preds = %while.stmt36
  %load_lval49 = load i32, i32* %a, align 4
  %sub50 = sub i32 %load_lval49, 5
  store i32 %sub50, i32* %a, align 4
  br label %cur35

if.else47:                                        ; preds = %while.stmt36
  br label %cur35

cur51:                                            ; preds = %while.cond53
  %load_lval101 = load i32, i32* %b, align 4
  %sub102 = sub i32 %load_lval101, 3
  store i32 %sub102, i32* %b, align 4
  %load_lval103 = load i32, i32* %a, align 4
  %add104 = add i32 %load_lval103, 1
  store i32 %add104, i32* %a, align 4
  %load_lval106 = load i32, i32* %a, align 4
  %load_lval107 = load i32, i32* %b, align 4
  %add108 = add i32 %load_lval106, %load_lval107
  %cmp109 = icmp sgt i32 %add108, 50
  %zext_to_i32110 = zext i1 %cmp109 to i32
  %to_bool112 = icmp ne i32 %zext_to_i32110, 0
  br i1 %to_bool112, label %if.then111, label %merge105

while.stmt52:                                     ; preds = %while.cond53
  %b58 = alloca i32, align 4
  store i32 30, i32* %b58, align 4
  br label %while.cond61

while.cond53:                                     ; preds = %merge74, %if.then78, %cur35
  %load_lval54 = load i32, i32* %b, align 4
  %cmp55 = icmp sgt i32 %load_lval54, 35
  %zext_to_i3256 = zext i1 %cmp55 to i32
  %to_bool57 = icmp ne i32 %zext_to_i3256, 0
  br i1 %to_bool57, label %while.stmt52, label %cur51

cur59:                                            ; preds = %merge62, %while.cond61
  %load_lval72 = load i32, i32* %b, align 4
  %sub73 = sub i32 %load_lval72, 10
  ret i32 %sub73

while.stmt60:                                     ; preds = %while.cond61
  %load_lval63 = load i32, i32* %b58, align 4
  %cmp64 = icmp slt i32 %load_lval63, 20
  %zext_to_i3265 = zext i1 %cmp64 to i32
  %to_bool68 = icmp ne i32 %zext_to_i3265, 0
  br i1 %to_bool68, label %if.then66, label %if.else67

while.cond61:                                     ; preds = %while.stmt52
  br i1 true, label %while.stmt60, label %cur59

merge62:                                          ; preds = %if.else67
  br label %cur59

if.then66:                                        ; preds = %while.stmt60
  %load_lval69 = load i32, i32* %b58, align 4
  ret i32 %load_lval69

if.else67:                                        ; preds = %while.stmt60
  %load_lval70 = load i32, i32* %b58, align 4
  %sub71 = sub i32 %load_lval70, 7
  store i32 %sub71, i32* %b58, align 4
  br label %merge62

merge74:                                          ; preds = %merge83
  br label %while.cond53

if.then78:                                        ; No predecessors!
  %load_lval81 = load i32, i32* %b, align 4
  %sub82 = sub i32 %load_lval81, 5
  store i32 %sub82, i32* %b, align 4
  br label %while.cond53

if.else79:                                        ; No predecessors!
  %load_lval84 = load i32, i32* %b, align 4
  %cmp85 = icmp sgt i32 %load_lval84, 50
  %zext_to_i3286 = zext i1 %cmp85 to i32
  %to_bool89 = icmp ne i32 %zext_to_i3286, 0
  br i1 %to_bool89, label %if.then87, label %if.else88

merge83:                                          ; preds = %merge92, %if.then87
  br label %merge74

if.then87:                                        ; preds = %if.else79
  %load_lval90 = load i32, i32* %b, align 4
  %sub91 = sub i32 %load_lval90, 7
  store i32 %sub91, i32* %b, align 4
  br label %merge83

if.else88:                                        ; preds = %if.else79
  %load_lval93 = load i32, i32* %b, align 4
  %cmp94 = icmp sgt i32 %load_lval93, 30
  %zext_to_i3295 = zext i1 %cmp94 to i32
  %to_bool98 = icmp ne i32 %zext_to_i3295, 0
  br i1 %to_bool98, label %if.then96, label %if.else97

merge92:                                          ; preds = %if.then96
  br label %merge83

if.then96:                                        ; preds = %if.else88
  %load_lval99 = load i32, i32* %b, align 4
  %sub100 = sub i32 %load_lval99, 1
  store i32 %sub100, i32* %b, align 4
  br label %merge92

if.else97:                                        ; preds = %if.else88
  ret i32 10

merge105:                                         ; preds = %if.then111, %cur51
  br label %while.cond28

if.then111:                                       ; preds = %cur51
  %load_lval113 = load i32, i32* %a, align 4
  %sub114 = sub i32 %load_lval113, 10
  store i32 %sub114, i32* %a, align 4
  br label %merge105
}
