	.file	"caller_callee.c"
	.text
	.globl	Q
	.type	Q, @function
Q:
.LFB0:
	.cfi_startproc
	movq	%rdi, %rax
	negq	%rax
	ret
	.cfi_endproc
.LFE0:
	.size	Q, .-Q
	.globl	P
	.type	P, @function
P:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbp
	movq	%rsi, %rdi
	call	Q
	movq	%rax, %rbx
	movq	%rbp, %rdi
	call	Q
	addq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE1:
	.size	P, .-P
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	movl	$0, %eax
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
	.section	.note.GNU-stack,"",@progbits
