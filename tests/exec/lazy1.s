.text
	.globl	main
main:
	call M_Main_main
	xorq %rax, %rax
	ret
C_Main:
M_Main_main:
	pushq $0
	popq %rax
	cmpq $0, %rax
	je L4
	pushq $1
	pushq $0
	popq %rbx
	popq %rax
	cqto
	idivq %rbx
	pushq %rax
	pushq $3
	popq %rbx
	popq %rax
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
L4:
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
	pushq $1
	popq %rax
	cmpq $0, %rax
	jne L9
	pushq $1
	pushq $0
	popq %rbx
	popq %rax
	cqto
	idivq %rbx
	pushq %rax
	pushq $2
	popq %rbx
	popq %rax
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
L9:
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je L5
	pushq $.S8
	popq %rdi
	call print_string
	jmp L6
L5:
	pushq $.S7
	popq %rdi
	call print_string
L6:
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
	.string "OK &&\n"
.S3:
	.string "oups &&\n"
.S7:
	.string "oups ||\n"
.S8:
	.string "OK ||\n"
