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
  %f = call i32 @f(i32 200)
  store i32 %f, i32* @x, align 4
  br label %while.cond

cur:                                              ; preds = %if.then, %while.cond
  %load_lval2 = load i32, i32* @x, align 4
  %cmp3 = icmp sge i32 %load_lval2, 100
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool6 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool6, label %if.then5, label %merge1

while.stmt:                                       ; preds = %while.cond
  call void @g()
  %load_lval = load i32, i32* @x, align 4
  %cmp = icmp sge i32 %load_lval, 200
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

while.cond:                                       ; preds = %merge, %mainEntry
  br i1 true, label %while.stmt, label %cur

merge:                                            ; preds = %if.then, %while.stmt
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  br label %cur
  br label %merge

merge1:                                           ; preds = %cur27, %cur
  %load_lval45 = load i32, i32* @x, align 4
  %cmp46 = icmp sge i32 %load_lval45, 125
  %zext_to_i3247 = zext i1 %cmp46 to i32
  %to_bool49 = icmp ne i32 %zext_to_i3247, 0
  br i1 %to_bool49, label %if.then48, label %merge44

if.then5:                                         ; preds = %cur
  %load_lval8 = load i32, i32* @x, align 4
  %cmp9 = icmp slt i32 %load_lval8, 10
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %to_bool12 = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool12, label %if.then11, label %if.else

merge7:                                           ; preds = %merge13, %if.then11
  %load_lval26 = load i32, i32* @x, align 4
  %add = add i32 %load_lval26, 1
  store i32 %add, i32* @x, align 4
  br label %while.cond29

if.then11:                                        ; preds = %if.then5
  ret i32 0
  br label %merge7

if.else:                                          ; preds = %if.then5
  %load_lval14 = load i32, i32* @x, align 4
  %cmp15 = icmp sgt i32 %load_lval14, 200
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %to_bool19 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool19, label %if.then17, label %if.else18

merge13:                                          ; preds = %merge20, %if.then17
  br label %merge7

if.then17:                                        ; preds = %if.else
  ret i32 2
  br label %merge13

if.else18:                                        ; preds = %if.else
  %load_lval21 = load i32, i32* @x, align 4
  %cmp22 = icmp sgt i32 %load_lval21, 256
  %zext_to_i3223 = zext i1 %cmp22 to i32
  %to_bool25 = icmp ne i32 %zext_to_i3223, 0
  br i1 %to_bool25, label %if.then24, label %merge20

merge20:                                          ; preds = %if.then24, %if.else18
  br label %merge13

if.then24:                                        ; preds = %if.else18
  ret i32 3
  br label %merge20

cur27:                                            ; preds = %merge36, %while.cond29
  br label %merge1

while.stmt28:                                     ; preds = %while.cond29
  %load_lval34 = load i32, i32* @x, align 4
  %add35 = add i32 %load_lval34, 1
  store i32 %add35, i32* @x, align 4
  %load_lval37 = load i32, i32* @x, align 4
  %cmp38 = icmp slt i32 %load_lval37, 125
  %zext_to_i3239 = zext i1 %cmp38 to i32
  %to_bool41 = icmp ne i32 %zext_to_i3239, 0
  br i1 %to_bool41, label %if.then40, label %merge36

while.cond29:                                     ; preds = %merge36, %merge36, %if.then40, %merge7
  %load_lval30 = load i32, i32* @x, align 4
  %cmp31 = icmp slt i32 %load_lval30, 200
  %zext_to_i3232 = zext i1 %cmp31 to i32
  %to_bool33 = icmp ne i32 %zext_to_i3232, 0
  br i1 %to_bool33, label %while.stmt28, label %cur27

merge36:                                          ; preds = %if.then40, %while.stmt28
  call void @g()
  %load_lval42 = load i32, i32* @x, align 4
  %add43 = add i32 %load_lval42, 2
  store i32 %add43, i32* @x, align 4
  br label %while.cond29
  br label %cur27
  br label %while.cond29

if.then40:                                        ; preds = %while.stmt28
  br label %while.cond29
  br label %merge36

merge44:                                          ; preds = %merge94, %merge1
  %load_lval102 = load i32, i32* @x, align 4
  ret i32 %load_lval102

if.then48:                                        ; preds = %merge1
  %load_lval51 = load i32, i32* @x, align 4
  %cmp52 = icmp slt i32 %load_lval51, 2030
  %zext_to_i3253 = zext i1 %cmp52 to i32
  %to_bool56 = icmp ne i32 %zext_to_i3253, 0
  br i1 %to_bool56, label %if.then54, label %if.else55

merge50:                                          ; preds = %merge79, %merge72
  %load_lval95 = load i32, i32* @x, align 4
  %cmp96 = icmp sgt i32 %load_lval95, 10
  %zext_to_i3297 = zext i1 %cmp96 to i32
  %to_bool99 = icmp ne i32 %zext_to_i3297, 0
  br i1 %to_bool99, label %if.then98, label %merge94

if.then54:                                        ; preds = %if.then48
  br label %while.cond59

if.else55:                                        ; preds = %if.then48
  %load_lval80 = load i32, i32* @x, align 4
  %cmp81 = icmp slt i32 %load_lval80, 5000
  %zext_to_i3282 = zext i1 %cmp81 to i32
  %to_bool85 = icmp ne i32 %zext_to_i3282, 0
  br i1 %to_bool85, label %if.then83, label %if.else84

cur57:                                            ; preds = %while.cond59
  %load_lval73 = load i32, i32* @x, align 4
  %cmp74 = icmp sgt i32 %load_lval73, 100
  %zext_to_i3275 = zext i1 %cmp74 to i32
  %to_bool77 = icmp ne i32 %zext_to_i3275, 0
  br i1 %to_bool77, label %if.then76, label %merge72

while.stmt58:                                     ; preds = %while.cond59
  %load_lval65 = load i32, i32* @x, align 4
  %to_bool68 = icmp ne i32 %load_lval65, 0
  br i1 %to_bool68, label %if.then66, label %if.else67

while.cond59:                                     ; preds = %merge64, %if.then54
  %load_lval60 = load i32, i32* @x, align 4
  %cmp61 = icmp sgt i32 %load_lval60, 100
  %zext_to_i3262 = zext i1 %cmp61 to i32
  %to_bool63 = icmp ne i32 %zext_to_i3262, 0
  br i1 %to_bool63, label %while.stmt58, label %cur57

merge64:                                          ; preds = %if.else67, %if.then66
  br label %while.cond59

if.then66:                                        ; preds = %while.stmt58
  %load_lval69 = load i32, i32* @x, align 4
  %sub = sub i32 %load_lval69, 1
  store i32 %sub, i32* @x, align 4
  br label %merge64

if.else67:                                        ; preds = %while.stmt58
  %load_lval70 = load i32, i32* @x, align 4
  %sub71 = sub i32 %load_lval70, 2
  store i32 %sub71, i32* @x, align 4
  br label %merge64

merge72:                                          ; preds = %if.then76, %cur57
  br label %merge50

if.then76:                                        ; preds = %cur57
  %load_lval78 = load i32, i32* @x, align 4
  ret i32 %load_lval78
  br label %merge72

merge79:                                          ; preds = %merge86, %if.then83
  br label %merge50

if.then83:                                        ; preds = %if.else55
  store i32 5016, i32* @x, align 4
  br label %merge79

if.else84:                                        ; preds = %if.else55
  %load_lval87 = load i32, i32* @x, align 4
  %cmp88 = icmp slt i32 %load_lval87, 231
  %zext_to_i3289 = zext i1 %cmp88 to i32
  %to_bool91 = icmp ne i32 %zext_to_i3289, 0
  br i1 %to_bool91, label %if.then90, label %merge86

merge86:                                          ; preds = %if.then90, %if.else84
  br label %merge79

if.then90:                                        ; preds = %if.else84
  %load_lval92 = load i32, i32* @x, align 4
  %add93 = add i32 %load_lval92, 1
  ret i32 %add93
  br label %merge86

merge94:                                          ; preds = %if.then98, %merge50
  br label %merge44

if.then98:                                        ; preds = %merge50
  %load_lval100 = load i32, i32* @x, align 4
  %sub101 = sub i32 %load_lval100, 10
  store i32 %sub101, i32* @x, align 4
  br label %merge94
}
