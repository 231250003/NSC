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
  %w = alloca [7 x i32], align 4
  %elemPtr = getelementptr [7 x i32], [7 x i32]* %w, i32 0, i32 0
  store i32 2, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [7 x i32], [7 x i32]* %w, i32 0, i32 1
  store i32 3, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [7 x i32], [7 x i32]* %w, i32 0, i32 2
  store i32 4, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [7 x i32], [7 x i32]* %w, i32 0, i32 3
  store i32 7, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [7 x i32], [7 x i32]* %w, i32 0, i32 4
  store i32 0, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [7 x i32], [7 x i32]* %w, i32 0, i32 5
  store i32 0, i32* %elemPtr5, align 4
  %elemPtr6 = getelementptr [7 x i32], [7 x i32]* %w, i32 0, i32 6
  store i32 0, i32* %elemPtr6, align 4
  %c = alloca [7 x i32], align 4
  %elemPtr7 = getelementptr [7 x i32], [7 x i32]* %c, i32 0, i32 0
  store i32 1, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [7 x i32], [7 x i32]* %c, i32 0, i32 1
  store i32 3, i32* %elemPtr8, align 4
  %elemPtr9 = getelementptr [7 x i32], [7 x i32]* %c, i32 0, i32 2
  store i32 5, i32* %elemPtr9, align 4
  %elemPtr10 = getelementptr [7 x i32], [7 x i32]* %c, i32 0, i32 3
  store i32 9, i32* %elemPtr10, align 4
  %elemPtr11 = getelementptr [7 x i32], [7 x i32]* %c, i32 0, i32 4
  store i32 0, i32* %elemPtr11, align 4
  %elemPtr12 = getelementptr [7 x i32], [7 x i32]* %c, i32 0, i32 5
  store i32 0, i32* %elemPtr12, align 4
  %elemPtr13 = getelementptr [7 x i32], [7 x i32]* %c, i32 0, i32 6
  store i32 0, i32* %elemPtr13, align 4
  %f = alloca [11 x [11 x i32]], align 4
  %elemPtr14 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr14, align 4
  %elemPtr15 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 1
  store i32 0, i32* %elemPtr15, align 4
  %elemPtr16 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 2
  store i32 0, i32* %elemPtr16, align 4
  %elemPtr17 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 3
  store i32 0, i32* %elemPtr17, align 4
  %elemPtr18 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 4
  store i32 0, i32* %elemPtr18, align 4
  %elemPtr19 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 5
  store i32 0, i32* %elemPtr19, align 4
  %elemPtr20 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 6
  store i32 0, i32* %elemPtr20, align 4
  %elemPtr21 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 7
  store i32 0, i32* %elemPtr21, align 4
  %elemPtr22 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 8
  store i32 0, i32* %elemPtr22, align 4
  %elemPtr23 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 9
  store i32 0, i32* %elemPtr23, align 4
  %elemPtr24 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 0, i32 10
  store i32 0, i32* %elemPtr24, align 4
  %elemPtr25 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr25, align 4
  %elemPtr26 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr26, align 4
  %elemPtr27 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 2
  store i32 0, i32* %elemPtr27, align 4
  %elemPtr28 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 3
  store i32 0, i32* %elemPtr28, align 4
  %elemPtr29 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 4
  store i32 0, i32* %elemPtr29, align 4
  %elemPtr30 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 5
  store i32 0, i32* %elemPtr30, align 4
  %elemPtr31 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 6
  store i32 0, i32* %elemPtr31, align 4
  %elemPtr32 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 7
  store i32 0, i32* %elemPtr32, align 4
  %elemPtr33 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 8
  store i32 0, i32* %elemPtr33, align 4
  %elemPtr34 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 9
  store i32 0, i32* %elemPtr34, align 4
  %elemPtr35 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 1, i32 10
  store i32 0, i32* %elemPtr35, align 4
  %elemPtr36 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 0
  store i32 0, i32* %elemPtr36, align 4
  %elemPtr37 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 1
  store i32 0, i32* %elemPtr37, align 4
  %elemPtr38 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 2
  store i32 0, i32* %elemPtr38, align 4
  %elemPtr39 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 3
  store i32 0, i32* %elemPtr39, align 4
  %elemPtr40 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 4
  store i32 0, i32* %elemPtr40, align 4
  %elemPtr41 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 5
  store i32 0, i32* %elemPtr41, align 4
  %elemPtr42 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 6
  store i32 0, i32* %elemPtr42, align 4
  %elemPtr43 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 7
  store i32 0, i32* %elemPtr43, align 4
  %elemPtr44 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 8
  store i32 0, i32* %elemPtr44, align 4
  %elemPtr45 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 9
  store i32 0, i32* %elemPtr45, align 4
  %elemPtr46 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 2, i32 10
  store i32 0, i32* %elemPtr46, align 4
  %elemPtr47 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 0
  store i32 0, i32* %elemPtr47, align 4
  %elemPtr48 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 1
  store i32 0, i32* %elemPtr48, align 4
  %elemPtr49 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 2
  store i32 0, i32* %elemPtr49, align 4
  %elemPtr50 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 3
  store i32 0, i32* %elemPtr50, align 4
  %elemPtr51 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 4
  store i32 0, i32* %elemPtr51, align 4
  %elemPtr52 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 5
  store i32 0, i32* %elemPtr52, align 4
  %elemPtr53 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 6
  store i32 0, i32* %elemPtr53, align 4
  %elemPtr54 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 7
  store i32 0, i32* %elemPtr54, align 4
  %elemPtr55 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 8
  store i32 0, i32* %elemPtr55, align 4
  %elemPtr56 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 9
  store i32 0, i32* %elemPtr56, align 4
  %elemPtr57 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 3, i32 10
  store i32 0, i32* %elemPtr57, align 4
  %elemPtr58 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 0
  store i32 0, i32* %elemPtr58, align 4
  %elemPtr59 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 1
  store i32 0, i32* %elemPtr59, align 4
  %elemPtr60 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 2
  store i32 0, i32* %elemPtr60, align 4
  %elemPtr61 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 3
  store i32 0, i32* %elemPtr61, align 4
  %elemPtr62 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 4
  store i32 0, i32* %elemPtr62, align 4
  %elemPtr63 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 5
  store i32 0, i32* %elemPtr63, align 4
  %elemPtr64 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 6
  store i32 0, i32* %elemPtr64, align 4
  %elemPtr65 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 7
  store i32 0, i32* %elemPtr65, align 4
  %elemPtr66 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 8
  store i32 0, i32* %elemPtr66, align 4
  %elemPtr67 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 9
  store i32 0, i32* %elemPtr67, align 4
  %elemPtr68 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 4, i32 10
  store i32 0, i32* %elemPtr68, align 4
  %elemPtr69 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 0
  store i32 0, i32* %elemPtr69, align 4
  %elemPtr70 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 1
  store i32 0, i32* %elemPtr70, align 4
  %elemPtr71 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 2
  store i32 0, i32* %elemPtr71, align 4
  %elemPtr72 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 3
  store i32 0, i32* %elemPtr72, align 4
  %elemPtr73 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 4
  store i32 0, i32* %elemPtr73, align 4
  %elemPtr74 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 5
  store i32 0, i32* %elemPtr74, align 4
  %elemPtr75 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 6
  store i32 0, i32* %elemPtr75, align 4
  %elemPtr76 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 7
  store i32 0, i32* %elemPtr76, align 4
  %elemPtr77 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 8
  store i32 0, i32* %elemPtr77, align 4
  %elemPtr78 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 9
  store i32 0, i32* %elemPtr78, align 4
  %elemPtr79 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 5, i32 10
  store i32 0, i32* %elemPtr79, align 4
  %elemPtr80 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 0
  store i32 0, i32* %elemPtr80, align 4
  %elemPtr81 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 1
  store i32 0, i32* %elemPtr81, align 4
  %elemPtr82 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 2
  store i32 0, i32* %elemPtr82, align 4
  %elemPtr83 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 3
  store i32 0, i32* %elemPtr83, align 4
  %elemPtr84 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 4
  store i32 0, i32* %elemPtr84, align 4
  %elemPtr85 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 5
  store i32 0, i32* %elemPtr85, align 4
  %elemPtr86 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 6
  store i32 0, i32* %elemPtr86, align 4
  %elemPtr87 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 7
  store i32 0, i32* %elemPtr87, align 4
  %elemPtr88 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 8
  store i32 0, i32* %elemPtr88, align 4
  %elemPtr89 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 9
  store i32 0, i32* %elemPtr89, align 4
  %elemPtr90 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 6, i32 10
  store i32 0, i32* %elemPtr90, align 4
  %elemPtr91 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 0
  store i32 0, i32* %elemPtr91, align 4
  %elemPtr92 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 1
  store i32 0, i32* %elemPtr92, align 4
  %elemPtr93 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 2
  store i32 0, i32* %elemPtr93, align 4
  %elemPtr94 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 3
  store i32 0, i32* %elemPtr94, align 4
  %elemPtr95 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 4
  store i32 0, i32* %elemPtr95, align 4
  %elemPtr96 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 5
  store i32 0, i32* %elemPtr96, align 4
  %elemPtr97 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 6
  store i32 0, i32* %elemPtr97, align 4
  %elemPtr98 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 7
  store i32 0, i32* %elemPtr98, align 4
  %elemPtr99 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 8
  store i32 0, i32* %elemPtr99, align 4
  %elemPtr100 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 9
  store i32 0, i32* %elemPtr100, align 4
  %elemPtr101 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 7, i32 10
  store i32 0, i32* %elemPtr101, align 4
  %elemPtr102 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 0
  store i32 0, i32* %elemPtr102, align 4
  %elemPtr103 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 1
  store i32 0, i32* %elemPtr103, align 4
  %elemPtr104 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 2
  store i32 0, i32* %elemPtr104, align 4
  %elemPtr105 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 3
  store i32 0, i32* %elemPtr105, align 4
  %elemPtr106 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 4
  store i32 0, i32* %elemPtr106, align 4
  %elemPtr107 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 5
  store i32 0, i32* %elemPtr107, align 4
  %elemPtr108 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 6
  store i32 0, i32* %elemPtr108, align 4
  %elemPtr109 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 7
  store i32 0, i32* %elemPtr109, align 4
  %elemPtr110 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 8
  store i32 0, i32* %elemPtr110, align 4
  %elemPtr111 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 9
  store i32 0, i32* %elemPtr111, align 4
  %elemPtr112 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 8, i32 10
  store i32 0, i32* %elemPtr112, align 4
  %elemPtr113 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 0
  store i32 0, i32* %elemPtr113, align 4
  %elemPtr114 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 1
  store i32 0, i32* %elemPtr114, align 4
  %elemPtr115 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 2
  store i32 0, i32* %elemPtr115, align 4
  %elemPtr116 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 3
  store i32 0, i32* %elemPtr116, align 4
  %elemPtr117 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 4
  store i32 0, i32* %elemPtr117, align 4
  %elemPtr118 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 5
  store i32 0, i32* %elemPtr118, align 4
  %elemPtr119 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 6
  store i32 0, i32* %elemPtr119, align 4
  %elemPtr120 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 7
  store i32 0, i32* %elemPtr120, align 4
  %elemPtr121 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 8
  store i32 0, i32* %elemPtr121, align 4
  %elemPtr122 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 9
  store i32 0, i32* %elemPtr122, align 4
  %elemPtr123 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 9, i32 10
  store i32 0, i32* %elemPtr123, align 4
  %elemPtr124 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 0
  store i32 0, i32* %elemPtr124, align 4
  %elemPtr125 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 1
  store i32 0, i32* %elemPtr125, align 4
  %elemPtr126 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 2
  store i32 0, i32* %elemPtr126, align 4
  %elemPtr127 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 3
  store i32 0, i32* %elemPtr127, align 4
  %elemPtr128 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 4
  store i32 0, i32* %elemPtr128, align 4
  %elemPtr129 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 5
  store i32 0, i32* %elemPtr129, align 4
  %elemPtr130 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 6
  store i32 0, i32* %elemPtr130, align 4
  %elemPtr131 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 7
  store i32 0, i32* %elemPtr131, align 4
  %elemPtr132 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 8
  store i32 0, i32* %elemPtr132, align 4
  %elemPtr133 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 9
  store i32 0, i32* %elemPtr133, align 4
  %elemPtr134 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 10, i32 10
  store i32 0, i32* %elemPtr134, align 4
  %n = alloca i32, align 4
  store i32 4, i32* %n, align 4
  %m = alloca i32, align 4
  store i32 10, i32* %m, align 4
  %i = alloca i32, align 4
  store i32 1, i32* %i, align 4
  %v = alloca i32, align 4
  store i32 1, i32* %v, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval195 = load i32, i32* %n, align 4
  %load_lval196 = load i32, i32* %m, align 4
  %elemPtr197 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 %load_lval195, i32 %load_lval196
  %load_lval198 = load i32, i32* %elemPtr197, align 4
  ret i32 %load_lval198

while.stmt:                                       ; preds = %while.cond
  br label %while.cond138

while.cond:                                       ; preds = %cur136, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %load_lval135 = load i32, i32* %n, align 4
  %cmp = icmp sle i32 %load_lval, %load_lval135
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur136:                                           ; preds = %while.cond138
  %load_lval193 = load i32, i32* %i, align 4
  %add194 = add i32 %load_lval193, 1
  store i32 %add194, i32* %i, align 4
  br label %while.cond

while.stmt137:                                    ; preds = %while.cond138
  %load_lval144 = load i32, i32* %v, align 4
  %load_lval145 = load i32, i32* %i, align 4
  %elemPtr146 = getelementptr [7 x i32], [7 x i32]* %w, i32 0, i32 %load_lval145
  %load_lval147 = load i32, i32* %elemPtr146, align 4
  %cmp148 = icmp sge i32 %load_lval144, %load_lval147
  %zext_to_i32149 = zext i1 %cmp148 to i32
  %to_bool150 = icmp ne i32 %zext_to_i32149, 0
  br i1 %to_bool150, label %if.then, label %if.else

while.cond138:                                    ; preds = %merge, %while.stmt
  %load_lval139 = load i32, i32* %v, align 4
  %load_lval140 = load i32, i32* %m, align 4
  %cmp141 = icmp sle i32 %load_lval139, %load_lval140
  %zext_to_i32142 = zext i1 %cmp141 to i32
  %to_bool143 = icmp ne i32 %zext_to_i32142, 0
  br i1 %to_bool143, label %while.stmt137, label %cur136

merge:                                            ; preds = %if.else
  %load_lval191 = load i32, i32* %v, align 4
  %add192 = add i32 %load_lval191, 1
  store i32 %add192, i32* %v, align 4
  br label %while.cond138

if.then:                                          ; preds = %while.stmt137
  %load_lval151 = load i32, i32* %i, align 4
  %sub = sub i32 %load_lval151, 1
  %load_lval152 = load i32, i32* %v, align 4
  %load_lval153 = load i32, i32* %i, align 4
  %elemPtr154 = getelementptr [7 x i32], [7 x i32]* %w, i32 0, i32 %load_lval153
  %load_lval155 = load i32, i32* %elemPtr154, align 4
  %sub156 = sub i32 %load_lval152, %load_lval155
  %elemPtr157 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 %sub, i32 %sub156
  %load_lval158 = load i32, i32* %elemPtr157, align 4
  %load_lval159 = load i32, i32* %i, align 4
  %elemPtr160 = getelementptr [7 x i32], [7 x i32]* %c, i32 0, i32 %load_lval159
  %load_lval161 = load i32, i32* %elemPtr160, align 4
  %add = add i32 %load_lval158, %load_lval161
  ret i32 %add

if.else:                                          ; preds = %while.stmt137
  %load_lval183 = load i32, i32* %i, align 4
  %load_lval184 = load i32, i32* %v, align 4
  %elemPtr185 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 %load_lval183, i32 %load_lval184
  %load_lval186 = load i32, i32* %i, align 4
  %sub187 = sub i32 %load_lval186, 1
  %load_lval188 = load i32, i32* %v, align 4
  %elemPtr189 = getelementptr [11 x [11 x i32]], [11 x [11 x i32]]* %f, i32 0, i32 %sub187, i32 %load_lval188
  %load_lval190 = load i32, i32* %elemPtr189, align 4
  store i32 %load_lval190, i32* %elemPtr185, align 4
  br label %merge
}
