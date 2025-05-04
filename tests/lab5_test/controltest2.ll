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
  %load_lval50 = load i32, i32* %a, align 4
  store i32 %load_lval50, i32* %result, align 4
  %load_lval51 = load i32, i32* %result, align 4
  ret i32 %load_lval51

while.stmt:                                       ; preds = %while.cond
  br label %while.cond9

while.cond:                                       ; preds = %merge40, %mainEntry
  %load_lval4 = load i32, i32* %b, align 4
  %load_lval5 = load i32, i32* %a, align 4
  %add6 = add i32 %load_lval4, %load_lval5
  %cmp = icmp sgt i32 %add6, 20
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur7:                                             ; preds = %if.else, %if.then, %while.cond9
  br label %while.cond21

while.stmt8:                                      ; preds = %while.cond9
  %load_lval14 = load i32, i32* %a, align 4
  %cmp15 = icmp sgt i32 %load_lval14, 40
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %to_bool17 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool17, label %if.then, label %if.else

while.cond9:                                      ; preds = %merge, %while.stmt
  %load_lval10 = load i32, i32* %a, align 4
  %cmp11 = icmp sgt i32 %load_lval10, 10
  %zext_to_i3212 = zext i1 %cmp11 to i32
  %to_bool13 = icmp ne i32 %zext_to_i3212, 0
  br i1 %to_bool13, label %while.stmt8, label %cur7

merge:                                            ; No predecessors!
  br label %while.cond9

if.then:                                          ; preds = %while.stmt8
  %load_lval18 = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval18, 5
  store i32 %sub, i32* %a, align 4
  br label %cur7

if.else:                                          ; preds = %while.stmt8
  br label %cur7

cur19:                                            ; preds = %while.cond21
  %load_lval36 = load i32, i32* %b, align 4
  %sub37 = sub i32 %load_lval36, 3
  store i32 %sub37, i32* %b, align 4
  %load_lval38 = load i32, i32* %a, align 4
  %add39 = add i32 %load_lval38, 1
  store i32 %add39, i32* %a, align 4
  %load_lval41 = load i32, i32* %a, align 4
  %load_lval42 = load i32, i32* %b, align 4
  %add43 = add i32 %load_lval41, %load_lval42
  %cmp44 = icmp sgt i32 %add43, 50
  %zext_to_i3245 = zext i1 %cmp44 to i32
  %to_bool47 = icmp ne i32 %zext_to_i3245, 0
  br i1 %to_bool47, label %if.then46, label %merge40

while.stmt20:                                     ; preds = %while.cond21
  %load_lval27 = load i32, i32* %b, align 4
  %cmp28 = icmp sgt i32 %load_lval27, 70
  %zext_to_i3229 = zext i1 %cmp28 to i32
  %to_bool31 = icmp ne i32 %zext_to_i3229, 0
  br i1 %to_bool31, label %if.then30, label %merge26

while.cond21:                                     ; preds = %merge26, %if.then30, %cur7
  %load_lval22 = load i32, i32* %b, align 4
  %cmp23 = icmp sgt i32 %load_lval22, 35
  %zext_to_i3224 = zext i1 %cmp23 to i32
  %to_bool25 = icmp ne i32 %zext_to_i3224, 0
  br i1 %to_bool25, label %while.stmt20, label %cur19

merge26:                                          ; preds = %while.stmt20
  %load_lval34 = load i32, i32* %b, align 4
  %sub35 = sub i32 %load_lval34, 10
  store i32 %sub35, i32* %b, align 4
  br label %while.cond21

if.then30:                                        ; preds = %while.stmt20
  %load_lval32 = load i32, i32* %b, align 4
  %sub33 = sub i32 %load_lval32, 5
  store i32 %sub33, i32* %b, align 4
  br label %while.cond21

merge40:                                          ; preds = %if.then46, %cur19
  br label %while.cond

if.then46:                                        ; preds = %cur19
  %load_lval48 = load i32, i32* %a, align 4
  %sub49 = sub i32 %load_lval48, 10
  store i32 %sub49, i32* %a, align 4
  br label %merge40
}
