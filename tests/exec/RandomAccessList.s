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
C_Pair:
	pushq %rbp
	movq %rsp, %rbp
	movq $40, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Pair, 0(%r12)
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
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_RandomAccessList:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_RandomAccessList, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_Cons:
	pushq %rbp
	movq %rsp, %rbp
	movq $32, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Cons, 0(%r12)
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
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_Empty:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Empty, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
M_Main_sequence:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 24(%rbp)
	pushq 16(%rbp)
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
	je L0
	call C_Empty
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L1
L0:
	pushq 16(%rbp)
	movq $D_RandomAccessList, %rbx
	movq %r15, %r9
	pushq 24(%rbp)
	pushq 16(%rbp)
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
	movq $D_Main, %rbx
	call *8(%rbx)
	addq $16, %rsp
	pushq %rax
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
L1:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	pushq $10
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Main, %rbx
	call *8(%rbx)
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
L2:
	pushq -16(%rbp)
	pushq $10
	call C_Int
	addq $8, %rsp
	pushq %rax
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
	je L3
	pushq -16(%rbp)
	movq $D_RandomAccessList, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	call print_int
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq $.S4
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
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
	jmp L2
L3:
	pushq $.S5
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
M_RandomAccessList_length:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	movq $D_RandomAccessList, %rbx
	call *8(%rbx)
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_RandomAccessList_add:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	movq $D_RandomAccessList, %rbx
	call *16(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_RandomAccessList_get:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	movq $D_RandomAccessList, %rbx
	call *24(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Cons_length:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_RandomAccessList, %rbx
	movq %r15, %r9
	pushq 32(%r15)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	movq 8(%rax), %r14
	imulq %r13, %r14
	pushq %r14
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq 16(%r15)
	popq %rax
	cmpq $0, 8(%rax)
	je L6
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	jmp L7
L6:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L7:
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
	movq %rbp, %rsp
	popq %rbp
	ret
M_Cons_get:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	pushq 16(%r15)
	popq %rax
	cmpq $0, 8(%rax)
	je L8
	pushq 16(%rbp)
	pushq $0
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
	je L12
	pushq 24(%r15)
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L13
L12:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L13:
	pushq 16(%rbp)
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
	pushq %rax
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_RandomAccessList, %rbx
	movq %r15, %r9
	pushq 32(%r15)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq 16(%rbp)
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
	pushq %rdx
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $1
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
	je L14
	pushq -16(%rbp)
	popq %rax
	pushq 24(%rax)
	jmp L15
L14:
	pushq -16(%rbp)
	popq %rax
	pushq 32(%rax)
L15:
	jmp L9
L8:
	pushq 16(%rbp)
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
	pushq %rax
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_RandomAccessList, %rbx
	movq %r15, %r9
	pushq 32(%r15)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq 16(%rbp)
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
	pushq %rdx
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $0
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
	je L10
	pushq -16(%rbp)
	popq %rax
	pushq 24(%rax)
	jmp L11
L10:
	pushq -16(%rbp)
	popq %rax
	pushq 32(%rax)
L11:
L9:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Cons_add:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%r15)
	popq %rax
	cmpq $0, 8(%rax)
	je L16
	pushq 24(%r15)
	pushq 16(%rbp)
	call C_Pair
	addq $16, %rsp
	pushq %rax
	movq $D_RandomAccessList, %rbx
	movq %r15, %r9
	pushq 32(%r15)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	pushq $0
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	call C_Cons
	addq $24, %rsp
	pushq %rax
	jmp L17
L16:
	pushq 32(%r15)
	pushq 16(%rbp)
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	call C_Cons
	addq $24, %rsp
	pushq %rax
L17:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Empty_length:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Empty_get:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
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
	pushq 16(%rbp)
	movq $D_Empty, %rbx
	call *24(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Empty_add:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq %r15
	pushq 16(%rbp)
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	call C_Cons
	addq $24, %rsp
	pushq %rax
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
D_Cons:
	.quad D_RandomAccessList, M_Cons_length, M_Cons_add, M_Cons_get
D_Empty:
	.quad D_RandomAccessList, M_Empty_length, M_Empty_add, M_Empty_get
D_Int:
	.quad D_AnyVal
D_Main:
	.quad D_Any, M_Main_sequence, M_Main_main
D_Nothing:
	.quad D_Null
D_Null:
	.quad D_String
D_Pair:
	.quad D_AnyRef
D_RandomAccessList:
	.quad D_AnyRef, M_RandomAccessList_length, M_RandomAccessList_add, M_RandomAccessList_get
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
.S4:
	.string " "
.S5:
	.string "\n"
.S18:
	.string "no such element"
