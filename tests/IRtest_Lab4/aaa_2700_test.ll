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
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %if.then, %fEntry
  %load_lval1 = load i32, i32* %param0_addr, align 4
  %sub = sub i32 %load_lval1, 1
  %f = call i32 @f(i32 %sub)
  %add = add i32 %f, 10
  store i32 %add, i32* %param0_addr, align 4
  %load_lval2 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval2

if.then:                                          ; preds = %fEntry
  ret i32 0
  br label %merge
}

define i32 @main() {
mainEntry:
  br label %while.cond

cur:                                              ; preds = %merge47, %while.cond
  %load_lval105 = load i32, i32* @x, align 4
  ret i32 %load_lval105

while.stmt:                                       ; preds = %while.cond
  %f = call i32 @f(i32 200)
  store i32 %f, i32* @x, align 4
  br label %while.cond3

while.cond:                                       ; preds = %merge47, %mainEntry
  br i1 true, label %while.stmt, label %cur

cur1:                                             ; preds = %if.then, %while.cond3
  %load_lval5 = load i32, i32* @x, align 4
  %cmp6 = icmp sge i32 %load_lval5, 100
  %zext_to_i327 = zext i1 %cmp6 to i32
  %to_bool9 = icmp ne i32 %zext_to_i327, 0
  br i1 %to_bool9, label %if.then8, label %merge4

while.stmt2:                                      ; preds = %while.cond3
  call void @g()
  %load_lval = load i32, i32* @x, align 4
  %cmp = icmp sge i32 %load_lval, 200
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

while.cond3:                                      ; preds = %merge, %while.stmt
  br i1 true, label %while.stmt2, label %cur1

merge:                                            ; preds = %if.then, %while.stmt2
  br label %while.cond3

if.then:                                          ; preds = %while.stmt2
  br label %cur1
  br label %merge

merge4:                                           ; preds = %cur30, %cur1
  %load_lval48 = load i32, i32* @x, align 4
  %cmp49 = icmp sge i32 %load_lval48, 125
  %zext_to_i3250 = zext i1 %cmp49 to i32
  %to_bool52 = icmp ne i32 %zext_to_i3250, 0
  br i1 %to_bool52, label %if.then51, label %merge47

if.then8:                                         ; preds = %cur1
  %load_lval11 = load i32, i32* @x, align 4
  %cmp12 = icmp slt i32 %load_lval11, 10
  %zext_to_i3213 = zext i1 %cmp12 to i32
  %to_bool15 = icmp ne i32 %zext_to_i3213, 0
  br i1 %to_bool15, label %if.then14, label %if.else

merge10:                                          ; preds = %merge16, %if.then14
  %load_lval29 = load i32, i32* @x, align 4
  %add = add i32 %load_lval29, 1
  store i32 %add, i32* @x, align 4
  br label %while.cond32

if.then14:                                        ; preds = %if.then8
  ret i32 0
  br label %merge10

if.else:                                          ; preds = %if.then8
  %load_lval17 = load i32, i32* @x, align 4
  %cmp18 = icmp sgt i32 %load_lval17, 200
  %zext_to_i3219 = zext i1 %cmp18 to i32
  %to_bool22 = icmp ne i32 %zext_to_i3219, 0
  br i1 %to_bool22, label %if.then20, label %if.else21

merge16:                                          ; preds = %merge23, %if.then20
  br label %merge10

if.then20:                                        ; preds = %if.else
  ret i32 2
  br label %merge16

if.else21:                                        ; preds = %if.else
  %load_lval24 = load i32, i32* @x, align 4
  %cmp25 = icmp sgt i32 %load_lval24, 256
  %zext_to_i3226 = zext i1 %cmp25 to i32
  %to_bool28 = icmp ne i32 %zext_to_i3226, 0
  br i1 %to_bool28, label %if.then27, label %merge23

merge23:                                          ; preds = %if.then27, %if.else21
  br label %merge16

if.then27:                                        ; preds = %if.else21
  ret i32 3
  br label %merge23

cur30:                                            ; preds = %merge39, %while.cond32
  br label %merge4

while.stmt31:                                     ; preds = %while.cond32
  %load_lval37 = load i32, i32* @x, align 4
  %add38 = add i32 %load_lval37, 1
  store i32 %add38, i32* @x, align 4
  %load_lval40 = load i32, i32* @x, align 4
  %cmp41 = icmp slt i32 %load_lval40, 125
  %zext_to_i3242 = zext i1 %cmp41 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3242, 0
  br i1 %to_bool44, label %if.then43, label %merge39

while.cond32:                                     ; preds = %merge39, %merge39, %if.then43, %merge10
  %load_lval33 = load i32, i32* @x, align 4
  %cmp34 = icmp slt i32 %load_lval33, 200
  %zext_to_i3235 = zext i1 %cmp34 to i32
  %to_bool36 = icmp ne i32 %zext_to_i3235, 0
  br i1 %to_bool36, label %while.stmt31, label %cur30

merge39:                                          ; preds = %if.then43, %while.stmt31
  call void @g()
  %load_lval45 = load i32, i32* @x, align 4
  %add46 = add i32 %load_lval45, 2
  store i32 %add46, i32* @x, align 4
  br label %while.cond32
  br label %cur30
  br label %while.cond32

if.then43:                                        ; preds = %while.stmt31
  br label %while.cond32
  br label %merge39

merge47:                                          ; preds = %merge97, %merge4
  br label %cur
  br label %while.cond

if.then51:                                        ; preds = %merge4
  %load_lval54 = load i32, i32* @x, align 4
  %cmp55 = icmp slt i32 %load_lval54, 2030
  %zext_to_i3256 = zext i1 %cmp55 to i32
  %to_bool59 = icmp ne i32 %zext_to_i3256, 0
  br i1 %to_bool59, label %if.then57, label %if.else58

merge53:                                          ; preds = %merge82, %merge75
  %load_lval98 = load i32, i32* @x, align 4
  %cmp99 = icmp sgt i32 %load_lval98, 10
  %zext_to_i32100 = zext i1 %cmp99 to i32
  %to_bool102 = icmp ne i32 %zext_to_i32100, 0
  br i1 %to_bool102, label %if.then101, label %merge97

if.then57:                                        ; preds = %if.then51
  br label %while.cond62

if.else58:                                        ; preds = %if.then51
  %load_lval83 = load i32, i32* @x, align 4
  %cmp84 = icmp slt i32 %load_lval83, 5000
  %zext_to_i3285 = zext i1 %cmp84 to i32
  %to_bool88 = icmp ne i32 %zext_to_i3285, 0
  br i1 %to_bool88, label %if.then86, label %if.else87

cur60:                                            ; preds = %while.cond62
  %load_lval76 = load i32, i32* @x, align 4
  %cmp77 = icmp sgt i32 %load_lval76, 100
  %zext_to_i3278 = zext i1 %cmp77 to i32
  %to_bool80 = icmp ne i32 %zext_to_i3278, 0
  br i1 %to_bool80, label %if.then79, label %merge75

while.stmt61:                                     ; preds = %while.cond62
  %load_lval68 = load i32, i32* @x, align 4
  %to_bool71 = icmp ne i32 %load_lval68, 0
  br i1 %to_bool71, label %if.then69, label %if.else70

while.cond62:                                     ; preds = %merge67, %if.then57
  %load_lval63 = load i32, i32* @x, align 4
  %cmp64 = icmp sgt i32 %load_lval63, 100
  %zext_to_i3265 = zext i1 %cmp64 to i32
  %to_bool66 = icmp ne i32 %zext_to_i3265, 0
  br i1 %to_bool66, label %while.stmt61, label %cur60

merge67:                                          ; preds = %if.else70, %if.then69
  br label %while.cond62

if.then69:                                        ; preds = %while.stmt61
  %load_lval72 = load i32, i32* @x, align 4
  %sub = sub i32 %load_lval72, 1
  store i32 %sub, i32* @x, align 4
  br label %merge67

if.else70:                                        ; preds = %while.stmt61
  %load_lval73 = load i32, i32* @x, align 4
  %sub74 = sub i32 %load_lval73, 2
  store i32 %sub74, i32* @x, align 4
  br label %merge67

merge75:                                          ; preds = %if.then79, %cur60
  br label %merge53

if.then79:                                        ; preds = %cur60
  %load_lval81 = load i32, i32* @x, align 4
  ret i32 %load_lval81
  br label %merge75

merge82:                                          ; preds = %merge89, %if.then86
  br label %merge53

if.then86:                                        ; preds = %if.else58
  store i32 5016, i32* @x, align 4
  br label %merge82

if.else87:                                        ; preds = %if.else58
  %load_lval90 = load i32, i32* @x, align 4
  %cmp91 = icmp slt i32 %load_lval90, 231
  %zext_to_i3292 = zext i1 %cmp91 to i32
  %to_bool94 = icmp ne i32 %zext_to_i3292, 0
  br i1 %to_bool94, label %if.then93, label %merge89

merge89:                                          ; preds = %if.then93, %if.else87
  br label %merge82

if.then93:                                        ; preds = %if.else87
  %load_lval95 = load i32, i32* @x, align 4
  %add96 = add i32 %load_lval95, 1
  ret i32 %add96
  br label %merge89

merge97:                                          ; preds = %if.then101, %merge53
  br label %merge47

if.then101:                                       ; preds = %merge53
  %load_lval103 = load i32, i32* @x, align 4
  %sub104 = sub i32 %load_lval103, 10
  store i32 %sub104, i32* @x, align 4
  br label %merge97
}
