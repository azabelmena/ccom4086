	.file	"absdiff.c"
	.text
	.globl	absdiff
	.type	absdiff, @function
absdiff:
.LFB0:
	.cfi_startproc
	movq	%rsi, %rdx
	subq	%rdi, %rdx
	movq	%rdi, %rax
	subq	%rsi, %rax
	cmpq	%rsi, %rdi
	cmovl	%rdx, %rax
	ret
	.cfi_endproc
.LFE0:
	.size	absdiff, .-absdiff
	.globl	absdiffGoto
	.type	absdiffGoto, @function
absdiffGoto:
.LFB1:
	.cfi_startproc
	movq	%rdi, %rdx
	subq	%rsi, %rdx
	movq	%rsi, %rax
	subq	%rdi, %rax
	cmpq	%rsi, %rdi
	cmovg	%rdx, %rax
	ret
.L5:
.L6:
	.cfi_endproc
.LFE1:
	.size	absdiffGoto, .-absdiffGoto
	.globl	absdiffSwitch
	.type	absdiffSwitch, @function
absdiffSwitch:
.LFB2:
	.cfi_startproc
	movq	%rdi, %rdx
	subq	%rsi, %rdx
	movq	%rsi, %rax
	subq	%rdi, %rax
	cmpq	%rsi, %rdi
	cmovg	%rdx, %rax
	ret
	.cfi_endproc
.LFE2:
	.size	absdiffSwitch, .-absdiffSwitch
	.globl	absdiffcmov
	.type	absdiffcmov, @function
absdiffcmov:
.LFB3:
	.cfi_startproc
	movq	%rsi, %rdx
	subq	%rdi, %rdx
	movq	%rdi, %rax
	subq	%rsi, %rax
	cmpq	%rdi, %rsi
	cmovg	%rdx, %rax
	ret
	.cfi_endproc
.LFE3:
	.size	absdiffcmov, .-absdiffcmov
	.ident	"GCC: (GNU) 11.1.0"
	.section	.note.GNU-stack,"",@progbits
