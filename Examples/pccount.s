	.file	"pccount.c"
	.text
	.globl	pccountDo
	.type	pccountDo, @function
pccountDo:
.LFB0:
	.cfi_startproc
	movl	$0, %eax
.L2:
	movq	%rdi, %rdx
	andl	$1, %edx
	addq	%rdx, %rax
	shrq	%rdi
	jne	.L2
	ret
	.cfi_endproc
.LFE0:
	.size	pccountDo, .-pccountDo
	.globl	pccountWhile
	.type	pccountWhile, @function
pccountWhile:
.LFB1:
	.cfi_startproc
	movl	$0, %eax
	jmp	.L4
.L5:
	movq	%rdi, %rdx
	andl	$1, %edx
	addq	%rdx, %rax
	shrq	%rdi
.L4:
	testq	%rdi, %rdi
	jne	.L5
	ret
	.cfi_endproc
.LFE1:
	.size	pccountWhile, .-pccountWhile
	.globl	pccountGoto
	.type	pccountGoto, @function
pccountGoto:
.LFB2:
	.cfi_startproc
	movl	$0, %eax
.L7:
	movq	%rdi, %rdx
	andl	$1, %edx
	addq	%rdx, %rax
	shrq	%rdi
	jne	.L7
	ret
	.cfi_endproc
.LFE2:
	.size	pccountGoto, .-pccountGoto
	.globl	pccountGotoWhile
	.type	pccountGotoWhile, @function
pccountGotoWhile:
.LFB3:
	.cfi_startproc
	movl	$0, %eax
.L9:
	movq	%rdi, %rdx
	andl	$1, %edx
	addq	%rdx, %rax
	shrq	%rdi
	jne	.L9
	ret
	.cfi_endproc
.LFE3:
	.size	pccountGotoWhile, .-pccountGotoWhile
	.ident	"GCC: (GNU) 11.1.0"
	.section	.note.GNU-stack,"",@progbits
