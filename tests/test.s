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
	popq %rbx
	popq %rax
	cmpq %rbx, %rax
	sets %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je L0
	pushq $.S3
	popq %rdi
	call print_string
	jmp L1
L0:
	pushq $.S2
	popq %rdi
	call print_string
L1:
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
.S2:
	.string "je ne suis pas content\n"
.S3:
	.string "je suis content\n"
