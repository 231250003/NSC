; ModuleID = 'my_module'
source_filename = "my_module"

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
  %load_lval = load i32, i32* %x1, align 4
  %load_lval1 = load i32, i32* %x2, align 4
  %add = add i32 %load_lval, %load_lval1
  %load_lval2 = load i32, i32* %x3, align 4
  %add3 = add i32 %add, %load_lval2
  %load_lval4 = load i32, i32* %x4, align 4
  %add5 = add i32 %add3, %load_lval4
  %load_lval6 = load i32, i32* %x5, align 4
  %add7 = add i32 %add5, %load_lval6
  %load_lval8 = load i32, i32* %x6, align 4
  %add9 = add i32 %add7, %load_lval8
  %load_lval10 = load i32, i32* %x7, align 4
  %add11 = add i32 %add9, %load_lval10
  %load_lval12 = load i32, i32* %x8, align 4
  %add13 = add i32 %add11, %load_lval12
  %load_lval14 = load i32, i32* %x9, align 4
  %add15 = add i32 %add13, %load_lval14
  %load_lval16 = load i32, i32* %x10, align 4
  %add17 = add i32 %add15, %load_lval16
  %load_lval18 = load i32, i32* %x11, align 4
  %add19 = add i32 %add17, %load_lval18
  %load_lval20 = load i32, i32* %x12, align 4
  %add21 = add i32 %add19, %load_lval20
  %load_lval22 = load i32, i32* %x13, align 4
  %add23 = add i32 %add21, %load_lval22
  %load_lval24 = load i32, i32* %x14, align 4
  %add25 = add i32 %add23, %load_lval24
  %load_lval26 = load i32, i32* %x15, align 4
  %add27 = add i32 %add25, %load_lval26
  %load_lval28 = load i32, i32* %x16, align 4
  %add29 = add i32 %add27, %load_lval28
  %load_lval30 = load i32, i32* %x17, align 4
  %add31 = add i32 %add29, %load_lval30
  %load_lval32 = load i32, i32* %x18, align 4
  %add33 = add i32 %add31, %load_lval32
  %load_lval34 = load i32, i32* %x19, align 4
  %add35 = add i32 %add33, %load_lval34
  %load_lval36 = load i32, i32* %x20, align 4
  %add37 = add i32 %add35, %load_lval36
  ret i32 %add37
}
