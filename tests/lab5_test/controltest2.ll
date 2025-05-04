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
  %load_lval67 = load i32, i32* %a, align 4
  store i32 %load_lval67, i32* %result, align 4
  %load_lval68 = load i32, i32* %result, align 4
  ret i32 %load_lval68

while.stmt:                                       ; preds = %while.cond
  br label %while.cond9

while.cond:                                       ; preds = %merge57, %mainEntry
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
  %load_lval53 = load i32, i32* %b, align 4
  %sub54 = sub i32 %load_lval53, 3
  store i32 %sub54, i32* %b, align 4
  %load_lval55 = load i32, i32* %a, align 4
  %add56 = add i32 %load_lval55, 1
  store i32 %add56, i32* %a, align 4
  %load_lval58 = load i32, i32* %a, align 4
  %load_lval59 = load i32, i32* %b, align 4
  %add60 = add i32 %load_lval58, %load_lval59
  %cmp61 = icmp sgt i32 %add60, 50
  %zext_to_i3262 = zext i1 %cmp61 to i32
  %to_bool64 = icmp ne i32 %zext_to_i3262, 0
  br i1 %to_bool64, label %if.then63, label %merge57

while.stmt20:                                     ; preds = %while.cond21
  %load_lval27 = load i32, i32* %b, align 4
  %cmp28 = icmp sgt i32 %load_lval27, 70
  %zext_to_i3229 = zext i1 %cmp28 to i32
  %to_bool32 = icmp ne i32 %zext_to_i3229, 0
  br i1 %to_bool32, label %if.then30, label %if.else31

while.cond21:                                     ; preds = %merge26, %if.then30, %cur7
  %load_lval22 = load i32, i32* %b, align 4
  %cmp23 = icmp sgt i32 %load_lval22, 35
  %zext_to_i3224 = zext i1 %cmp23 to i32
  %to_bool25 = icmp ne i32 %zext_to_i3224, 0
  br i1 %to_bool25, label %while.stmt20, label %cur19

merge26:                                          ; preds = %merge35
  br label %while.cond21

if.then30:                                        ; preds = %while.stmt20
  %load_lval33 = load i32, i32* %b, align 4
  %sub34 = sub i32 %load_lval33, 5
  store i32 %sub34, i32* %b, align 4
  br label %while.cond21

if.else31:                                        ; preds = %while.stmt20
  %load_lval36 = load i32, i32* %b, align 4
  %cmp37 = icmp sgt i32 %load_lval36, 50
  %zext_to_i3238 = zext i1 %cmp37 to i32
  %to_bool41 = icmp ne i32 %zext_to_i3238, 0
  br i1 %to_bool41, label %if.then39, label %if.else40

merge35:                                          ; preds = %merge44, %if.then39
  br label %merge26

if.then39:                                        ; preds = %if.else31
  %load_lval42 = load i32, i32* %b, align 4
  %sub43 = sub i32 %load_lval42, 7
  store i32 %sub43, i32* %b, align 4
  br label %merge35

if.else40:                                        ; preds = %if.else31
  %load_lval45 = load i32, i32* %b, align 4
  %cmp46 = icmp sgt i32 %load_lval45, 30
  %zext_to_i3247 = zext i1 %cmp46 to i32
  %to_bool50 = icmp ne i32 %zext_to_i3247, 0
  br i1 %to_bool50, label %if.then48, label %if.else49

merge44:                                          ; preds = %if.then48
  br label %merge35

if.then48:                                        ; preds = %if.else40
  %load_lval51 = load i32, i32* %b, align 4
  %sub52 = sub i32 %load_lval51, 1
  store i32 %sub52, i32* %b, align 4
  br label %merge44

if.else49:                                        ; preds = %if.else40
  ret i32 10

merge57:                                          ; preds = %if.then63, %cur19
  br label %while.cond

if.then63:                                        ; preds = %cur19
  %load_lval65 = load i32, i32* %a, align 4
  %sub66 = sub i32 %load_lval65, 10
  store i32 %sub66, i32* %a, align 4
  br label %merge57
}
