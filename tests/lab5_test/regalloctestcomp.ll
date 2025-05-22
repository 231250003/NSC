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
  store i32 2, i32* @x, align 4
  store i32 4, i32* @y, align 4
  store i32 6, i32* @z, align 4
  store i32 8, i32* @a, align 4
  store i32 10, i32* @b, align 4
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
  ret i32 840
}
