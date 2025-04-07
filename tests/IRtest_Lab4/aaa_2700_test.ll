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
  %load_lval1 = load i32, i32* %param0_addr, align 4
  %sub = sub i32 %load_lval1, 1
  %f = call i32 @f(i32 %sub)
  %add = add i32 %f, 10
  store i32 %add, i32* %param0_addr, align 4
  %load_lval2 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval2

if.then:                                          ; No predecessors!
}

define i32 @main() {
mainEntry:
  br label %while.cond

cur:                                              ; preds = %merge48, %while.cond
  %load_lval106 = load i32, i32* @x, align 4
  ret i32 %load_lval106

while.stmt:                                       ; preds = %while.cond
  %f = call i32 @f(i32 200)
  store i32 %f, i32* @x, align 4
  br label %while.cond3

while.cond:                                       ; preds = %merge48, %mainEntry
  br i1 true, label %while.stmt, label %cur

cur1:                                             ; preds = %if.then, %while.cond3
  %load_lval7 = load i32, i32* @x, align 4
  %cmp8 = icmp sge i32 %load_lval7, 100
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool11 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool11, label %if.then10, label %merge6

while.stmt2:                                      ; preds = %while.cond3
  call void @g()
  %load_lval4 = load i32, i32* @x, align 4
  %cmp = icmp sge i32 %load_lval4, 200
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool5 = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool5, label %if.then, label %merge

while.cond3:                                      ; preds = %merge, %while.stmt
  %load_lval = load i32, i32* @x, align 4
  %to_bool = icmp ne i32 %load_lval, 0
  br i1 %to_bool, label %while.stmt2, label %cur1

merge:                                            ; preds = %if.then, %while.stmt2
  br label %while.cond3

if.then:                                          ; preds = %while.stmt2
  br label %cur1
  br label %merge

merge6:                                           ; preds = %cur31, %cur1
  store i32 5000, i32* @x, align 4
  %load_lval49 = load i32, i32* @x, align 4
  %cmp50 = icmp sge i32 %load_lval49, 125
  %zext_to_i3251 = zext i1 %cmp50 to i32
  %to_bool53 = icmp ne i32 %zext_to_i3251, 0
  br i1 %to_bool53, label %if.then52, label %merge48

if.then10:                                        ; preds = %cur1
  %load_lval13 = load i32, i32* @x, align 4
  %cmp14 = icmp slt i32 %load_lval13, 10
  %zext_to_i3215 = zext i1 %cmp14 to i32
  %to_bool17 = icmp ne i32 %zext_to_i3215, 0
  br i1 %to_bool17, label %if.then16, label %if.else

merge12:                                          ; preds = %merge18, %if.then16
  %load_lval30 = load i32, i32* @x, align 4
  %add = add i32 %load_lval30, 1
  store i32 %add, i32* @x, align 4
  br label %while.cond33

if.then16:                                        ; preds = %if.then10
  ret i32 0
  br label %merge12

if.else:                                          ; preds = %if.then10
  %load_lval19 = load i32, i32* @x, align 4
  %cmp20 = icmp sgt i32 %load_lval19, 200
  %zext_to_i3221 = zext i1 %cmp20 to i32
  %to_bool24 = icmp ne i32 %zext_to_i3221, 0
  br i1 %to_bool24, label %if.then22, label %if.else23

merge18:                                          ; preds = %if.else23, %if.then22
  br label %merge12

if.then22:                                        ; preds = %if.else
  ret i32 2
  br label %merge18

if.else23:                                        ; preds = %if.else
  %load_lval25 = load i32, i32* @x, align 4
  %cmp26 = icmp sgt i32 %load_lval25, 256
  %zext_to_i3227 = zext i1 %cmp26 to i32
  %to_bool29 = icmp ne i32 %zext_to_i3227, 0
  br label %merge18

if.then28:                                        ; No predecessors!

cur31:                                            ; preds = %merge40, %while.cond33
  br label %merge6

while.stmt32:                                     ; preds = %while.cond33
  %load_lval38 = load i32, i32* @x, align 4
  %add39 = add i32 %load_lval38, 1
  store i32 %add39, i32* @x, align 4
  %load_lval41 = load i32, i32* @x, align 4
  %cmp42 = icmp slt i32 %load_lval41, 125
  %zext_to_i3243 = zext i1 %cmp42 to i32
  %to_bool45 = icmp ne i32 %zext_to_i3243, 0
  br i1 %to_bool45, label %if.then44, label %merge40

while.cond33:                                     ; preds = %merge40, %merge40, %if.then44, %merge12
  %load_lval34 = load i32, i32* @x, align 4
  %cmp35 = icmp slt i32 %load_lval34, 200
  %zext_to_i3236 = zext i1 %cmp35 to i32
  %to_bool37 = icmp ne i32 %zext_to_i3236, 0
  br i1 %to_bool37, label %while.stmt32, label %cur31

merge40:                                          ; preds = %if.then44, %while.stmt32
  call void @g()
  %load_lval46 = load i32, i32* @x, align 4
  %add47 = add i32 %load_lval46, 2
  store i32 %add47, i32* @x, align 4
  br label %while.cond33
  br label %cur31
  br label %while.cond33

if.then44:                                        ; preds = %while.stmt32
  br label %while.cond33
  br label %merge40

merge48:                                          ; preds = %merge96, %merge6
  %load_lval104 = load i32, i32* @x, align 4
  %sub105 = sub i32 %load_lval104, 100
  br label %cur
  br label %while.cond

if.then52:                                        ; preds = %merge6
  %load_lval55 = load i32, i32* @x, align 4
  %cmp56 = icmp slt i32 %load_lval55, 2030
  %zext_to_i3257 = zext i1 %cmp56 to i32
  %to_bool60 = icmp ne i32 %zext_to_i3257, 0
  br i1 %to_bool60, label %if.then58, label %if.else59

merge54:                                          ; preds = %merge81, %cur61
  %load_lval97 = load i32, i32* @x, align 4
  %cmp98 = icmp sgt i32 %load_lval97, 10
  %zext_to_i3299 = zext i1 %cmp98 to i32
  %to_bool101 = icmp ne i32 %zext_to_i3299, 0
  br i1 %to_bool101, label %if.then100, label %merge96

if.then58:                                        ; preds = %if.then52
  br label %while.cond63

if.else59:                                        ; preds = %if.then52
  %load_lval82 = load i32, i32* @x, align 4
  %cmp83 = icmp slt i32 %load_lval82, 5000
  %zext_to_i3284 = zext i1 %cmp83 to i32
  %to_bool87 = icmp ne i32 %zext_to_i3284, 0
  br i1 %to_bool87, label %if.then85, label %if.else86

cur61:                                            ; preds = %while.cond63
  %load_lval76 = load i32, i32* @x, align 4
  %cmp77 = icmp sgt i32 %load_lval76, 100
  %zext_to_i3278 = zext i1 %cmp77 to i32
  %to_bool80 = icmp ne i32 %zext_to_i3278, 0
  br label %merge54

while.stmt62:                                     ; preds = %while.cond63
  %load_lval69 = load i32, i32* @x, align 4
  %to_bool72 = icmp ne i32 %load_lval69, 0
  br i1 %to_bool72, label %if.then70, label %if.else71

while.cond63:                                     ; preds = %merge68, %if.then58
  %load_lval64 = load i32, i32* @x, align 4
  %cmp65 = icmp sgt i32 %load_lval64, 100
  %zext_to_i3266 = zext i1 %cmp65 to i32
  %to_bool67 = icmp ne i32 %zext_to_i3266, 0
  br i1 %to_bool67, label %while.stmt62, label %cur61

merge68:                                          ; preds = %if.else71, %if.then70
  br label %while.cond63

if.then70:                                        ; preds = %while.stmt62
  %load_lval73 = load i32, i32* @x, align 4
  %sub = sub i32 %load_lval73, 1
  store i32 %sub, i32* @x, align 4
  br label %merge68

if.else71:                                        ; preds = %while.stmt62
  %load_lval74 = load i32, i32* @x, align 4
  %sub75 = sub i32 %load_lval74, 2
  store i32 %sub75, i32* @x, align 4
  br label %merge68

if.then79:                                        ; No predecessors!

merge81:                                          ; preds = %merge88, %if.then85
  br label %merge54

if.then85:                                        ; preds = %if.else59
  store i32 5016, i32* @x, align 4
  br label %merge81

if.else86:                                        ; preds = %if.else59
  %load_lval89 = load i32, i32* @x, align 4
  %cmp90 = icmp slt i32 %load_lval89, 231
  %zext_to_i3291 = zext i1 %cmp90 to i32
  %to_bool93 = icmp ne i32 %zext_to_i3291, 0
  br i1 %to_bool93, label %if.then92, label %merge88

merge88:                                          ; preds = %if.then92, %if.else86
  br label %merge81

if.then92:                                        ; preds = %if.else86
  %load_lval94 = load i32, i32* @x, align 4
  %add95 = add i32 %load_lval94, 1
  ret i32 %add95
  br label %merge88

merge96:                                          ; preds = %if.then100, %merge54
  br label %merge48

if.then100:                                       ; preds = %merge54
  %load_lval102 = load i32, i32* @x, align 4
  %sub103 = sub i32 %load_lval102, 10
  store i32 %sub103, i32* @x, align 4
  br label %merge96
}
