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
C_Mandelbrot:
	pushq %rbp
	movq %rsp, %rbp
	movq $16, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Mandelbrot, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 16(%rbp)
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
	addq $0, %rsp
	movq $D_Mandelbrot, %rbx
	movq %r15, %r9
	pushq $30
	call C_Int
	addq $8, %rsp
	pushq %rax
	call C_Mandelbrot
	addq $8, %rsp
	pushq %rax
	popq %r15
	call *64(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Mandelbrot_add:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	pushq 24(%rbp)
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
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Mandelbrot_sub:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	pushq 24(%rbp)
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
	movq %rbp, %rsp
	popq %rbp
	ret
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Mandelbrot_mul:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	pushq 16(%rbp)
	pushq 24(%rbp)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	movq 8(%rax), %r14
	imulq %r13, %r14
	pushq %r14
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq -8(%rbp)
	pushq $8192
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
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	movq 8(%rax), %r14
	addq %r13, %r14
	pushq %r14
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq $8192
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
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Mandelbrot_div:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	pushq 16(%rbp)
	pushq $8192
	call C_Int
	addq $8, %rsp
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
	popq %rax
	movq %rax, -8(%rbp)
	pushq -8(%rbp)
	pushq 24(%rbp)
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
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	movq 8(%rax), %r14
	addq %r13, %r14
	pushq %r14
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq 24(%rbp)
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
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Mandelbrot_of_int:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	pushq $8192
	call C_Int
	addq $8, %rsp
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
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Mandelbrot_iter:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	pushq 16(%rbp)
	pushq $100
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
	je L0
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L1
L0:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L1:
	pushq 40(%rbp)
	pushq 40(%rbp)
	movq $D_Mandelbrot, %rbx
	call *24(%rbx)
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq 48(%rbp)
	pushq 48(%rbp)
	movq $D_Mandelbrot, %rbx
	call *24(%rbx)
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq -16(%rbp)
	pushq -8(%rbp)
	movq $D_Mandelbrot, %rbx
	call *8(%rbx)
	addq $16, %rsp
	pushq %rax
	pushq $4
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
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
	cmpq $0, 8(%rax)
	je L2
	pushq $0
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L3
L2:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L3:
	pushq 32(%rbp)
	pushq 48(%rbp)
	pushq 40(%rbp)
	movq $D_Mandelbrot, %rbx
	call *24(%rbx)
	addq $16, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *24(%rbx)
	addq $16, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *8(%rbx)
	addq $16, %rsp
	pushq %rax
	pushq 24(%rbp)
	pushq -16(%rbp)
	pushq -8(%rbp)
	movq $D_Mandelbrot, %rbx
	call *16(%rbx)
	addq $16, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *8(%rbx)
	addq $16, %rsp
	pushq %rax
	pushq 32(%rbp)
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
	movq $D_Mandelbrot, %rbx
	call *48(%rbx)
	addq $40, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Mandelbrot_inside:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq 24(%rbp)
	pushq 16(%rbp)
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *48(%rbx)
	addq $40, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Mandelbrot_run:
	pushq %rbp
	movq %rsp, %rbp
	addq $-80, %rsp
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	pushq 8(%rax)
	call C_Int
	addq $8, %rsp
	negq 8(%rax)
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq 8(%r15)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	movq 8(%rax), %r14
	imulq %r13, %r14
	pushq %r14
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq -8(%rbp)
	pushq -16(%rbp)
	movq $D_Mandelbrot, %rbx
	call *16(%rbx)
	addq $16, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *32(%rbx)
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rax, -24(%rbp)
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	pushq 8(%rax)
	call C_Int
	addq $8, %rsp
	negq 8(%rax)
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -32(%rbp)
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -40(%rbp)
	pushq 8(%r15)
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq -32(%rbp)
	pushq -40(%rbp)
	movq $D_Mandelbrot, %rbx
	call *16(%rbx)
	addq $16, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *32(%rbx)
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rax, -48(%rbp)
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -56(%rbp)
L4:
	pushq -56(%rbp)
	pushq 8(%r15)
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
	je L5
	pushq -48(%rbp)
	pushq -56(%rbp)
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *24(%rbx)
	addq $16, %rsp
	pushq %rax
	pushq -32(%rbp)
	movq $D_Mandelbrot, %rbx
	call *8(%rbx)
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rax, -64(%rbp)
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -72(%rbp)
L6:
	pushq -72(%rbp)
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	pushq 8(%r15)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	movq 8(%rax), %r14
	imulq %r13, %r14
	pushq %r14
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
	je L7
	pushq -24(%rbp)
	pushq -72(%rbp)
	movq $D_Mandelbrot, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Mandelbrot, %rbx
	call *24(%rbx)
	addq $16, %rsp
	pushq %rax
	pushq -8(%rbp)
	movq $D_Mandelbrot, %rbx
	call *8(%rbx)
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rax, -80(%rbp)
	pushq -64(%rbp)
	pushq -80(%rbp)
	movq $D_Mandelbrot, %rbx
	call *56(%rbx)
	addq $16, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L8
	pushq $.S11
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L9
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
L9:
	pushq -72(%rbp)
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
	movq %rax, -72(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L6
L7:
	pushq $.S12
	call C_String
	addq $8, %rsp
	pushq %rax
	call print_string
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq -56(%rbp)
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
	movq %rax, -56(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	jmp L4
L5:
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
D_Main:
	.quad D_Any, M_Main_main
D_Mandelbrot:
	.quad D_AnyRef, M_Mandelbrot_add, M_Mandelbrot_sub, M_Mandelbrot_mul, M_Mandelbrot_div, M_Mandelbrot_of_int, M_Mandelbrot_iter, M_Mandelbrot_inside, M_Mandelbrot_run
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
.S10:
	.string "1"
.S11:
	.string "0"
.S12:
	.string "\n"
