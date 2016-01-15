.text
	.globl	main
main:
	call C_Main
	call M_Main_main
	xorq %rax, %rax
	ret
C_Main:
	movq $8, %rdi
	call malloc
	movq $D_Main, 0(%rax)
	ret
C_Nothing:
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Nothing, 0(%r12)
	ret
C_Null:
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Null, 0(%r12)
	ret
C_String:
	movq $16, %rdi
	call malloc
	movq %rax, %r12
	movq $D_String, 0(%r12)
	addq $8, %r12
	popq %rbx
	movq %rbx, 0(%r12)
	ret
C_AnyRef:
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_AnyRef, 0(%r12)
	ret
C_Any:
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Any, 0(%r12)
	ret
C_Boolean:
	movq $16, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Boolean, 0(%r12)
	addq $8, %r12
	popq %rbx
	movq %rbx, 0(%r12)
	ret
C_Int:
	movq $16, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Int, 0(%r12)
	addq $8, %r12
	popq %rbx
	movq %rbx, 0(%r12)
	ret
C_Unit:
	movq $16, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Unit, 0(%r12)
	addq $8, %r12
	popq %rbx
	movq %rbx, 0(%r12)
	ret
C_AnyVal:
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_AnyVal, 0(%r12)
	ret
M_Main_main:
	pushq $.S0
	call C_String
	pushq %rax
	popq %rdi
	call print_string
	pushq $.S1
	call C_String
	pushq %rax
	popq %rdi
	call print_string
	pushq $.S2
	call C_String
	pushq %rax
	popq %rdi
	call print_string
	ret
print_int:
	movq %rdi, %rsi
	movq $.Sprint_int, %rdi
	movq $0, %rax
	call printf
	ret
print_string:
	movq %rdi, %rsi
	movq $.Sprint_string, %rdi
	movq $0, %rax
	call printf
	ret
.data
D_Main:
	.quad D_Any, M_Main_main
D_Any:
	.quad D_Any
D_AnyRef:
	.quad D_Any
D_AnyVal:
	.quad D_Any
D_Boolean:
	.quad D_AnyVal
D_Int:
	.quad D_AnyVal
D_Nothing:
	.quad D_Null
D_Null:
	.quad D_String
D_String:
	.quad D_AnyRef
D_Unit:
	.quad D_AnyVal
.Sprint_int:
	.string "%d"
.Sprint_string:
	.string "%s"
.S0:
	.string "hello,"
.S1:
	.string " "
.S2:
	.string "world!\n"
