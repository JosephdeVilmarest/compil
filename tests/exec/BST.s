.text
	.globl	main
main:
	call C_Main
	movq %rax, %r15
	call M_Main_main
	xorq %rax, %rax
	ret
C_Main:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Main, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_BST:
	pushq %rbp
	movq %rsp, %rbp
	movq $56, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_BST, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 16(%rbp)
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 24(%rbp)
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 32(%rbp)
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
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	call C_BST
	addq $24, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $17
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $5
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $8
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $0, %rsp
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
	pushq $5
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L6
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	pushq 8(%rax)
	call C_Boolean
	addq $8, %rsp
	negq 8(%rax)
	addq $1, 8(%rax)
	pushq %rax
	popq %rax
L6:
	pushq 8(%rax)
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L5
	pushq $17
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
L5:
	pushq 8(%rax)
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L4
	pushq $3
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	pushq 8(%rax)
	call C_Boolean
	addq $8, %rsp
	negq 8(%rax)
	addq $1, 8(%rax)
	pushq %rax
	popq %rax
L4:
	pushq 8(%rax)
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L1
	pushq $.S3
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L2
L1:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L2:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_BST_add:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
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
	je L7
	movq $0, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L8
L7:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L8:
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
	je L9
	pushq 32(%r15)
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	cmpq %rax, %rbx
	sete %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L13
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
	jmp L14
L13:
	pushq 16(%rbp)
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq 32(%r15)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
L14:
	jmp L10
L9:
	pushq 48(%r15)
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	cmpq %rax, %rbx
	sete %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L11
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
	jmp L12
L11:
	pushq 16(%rbp)
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq 48(%r15)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
L12:
L10:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_BST_contains:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
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
	je L15
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L16
L15:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L16:
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
	je L19
	pushq 32(%r15)
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	cmpq %rax, %rbx
	setne %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
L19:
	pushq 8(%rax)
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L17
	pushq 16(%rbp)
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq 32(%r15)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L18
L17:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L18:
	pushq 48(%r15)
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	cmpq %rax, %rbx
	setne %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L20
	pushq 16(%rbp)
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq 48(%r15)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L21
L20:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L21:
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
	addq $0, %rsp
	pushq 32(%r15)
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	cmpq %rax, %rbx
	setne %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L22
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq 32(%r15)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	jmp L23
L22:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L23:
	pushq $.S24
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
	pushq $.S25
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
	cmpq %rax, %rbx
	setne %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L26
	movq $D_BST, %rbx
	movq %r15, %r9
	pushq 48(%r15)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	jmp L27
L26:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L27:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
C_Nothing:
	pushq %rbp
	movq %rsp, %rbp
	movq $.SNothing, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
C_Null:
	pushq %rbp
	movq %rsp, %rbp
	movq $.SNull, %rax
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
.SNothing:
	.quad D_Nothing
.SNull:
	.quad D_Null
.S0:
	.string "\n"
.S3:
	.string "ok\n"
.S24:
	.string " "
.S25:
	.string " "
