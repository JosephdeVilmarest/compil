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
C_A:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_A, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_B:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_B, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
M_Main_print_bool:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	popq %rax
	cmpq $0, 8(%rax)
	je L0
	pushq $.S3
	call C_String
	addq $8, %rsp
	pushq %rax
	jmp L1
L0:
	pushq $.S2
	call C_String
	addq $8, %rsp
	pushq %rax
L1:
	call print_string
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
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-24, %rsp
	call C_A
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	call C_B
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	movq $D_A, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Main, %rbx
	call *8(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_A, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Main, %rbx
	call *8(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_B, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Main, %rbx
	call *8(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_B, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Main, %rbx
	call *8(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq -16(%rbp)
	popq %rax
	movq %rax, -24(%rbp)
	movq $D_A, %rbx
	movq %r15, %r9
	pushq -24(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Main, %rbx
	call *8(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_A, %rbx
	movq %r15, %r9
	pushq -24(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Main, %rbx
	call *8(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_A_f:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_A_g:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	movq $D_A, %rbx
	call *8(%rbx)
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_B_f:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $0
	call C_Boolean
	addq $8, %rsp
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
D_A:
	.quad D_AnyRef, M_A_f, M_A_g
D_Any:
	.quad D_Any
D_AnyRef:
	.quad D_Any
D_AnyVal:
	.quad D_Any
D_B:
	.quad D_A, M_B_f, M_A_g
D_Boolean:
	.quad D_AnyVal
D_Int:
	.quad D_AnyVal
D_Main:
	.quad D_Any, M_Main_print_bool, M_Main_main
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
	.string "false"
.S3:
	.string "true"
.S4:
	.string "\n"
