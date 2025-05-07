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

cur28:                                            ; preds = %while.cond30
  %result = alloca i32, align 4
  %load_lval133 = load i32, i32* %a, align 4
  store i32 %load_lval133, i32* %result, align 4
  %load_lval134 = load i32, i32* %result, align 4
  ret i32 %load_lval134

while.stmt29:                                     ; preds = %while.cond30
  br label %while.cond39

while.cond30:                                     ; preds = %merge123, %cur
  %load_lval31 = load i32, i32* %b, align 4
  %load_lval32 = load i32, i32* %a, align 4
  %add33 = add i32 %load_lval31, %load_lval32
  %cmp34 = icmp sgt i32 %add33, 20
  %zext_to_i3235 = zext i1 %cmp34 to i32
  %to_bool36 = icmp ne i32 %zext_to_i3235, 0
  br i1 %to_bool36, label %while.stmt29, label %cur28

cur37:                                            ; preds = %if.else49, %if.then48, %while.cond39
  %cnt = alloca i32, align 4
  store i32 0, i32* %cnt, align 4
  br label %while.cond55

while.stmt38:                                     ; preds = %while.cond39
  %load_lval45 = load i32, i32* %a, align 4
  %cmp46 = icmp sgt i32 %load_lval45, 40
  %zext_to_i3247 = zext i1 %cmp46 to i32
  %to_bool50 = icmp ne i32 %zext_to_i3247, 0
  br i1 %to_bool50, label %if.then48, label %if.else49

while.cond39:                                     ; preds = %merge44, %while.stmt29
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

cur53:                                            ; preds = %if.then64, %while.cond55
  %load_lval119 = load i32, i32* %b, align 4
  %sub120 = sub i32 %load_lval119, 3
  store i32 %sub120, i32* %b, align 4
  %load_lval121 = load i32, i32* %a, align 4
  %add122 = add i32 %load_lval121, 1
  store i32 %add122, i32* %a, align 4
  %load_lval124 = load i32, i32* %a, align 4
  %load_lval125 = load i32, i32* %b, align 4
  %add126 = add i32 %load_lval124, %load_lval125
  %cmp127 = icmp sgt i32 %add126, 50
  %zext_to_i32128 = zext i1 %cmp127 to i32
  %to_bool130 = icmp ne i32 %zext_to_i32128, 0
  br i1 %to_bool130, label %if.then129, label %merge123

while.stmt54:                                     ; preds = %while.cond55
  %load_lval61 = load i32, i32* %cnt, align 4
  %cmp62 = icmp eq i32 %load_lval61, 30
  %zext_to_i3263 = zext i1 %cmp62 to i32
  %to_bool65 = icmp ne i32 %zext_to_i3263, 0
  br i1 %to_bool65, label %if.then64, label %merge60

while.cond55:                                     ; preds = %merge97, %cur37
  %load_lval56 = load i32, i32* %b, align 4
  %cmp57 = icmp sgt i32 %load_lval56, 35
  %zext_to_i3258 = zext i1 %cmp57 to i32
  %to_bool59 = icmp ne i32 %zext_to_i3258, 0
  br i1 %to_bool59, label %while.stmt54, label %cur53

merge60:                                          ; preds = %while.stmt54
  %b66 = alloca i32, align 4
  store i32 30, i32* %b66, align 4
  br label %while.cond69

if.then64:                                        ; preds = %while.stmt54
  br label %cur53

cur67:                                            ; preds = %merge70, %while.cond69
  %load_lval81 = load i32, i32* %b, align 4
  %cmp82 = icmp sgt i32 %load_lval81, 70
  %zext_to_i3283 = zext i1 %cmp82 to i32
  %to_bool86 = icmp ne i32 %zext_to_i3283, 0
  br i1 %to_bool86, label %if.then84, label %if.else85

while.stmt68:                                     ; preds = %while.cond69
  %load_lval71 = load i32, i32* %b66, align 4
  %cmp72 = icmp slt i32 %load_lval71, 20
  %zext_to_i3273 = zext i1 %cmp72 to i32
  %to_bool76 = icmp ne i32 %zext_to_i3273, 0
  br i1 %to_bool76, label %if.then74, label %if.else75

while.cond69:                                     ; preds = %merge60
  br i1 true, label %while.stmt68, label %cur67

merge70:                                          ; preds = %if.else75
  br label %cur67

if.then74:                                        ; preds = %while.stmt68
  %load_lval77 = load i32, i32* %b66, align 4
  ret i32 %load_lval77

if.else75:                                        ; preds = %while.stmt68
  %load_lval78 = load i32, i32* %b66, align 4
  %sub79 = sub i32 %load_lval78, 7
  store i32 %sub79, i32* %b66, align 4
  br label %merge70

merge80:                                          ; preds = %merge89, %if.then84
  %load_lval98 = load i32, i32* %b, align 4
  %load_lval99 = load i32, i32* %a, align 4
  %add100 = add i32 %load_lval98, %load_lval99
  %cmp101 = icmp sgt i32 %add100, 40
  %zext_to_i32102 = zext i1 %cmp101 to i32
  %to_bool105 = icmp ne i32 %zext_to_i32102, 0
  br i1 %to_bool105, label %if.then103, label %if.else104

if.then84:                                        ; preds = %cur67
  %load_lval87 = load i32, i32* %b, align 4
  %sub88 = sub i32 %load_lval87, 5
  store i32 %sub88, i32* %b, align 4
  br label %merge80

if.else85:                                        ; preds = %cur67
  %load_lval90 = load i32, i32* %b, align 4
  %cmp91 = icmp sgt i32 %load_lval90, 50
  %zext_to_i3292 = zext i1 %cmp91 to i32
  %to_bool94 = icmp ne i32 %zext_to_i3292, 0
  br i1 %to_bool94, label %if.then93, label %merge89

merge89:                                          ; preds = %if.then93, %if.else85
  br label %merge80

if.then93:                                        ; preds = %if.else85
  %load_lval95 = load i32, i32* %b, align 4
  %sub96 = sub i32 %load_lval95, 7
  store i32 %sub96, i32* %b, align 4
  br label %merge89

merge97:                                          ; preds = %merge108, %if.then103
  %load_lval117 = load i32, i32* %cnt, align 4
  %add118 = add i32 %load_lval117, 1
  store i32 %add118, i32* %cnt, align 4
  br label %while.cond55

if.then103:                                       ; preds = %merge80
  %load_lval106 = load i32, i32* %b, align 4
  %add107 = add i32 %load_lval106, 10
  store i32 %add107, i32* %b, align 4
  br label %merge97

if.else104:                                       ; preds = %merge80
  %load_lval109 = load i32, i32* %b, align 4
  %cmp110 = icmp sgt i32 %load_lval109, 30
  %zext_to_i32111 = zext i1 %cmp110 to i32
  %to_bool114 = icmp ne i32 %zext_to_i32111, 0
  br i1 %to_bool114, label %if.then112, label %if.else113

merge108:                                         ; preds = %if.then112
  br label %merge97

if.then112:                                       ; preds = %if.else104
  %load_lval115 = load i32, i32* %b, align 4
  %sub116 = sub i32 %load_lval115, 1
  store i32 %sub116, i32* %b, align 4
  br label %merge108

if.else113:                                       ; preds = %if.else104
  ret i32 10

merge123:                                         ; preds = %if.then129, %cur53
  br label %while.cond30

if.then129:                                       ; preds = %cur53
  %load_lval131 = load i32, i32* %a, align 4
  %sub132 = sub i32 %load_lval131, 10
  store i32 %sub132, i32* %a, align 4
  br label %merge123
}
