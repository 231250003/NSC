; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @max(i32 %a, i32 %b) {
maxEntry:
  %param0_addr = alloca i32, align 4
  store i32 %a, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %b, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %load_lval1 = load i32, i32* %param1_addr, align 4
  %cmp = icmp sgt i32 %load_lval, %load_lval1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %if.else

if.then:                                          ; preds = %maxEntry
  %load_lval2 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval2

if.else:                                          ; preds = %maxEntry
  %load_lval3 = load i32, i32* %param1_addr, align 4
  ret i32 %load_lval3
}

define i32 @main() {
mainEntry:
  %w = alloca [4 x i32], align 4
  %elemPtr = getelementptr [4 x i32], [4 x i32]* %w, i32 0, i32 0
  store i32 2, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [4 x i32], [4 x i32]* %w, i32 0, i32 1
  store i32 3, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [4 x i32], [4 x i32]* %w, i32 0, i32 2
  store i32 4, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [4 x i32], [4 x i32]* %w, i32 0, i32 3
  store i32 7, i32* %elemPtr3, align 4
  %c = alloca [4 x i32], align 4
  %elemPtr4 = getelementptr [4 x i32], [4 x i32]* %c, i32 0, i32 0
  store i32 1, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [4 x i32], [4 x i32]* %c, i32 0, i32 1
  store i32 3, i32* %elemPtr5, align 4
  %elemPtr6 = getelementptr [4 x i32], [4 x i32]* %c, i32 0, i32 2
  store i32 5, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [4 x i32], [4 x i32]* %c, i32 0, i32 3
  store i32 9, i32* %elemPtr7, align 4
  %f = alloca [5 x [11 x i32]], align 4
  %elemPtr8 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr8, align 4
  %elemPtr9 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 1
  store i32 0, i32* %elemPtr9, align 4
  %elemPtr10 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 2
  store i32 0, i32* %elemPtr10, align 4
  %elemPtr11 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 3
  store i32 0, i32* %elemPtr11, align 4
  %elemPtr12 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 4
  store i32 0, i32* %elemPtr12, align 4
  %elemPtr13 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 5
  store i32 0, i32* %elemPtr13, align 4
  %elemPtr14 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 6
  store i32 0, i32* %elemPtr14, align 4
  %elemPtr15 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 7
  store i32 0, i32* %elemPtr15, align 4
  %elemPtr16 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 8
  store i32 0, i32* %elemPtr16, align 4
  %elemPtr17 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 9
  store i32 0, i32* %elemPtr17, align 4
  %elemPtr18 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 0, i32 10
  store i32 0, i32* %elemPtr18, align 4
  %elemPtr19 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr19, align 4
  %elemPtr20 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr20, align 4
  %elemPtr21 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 2
  store i32 0, i32* %elemPtr21, align 4
  %elemPtr22 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 3
  store i32 0, i32* %elemPtr22, align 4
  %elemPtr23 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 4
  store i32 0, i32* %elemPtr23, align 4
  %elemPtr24 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 5
  store i32 0, i32* %elemPtr24, align 4
  %elemPtr25 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 6
  store i32 0, i32* %elemPtr25, align 4
  %elemPtr26 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 7
  store i32 0, i32* %elemPtr26, align 4
  %elemPtr27 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 8
  store i32 0, i32* %elemPtr27, align 4
  %elemPtr28 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 9
  store i32 0, i32* %elemPtr28, align 4
  %elemPtr29 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 1, i32 10
  store i32 0, i32* %elemPtr29, align 4
  %elemPtr30 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 0
  store i32 0, i32* %elemPtr30, align 4
  %elemPtr31 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 1
  store i32 0, i32* %elemPtr31, align 4
  %elemPtr32 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 2
  store i32 0, i32* %elemPtr32, align 4
  %elemPtr33 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 3
  store i32 0, i32* %elemPtr33, align 4
  %elemPtr34 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 4
  store i32 0, i32* %elemPtr34, align 4
  %elemPtr35 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 5
  store i32 0, i32* %elemPtr35, align 4
  %elemPtr36 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 6
  store i32 0, i32* %elemPtr36, align 4
  %elemPtr37 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 7
  store i32 0, i32* %elemPtr37, align 4
  %elemPtr38 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 8
  store i32 0, i32* %elemPtr38, align 4
  %elemPtr39 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 9
  store i32 0, i32* %elemPtr39, align 4
  %elemPtr40 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 2, i32 10
  store i32 0, i32* %elemPtr40, align 4
  %elemPtr41 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 0
  store i32 0, i32* %elemPtr41, align 4
  %elemPtr42 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 1
  store i32 0, i32* %elemPtr42, align 4
  %elemPtr43 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 2
  store i32 0, i32* %elemPtr43, align 4
  %elemPtr44 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 3
  store i32 0, i32* %elemPtr44, align 4
  %elemPtr45 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 4
  store i32 0, i32* %elemPtr45, align 4
  %elemPtr46 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 5
  store i32 0, i32* %elemPtr46, align 4
  %elemPtr47 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 6
  store i32 0, i32* %elemPtr47, align 4
  %elemPtr48 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 7
  store i32 0, i32* %elemPtr48, align 4
  %elemPtr49 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 8
  store i32 0, i32* %elemPtr49, align 4
  %elemPtr50 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 9
  store i32 0, i32* %elemPtr50, align 4
  %elemPtr51 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 3, i32 10
  store i32 0, i32* %elemPtr51, align 4
  %elemPtr52 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 0
  store i32 0, i32* %elemPtr52, align 4
  %elemPtr53 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 1
  store i32 0, i32* %elemPtr53, align 4
  %elemPtr54 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 2
  store i32 0, i32* %elemPtr54, align 4
  %elemPtr55 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 3
  store i32 0, i32* %elemPtr55, align 4
  %elemPtr56 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 4
  store i32 0, i32* %elemPtr56, align 4
  %elemPtr57 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 5
  store i32 0, i32* %elemPtr57, align 4
  %elemPtr58 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 6
  store i32 0, i32* %elemPtr58, align 4
  %elemPtr59 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 7
  store i32 0, i32* %elemPtr59, align 4
  %elemPtr60 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 8
  store i32 0, i32* %elemPtr60, align 4
  %elemPtr61 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 9
  store i32 0, i32* %elemPtr61, align 4
  %elemPtr62 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 4, i32 10
  store i32 0, i32* %elemPtr62, align 4
  %n = alloca i32, align 4
  store i32 4, i32* %n, align 4
  %m = alloca i32, align 4
  store i32 10, i32* %m, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval105 = load i32, i32* %n, align 4
  %load_lval106 = load i32, i32* %m, align 4
  %elemPtr107 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 %load_lval105, i32 %load_lval106
  %load_lval108 = load i32, i32* %elemPtr107, align 4
  ret i32 %load_lval108

while.stmt:                                       ; preds = %while.cond
  %v = alloca i32, align 4
  store i32 1, i32* %v, align 4
  br label %while.cond66

while.cond:                                       ; preds = %cur64, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %load_lval63 = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %load_lval, %load_lval63
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur64:                                            ; preds = %while.cond66
  %load_lval103 = load i32, i32* %i, align 4
  %add104 = add i32 %load_lval103, 1
  store i32 %add104, i32* %i, align 4
  br label %while.cond

while.stmt65:                                     ; preds = %while.cond66
  %load_lval72 = load i32, i32* %v, align 4
  %load_lval73 = load i32, i32* %i, align 4
  %elemPtr74 = getelementptr [4 x i32], [4 x i32]* %w, i32 0, i32 %load_lval73
  %load_lval75 = load i32, i32* %elemPtr74, align 4
  %cmp76 = icmp sge i32 %load_lval72, %load_lval75
  %zext_to_i3277 = zext i1 %cmp76 to i32
  %to_bool78 = icmp ne i32 %zext_to_i3277, 0
  br i1 %to_bool78, label %if.then, label %if.else

while.cond66:                                     ; preds = %merge, %while.stmt
  %load_lval67 = load i32, i32* %v, align 4
  %load_lval68 = load i32, i32* %m, align 4
  %cmp69 = icmp sle i32 %load_lval67, %load_lval68
  %zext_to_i3270 = zext i1 %cmp69 to i32
  %to_bool71 = icmp ne i32 %zext_to_i3270, 0
  br i1 %to_bool71, label %while.stmt65, label %cur64

merge:                                            ; preds = %if.else, %if.then
  %load_lval101 = load i32, i32* %v, align 4
  %add102 = add i32 %load_lval101, 1
  store i32 %add102, i32* %v, align 4
  br label %while.cond66

if.then:                                          ; preds = %while.stmt65
  %load_lval79 = load i32, i32* %i, align 4
  %add = add i32 %load_lval79, 1
  %load_lval80 = load i32, i32* %v, align 4
  %elemPtr81 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 %add, i32 %load_lval80
  %load_lval82 = load i32, i32* %i, align 4
  %load_lval83 = load i32, i32* %v, align 4
  %load_lval84 = load i32, i32* %i, align 4
  %elemPtr85 = getelementptr [4 x i32], [4 x i32]* %w, i32 0, i32 %load_lval84
  %load_lval86 = load i32, i32* %elemPtr85, align 4
  %sub = sub i32 %load_lval83, %load_lval86
  %elemPtr87 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 %load_lval82, i32 %sub
  %load_lval88 = load i32, i32* %elemPtr87, align 4
  %load_lval89 = load i32, i32* %i, align 4
  %elemPtr90 = getelementptr [4 x i32], [4 x i32]* %c, i32 0, i32 %load_lval89
  %load_lval91 = load i32, i32* %elemPtr90, align 4
  %add92 = add i32 %load_lval88, %load_lval91
  store i32 %add92, i32* %elemPtr81, align 4
  br label %merge

if.else:                                          ; preds = %while.stmt65
  %load_lval93 = load i32, i32* %i, align 4
  %add94 = add i32 %load_lval93, 1
  %load_lval95 = load i32, i32* %v, align 4
  %elemPtr96 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 %add94, i32 %load_lval95
  %load_lval97 = load i32, i32* %i, align 4
  %load_lval98 = load i32, i32* %v, align 4
  %elemPtr99 = getelementptr [5 x [11 x i32]], [5 x [11 x i32]]* %f, i32 0, i32 %load_lval97, i32 %load_lval98
  %load_lval100 = load i32, i32* %elemPtr99, align 4
  store i32 %load_lval100, i32* %elemPtr96, align 4
  br label %merge
}
