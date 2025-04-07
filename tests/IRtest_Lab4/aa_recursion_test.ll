; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @g(i32 %x) {
gEntry:
  %add = add i32 %x, 1
  ret i32 %add
}

define i32 @f(i32 %x) {
fEntry:
  ret i32 10
}

define void @x() {
xEntry:
  ret void
  ret void
}

define void @t() {
tEntry:
  ret void
  ret void
}

define i32 @main() {
mainEntry:
  %f = call i32 @f(i32 10)
  ret i32 %f
}
