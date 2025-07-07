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
  %load_lval39 = load i32, i32* %x1, align 4
  %mul = mul i32 %load_lval39, 2
  store i32 %mul, i32* %x1, align 4
  %load_lval40 = load i32, i32* %x2, align 4
  %mul41 = mul i32 %load_lval40, 2
  store i32 %mul41, i32* %x2, align 4
  %load_lval42 = load i32, i32* %x3, align 4
  %mul43 = mul i32 %load_lval42, 2
  store i32 %mul43, i32* %x3, align 4
  %load_lval44 = load i32, i32* %x4, align 4
  %mul45 = mul i32 %load_lval44, 2
  store i32 %mul45, i32* %x4, align 4
  %load_lval46 = load i32, i32* %x5, align 4
  %mul47 = mul i32 %load_lval46, 2
  store i32 %mul47, i32* %x5, align 4
  %load_lval48 = load i32, i32* %x6, align 4
  %mul49 = mul i32 %load_lval48, 2
  store i32 %mul49, i32* %x6, align 4
  %load_lval50 = load i32, i32* %x7, align 4
  %mul51 = mul i32 %load_lval50, 2
  store i32 %mul51, i32* %x7, align 4
  %load_lval52 = load i32, i32* %x8, align 4
  %mul53 = mul i32 %load_lval52, 2
  store i32 %mul53, i32* %x8, align 4
  %load_lval54 = load i32, i32* %x9, align 4
  %mul55 = mul i32 %load_lval54, 2
  store i32 %mul55, i32* %x9, align 4
  %load_lval56 = load i32, i32* %x10, align 4
  %mul57 = mul i32 %load_lval56, 2
  store i32 %mul57, i32* %x10, align 4
  %load_lval58 = load i32, i32* %x11, align 4
  %mul59 = mul i32 %load_lval58, 2
  store i32 %mul59, i32* %x11, align 4
  %load_lval60 = load i32, i32* %x12, align 4
  %mul61 = mul i32 %load_lval60, 2
  store i32 %mul61, i32* %x12, align 4
  %load_lval62 = load i32, i32* %x13, align 4
  %mul63 = mul i32 %load_lval62, 2
  store i32 %mul63, i32* %x13, align 4
  %load_lval64 = load i32, i32* %x14, align 4
  %mul65 = mul i32 %load_lval64, 2
  store i32 %mul65, i32* %x14, align 4
  %load_lval66 = load i32, i32* %x15, align 4
  %mul67 = mul i32 %load_lval66, 2
  store i32 %mul67, i32* %x15, align 4
  %load_lval68 = load i32, i32* %x16, align 4
  %mul69 = mul i32 %load_lval68, 2
  store i32 %mul69, i32* %x16, align 4
  %load_lval70 = load i32, i32* %x17, align 4
  %mul71 = mul i32 %load_lval70, 2
  store i32 %mul71, i32* %x17, align 4
  %load_lval72 = load i32, i32* %x18, align 4
  %mul73 = mul i32 %load_lval72, 2
  store i32 %mul73, i32* %x18, align 4
  %load_lval74 = load i32, i32* %x19, align 4
  %mul75 = mul i32 %load_lval74, 2
  store i32 %mul75, i32* %x19, align 4
  %load_lval76 = load i32, i32* %x20, align 4
  %mul77 = mul i32 %load_lval76, 2
  store i32 %mul77, i32* %x20, align 4
  %load_lval78 = load i32, i32* %x1, align 4
  %load_lval79 = load i32, i32* %x2, align 4
  %add80 = add i32 %load_lval78, %load_lval79
  %load_lval81 = load i32, i32* %x3, align 4
  %add82 = add i32 %add80, %load_lval81
  %load_lval83 = load i32, i32* %x4, align 4
  %add84 = add i32 %add82, %load_lval83
  %load_lval85 = load i32, i32* %x5, align 4
  %add86 = add i32 %add84, %load_lval85
  %load_lval87 = load i32, i32* %x6, align 4
  %add88 = add i32 %add86, %load_lval87
  %load_lval89 = load i32, i32* %x7, align 4
  %add90 = add i32 %add88, %load_lval89
  %load_lval91 = load i32, i32* %x8, align 4
  %add92 = add i32 %add90, %load_lval91
  %load_lval93 = load i32, i32* %x9, align 4
  %add94 = add i32 %add92, %load_lval93
  %load_lval95 = load i32, i32* %x10, align 4
  %add96 = add i32 %add94, %load_lval95
  %load_lval97 = load i32, i32* %x11, align 4
  %add98 = add i32 %add96, %load_lval97
  %load_lval99 = load i32, i32* %x12, align 4
  %add100 = add i32 %add98, %load_lval99
  %load_lval101 = load i32, i32* %x13, align 4
  %add102 = add i32 %add100, %load_lval101
  %load_lval103 = load i32, i32* %x14, align 4
  %add104 = add i32 %add102, %load_lval103
  %load_lval105 = load i32, i32* %x15, align 4
  %add106 = add i32 %add104, %load_lval105
  %load_lval107 = load i32, i32* %x16, align 4
  %add108 = add i32 %add106, %load_lval107
  %load_lval109 = load i32, i32* %x17, align 4
  %add110 = add i32 %add108, %load_lval109
  %load_lval111 = load i32, i32* %x18, align 4
  %add112 = add i32 %add110, %load_lval111
  %load_lval113 = load i32, i32* %x19, align 4
  %add114 = add i32 %add112, %load_lval113
  %load_lval115 = load i32, i32* %x20, align 4
  %add116 = add i32 %add114, %load_lval115
  %load_lval117 = load i32, i32* @x, align 4
  %add118 = add i32 %add116, %load_lval117
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
