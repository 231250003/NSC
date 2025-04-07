; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 100
@y = global i32 2
@z = global i32 3

define void @g() {
gEntry:
  %load_lval = load i32, i32* @x, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @x, align 4
  ret void
}

define i32 @f(i32 %x) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %cmp = icmp eq i32 %load_lval, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %fEntry
  %load_lval1 = load i32, i32* %param0_addr, align 4
  %sub = sub i32 %load_lval1, 1
  %f = call i32 @f(i32 %sub)
  %add = add i32 %f, 10
  store i32 %add, i32* %param0_addr, align 4
  %load_lval2 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval2

if.then:                                          ; preds = %fEntry
  ret i32 0
}

define i32 @main() {
mainEntry:
  br label %while.cond

cur:                                              ; preds = %cur1, %while.cond
  %load_lval99 = load i32, i32* @x, align 4
  ret i32 %load_lval99

while.stmt:                                       ; preds = %while.cond
  %f = call i32 @f(i32 200)
  store i32 %f, i32* @x, align 4
  br label %while.cond3

while.cond:                                       ; preds = %cur1, %mainEntry
  br i1 true, label %while.stmt, label %cur

cur1:                                             ; preds = %cur1, %cur1, %if.then, %while.cond3
  %load_lval6 = load i32, i32* @x, align 4
  %cmp7 = icmp sge i32 %load_lval6, 100
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool10 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool10, label %if.then9, label %cur1
  store i32 5000, i32* @x, align 4
  %load_lval44 = load i32, i32* @x, align 4
  %cmp45 = icmp sge i32 %load_lval44, 125
  %zext_to_i3246 = zext i1 %cmp45 to i32
  %to_bool48 = icmp ne i32 %zext_to_i3246, 0
  br i1 %to_bool48, label %if.then47, label %cur1
  %load_lval97 = load i32, i32* @x, align 4
  %sub98 = sub i32 %load_lval97, 100
  br label %cur
  br label %while.cond

while.stmt2:                                      ; preds = %while.stmt2, %while.cond3
  call void @g()
  %load_lval4 = load i32, i32* @x, align 4
  %cmp = icmp sge i32 %load_lval4, 200
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool5 = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool5, label %if.then, label %while.stmt2
  br label %while.cond3

while.cond3:                                      ; preds = %while.stmt2, %while.stmt
  %load_lval = load i32, i32* @x, align 4
  %to_bool = icmp ne i32 %load_lval, 0
  br i1 %to_bool, label %while.stmt2, label %cur1

if.then:                                          ; preds = %while.stmt2
  br label %cur1

if.then9:                                         ; preds = %cur1
  %load_lval11 = load i32, i32* @x, align 4
  %cmp12 = icmp slt i32 %load_lval11, 10
  %zext_to_i3213 = zext i1 %cmp12 to i32
  %to_bool15 = icmp ne i32 %zext_to_i3213, 0
  br i1 %to_bool15, label %if.then14, label %if.else
  %load_lval27 = load i32, i32* @x, align 4
  %add = add i32 %load_lval27, 1
  store i32 %add, i32* @x, align 4
  br label %while.cond30

if.then14:                                        ; preds = %if.then9
  ret i32 0

if.else:                                          ; preds = %if.then9
  %load_lval16 = load i32, i32* @x, align 4
  %cmp17 = icmp sgt i32 %load_lval16, 200
  %zext_to_i3218 = zext i1 %cmp17 to i32
  %to_bool21 = icmp ne i32 %zext_to_i3218, 0
  br i1 %to_bool21, label %if.then19, label %if.else20

if.then19:                                        ; preds = %if.else
  ret i32 2

if.else20:                                        ; preds = %if.else20, %if.else
  %load_lval22 = load i32, i32* @x, align 4
  %cmp23 = icmp sgt i32 %load_lval22, 256
  %zext_to_i3224 = zext i1 %cmp23 to i32
  %to_bool26 = icmp ne i32 %zext_to_i3224, 0
  br i1 %to_bool26, label %if.then25, label %if.else20

if.then25:                                        ; preds = %if.else20
  ret i32 3

cur28:                                            ; preds = %while.stmt29, %while.cond30

while.stmt29:                                     ; preds = %while.stmt29, %while.cond30
  %load_lval35 = load i32, i32* @x, align 4
  %add36 = add i32 %load_lval35, 1
  store i32 %add36, i32* @x, align 4
  %load_lval37 = load i32, i32* @x, align 4
  %cmp38 = icmp slt i32 %load_lval37, 125
  %zext_to_i3239 = zext i1 %cmp38 to i32
  %to_bool41 = icmp ne i32 %zext_to_i3239, 0
  br i1 %to_bool41, label %if.then40, label %while.stmt29
  call void @g()
  %load_lval42 = load i32, i32* @x, align 4
  %add43 = add i32 %load_lval42, 2
  store i32 %add43, i32* @x, align 4
  br label %while.cond30
  br label %cur28
  br label %while.cond30

while.cond30:                                     ; preds = %while.stmt29, %while.stmt29, %if.then40, %if.then9
  %load_lval31 = load i32, i32* @x, align 4
  %cmp32 = icmp slt i32 %load_lval31, 200
  %zext_to_i3233 = zext i1 %cmp32 to i32
  %to_bool34 = icmp ne i32 %zext_to_i3233, 0
  br i1 %to_bool34, label %while.stmt29, label %cur28

if.then40:                                        ; preds = %while.stmt29
  br label %while.cond30

if.then47:                                        ; preds = %if.then47, %cur1
  %load_lval49 = load i32, i32* @x, align 4
  %cmp50 = icmp slt i32 %load_lval49, 2030
  %zext_to_i3251 = zext i1 %cmp50 to i32
  %to_bool54 = icmp ne i32 %zext_to_i3251, 0
  br i1 %to_bool54, label %if.then52, label %if.else53
  %load_lval89 = load i32, i32* @x, align 4
  %cmp90 = icmp sgt i32 %load_lval89, 10
  %zext_to_i3291 = zext i1 %cmp90 to i32
  %to_bool93 = icmp ne i32 %zext_to_i3291, 0
  br i1 %to_bool93, label %if.then92, label %if.then47

if.then52:                                        ; preds = %if.then47
  br label %while.cond57

if.else53:                                        ; preds = %if.then47
  %load_lval75 = load i32, i32* @x, align 4
  %cmp76 = icmp slt i32 %load_lval75, 5000
  %zext_to_i3277 = zext i1 %cmp76 to i32
  %to_bool80 = icmp ne i32 %zext_to_i3277, 0
  br i1 %to_bool80, label %if.then78, label %if.else79

cur55:                                            ; preds = %cur55, %while.cond57
  %load_lval69 = load i32, i32* @x, align 4
  %cmp70 = icmp sgt i32 %load_lval69, 100
  %zext_to_i3271 = zext i1 %cmp70 to i32
  %to_bool73 = icmp ne i32 %zext_to_i3271, 0
  br i1 %to_bool73, label %if.then72, label %cur55

while.stmt56:                                     ; preds = %while.cond57
  %load_lval62 = load i32, i32* @x, align 4
  %to_bool65 = icmp ne i32 %load_lval62, 0
  br i1 %to_bool65, label %if.then63, label %if.else64

while.cond57:                                     ; preds = %merge, %if.then52
  %load_lval58 = load i32, i32* @x, align 4
  %cmp59 = icmp sgt i32 %load_lval58, 100
  %zext_to_i3260 = zext i1 %cmp59 to i32
  %to_bool61 = icmp ne i32 %zext_to_i3260, 0
  br i1 %to_bool61, label %while.stmt56, label %cur55

if.then63:                                        ; preds = %while.stmt56
  %load_lval66 = load i32, i32* @x, align 4
  %sub = sub i32 %load_lval66, 1
  store i32 %sub, i32* @x, align 4
  br label %merge

if.else64:                                        ; preds = %while.stmt56
  %load_lval67 = load i32, i32* @x, align 4
  %sub68 = sub i32 %load_lval67, 2
  store i32 %sub68, i32* @x, align 4
  br label %merge

merge:                                            ; preds = %if.else64, %if.then63
  br label %while.cond57

if.then72:                                        ; preds = %cur55
  %load_lval74 = load i32, i32* @x, align 4
  ret i32 %load_lval74

if.then78:                                        ; preds = %if.else53
  store i32 5016, i32* @x, align 4
  br label %merge81

if.else79:                                        ; preds = %if.else79, %if.else53
  %load_lval82 = load i32, i32* @x, align 4
  %cmp83 = icmp slt i32 %load_lval82, 231
  %zext_to_i3284 = zext i1 %cmp83 to i32
  %to_bool86 = icmp ne i32 %zext_to_i3284, 0
  br i1 %to_bool86, label %if.then85, label %if.else79

merge81:                                          ; preds = %if.then78

if.then85:                                        ; preds = %if.else79
  %load_lval87 = load i32, i32* @x, align 4
  %add88 = add i32 %load_lval87, 1
  ret i32 %add88

if.then92:                                        ; preds = %if.then47
  %load_lval94 = load i32, i32* @x, align 4
  %sub95 = sub i32 %load_lval94, 10
  store i32 %sub95, i32* @x, align 4
  br label %merge96

merge96:                                          ; preds = %if.then92
}
