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
  %load_lval117 = load i32, i32* %a, align 4
  store i32 %load_lval117, i32* %result, align 4
  %load_lval118 = load i32, i32* %result, align 4
  ret i32 %load_lval118

while.stmt29:                                     ; preds = %while.cond30
  br label %while.cond39

while.cond30:                                     ; preds = %merge107, %cur
  %load_lval31 = load i32, i32* %b, align 4
  %load_lval32 = load i32, i32* %a, align 4
  %add33 = add i32 %load_lval31, %load_lval32
  %cmp34 = icmp sgt i32 %add33, 20
  %zext_to_i3235 = zext i1 %cmp34 to i32
  %to_bool36 = icmp ne i32 %zext_to_i3235, 0
  br i1 %to_bool36, label %while.stmt29, label %cur28

cur37:                                            ; preds = %if.else49, %if.then48, %while.cond39
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

cur53:                                            ; preds = %while.cond55
  %load_lval103 = load i32, i32* %b, align 4
  %sub104 = sub i32 %load_lval103, 3
  store i32 %sub104, i32* %b, align 4
  %load_lval105 = load i32, i32* %a, align 4
  %add106 = add i32 %load_lval105, 1
  store i32 %add106, i32* %a, align 4
  %load_lval108 = load i32, i32* %a, align 4
  %load_lval109 = load i32, i32* %b, align 4
  %add110 = add i32 %load_lval108, %load_lval109
  %cmp111 = icmp sgt i32 %add110, 50
  %zext_to_i32112 = zext i1 %cmp111 to i32
  %to_bool114 = icmp ne i32 %zext_to_i32112, 0
  br i1 %to_bool114, label %if.then113, label %merge107

while.stmt54:                                     ; preds = %while.cond55
  %b60 = alloca i32, align 4
  store i32 30, i32* %b60, align 4
  br label %while.cond63

while.cond55:                                     ; preds = %merge76, %if.then80, %cur37
  %load_lval56 = load i32, i32* %b, align 4
  %cmp57 = icmp sgt i32 %load_lval56, 35
  %zext_to_i3258 = zext i1 %cmp57 to i32
  %to_bool59 = icmp ne i32 %zext_to_i3258, 0
  br i1 %to_bool59, label %while.stmt54, label %cur53

cur61:                                            ; preds = %merge64, %while.cond63
  %load_lval74 = load i32, i32* %b, align 4
  %sub75 = sub i32 %load_lval74, 10
  ret i32 %sub75

while.stmt62:                                     ; preds = %while.cond63
  %load_lval65 = load i32, i32* %b60, align 4
  %cmp66 = icmp slt i32 %load_lval65, 20
  %zext_to_i3267 = zext i1 %cmp66 to i32
  %to_bool70 = icmp ne i32 %zext_to_i3267, 0
  br i1 %to_bool70, label %if.then68, label %if.else69

while.cond63:                                     ; preds = %while.stmt54
  br i1 true, label %while.stmt62, label %cur61

merge64:                                          ; preds = %if.else69
  br label %cur61

if.then68:                                        ; preds = %while.stmt62
  %load_lval71 = load i32, i32* %b60, align 4
  ret i32 %load_lval71

if.else69:                                        ; preds = %while.stmt62
  %load_lval72 = load i32, i32* %b60, align 4
  %sub73 = sub i32 %load_lval72, 7
  store i32 %sub73, i32* %b60, align 4
  br label %merge64

merge76:                                          ; preds = %merge85
  br label %while.cond55

if.then80:                                        ; No predecessors!
  %load_lval83 = load i32, i32* %b, align 4
  %sub84 = sub i32 %load_lval83, 5
  store i32 %sub84, i32* %b, align 4
  br label %while.cond55

if.else81:                                        ; No predecessors!
  %load_lval86 = load i32, i32* %b, align 4
  %cmp87 = icmp sgt i32 %load_lval86, 50
  %zext_to_i3288 = zext i1 %cmp87 to i32
  %to_bool91 = icmp ne i32 %zext_to_i3288, 0
  br i1 %to_bool91, label %if.then89, label %if.else90

merge85:                                          ; preds = %merge94, %if.then89
  br label %merge76

if.then89:                                        ; preds = %if.else81
  %load_lval92 = load i32, i32* %b, align 4
  %sub93 = sub i32 %load_lval92, 7
  store i32 %sub93, i32* %b, align 4
  br label %merge85

if.else90:                                        ; preds = %if.else81
  %load_lval95 = load i32, i32* %b, align 4
  %cmp96 = icmp sgt i32 %load_lval95, 30
  %zext_to_i3297 = zext i1 %cmp96 to i32
  %to_bool100 = icmp ne i32 %zext_to_i3297, 0
  br i1 %to_bool100, label %if.then98, label %if.else99

merge94:                                          ; preds = %if.then98
  br label %merge85

if.then98:                                        ; preds = %if.else90
  %load_lval101 = load i32, i32* %b, align 4
  %sub102 = sub i32 %load_lval101, 1
  store i32 %sub102, i32* %b, align 4
  br label %merge94

if.else99:                                        ; preds = %if.else90
  ret i32 10

merge107:                                         ; preds = %if.then113, %cur53
  br label %while.cond30

if.then113:                                       ; preds = %cur53
  %load_lval115 = load i32, i32* %a, align 4
  %sub116 = sub i32 %load_lval115, 10
  store i32 %sub116, i32* %a, align 4
  br label %merge107
}
