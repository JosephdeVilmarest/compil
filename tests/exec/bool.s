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
	movq %rax, %r12
	movq $D_Main, 0(%r12)
	popq %rax
	ret
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L1
	pushq $0
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
L1:
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	jne L0
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
L0:
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L2
	pushq $0
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	jne L3
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
L3:
	pushq %rax
	popq %rax
L2:
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L4
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	negq 8(%rax)
	addq $1, 8(%rax)
	pushq %rax
	popq %rax
L4:
	pushq %rax
	popq %rax
	movq %rax, -24(%rbp)
	pushq -8(%rbp)
	popq %rax
	cmpq $0, 8(%rax)
	je L5
	pushq -16(%rbp)
	popq %rax
	cmpq $0, 8(%rax)
	jne L6
	pushq -24(%rbp)
	popq %rax
L6:
	pushq %rax
	popq %rax
	negq 8(%rax)
	addq $1, 8(%rax)
	pushq %rax
	popq %rax
L5:
	pushq %rax
	popq %rax
	negq 8(%rax)
	addq $1, 8(%rax)
	pushq %rax
	popq %rax
	movq %rax, -32(%rbp)
	pushq -32(%rbp)
	popq %rax
	cmpq $0, 8(%rax)
	je L7
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
	jmp L8
L7:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L8:
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
.S9:
	.string "OK\n"
