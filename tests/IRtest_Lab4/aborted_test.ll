; ModuleID = 'my_module'
source_filename = "my_module"

@y = global i32 0

define void @p() {
pEntry:
  %load_lval = load i32, i32* @y, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @y, align 4
  ret void
  ret void
}

define i32 @f(i32 %x, i32 %t) {
fEntry:
  call void @p()
  %add = add i32 %t, %x
  %load_lval2 = load i32, i32* @y, align 4
  %add3 = add i32 %add, %load_lval2
  ret i32 %add3
}

define i32 @g(i32 %x, i32 %y, i32 %z) {
gEntry:
  %f = call i32 @f(i32 %x, i32 %z)
  ret i32 %f
}

define i32 @main() {
mainEntry:
  %g = call i32 @g(i32 2, i32 4, i32 100)
  ret i32 %g
}
