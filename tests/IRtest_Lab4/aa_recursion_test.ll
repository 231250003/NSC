; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @g(i32 %x) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %add = add i32 %load_lval, 1
  ret i32 %add
}

define i32 @f() {
fEntry:
  %f = alloca i32, align 4
  store i32 10, i32* %f, align 4
  ret void
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
  %main = alloca i32, align 4
  %f = call i32 @f()
  store i32 %f, i32* %main, align 4
  %load_lval = load i32, i32* %main, align 4
  %add = add i32 %load_lval, 10
  %f1 = call i32 @f()
  %g = call i32 @g(i32 %f1)
  %add2 = add i32 %add, %g
  store i32 %add2, i32* %main, align 4
  %f3 = call i32 @f()
  %f4 = call i32 @f()
  %f5 = call i32 @f()
  %f6 = call i32 @f()
  %z = alloca i32, align 4
  store i32 64, i32* %z, align 4
  %load_lval7 = load i32, i32* %main, align 4
  %f8 = call i32 @f()
  %add9 = add i32 %load_lval7, %f8
  ret i32 %add9
}
