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
C_List:
	pushq %rbp
	movq %rsp, %rbp
	movq $24, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_List, 0(%r12)
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
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_Queue:
	pushq %rbp
	movq %rsp, %rbp
	movq $24, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Queue, 0(%r12)
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
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_Fruit:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Fruit, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_Apple:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Apple, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_Pear:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Pear, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-32, %rsp
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	call C_Queue
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $1
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq $3
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *32(%rbx)
	movq %r9, %r15
	addq $0, %rsp
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
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *40(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *32(%rbx)
	movq %r9, %r15
	addq $0, %rsp
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
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *40(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rax, -8(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -8(%rbp)
	popq %r15
	call *32(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
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
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	call C_Queue
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	call C_Apple
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rax, -24(%rbp)
	pushq -24(%rbp)
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -16(%rbp)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	call C_Pear
	addq $0, %rsp
	pushq %rax
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -16(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, -32(%rbp)
	movq $D_Queue, %rbx
	movq %r15, %r9
	pushq -32(%rbp)
	popq %r15
	call *32(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	pushq -24(%rbp)
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
	je L3
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
	jmp L4
L3:
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
L4:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_List_head:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 8(%r15)
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_List_tail:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%r15)
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Queue_add:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%r15)
	pushq 16(%rbp)
	call C_List
	addq $16, %rsp
	pushq %rax
	pushq 8(%r15)
	call C_Queue
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Queue_rev_append:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
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
	je L6
	pushq 24(%rbp)
	jmp L7
L6:
	pushq 24(%rbp)
	movq $D_List, %rbx
	movq %r15, %r9
	pushq 16(%rbp)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	call C_List
	addq $16, %rsp
	pushq %rax
	movq $D_List, %rbx
	movq %r15, %r9
	pushq 16(%rbp)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Queue, %rbx
	call *16(%rbx)
	addq $16, %rsp
	pushq %rax
L7:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Queue_reverse:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	movq $D_Queue, %rbx
	call *16(%rbx)
	addq $16, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Queue_head:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 8(%r15)
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
	je L8
	movq $D_List, %rbx
	movq %r15, %r9
	pushq 8(%r15)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	jmp L9
L8:
	movq $D_List, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	movq $D_Queue, %rbx
	call *24(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
L9:
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Queue_tail:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 8(%r15)
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
	je L10
	pushq 16(%r15)
	movq $D_List, %rbx
	movq %r15, %r9
	pushq 8(%r15)
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	call C_Queue
	addq $16, %rsp
	pushq %rax
	jmp L11
L10:
	pushq $0
	call C_Null
	addq $8, %rsp
	pushq %rax
	movq $D_List, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	movq $D_Queue, %rbx
	call *24(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %r15
	call *16(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	call C_Queue
	addq $16, %rsp
	pushq %rax
L11:
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
D_Apple:
	.quad D_Fruit
D_Boolean:
	.quad D_AnyVal
D_Fruit:
	.quad D_AnyRef
D_Int:
	.quad D_AnyVal
D_List:
	.quad D_AnyRef, M_List_head, M_List_tail
D_Main:
	.quad D_Any, M_Main_main
D_Nothing:
	.quad D_Null
D_Null:
	.quad D_String
D_Pear:
	.quad D_Fruit
D_Queue:
	.quad D_AnyRef, M_Queue_add, M_Queue_rev_append, M_Queue_reverse, M_Queue_head, M_Queue_tail
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
.S1:
	.string "\n"
.S2:
	.string "\n"
.S5:
	.string "OK\n"
