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
	pushq %rax
	movq %rax, %r15
	movq %rax, %r12
	movq $D_Main, 0(%r12)
	popq %rax
	ret
C_BST:
	movq $56, %rdi
	call malloc
	pushq %rax
	movq %rax, %r15
	movq %rax, %r12
	movq $D_BST, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 8(%rsp)
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 16(%rsp)
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 24(%rsp)
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 8(%r15)
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 16(%r15)
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 24(%r15)
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	popq %rax
	ret
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
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
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_BST_add:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	pushq 16(%rbp)
	pushq 40(%r15)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	cmpq 8(%rax), %r13
	sete %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L1
	movq $0, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L2
L1:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L2:
	pushq 16(%rbp)
	pushq 40(%r15)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	cmpq %r13, 8(%rax)
	sets %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L3
	pushq 32(%r15)
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	cmpq 8(%rax), %r13
	sete %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L7
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	call C_BST
	addq $24, %rsp
	pushq %rax
	popq %rax
	movq %rax, 32(%r15)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L8
L7:
	pushq 16(%rbp)
	movq $D_BST, %rbx
	pushq 32(%r15)
	popq %r15
	call *8(%rbx)
	addq $8, %rsp
	pushq %rax
L8:
	jmp L4
L3:
	pushq 48(%r15)
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	cmpq 8(%rax), %r13
	sete %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L5
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	call C_BST
	addq $24, %rsp
	pushq %rax
	popq %rax
	movq %rax, 48(%r15)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L6
L5:
	pushq 16(%rbp)
	movq $D_BST, %rbx
	pushq 48(%r15)
	popq %r15
	call *8(%rbx)
	addq $8, %rsp
	pushq %rax
L6:
L4:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_BST_contains:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	pushq 16(%rbp)
	pushq 40(%r15)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	cmpq 8(%rax), %r13
	sete %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L9
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L10
L9:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L10:
	pushq 16(%rbp)
	pushq 40(%r15)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	cmpq %r13, 8(%rax)
	sets %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L13
	pushq 32(%r15)
	pushq $0
	call C_Null
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
L13:
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L11
	pushq 16(%rbp)
	movq $D_BST, %rbx
	pushq 32(%r15)
	popq %r15
	call *16(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L12
L11:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L12:
	pushq 48(%r15)
	pushq $0
	call C_Null
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
	je L14
	pushq 16(%rbp)
	movq $D_BST, %rbx
	pushq 48(%r15)
	popq %r15
	call *16(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L15
L14:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L15:
	pushq $0
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_BST_display:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	pushq 32(%r15)
	pushq $0
	call C_Null
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
	je L16
	movq $D_BST, %rbx
	pushq 32(%r15)
	popq %r15
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	jmp L17
L16:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L17:
	pushq $.S18
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq 40(%r15)
	call print_int
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq $.S19
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq 48(%r15)
	pushq $0
	call C_Null
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
	je L20
	movq $D_BST, %rbx
	pushq 48(%r15)
	popq %r15
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	jmp L21
L20:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L21:
	popq %rax
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
D_BST:
	.quad D_AnyRef, M_BST_add, M_BST_contains, M_BST_display
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
D_String:
	.quad D_AnyRef
D_Unit:
	.quad D_AnyVal
.Sprint_int:
	.string "%d"
.Sprint_string:
	.string "%s"
.S0:
	.string "ok\n"
.S18:
	.string " "
.S19:
	.string " "
