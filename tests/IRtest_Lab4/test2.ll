; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @g(i32 %x) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %add = add i32 %load_lval, 1
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  %g = call i32 @g(i32 10)
  store i32 %g, i32* %x, align 4
  br label %while.cond

cur:                                              ; preds = %if.else43, %while.cond
  ret i32 1

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %x, align 4
  %add = add i32 %load_lval1, 1
  store i32 %add, i32* %x, align 4
  %load_lval2 = load i32, i32* %x, align 4
  %cmp3 = icmp sgt i32 %load_lval2, 30
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool5 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool5, label %if.then, label %merge

while.cond:                                       ; preds = %merge47, %mainEntry
  %load_lval = load i32, i32* %x, align 4
  %cmp = icmp slt i32 %load_lval, 100
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

if.then:                                          ; preds = %while.stmt
  br label %while.cond8

merge:                                            ; preds = %while.stmt
  %load_lval39 = load i32, i32* %x, align 4
  %cmp40 = icmp sgt i32 %load_lval39, 10
  %zext_to_i3241 = zext i1 %cmp40 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3241, 0
  br i1 %to_bool44, label %if.then42, label %if.else43

cur6:                                             ; preds = %if.else31, %while.cond8
  %load_lval36 = load i32, i32* %x, align 4
  %sub37 = sub i32 %load_lval36, 1
  store i32 %sub37, i32* %x, align 4
  %load_lval38 = load i32, i32* %x, align 4
  ret i32 %load_lval38

while.stmt7:                                      ; preds = %while.cond8
  %load_lval13 = load i32, i32* %x, align 4
  %cmp14 = icmp sgt i32 %load_lval13, 20
  %zext_to_i3215 = zext i1 %cmp14 to i32
  %to_bool17 = icmp ne i32 %zext_to_i3215, 0
  br i1 %to_bool17, label %if.then16, label %if.else

while.cond8:                                      ; preds = %merge35, %merge23, %if.then
  %load_lval9 = load i32, i32* %x, align 4
  %cmp10 = icmp sgt i32 %load_lval9, 10
  %zext_to_i3211 = zext i1 %cmp10 to i32
  %to_bool12 = icmp ne i32 %zext_to_i3211, 0
  br i1 %to_bool12, label %while.stmt7, label %cur6

if.then16:                                        ; preds = %while.stmt7
  %load_lval18 = load i32, i32* %x, align 4
  %cmp19 = icmp sgt i32 %load_lval18, 21
  %zext_to_i3220 = zext i1 %cmp19 to i32
  %to_bool22 = icmp ne i32 %zext_to_i3220, 0
  br i1 %to_bool22, label %if.then21, label %merge23

if.else:                                          ; preds = %while.stmt7
  %load_lval27 = load i32, i32* %x, align 4
  %cmp28 = icmp sgt i32 %load_lval27, 25
  %zext_to_i3229 = zext i1 %cmp28 to i32
  %to_bool32 = icmp ne i32 %zext_to_i3229, 0
  br i1 %to_bool32, label %if.then30, label %if.else31

if.then21:                                        ; preds = %if.then16
  %load_lval24 = load i32, i32* %x, align 4
  %sub = sub i32 %load_lval24, 5
  store i32 %sub, i32* %x, align 4
  br label %merge23

merge23:                                          ; preds = %if.then21, %if.then16
  %load_lval25 = load i32, i32* %x, align 4
  %sub26 = sub i32 %load_lval25, 1
  store i32 %sub26, i32* %x, align 4
  br label %while.cond8

if.then30:                                        ; preds = %if.else
  %load_lval33 = load i32, i32* %x, align 4
  %add34 = add i32 %load_lval33, 1
  store i32 %add34, i32* %x, align 4
  br label %merge35

if.else31:                                        ; preds = %if.else
  br label %cur6

merge35:                                          ; preds = %if.then30
  br label %while.cond8

if.then42:                                        ; preds = %merge
  %load_lval45 = load i32, i32* %x, align 4
  %add46 = add i32 %load_lval45, 5
  store i32 %add46, i32* %x, align 4
  br label %merge47

if.else43:                                        ; preds = %merge
  br label %cur

merge47:                                          ; preds = %if.then42
  br label %while.cond
}
