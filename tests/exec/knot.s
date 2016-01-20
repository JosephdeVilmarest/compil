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
	movq $24, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Main, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq $.S5
	call C_String
	addq $8, %rsp
	pushq %rax
	call C_State
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq $.S6
	call C_String
	addq $8, %rsp
	pushq %rax
	call C_State
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_Omega:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Omega, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_Function:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Function, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_State:
	pushq %rbp
	movq %rsp, %rbp
	movq $24, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_State, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 16(%rbp)
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	call C_Function
	addq $0, %rsp
	pushq %rax
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
M_Main_knot:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%r15)
	movq $D_State, %rbx
	movq %r15, %r9
	pushq 8(%r15)
	popq %r15
	call *40(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq 8(%r15)
	movq $D_State, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *40(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq $D_Main, %rbx
	call *8(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $42
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
L0:
	pushq -8(%rbp)
	pushq $0
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
	je L1
	pushq -8(%rbp)
	call print_int
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
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
	pushq -8(%rbp)
	movq $D_State, %rbx
	movq %r15, %r9
	pushq 8(%r15)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq -8(%rbp)
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
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L0
L1:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Omega_omega:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	movq $D_Omega, %rbx
	call *8(%rbx)
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Function_apply:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	movq $D_Function, %rbx
	call *8(%rbx)
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_State_knot:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	popq %rax
	movq %rax, 32(%r15)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_State_apply:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
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
	je L3
	pushq 24(%r15)
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L4
L3:
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
	movq $D_Function, %rbx
	movq %r15, %r9
	pushq 32(%r15)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
L4:
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
D_Function:
	.quad D_Omega, M_Omega_omega, M_Function_apply
D_Int:
	.quad D_AnyVal
D_Main:
	.quad D_Any, M_Main_knot, M_Main_main
D_Nothing:
	.quad D_Null
D_Null:
	.quad D_String
D_Omega:
	.quad D_AnyRef, M_Omega_omega
D_State:
	.quad D_Function, M_Omega_omega, M_Function_apply, M_State_apply
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
	.string " "
.S5:
	.string "even\n"
.S6:
	.string "odd\n"
