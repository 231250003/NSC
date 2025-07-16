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
  %load_lval = load i32, i32* @x, align 4
  store i32 %load_lval, i32* %a, align 4
  %b = alloca i32, align 4
  %load_lval1 = load i32, i32* @y, align 4
  store i32 %load_lval1, i32* %b, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval14 = load i32, i32* %a, align 4
  %load_lval15 = load i32, i32* @x, align 4
  %not = icmp eq i32 %load_lval15, 0
  %zext_to_i3216 = zext i1 %not to i32
  %add = add i32 %zext_to_i3216, 3
  %cmp17 = icmp ne i32 %load_lval14, %add
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

while.cond:                                       ; preds = %merge, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %cmp = icmp ne i32 %load_lval2, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.else, %if.then
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval8 = load i32, i32* %a, align 4
  %load_lval9 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval8, %load_lval9
  store i32 %sub, i32* %a, align 4
  br label %merge

if.else:                                          ; preds = %while.stmt
  %load_lval10 = load i32, i32* %b, align 4
  %load_lval11 = load i32, i32* %a, align 4
  %sub12 = sub i32 %load_lval10, %load_lval11
  store i32 %sub12, i32* %b, align 4
  br label %merge

merge13:                                          ; preds = %if.then19, %cur
  %x1 = alloca i32, align 4
  store i32 1, i32* %x1, align 4
  %x2 = alloca i32, align 4
  store i32 2, i32* %x2, align 4
  %x3 = alloca i32, align 4
  store i32 3, i32* %x3, align 4
  %x4 = alloca i32, align 4
  store i32 4, i32* %x4, align 4
  %x5 = alloca i32, align 4
  store i32 5, i32* %x5, align 4
  %x6 = alloca i32, align 4
  store i32 6, i32* %x6, align 4
  %x7 = alloca i32, align 4
  store i32 7, i32* %x7, align 4
  %x8 = alloca i32, align 4
  store i32 8, i32* %x8, align 4
  %x9 = alloca i32, align 4
  store i32 9, i32* %x9, align 4
  %x10 = alloca i32, align 4
  store i32 10, i32* %x10, align 4
  %x11 = alloca i32, align 4
  store i32 11, i32* %x11, align 4
  %x12 = alloca i32, align 4
  store i32 12, i32* %x12, align 4
  %x13 = alloca i32, align 4
  store i32 13, i32* %x13, align 4
  %x14 = alloca i32, align 4
  store i32 14, i32* %x14, align 4
  %x15 = alloca i32, align 4
  store i32 15, i32* %x15, align 4
  %x16 = alloca i32, align 4
  store i32 16, i32* %x16, align 4
  %x17 = alloca i32, align 4
  store i32 17, i32* %x17, align 4
  %x18 = alloca i32, align 4
  store i32 18, i32* %x18, align 4
  %x19 = alloca i32, align 4
  store i32 19, i32* %x19, align 4
  %x20 = alloca i32, align 4
  store i32 20, i32* %x20, align 4
  %load_lval23 = load i32, i32* @x, align 4
  %add24 = add i32 %load_lval23, 1
  store i32 %add24, i32* @x, align 4
  %load_lval25 = load i32, i32* @y, align 4
  %add26 = add i32 %load_lval25, 2
  store i32 %add26, i32* @y, align 4
  %load_lval27 = load i32, i32* @z, align 4
  %add28 = add i32 %load_lval27, 3
  store i32 %add28, i32* @z, align 4
  %load_lval29 = load i32, i32* %a, align 4
  %add30 = add i32 %load_lval29, 4
  store i32 %add30, i32* %a, align 4
  %load_lval31 = load i32, i32* %b, align 4
  %add32 = add i32 %load_lval31, 5
  store i32 %add32, i32* %b, align 4
  %load_lval33 = load i32, i32* @c, align 4
  %add34 = add i32 %load_lval33, 6
  store i32 %add34, i32* @c, align 4
  %load_lval35 = load i32, i32* @d, align 4
  %add36 = add i32 %load_lval35, 7
  store i32 %add36, i32* @d, align 4
  %load_lval37 = load i32, i32* @e, align 4
  %add38 = add i32 %load_lval37, 8
  store i32 %add38, i32* @e, align 4
  %load_lval39 = load i32, i32* @f, align 4
  %add40 = add i32 %load_lval39, 9
  store i32 %add40, i32* @f, align 4
  %load_lval41 = load i32, i32* @g, align 4
  %add42 = add i32 %load_lval41, 10
  store i32 %add42, i32* @g, align 4
  %load_lval43 = load i32, i32* @h, align 4
  %add44 = add i32 %load_lval43, 11
  store i32 %add44, i32* @h, align 4
  %load_lval45 = load i32, i32* @i, align 4
  %add46 = add i32 %load_lval45, 12
  store i32 %add46, i32* @i, align 4
  %load_lval47 = load i32, i32* @j, align 4
  %add48 = add i32 %load_lval47, 13
  store i32 %add48, i32* @j, align 4
  %load_lval49 = load i32, i32* @k, align 4
  %add50 = add i32 %load_lval49, 14
  store i32 %add50, i32* @k, align 4
  %load_lval51 = load i32, i32* @l, align 4
  %add52 = add i32 %load_lval51, 15
  store i32 %add52, i32* @l, align 4
  %load_lval53 = load i32, i32* @m, align 4
  %add54 = add i32 %load_lval53, 16
  store i32 %add54, i32* @m, align 4
  %load_lval55 = load i32, i32* @n, align 4
  %add56 = add i32 %load_lval55, 17
  store i32 %add56, i32* @n, align 4
  %load_lval57 = load i32, i32* @o, align 4
  %add58 = add i32 %load_lval57, 18
  store i32 %add58, i32* @o, align 4
  %load_lval59 = load i32, i32* @p, align 4
  %add60 = add i32 %load_lval59, 19
  store i32 %add60, i32* @p, align 4
  %load_lval61 = load i32, i32* @q, align 4
  %add62 = add i32 %load_lval61, 20
  store i32 %add62, i32* @q, align 4
  %mul = mul i32 1, 2
  %mul65 = mul i32 2, 2
  %mul67 = mul i32 3, 2
  %mul69 = mul i32 4, 2
  %mul71 = mul i32 5, 2
  %mul73 = mul i32 6, 2
  %mul75 = mul i32 7, 2
  %mul77 = mul i32 8, 2
  %mul79 = mul i32 9, 2
  %mul81 = mul i32 10, 2
  %mul83 = mul i32 11, 2
  %mul85 = mul i32 12, 2
  %mul87 = mul i32 13, 2
  %mul89 = mul i32 14, 2
  %mul91 = mul i32 15, 2
  %mul93 = mul i32 16, 2
  %mul95 = mul i32 17, 2
  %mul97 = mul i32 18, 2
  %mul99 = mul i32 19, 2
  %mul101 = mul i32 20, 2
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
