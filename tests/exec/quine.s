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
C_Job:
	pushq %rbp
	movq %rsp, %rbp
	movq $8, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Job, 0(%r12)
	popq %rax
	popq %r15
	movq %rbp, %rsp
	popq %rbp
	ret
C_WriteString:
	pushq %rbp
	movq %rsp, %rbp
	movq $16, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_WriteString, 0(%r12)
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
C_WriteInt:
	pushq %rbp
	movq %rsp, %rbp
	movq $16, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_WriteInt, 0(%r12)
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
C_Sequenced:
	pushq %rbp
	movq %rsp, %rbp
	movq $24, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Sequenced, 0(%r12)
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
C_Writer:
	pushq %rbp
	movq %rsp, %rbp
	movq $32, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Writer, 0(%r12)
	addq $8, %r12
	pushq %r12
	call C_Job
	addq $0, %rsp
	pushq %rax
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
	addq $8, %r12
	pushq %r12
	pushq $1
	call C_Boolean
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
C_Quine:
	pushq %rbp
	movq %rsp, %rbp
	movq $24, %rdi
	call malloc
	pushq %r15
	movq %rax, %r15
	pushq %rax
	movq %rax, %r12
	movq $D_Quine, 0(%r12)
	addq $8, %r12
	pushq %r12
	call C_Writer
	addq $0, %rsp
	pushq %rax
	popq %rbx
	popq %r12
	movq %rbx, 0(%r12)
	addq $8, %r12
	pushq %r12
	call C_Writer
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
M_Main_main:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	movq $D_Quine, %rbx
	movq %r15, %r9
	call C_Quine
	addq $0, %rsp
	pushq %rax
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Job_work:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_WriteString_work:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%r15)
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
M_WriteInt_work:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%r15)
	call print_int
	addq $8, %rsp
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Sequenced_work:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	movq $D_Job, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Job, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Writer_app:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	pushq 16(%r15)
	call C_Sequenced
	addq $16, %rsp
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
M_Writer_indent:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	pushq 32(%r15)
	popq %rax
	cmpq $0, 8(%rax)
	je L0
	pushq 24(%r15)
	popq %rax
	movq %rax, -8(%rbp)
L2:
	pushq -8(%rbp)
	pushq $0
	call C_Int
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
	movq 8(%rax), %rbx
	cmpq $0, %rbx
	je L3
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
	pushq $.S4
	call C_String
	addq $8, %rsp
	pushq %rax
	call C_WriteString
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	call *24(%rbx)
	addq $8, %rsp
	pushq %rax
	jmp L2
L3:
	pushq $0
	call C_Boolean
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rax, 32(%r15)
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
M_Writer_append:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	movq $D_Writer, %rbx
	call *32(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	call *24(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Writer_prepend:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%r15)
	pushq 16(%rbp)
	call C_Sequenced
	addq $16, %rsp
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
M_Writer_emit_string:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	call C_WriteString
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Writer_emit_int:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	call C_WriteInt
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Writer_set_indent:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	popq %rax
	movq %rax, 24(%r15)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Writer_move_indent:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 24(%r15)
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
	movq %rax, 24(%r15)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Writer_newline:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $.S5
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	call *56(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $1
	call C_Boolean
	addq $8, %rsp
	pushq %rax
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
M_Writer_extract:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	pushq 16(%r15)
	popq %rax
	movq %rax, -8(%rbp)
	call C_Job
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rax, 16(%r15)
	pushq $0
	call C_Unit
	addq $8, %rsp
	pushq %rax
	pushq -8(%rbp)
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Writer_work:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	movq $D_Job, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_n:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $.S6
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *88(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_e:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S7
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S8
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_en:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *88(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	pushq $.S9
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S10
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_s:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $.S11
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S12
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S13
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S14
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_q:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $.S15
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S16
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_sl:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $.S17
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S18
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_swi:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *72(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S19
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *64(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S20
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_si:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *72(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S21
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *64(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S22
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_mi:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *80(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S23
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *64(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S24
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_li:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq 16(%rbp)
	popq %rax
	pushq 8(%rax)
	call C_Int
	addq $8, %rsp
	negq 8(%rax)
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *80(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S25
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq 16(%rbp)
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *64(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S26
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_sw:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *96(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *48(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	pushq $.S27
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_t:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $.S28
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *56(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *88(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 24(%r15)
	popq %r15
	call *96(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *48(%rbx)
	movq %r9, %r15
	addq $8, %rsp
	pushq %rax
	movq $D_Writer, %rbx
	movq %r15, %r9
	pushq 16(%r15)
	popq %r15
	call *8(%rbx)
	movq %r9, %r15
	addq $0, %rsp
	pushq %rax
	popq %rax
	movq %rbp, %rsp
	popq %rbp
	ret
M_Quine_work:
	pushq %rbp
	movq %rsp, %rbp
	addq $0, %rsp
	pushq $4
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *72(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $0
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *80(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S29
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S30
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S31
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S32
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S33
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S34
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S35
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S36
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S37
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S38
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S39
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S40
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S41
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S42
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S43
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S44
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S45
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S46
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S47
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S48
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S49
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S50
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S51
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S52
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S53
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S54
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S55
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S56
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S57
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S58
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S59
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S60
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S61
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S62
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S63
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S64
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S65
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S66
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S67
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S68
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S69
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S70
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S71
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S72
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S73
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S74
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S75
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S76
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S77
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S78
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S79
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S80
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S81
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S82
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S83
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S84
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S85
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S86
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S87
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S88
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S89
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S90
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S91
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S92
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S93
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S94
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S95
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S96
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S97
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S98
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S99
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S100
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S101
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S102
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S103
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S104
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S105
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S106
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S107
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S108
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S109
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S110
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S111
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S112
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S113
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S114
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S115
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S116
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S117
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S118
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *64(%rbx)
	addq $0, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *56(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S119
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S120
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S121
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S122
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S123
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S124
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S125
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S126
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S127
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S128
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S129
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S130
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S131
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S132
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S133
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S134
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S135
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S136
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S137
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S138
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S139
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S140
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S141
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S142
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S143
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S144
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S145
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S146
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S147
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S148
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S149
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S150
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S151
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S152
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S153
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S154
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S155
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S156
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S157
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S158
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S159
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S160
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S161
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S162
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S163
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S164
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S165
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *88(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S166
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S167
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *48(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S168
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S169
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S170
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S171
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S172
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S173
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *104(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S174
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $2
	call C_Int
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *96(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S175
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S176
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S177
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *32(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *24(%rbx)
	addq $0, %rsp
	pushq %rax
	pushq $.S178
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	pushq $.S179
	call C_String
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *40(%rbx)
	addq $8, %rsp
	pushq %rax
	movq $D_Quine, %rbx
	call *112(%rbx)
	addq $0, %rsp
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
D_Int:
	.quad D_AnyVal
D_Job:
	.quad D_AnyRef, M_Job_work
D_Main:
	.quad D_Any, M_Main_main
D_Nothing:
	.quad D_Null
D_Null:
	.quad D_String
D_Quine:
	.quad D_Job, M_Quine_work, M_Quine_n, M_Quine_e, M_Quine_en, M_Quine_s, M_Quine_q, M_Quine_sl, M_Quine_swi, M_Quine_si, M_Quine_mi, M_Quine_li, M_Quine_sw, M_Quine_t
D_Sequenced:
	.quad D_Job, M_Sequenced_work
D_String:
	.quad D_AnyRef
D_Unit:
	.quad D_AnyVal
D_WriteInt:
	.quad D_Job, M_WriteInt_work
D_WriteString:
	.quad D_Job, M_WriteString_work
D_Writer:
	.quad D_Job, M_Writer_work, M_Writer_app, M_Writer_indent, M_Writer_append, M_Writer_prepend, M_Writer_emit_string, M_Writer_emit_int, M_Writer_set_indent, M_Writer_move_indent, M_Writer_newline, M_Writer_extract
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
.S6:
	.string "n();"
.S7:
	.string "e(\\\""
.S8:
	.string "\\\"); "
.S9:
	.string "en(\\\""
.S10:
	.string "\\\"); "
.S11:
	.string "\\\""
.S12:
	.string "\\\""
.S13:
	.string "s(\\\""
.S14:
	.string "\\\"); "
.S15:
	.string "\\\""
.S16:
	.string "q(); "
.S17:
	.string "\\\\"
.S18:
	.string "sl(); "
.S19:
	.string "swi("
.S20:
	.string "); "
.S21:
	.string "si("
.S22:
	.string "); "
.S23:
	.string "mi("
.S24:
	.string "); "
.S25:
	.string "li("
.S26:
	.string "); "
.S27:
	.string "sw(); "
.S28:
	.string "t()"
.S29:
	.string ""
.S30:
	.string "class Job { def work() {} }"
.S31:
	.string "class WriteString(s: String) extends Job "
.S32:
	.string "{ override def work() { print(s) } }"
.S33:
	.string "class WriteInt(x: Int) extends Job "
.S34:
	.string "{ override def work() { print(x) } }"
.S35:
	.string "class Sequenced(j1: Job,j2: Job) extends Job {"
.S36:
	.string "override def work() { j1.work(); j2.work() }"
.S37:
	.string "}"
.S38:
	.string ""
.S39:
	.string "class Writer extends Job {"
.S40:
	.string "var output = new Job();"
.S41:
	.string "var idt = 0;"
.S42:
	.string "var nline = true;"
.S43:
	.string "def app(j: Job) { "
.S44:
	.string "output = new Sequenced(output,j) };"
.S45:
	.string "def indent() {"
.S46:
	.string "if(nline) {"
.S47:
	.string "var m = idt;"
.S48:
	.string "while(m > 0) { m = m - 1; app(new WriteString("
.S49:
	.string " "
.S50:
	.string ")) };"
.S51:
	.string "nline = false"
.S52:
	.string "}"
.S53:
	.string "};"
.S54:
	.string "def append(j: Job) { indent(); app(j) };"
.S55:
	.string "def prepend(j: Job) { output = new Sequenced(j,output) };"
.S56:
	.string "def emit_string(s: String) { append(new WriteString(s)) };"
.S57:
	.string "def emit_int(x: Int) { append(new WriteInt(x)) };"
.S58:
	.string "def set_indent(x: Int) { idt = x };"
.S59:
	.string "def move_indent(x: Int) { idt = idt + x };"
.S60:
	.string "def newline() { emit_string("
.S61:
	.string "n"
.S62:
	.string "); nline = true };"
.S63:
	.string "def extract() : Job = { val u = output; output = new Job(); u };"
.S64:
	.string "override def work() { output.work() }"
.S65:
	.string "}"
.S66:
	.string ""
.S67:
	.string "class Quine extends Job {"
.S68:
	.string "val mnw = new Writer();"
.S69:
	.string "val mdw = new Writer();"
.S70:
	.string "def n() { mdw.emit_string("
.S71:
	.string "n();"
.S72:
	.string "); mdw.newline() };"
.S73:
	.string "def e(s: String) {"
.S74:
	.string "mnw.emit_string(s);"
.S75:
	.string "mdw.emit_string("
.S76:
	.string "e("
.S77:
	.string ""
.S78:
	.string ");"
.S79:
	.string "mdw.emit_string(s);"
.S80:
	.string "mdw.emit_string("
.S81:
	.string "); "
.S82:
	.string ")"
.S83:
	.string "};"
.S84:
	.string "def en(s: String) {"
.S85:
	.string "mnw.emit_string(s);"
.S86:
	.string "mnw.newline();"
.S87:
	.string "mdw.emit_string("
.S88:
	.string "en("
.S89:
	.string ""
.S90:
	.string ");"
.S91:
	.string "mdw.emit_string(s);"
.S92:
	.string "mdw.emit_string("
.S93:
	.string "); "
.S94:
	.string ")"
.S95:
	.string "};"
.S96:
	.string "def s(s:String) {"
.S97:
	.string "mnw.emit_string("
.S98:
	.string ""
.S99:
	.string ");"
.S100:
	.string "mnw.emit_string(s);"
.S101:
	.string "mnw.emit_string("
.S102:
	.string ""
.S103:
	.string ");"
.S104:
	.string "mdw.emit_string("
.S105:
	.string "s("
.S106:
	.string ""
.S107:
	.string ");"
.S108:
	.string "mdw.emit_string(s);"
.S109:
	.string "mdw.emit_string("
.S110:
	.string "); "
.S111:
	.string ")"
.S112:
	.string "};"
.S113:
	.string "def q() { mnw.emit_string("
.S114:
	.string ""
.S115:
	.string "); mdw.emit_string("
.S116:
	.string "q(); "
.S117:
	.string ") };"
.S118:
	.string "def sl() { mnw.emit_string("
.S119:
	.string "); mdw.emit_string("
.S120:
	.string "sl(); "
.S121:
	.string ") };"
.S122:
	.string "def swi(x: Int) {"
.S123:
	.string "mdw.set_indent(x);"
.S124:
	.string "mdw.emit_string("
.S125:
	.string "swi("
.S126:
	.string ");"
.S127:
	.string "mdw.emit_int(x);"
.S128:
	.string "mdw.emit_string("
.S129:
	.string "); "
.S130:
	.string ")"
.S131:
	.string "};"
.S132:
	.string "def si(x: Int) {"
.S133:
	.string "mnw.set_indent(x);"
.S134:
	.string "mdw.emit_string("
.S135:
	.string "si("
.S136:
	.string ");"
.S137:
	.string "mdw.emit_int(x);"
.S138:
	.string "mdw.emit_string("
.S139:
	.string "); "
.S140:
	.string ")"
.S141:
	.string "};"
.S142:
	.string "def mi(x: Int) {"
.S143:
	.string "mnw.move_indent(x);"
.S144:
	.string "mdw.emit_string("
.S145:
	.string "mi("
.S146:
	.string ");"
.S147:
	.string "mdw.emit_int(x);"
.S148:
	.string "mdw.emit_string("
.S149:
	.string "); "
.S150:
	.string ")"
.S151:
	.string "};"
.S152:
	.string "def li(x: Int) {"
.S153:
	.string "mnw.move_indent(-x);"
.S154:
	.string "mdw.emit_string("
.S155:
	.string "li("
.S156:
	.string ");"
.S157:
	.string "mdw.emit_int(x);"
.S158:
	.string "mdw.emit_string("
.S159:
	.string "); "
.S160:
	.string ")"
.S161:
	.string "};"
.S162:
	.string "def sw() { mdw.prepend(mnw.extract()); mdw.emit_string("
.S163:
	.string "sw(); "
.S164:
	.string ") };"
.S165:
	.string "def t() {"
.S166:
	.string "mdw.emit_string("
.S167:
	.string "t()"
.S168:
	.string ");"
.S169:
	.string "mdw.newline();"
.S170:
	.string "mnw.prepend(mdw.extract());"
.S171:
	.string "mnw.work()"
.S172:
	.string "};"
.S173:
	.string "override def work() {"
.S174:
	.string "}"
.S175:
	.string "}"
.S176:
	.string ""
.S177:
	.string "object Main { def main(a: Array[String]) { "
.S178:
	.string "(new Quine()).work() } }"
.S179:
	.string ""
