; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 56
@y = global i32 98
@z = global i32 3
@a = global i32 4
@b = global i32 5
@c = global i32 6
@d = global i32 7
@e = global i32 8
@f = global i32 9
@g = global i32 10
@h = global i32 11
@i = global i32 12
@j = global i32 13
@k = global i32 14
@l = global i32 15
@m = global i32 16
@n = global i32 17
@o = global i32 18
@p = global i32 19
@q = global i32 20

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  store i32 56, i32* %a, align 4
  %b = alloca i32, align 4
  store i32 98, i32* %b, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval14 = load i32, i32* %a, align 4
  %cmp17 = icmp ne i32 %load_lval14, 3
  %zext_to_i3218 = zext i1 %cmp17 to i32
  %to_bool20 = icmp ne i32 %zext_to_i3218, 0
  br i1 %to_bool20, label %if.then19, label %merge13

while.stmt:                                       ; preds = %while.cond
  %load_lval3 = load i32, i32* %a, align 4
  %load_lval4 = load i32, i32* %b, align 4
  %cmp5 = icmp sgt i32 %load_lval3, %load_lval4
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool7 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool7, label %if.then, label %if.else

while.cond:                                       ; preds = %if.else, %if.then, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %cmp = icmp ne i32 %load_lval2, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

if.then:                                          ; preds = %while.stmt
  %load_lval8 = load i32, i32* %a, align 4
  %load_lval9 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval8, %load_lval9
  store i32 %sub, i32* %a, align 4
  br label %while.cond

if.else:                                          ; preds = %while.stmt
  %load_lval10 = load i32, i32* %b, align 4
  %load_lval11 = load i32, i32* %a, align 4
  %sub12 = sub i32 %load_lval10, %load_lval11
  store i32 %sub12, i32* %b, align 4
  br label %while.cond

merge13:                                          ; preds = %if.then19, %cur
  store i32 57, i32* @x, align 4
  store i32 100, i32* @y, align 4
  store i32 6, i32* @z, align 4
  %load_lval29 = load i32, i32* %a, align 4
  %add30 = add i32 %load_lval29, 4
  store i32 %add30, i32* %a, align 4
  %load_lval31 = load i32, i32* %b, align 4
  %add32 = add i32 %load_lval31, 5
  store i32 %add32, i32* %b, align 4
  store i32 12, i32* @c, align 4
  store i32 14, i32* @d, align 4
  store i32 16, i32* @e, align 4
  store i32 18, i32* @f, align 4
  store i32 20, i32* @g, align 4
  store i32 22, i32* @h, align 4
  store i32 24, i32* @i, align 4
  store i32 26, i32* @j, align 4
  store i32 28, i32* @k, align 4
  store i32 30, i32* @l, align 4
  store i32 32, i32* @m, align 4
  store i32 34, i32* @n, align 4
  store i32 36, i32* @o, align 4
  store i32 38, i32* @p, align 4
  store i32 40, i32* @q, align 4
  %load_lval102 = load i32, i32* %a, align 4
  %add104 = add i32 %load_lval102, 2
  %add106 = add i32 %add104, 4
  %add108 = add i32 %add106, 6
  %add110 = add i32 %add108, 8
  %add112 = add i32 %add110, 10
  %add114 = add i32 %add112, 12
  %add116 = add i32 %add114, 14
  %add118 = add i32 %add116, 16
  %add120 = add i32 %add118, 18
  %add122 = add i32 %add120, 20
  %add124 = add i32 %add122, 22
  %add126 = add i32 %add124, 24
  %add128 = add i32 %add126, 26
  %add130 = add i32 %add128, 28
  %add132 = add i32 %add130, 30
  %add134 = add i32 %add132, 32
  %add136 = add i32 %add134, 34
  %add138 = add i32 %add136, 36
  %add140 = add i32 %add138, 38
  %add142 = add i32 %add140, 40
  ret i32 %add142

if.then19:                                        ; preds = %cur
  %load_lval21 = load i32, i32* %a, align 4
  %add22 = add i32 %load_lval21, 1
  store i32 %add22, i32* %a, align 4
  br label %merge13
}
