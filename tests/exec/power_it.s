.text
	.globl	main
main:
	call C_Main
	pushq %rax
	call M_Main_main
	addq $8, %rsp
	xorq %rax, %rax
	ret
C_Main:
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Main, 0(%r12)
	ret
C_Power:
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Power, 0(%r12)
	ret
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	call C_Power
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $4
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Power, %rbx
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	addq $16, %rsp
	pushq %rax
	call print_int
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq $.S0
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq $3
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $6
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Power, %rbx
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	addq $16, %rsp
	pushq %rax
	call print_int
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq $.S1
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Power_power:
	pushq %rbp
	movq %rsp, %rbp
	subq $24, %rsp
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq 16(%rbp)
	popq %rax
	movq %rax, -16(%rbp)
	pushq 24(%rbp)
	popq %rax
	movq %rax, -24(%rbp)
L2:
	pushq -24(%rbp)
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	cmpq 8(%rax), %r13
	sets %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq 8(%rax), %rbx
	cmpq $0, %rbx
	je L3
	pushq -24(%rbp)
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %r14
	popq %r13
	movq 8(%r13), %rax
	movq 8(%r14), %rbx
	cqto
	idivq %rbx
	movq %rdx, 8(%r13)
	pushq %r13
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	cmpq 8(%rax), %r13
	setne %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L4
	pushq -8(%rbp)
	pushq -16(%rbp)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	imulq 8(%rax), %r13
	movq %r13, 8(%rax)
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L5
L4:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L5:
	pushq -16(%rbp)
	pushq -16(%rbp)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	imulq 8(%rax), %r13
	movq %r13, 8(%rax)
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq -24(%rbp)
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %r14
	popq %r13
	movq 8(%r13), %rax
	movq 8(%r14), %rbx
	cqto
	idivq %rbx
	movq %rax, 8(%r13)
	pushq %r13
	popq %rax
	movq %rax, -24(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L2
L3:
	pushq -8(%rbp)
	movq %rbp, %rsp
	popq %rbp
	ret
C_Nothing:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Nothing, 0(%r12)
	movq %rbp, %rsp
	popq %rbp
	ret
C_Null:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Null, 0(%r12)
	movq %rbp, %rsp
	popq %rbp
	ret
C_String:
	pushq %rbp
	movq %rsp, %rbp
	movq $16, %rdi
	call malloc
	movq %rax, %r12
	movq $D_String, 0(%r12)
	movq 16(%rbp), %rbx
	movq %rbx, 8(%r12)
	movq %rbp, %rsp
	popq %rbp
	ret
C_AnyRef:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_AnyRef, 0(%r12)
	movq %rbp, %rsp
	popq %rbp
	ret
C_Any:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Any, 0(%r12)
	movq %rbp, %rsp
	popq %rbp
	ret
C_Boolean:
	pushq %rbp
	movq %rsp, %rbp
	movq $16, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Boolean, 0(%r12)
	movq 16(%rbp), %rbx
	movq %rbx, 8(%r12)
	movq %rbp, %rsp
	popq %rbp
	ret
C_Int:
	pushq %rbp
	movq %rsp, %rbp
	movq $16, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Int, 0(%r12)
	movq 16(%rbp), %rbx
	movq %rbx, 8(%r12)
	movq %rbp, %rsp
	popq %rbp
	ret
C_Unit:
	pushq %rbp
	movq %rsp, %rbp
	movq $16, %rdi
	call malloc
	movq %rax, %r12
	movq $D_Unit, 0(%r12)
	movq 16(%rbp), %rbx
	movq %rbx, 8(%r12)
	movq %rbp, %rsp
	popq %rbp
	ret
C_AnyVal:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	movq %rax, %r12
	movq $D_AnyVal, 0(%r12)
	movq %rbp, %rsp
	popq %rbp
	ret
print_int:
	pushq %rbp
	movq %rsp, %rbp
	movq 16(%rbp), %rdi
	movq 8(%rdi), %rsi
	movq $.Sprint_int, %rdi
	movq $0, %rax
	call printf
	movq %rbp, %rsp
	popq %rbp
	ret
print_string:
	pushq %rbp
	movq %rsp, %rbp
	movq 16(%rbp), %rdi
	movq 8(%rdi), %rsi
	movq $.Sprint_string, %rdi
	movq $0, %rax
	call printf
	movq %rbp, %rsp
	popq %rbp
	ret
.data
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
D_Main:
	.quad D_Any, M_Main_main
D_Nothing:
	.quad D_Null
D_Null:
	.quad D_String
D_Power:
	.quad D_AnyRef, M_Power_power
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
