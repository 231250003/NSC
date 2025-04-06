; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 5
@y = global i32 6

define i32 @add(i32 %a, i32 %b) {
addEntry:
  %param0_addr = alloca i32, align 4
  store i32 %a, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %b, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %load_lval1 = load i32, i32* %param1_addr, align 4
  %add = add i32 %load_lval, %load_lval1
  ret i32 %add
}

define i32 @always_true() {
always_trueEntry:
  ret i32 1
}

define void @do_nothing() {
do_nothingEntry:
  ret void
}

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  br label %while.cond107

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %i, align 4
  %mod = srem i32 %load_lval1, 2
  %cmp2 = icmp eq i32 %mod, 0
  %zext_to_i323 = zext i1 %cmp2 to i32
  %lhs_bool = icmp ne i32 %zext_to_i323, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

while.cond:                                       ; preds = %cur74, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.then, %and.merge
  %load_lval10 = load i32, i32* @x, align 4
  %not = icmp eq i32 %load_lval10, 0
  %zext_to_i3211 = zext i1 %not to i32
  %load_lval12 = load i32, i32* %sum, align 4
  %load_lval13 = load i32, i32* %i, align 4
  %load_lval14 = load i32, i32* @x, align 4
  %add = call i32 @add(i32 %load_lval13, i32 %load_lval14)
  %add15 = add i32 %load_lval12, %add
  store i32 %add15, i32* %sum, align 4
  %load_lval17 = load i32, i32* %i, align 4
  %cmp18 = icmp sge i32 %load_lval17, 3
  %zext_to_i3219 = zext i1 %cmp18 to i32
  %lhs_bool20 = icmp ne i32 %zext_to_i3219, 0
  br i1 %lhs_bool20, label %and.rhs21, label %and.merge22

and.rhs:                                          ; preds = %while.stmt
  %load_lval4 = load i32, i32* %i, align 4
  %cmp5 = icmp ne i32 %load_lval4, 4
  %zext_to_i326 = zext i1 %cmp5 to i32
  %rhs_bool = icmp ne i32 %zext_to_i326, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %while.stmt
  %and_result = phi i1 [ false, %while.stmt ], [ %rhs_bool, %and.rhs ]
  %zext_to_i327 = zext i1 %and_result to i32
  %to_bool8 = icmp ne i32 %zext_to_i327, 0
  br i1 %to_bool8, label %if.then, label %merge

if.then:                                          ; preds = %and.merge
  %load_lval9 = load i32, i32* %i, align 4
  br label %merge

merge16:                                          ; preds = %if.else, %if.then29
  %load_lval36 = load i32, i32* %i, align 4
  %not37 = icmp eq i32 %load_lval36, 0
  %zext_to_i3238 = zext i1 %not37 to i32
  %cmp39 = icmp ne i32 %zext_to_i3238, 5
  %zext_to_i3240 = zext i1 %cmp39 to i32
  %lhs_bool41 = icmp ne i32 %zext_to_i3240, 0
  br i1 %lhs_bool41, label %or.merge, label %or.rhs

and.rhs21:                                        ; preds = %merge
  %load_lval23 = load i32, i32* %i, align 4
  %cmp24 = icmp sle i32 %load_lval23, 6
  %zext_to_i3225 = zext i1 %cmp24 to i32
  %rhs_bool26 = icmp ne i32 %zext_to_i3225, 0
  br label %and.merge22

and.merge22:                                      ; preds = %and.rhs21, %merge
  %and_result27 = phi i1 [ false, %merge ], [ %rhs_bool26, %and.rhs21 ]
  %zext_to_i3228 = zext i1 %and_result27 to i32
  %to_bool30 = icmp ne i32 %zext_to_i3228, 0
  br i1 %to_bool30, label %if.then29, label %if.else

if.then29:                                        ; preds = %and.merge22
  %load_lval31 = load i32, i32* %sum, align 4
  %load_lval32 = load i32, i32* @y, align 4
  %sub = sub i32 %load_lval31, %load_lval32
  store i32 %sub, i32* %sum, align 4
  br label %merge16

if.else:                                          ; preds = %and.merge22
  %load_lval33 = load i32, i32* %sum, align 4
  %add34 = add i32 %load_lval33, 1
  store i32 %add34, i32* %sum, align 4
  br label %merge16

merge35:                                          ; preds = %merge53, %if.then48
  %load_lval72 = load i32, i32* @x, align 4
  %sub73 = sub i32 %load_lval72, 1
  store i32 %sub73, i32* @x, align 4
  br label %while.cond76

or.rhs:                                           ; preds = %merge16
  %load_lval42 = load i32, i32* @x, align 4
  %load_lval43 = load i32, i32* @y, align 4
  %cmp44 = icmp eq i32 %load_lval42, %load_lval43
  %zext_to_i3245 = zext i1 %cmp44 to i32
  %rhs_bool46 = icmp ne i32 %zext_to_i3245, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %merge16
  %or_result = phi i1 [ true, %merge16 ], [ %rhs_bool46, %or.rhs ]
  %zext_to_i3247 = zext i1 %or_result to i32
  %to_bool50 = icmp ne i32 %zext_to_i3247, 0
  br i1 %to_bool50, label %if.then48, label %if.else49

if.then48:                                        ; preds = %or.merge
  %load_lval51 = load i32, i32* @x, align 4
  %add52 = add i32 %load_lval51, 1
  store i32 %add52, i32* @x, align 4
  br label %merge35

if.else49:                                        ; preds = %or.merge
  %load_lval54 = load i32, i32* @x, align 4
  %load_lval55 = load i32, i32* @y, align 4
  %cmp56 = icmp slt i32 %load_lval54, %load_lval55
  %zext_to_i3257 = zext i1 %cmp56 to i32
  %lhs_bool58 = icmp ne i32 %zext_to_i3257, 0
  br i1 %lhs_bool58, label %and.rhs59, label %and.merge60

merge53:                                          ; preds = %if.then67, %and.merge60
  br label %merge35

and.rhs59:                                        ; preds = %if.else49
  %load_lval61 = load i32, i32* @y, align 4
  %cmp62 = icmp sgt i32 %load_lval61, 3
  %zext_to_i3263 = zext i1 %cmp62 to i32
  %rhs_bool64 = icmp ne i32 %zext_to_i3263, 0
  br label %and.merge60

and.merge60:                                      ; preds = %and.rhs59, %if.else49
  %and_result65 = phi i1 [ false, %if.else49 ], [ %rhs_bool64, %and.rhs59 ]
  %zext_to_i3266 = zext i1 %and_result65 to i32
  %to_bool68 = icmp ne i32 %zext_to_i3266, 0
  br i1 %to_bool68, label %if.then67, label %merge53

if.then67:                                        ; preds = %and.merge60
  %load_lval69 = load i32, i32* @x, align 4
  %not70 = icmp eq i32 %load_lval69, 0
  %zext_to_i3271 = zext i1 %not70 to i32
  br label %merge53

cur74:                                            ; preds = %if.then101, %and.merge82
  %load_lval103 = load i32, i32* %i, align 4
  %add104 = add i32 %load_lval103, 1
  store i32 %add104, i32* %i, align 4
  br label %while.cond

while.stmt75:                                     ; preds = %and.merge82
  %load_lval92 = load i32, i32* @x, align 4
  %add93 = add i32 %load_lval92, 1
  store i32 %add93, i32* @x, align 4
  %load_lval94 = load i32, i32* %sum, align 4
  %load_lval95 = load i32, i32* @x, align 4
  %add96 = add i32 %load_lval94, %load_lval95
  store i32 %add96, i32* %sum, align 4
  %load_lval98 = load i32, i32* @x, align 4
  %cmp99 = icmp eq i32 %load_lval98, 12
  %zext_to_i32100 = zext i1 %cmp99 to i32
  %to_bool102 = icmp ne i32 %zext_to_i32100, 0
  br i1 %to_bool102, label %if.then101, label %merge97

while.cond76:                                     ; preds = %merge97, %merge35
  %load_lval77 = load i32, i32* @x, align 4
  %cmp78 = icmp slt i32 %load_lval77, 15
  %zext_to_i3279 = zext i1 %cmp78 to i32
  %lhs_bool80 = icmp ne i32 %zext_to_i3279, 0
  br i1 %lhs_bool80, label %and.rhs81, label %and.merge82

and.rhs81:                                        ; preds = %while.cond76
  %load_lval83 = load i32, i32* %sum, align 4
  %not84 = icmp eq i32 %load_lval83, 0
  %zext_to_i3285 = zext i1 %not84 to i32
  %cmp86 = icmp sgt i32 %zext_to_i3285, 50
  %zext_to_i3287 = zext i1 %cmp86 to i32
  %rhs_bool88 = icmp ne i32 %zext_to_i3287, 0
  br label %and.merge82

and.merge82:                                      ; preds = %and.rhs81, %while.cond76
  %and_result89 = phi i1 [ false, %while.cond76 ], [ %rhs_bool88, %and.rhs81 ]
  %zext_to_i3290 = zext i1 %and_result89 to i32
  %to_bool91 = icmp ne i32 %zext_to_i3290, 0
  br i1 %to_bool91, label %while.stmt75, label %cur74

merge97:                                          ; preds = %if.then101, %while.stmt75
  br label %while.cond76

if.then101:                                       ; preds = %while.stmt75
  br label %cur74
  br label %merge97

cur105:                                           ; preds = %while.cond107
  %load_lval136 = load i32, i32* %j, align 4
  ret i32 %load_lval136

while.stmt106:                                    ; preds = %while.cond107
  %inner = alloca i32, align 4
  store i32 0, i32* %inner, align 4
  br label %while.cond114

while.cond107:                                    ; preds = %cur112, %cur
  %load_lval108 = load i32, i32* %j, align 4
  %cmp109 = icmp slt i32 %load_lval108, 5
  %zext_to_i32110 = zext i1 %cmp109 to i32
  %to_bool111 = icmp ne i32 %zext_to_i32110, 0
  br i1 %to_bool111, label %while.stmt106, label %cur105

cur112:                                           ; preds = %while.cond114
  %load_lval134 = load i32, i32* %j, align 4
  %add135 = add i32 %load_lval134, 1
  store i32 %add135, i32* %j, align 4
  br label %while.cond107

while.stmt113:                                    ; preds = %while.cond114
  %load_lval120 = load i32, i32* %j, align 4
  %load_lval121 = load i32, i32* %inner, align 4
  %add122 = add i32 %load_lval120, %load_lval121
  %mod123 = srem i32 %add122, 2
  %cmp124 = icmp ne i32 %mod123, 0
  %zext_to_i32125 = zext i1 %cmp124 to i32
  %to_bool127 = icmp ne i32 %zext_to_i32125, 0
  br i1 %to_bool127, label %if.then126, label %merge119

while.cond114:                                    ; preds = %merge119, %while.stmt106
  %load_lval115 = load i32, i32* %inner, align 4
  %cmp116 = icmp slt i32 %load_lval115, 3
  %zext_to_i32117 = zext i1 %cmp116 to i32
  %to_bool118 = icmp ne i32 %zext_to_i32117, 0
  br i1 %to_bool118, label %while.stmt113, label %cur112

merge119:                                         ; preds = %if.then126, %while.stmt113
  %load_lval132 = load i32, i32* %inner, align 4
  %add133 = add i32 %load_lval132, 1
  store i32 %add133, i32* %inner, align 4
  br label %while.cond114

if.then126:                                       ; preds = %while.stmt113
  %load_lval128 = load i32, i32* %sum, align 4
  %load_lval129 = load i32, i32* %j, align 4
  %load_lval130 = load i32, i32* %inner, align 4
  %mul = mul i32 %load_lval129, %load_lval130
  %add131 = add i32 %load_lval128, %mul
  store i32 %add131, i32* %sum, align 4
  br label %merge119
}
