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
	pushq $0
	call C_Boolean
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L4
	pushq $1
	call C_Int
	pushq %rax
	pushq $0
	call C_Int
	pushq %rax
	popq %rbx
	popq %rax
	pushq %rax
	movq %rax, %rcx
	movq 8(%rax), %rax
	movq 8(%rbx), %rbx
	cqto
	idivq 0(%rbx)
	movq %rax, 8(%rcx)
	pushq $3
	call C_Int
	pushq %rax
	popq %rbx
	popq %rax
	pushq %rax
	cmpq 8(%rax), 8(%rbx)
	sete %cl
	movzbq %cl, %rcx
	movq %rcx, 8(%rax)
	popq %rax
L4:
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L0
	pushq $.S3
	call C_String
	pushq %rax
	popq %rdi
	call print_string
	jmp L1
L0:
	pushq $.S2
	call C_String
	pushq %rax
	popq %rdi
	call print_string
L1:
	pushq $1
	popq %rax
	cmpq $0, 8(%rax)
	jne L9
	pushq $1
	call C_Int
	pushq %rax
	pushq $0
	call C_Int
	pushq %rax
	popq %rbx
	popq %rax
	pushq %rax
	movq %rax, %rcx
	movq 8(%rax), %rax
	movq 8(%rbx), %rbx
	cqto
	idivq 0(%rbx)
	movq %rax, 8(%rcx)
	pushq $2
	call C_Int
	pushq %rax
	popq %rbx
	popq %rax
	pushq %rax
	cmpq 8(%rax), 8(%rbx)
	sete %cl
	movzbq %cl, %rcx
	movq %rcx, 8(%rax)
	popq %rax
L9:
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L5
	pushq $.S8
	call C_String
	pushq %rax
	popq %rdi
	call print_string
	jmp L6
L5:
	pushq $.S7
	call C_String
	pushq %rax
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
