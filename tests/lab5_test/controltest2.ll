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
  %load_lval73 = load i32, i32* %a, align 4
  store i32 %load_lval73, i32* %result, align 4
  %load_lval74 = load i32, i32* %result, align 4
  ret i32 %load_lval74

while.stmt:                                       ; preds = %while.cond
  %load_lval7 = load i32, i32* %a, align 4
  %cmp8 = icmp eq i32 %load_lval7, 98
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool10 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool10, label %if.then, label %merge

while.cond:                                       ; preds = %merge63, %mainEntry
  %load_lval4 = load i32, i32* %b, align 4
  %load_lval5 = load i32, i32* %a, align 4
  %add6 = add i32 %load_lval4, %load_lval5
  %cmp = icmp sgt i32 %add6, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %while.stmt
  br label %while.cond13

if.then:                                          ; preds = %while.stmt
  ret i32 1

cur11:                                            ; preds = %if.else, %if.then22, %while.cond13
  br label %while.cond27

while.stmt12:                                     ; preds = %while.cond13
  %load_lval19 = load i32, i32* %a, align 4
  %cmp20 = icmp sgt i32 %load_lval19, 40
  %zext_to_i3221 = zext i1 %cmp20 to i32
  %to_bool23 = icmp ne i32 %zext_to_i3221, 0
  br i1 %to_bool23, label %if.then22, label %if.else

while.cond13:                                     ; preds = %merge18, %merge
  %load_lval14 = load i32, i32* %a, align 4
  %cmp15 = icmp sgt i32 %load_lval14, 10
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %to_bool17 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool17, label %while.stmt12, label %cur11

merge18:                                          ; No predecessors!
  br label %while.cond13

if.then22:                                        ; preds = %while.stmt12
  %load_lval24 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval24, 5
  store i32 %sub, i32* %a, align 4
  br label %cur11

if.else:                                          ; preds = %while.stmt12
  br label %cur11

cur25:                                            ; preds = %while.cond27
  %load_lval59 = load i32, i32* %b, align 4
  %sub60 = sub i32 %load_lval59, 3
  store i32 %sub60, i32* %b, align 4
  %load_lval61 = load i32, i32* %a, align 4
  %add62 = add i32 %load_lval61, 1
  store i32 %add62, i32* %a, align 4
  %load_lval64 = load i32, i32* %a, align 4
  %load_lval65 = load i32, i32* %b, align 4
  %add66 = add i32 %load_lval64, %load_lval65
  %cmp67 = icmp sgt i32 %add66, 50
  %zext_to_i3268 = zext i1 %cmp67 to i32
  %to_bool70 = icmp ne i32 %zext_to_i3268, 0
  br i1 %to_bool70, label %if.then69, label %merge63

while.stmt26:                                     ; preds = %while.cond27
  %load_lval33 = load i32, i32* %b, align 4
  %cmp34 = icmp sgt i32 %load_lval33, 70
  %zext_to_i3235 = zext i1 %cmp34 to i32
  %to_bool38 = icmp ne i32 %zext_to_i3235, 0
  br i1 %to_bool38, label %if.then36, label %if.else37

while.cond27:                                     ; preds = %merge32, %if.then36, %cur11
  %load_lval28 = load i32, i32* %b, align 4
  %cmp29 = icmp sgt i32 %load_lval28, 35
  %zext_to_i3230 = zext i1 %cmp29 to i32
  %to_bool31 = icmp ne i32 %zext_to_i3230, 0
  br i1 %to_bool31, label %while.stmt26, label %cur25

merge32:                                          ; preds = %merge41
  br label %while.cond27

if.then36:                                        ; preds = %while.stmt26
  %load_lval39 = load i32, i32* %b, align 4
  %sub40 = sub i32 %load_lval39, 5
  store i32 %sub40, i32* %b, align 4
  br label %while.cond27

if.else37:                                        ; preds = %while.stmt26
  %load_lval42 = load i32, i32* %b, align 4
  %cmp43 = icmp sgt i32 %load_lval42, 50
  %zext_to_i3244 = zext i1 %cmp43 to i32
  %to_bool47 = icmp ne i32 %zext_to_i3244, 0
  br i1 %to_bool47, label %if.then45, label %if.else46

merge41:                                          ; preds = %merge50, %if.then45
  br label %merge32

if.then45:                                        ; preds = %if.else37
  %load_lval48 = load i32, i32* %b, align 4
  %sub49 = sub i32 %load_lval48, 7
  store i32 %sub49, i32* %b, align 4
  br label %merge41

if.else46:                                        ; preds = %if.else37
  %load_lval51 = load i32, i32* %b, align 4
  %cmp52 = icmp sgt i32 %load_lval51, 30
  %zext_to_i3253 = zext i1 %cmp52 to i32
  %to_bool56 = icmp ne i32 %zext_to_i3253, 0
  br i1 %to_bool56, label %if.then54, label %if.else55

merge50:                                          ; preds = %if.then54
  br label %merge41

if.then54:                                        ; preds = %if.else46
  %load_lval57 = load i32, i32* %b, align 4
  %sub58 = sub i32 %load_lval57, 1
  store i32 %sub58, i32* %b, align 4
  br label %merge50

if.else55:                                        ; preds = %if.else46
  ret i32 10

merge63:                                          ; preds = %if.then69, %cur25
  br label %while.cond

if.then69:                                        ; preds = %cur25
  %load_lval71 = load i32, i32* %a, align 4
  %sub72 = sub i32 %load_lval71, 10
  store i32 %sub72, i32* %a, align 4
  br label %merge63
}
