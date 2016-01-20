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
C_ListeC:
	pushq %rbp
	movq %rsp, %rbp
	movq $40, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_ListeC, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 16(%rbp)
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
	pushq %r15
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq %r15
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_Josephus:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Josephus, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-24, %rsp
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	call C_ListeC
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	movq $D_ListeC, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	pushq $3
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_ListeC, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	movq $D_ListeC, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_ListeC, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	movq $D_ListeC, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_ListeC, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %rax
	pushq 24(%rax)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_ListeC, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	call C_Josephus
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq $7
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Josephus, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -24(%rbp)
	movq $D_ListeC, %rbx
	movq %r15, %r9
	pushq -24(%rbp)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	pushq $5
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $7
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Josephus, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $16, %rsp
	pushq %rax
	pushq $6
	call C_Int
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
	pushq $5
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $5
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Josephus, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $16, %rsp
	pushq %rax
	pushq $2
	call C_Int
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
L5:
	pushq 8(%rax)
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L4
	pushq $17
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $5
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Josephus, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $16, %rsp
	pushq %rax
	pushq $4
	call C_Int
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
L4:
	pushq 8(%rax)
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L3
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $13
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Josephus, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $16, %rsp
	pushq %rax
	pushq $11
	call C_Int
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
L3:
	pushq 8(%rax)
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L0
	pushq $.S2
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L1
L0:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L1:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_ListeC_insererApres:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	pushq 16(%rbp)
	call C_ListeC
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq -8(%rbp)
	pushq 24(%r15)
	popq %rbx
	popq %rax
	movq %rbx, 24(%rax)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq -8(%rbp)
	popq %rax
	movq %rax, 24(%r15)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq -8(%rbp)
	popq %rax
	pushq 24(%rax)
	pushq -8(%rbp)
	popq %rbx
	popq %rax
	movq %rbx, 32(%rax)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq -8(%rbp)
	pushq %r15
	popq %rbx
	popq %rax
	movq %rbx, 32(%rax)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_ListeC_supprimer:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 32(%r15)
	pushq 24(%r15)
	popq %rbx
	popq %rax
	movq %rbx, 24(%rax)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq 24(%r15)
	pushq 32(%r15)
	popq %rbx
	popq %rax
	movq %rbx, 32(%rax)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_ListeC_afficher:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	pushq %r15
	popq %rax
	movq %rax, -8(%rbp)
	pushq -8(%rbp)
	popq %rax
	pushq 16(%rax)
	call print_int
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq $.S6
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq -8(%rbp)
	popq %rax
	pushq 24(%rax)
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
L7:
	pushq -8(%rbp)
	pushq %r15
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
	movq 8(%rax), %rbx
	cmpq $0, %rbx
	je L8
	pushq -8(%rbp)
	popq %rax
	pushq 16(%rax)
	call print_int
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq $.S9
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq -8(%rbp)
	popq %rax
	pushq 24(%rax)
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L7
L8:
	pushq $.S10
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
M_Josephus_cercle:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	call C_ListeC
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq 16(%rbp)
	popq %rax
	movq %rax, -16(%rbp)
L11:
	pushq -16(%rbp)
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	cmpq %r13, 8(%rax)
	setns %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq 8(%rax), %rbx
	cmpq $0, %rbx
	je L12
	pushq -16(%rbp)
	movq $D_ListeC, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq -16(%rbp)
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	movq 8(%rax), %r14
	subq %r13, %r14
	pushq %r14
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L11
L12:
	pushq -8(%rbp)
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Josephus_josephus:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	pushq 16(%rbp)
	movq $D_Josephus, %rbx
	call *8(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
L13:
	pushq -8(%rbp)
	pushq -8(%rbp)
	popq %rax
	pushq 24(%rax)
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
	movq 8(%rax), %rbx
	cmpq $0, %rbx
	je L14
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
L15:
	pushq -16(%rbp)
	pushq 24(%rbp)
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
	movq 8(%rax), %rbx
	cmpq $0, %rbx
	je L16
	pushq -8(%rbp)
	popq %rax
	pushq 24(%rax)
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq -16(%rbp)
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	movq 8(%rax), %r14
	addq %r13, %r14
	pushq %r14
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L15
L16:
	movq $D_ListeC, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	pushq -8(%rbp)
	popq %rax
	pushq 24(%rax)
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L13
L14:
	pushq -8(%rbp)
	popq %rax
	pushq 16(%rax)
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
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
D_Boolean:
	.quad D_AnyVal
D_Int:
	.quad D_AnyVal
D_Josephus:
	.quad D_AnyRef, M_Josephus_cercle, M_Josephus_josephus
D_ListeC:
	.quad D_AnyRef, M_ListeC_insererApres, M_ListeC_supprimer, M_ListeC_afficher
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
.S2:
	.string "ok\n"
.S6:
	.string " "
.S9:
	.string " "
.S10:
	.string "\n"
