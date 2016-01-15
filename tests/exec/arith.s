.text
	.globl	main
main:
	call M_Main_main
	xorq %rax, %rax
	ret
C_Main:
M_Main_main:
	pushq $1
	pushq $2
	pushq $3
	popq %rbx
	popq %rax
	imulq %rbx, %rax
	pushq %rax
	popq %rbx
	popq %rax
	addq %rbx, %rax
	pushq %rax
	popq %rdi
	call print_int
	pushq $.S0
	popq %rdi
	call print_string
	pushq $2
	popq %rax
	negq %rax
	pushq %rax
	pushq $3
	popq %rbx
	popq %rax
	imulq %rbx, %rax
	pushq %rax
	popq %rdi
	call print_int
	pushq $.S1
	popq %rdi
	call print_string
	pushq $2
	pushq $3
	popq %rbx
	popq %rax
	imulq %rbx, %rax
	pushq %rax
	pushq $4
	pushq $7
	popq %rbx
	popq %rax
	imulq %rbx, %rax
	pushq %rax
	popq %rbx
	popq %rax
	addq %rbx, %rax
	pushq %rax
	popq %rdi
	call print_int
	pushq $.S2
	popq %rdi
	call print_string
	pushq $7
	pushq $1
	popq %rbx
	popq %rax
	cqto
	idivq %rbx
	pushq %rax
	pushq $2
	popq %rbx
	popq %rax
	cqto
	idivq %rbx
	pushq %rax
	popq %rdi
	call print_int
	pushq $.S3
	popq %rdi
	call print_string
	pushq $2
	pushq $3
	popq %rax
	negq %rax
	pushq %rax
	popq %rbx
	popq %rax
	imulq %rbx, %rax
	pushq %rax
	pushq $4
	popq %rax
	negq %rax
	pushq %rax
	popq %rbx
	popq %rax
	imulq %rbx, %rax
	pushq %rax
	popq %rdi
	call print_int
	pushq $.S4
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
	.string "\n"
.S1:
	.string "\n"
.S2:
	.string "\n"
.S3:
	.string "\n"
.S4:
	.string "\n"
