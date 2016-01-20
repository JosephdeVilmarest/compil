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
C_Vehicle:
	pushq %rbp
	movq %rsp, %rbp
	movq $24, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Vehicle, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq $10
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq 8(%r15)
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_Car:
	pushq %rbp
	movq %rsp, %rbp
	movq $32, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Car, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq $10
	call C_Int
	addq $8, %rsp
	pushq %rax
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
	pushq $0
	call C_Int
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
C_Truck:
	pushq %rbp
	movq %rsp, %rbp
	movq $32, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Truck, 0(%r12)
	addq $8, %r12
	pushq %r12
	pushq $10
	call C_Int
	addq $8, %rsp
	pushq %rax
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
	pushq $0
	call C_Int
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
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-24, %rsp
	call C_Truck
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	call C_Car
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq -16(%rbp)
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	movq %rbx, 32(%rax)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq -16(%rbp)
	popq %rax
	pushq 16(%rax)
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
	pushq $60
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Car, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq -16(%rbp)
	popq %rax
	pushq 16(%rax)
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
	pushq -16(%rbp)
	popq %rax
	movq %rax, -24(%rbp)
	pushq $70
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Vehicle, %rbx
	movq %r15, %r9
	pushq -24(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq -16(%rbp)
	popq %rax
	pushq 16(%rax)
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
	movq $D_Car, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *24(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq -8(%rbp)
	popq %rax
	pushq 16(%rax)
	call print_int
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
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
	pushq -16(%rbp)
	popq %rax
	pushq 16(%rax)
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
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Vehicle_move:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%r15)
	pushq 16(%rbp)
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
	movq %rax, 16(%r15)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Car_await:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	popq %rax
	pushq 16(%rax)
	pushq 16(%r15)
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
	je L5
	pushq 16(%r15)
	pushq 16(%rbp)
	popq %rax
	pushq 16(%rax)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	movq 8(%rax), %r14
	subq %r13, %r14
	pushq %r14
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Vehicle, %rbx
	movq %r15, %r9
	pushq 16(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	jmp L6
L5:
	pushq $10
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Car, %rbx
	call *8(%rbx)
	addq $8, %rsp
	pushq %rax
L6:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Truck_move:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	pushq $55
	call C_Int
	addq $8, %rsp
	pushq %rax
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	cmpq 8(%rax), %r13
	setns %cl
	movzbq %cl, %rcx
	pushq %rcx
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	cmpq $0, 8(%rax)
	je L7
	pushq 16(%r15)
	pushq 16(%rbp)
	popq %rbx
	popq %rax
	movq 8(%rbx), %r13
	movq 8(%rax), %r14
	addq %r13, %r14
	pushq %r14
	call C_Int
	addq $8, %rsp
	pushq %rax
	jmp L8
L7:
	pushq $55
	call C_Int
	addq $8, %rsp
	pushq %rax
L8:
	popq %rax
	movq %rax, 16(%r15)
	pushq $0
	call C_Unit
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
D_Any:
	.quad D_Any
D_AnyRef:
	.quad D_Any
D_AnyVal:
	.quad D_Any
D_Boolean:
	.quad D_AnyVal
D_Car:
	.quad D_Vehicle, M_Vehicle_move, M_Car_await
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
D_Truck:
	.quad D_Vehicle, M_Truck_move
D_Unit:
	.quad D_AnyVal
D_Vehicle:
	.quad D_AnyRef, M_Vehicle_move
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
.S1:
	.string "\n"
.S2:
	.string "\n"
.S3:
	.string "\n"
.S4:
	.string "\n"
