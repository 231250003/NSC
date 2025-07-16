; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 1
@y = global i32 2
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
  %load_lval = load i32, i32* @x, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @x, align 4
  %load_lval1 = load i32, i32* @y, align 4
  %add2 = add i32 %load_lval1, 2
  store i32 %add2, i32* @y, align 4
  %load_lval3 = load i32, i32* @z, align 4
  %add4 = add i32 %load_lval3, 3
  store i32 %add4, i32* @z, align 4
  %load_lval5 = load i32, i32* @a, align 4
  %add6 = add i32 %load_lval5, 4
  store i32 %add6, i32* @a, align 4
  %load_lval7 = load i32, i32* @b, align 4
  %add8 = add i32 %load_lval7, 5
  store i32 %add8, i32* @b, align 4
  %load_lval9 = load i32, i32* @c, align 4
  %add10 = add i32 %load_lval9, 6
  store i32 %add10, i32* @c, align 4
  %load_lval11 = load i32, i32* @d, align 4
  %add12 = add i32 %load_lval11, 7
  store i32 %add12, i32* @d, align 4
  %load_lval13 = load i32, i32* @e, align 4
  %add14 = add i32 %load_lval13, 8
  store i32 %add14, i32* @e, align 4
  %load_lval15 = load i32, i32* @f, align 4
  %add16 = add i32 %load_lval15, 9
  store i32 %add16, i32* @f, align 4
  %load_lval17 = load i32, i32* @g, align 4
  %add18 = add i32 %load_lval17, 10
  store i32 %add18, i32* @g, align 4
  %load_lval19 = load i32, i32* @h, align 4
  %add20 = add i32 %load_lval19, 11
  store i32 %add20, i32* @h, align 4
  %load_lval21 = load i32, i32* @i, align 4
  %add22 = add i32 %load_lval21, 12
  store i32 %add22, i32* @i, align 4
  %load_lval23 = load i32, i32* @j, align 4
  %add24 = add i32 %load_lval23, 13
  store i32 %add24, i32* @j, align 4
  %load_lval25 = load i32, i32* @k, align 4
  %add26 = add i32 %load_lval25, 14
  store i32 %add26, i32* @k, align 4
  %load_lval27 = load i32, i32* @l, align 4
  %add28 = add i32 %load_lval27, 15
  store i32 %add28, i32* @l, align 4
  %load_lval29 = load i32, i32* @m, align 4
  %add30 = add i32 %load_lval29, 16
  store i32 %add30, i32* @m, align 4
  %load_lval31 = load i32, i32* @n, align 4
  %add32 = add i32 %load_lval31, 17
  store i32 %add32, i32* @n, align 4
  %load_lval33 = load i32, i32* @o, align 4
  %add34 = add i32 %load_lval33, 18
  store i32 %add34, i32* @o, align 4
  %load_lval35 = load i32, i32* @p, align 4
  %add36 = add i32 %load_lval35, 19
  store i32 %add36, i32* @p, align 4
  %load_lval37 = load i32, i32* @q, align 4
  %add38 = add i32 %load_lval37, 20
  store i32 %add38, i32* @q, align 4
  %load_lval117 = load i32, i32* @x, align 4
  %add118 = add i32 420, %load_lval117
  %load_lval119 = load i32, i32* @y, align 4
  %add120 = add i32 %add118, %load_lval119
  %load_lval121 = load i32, i32* @z, align 4
  %add122 = add i32 %add120, %load_lval121
  %load_lval123 = load i32, i32* @a, align 4
  %add124 = add i32 %add122, %load_lval123
  %load_lval125 = load i32, i32* @b, align 4
  %add126 = add i32 %add124, %load_lval125
  %load_lval127 = load i32, i32* @c, align 4
  %add128 = add i32 %add126, %load_lval127
  %load_lval129 = load i32, i32* @d, align 4
  %add130 = add i32 %add128, %load_lval129
  %load_lval131 = load i32, i32* @e, align 4
  %add132 = add i32 %add130, %load_lval131
  %load_lval133 = load i32, i32* @f, align 4
  %add134 = add i32 %add132, %load_lval133
  %load_lval135 = load i32, i32* @g, align 4
  %add136 = add i32 %add134, %load_lval135
  %load_lval137 = load i32, i32* @h, align 4
  %add138 = add i32 %add136, %load_lval137
  %load_lval139 = load i32, i32* @i, align 4
  %add140 = add i32 %add138, %load_lval139
  %load_lval141 = load i32, i32* @j, align 4
  %add142 = add i32 %add140, %load_lval141
  %load_lval143 = load i32, i32* @k, align 4
  %add144 = add i32 %add142, %load_lval143
  %load_lval145 = load i32, i32* @l, align 4
  %add146 = add i32 %add144, %load_lval145
  %load_lval147 = load i32, i32* @m, align 4
  %add148 = add i32 %add146, %load_lval147
  %load_lval149 = load i32, i32* @n, align 4
  %add150 = add i32 %add148, %load_lval149
  %load_lval151 = load i32, i32* @o, align 4
  %add152 = add i32 %add150, %load_lval151
  %load_lval153 = load i32, i32* @p, align 4
  %add154 = add i32 %add152, %load_lval153
  %load_lval155 = load i32, i32* @q, align 4
  %add156 = add i32 %add154, %load_lval155
  ret i32 %add156
}
