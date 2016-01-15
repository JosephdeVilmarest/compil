.text
	.globl	main
main:
	call M_Main_main
	xorq %rax, %rax
	ret
C_Main:
M_Main_main:
	pushq $1
	popq %rax
	cmpq $0, %rax
	je L0
	pushq $0
	popq %rax
	cmpq $0, %rax
	je L2
	jmp L3
L2:
	pushq $1
	pushq $2
	popq %rbx
	popq %rax
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je L4
	pushq $0
	pushq $0
	popq %rbx
	popq %rax
	cqto
	idivq %rbx
	pushq %rax
	popq %rdi
	call print_int
	jmp L5
L4:
	pushq $.S6
	popq %rdi
	call print_string
L5:
L3:
	jmp L1
L0:
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
.S6:
	.string "ok\n"