	.file	"absdiff.c"
	.text
	.globl	absdiff
	.type	absdiff, @function
absdiff:
.LFB0:
	.cfi_startproc
	cmpq	%rsi, %rdi
	jle	.L2
	movq	%rdi, %rax
	subq	%rsi, %rax
	ret
.L2:
	movq	%rsi, %rax
	subq	%rdi, %rax
	ret
	.cfi_endproc
.LFE0:
	.size	absdiff, .-absdiff
	.globl	absdiffGoto
	.type	absdiffGoto, @function
absdiffGoto:
.LFB1:
	.cfi_startproc
	cmpq	%rsi, %rdi
	jle	.L5
	movq	%rdi, %rax
	subq	%rsi, %rax
	ret
.L5:
	movq	%rsi, %rax
	subq	%rdi, %rax
.L6:
	ret
	.cfi_endproc
.LFE1:
	.size	absdiffGoto, .-absdiffGoto
	.globl	absdiffSwitch
	.type	absdiffSwitch, @function
absdiffSwitch:
.LFB2:
	.cfi_startproc
	cmpq	%rsi, %rdi
	jle	.L8
	movq	%rdi, %rax
	subq	%rsi, %rax
	ret
.L8:
	movq	%rsi, %rax
	subq	%rdi, %rax
	ret
	.cfi_endproc
.LFE2:
	.size	absdiffSwitch, .-absdiffSwitch
	.ident	"GCC: (GNU) 11.1.0"
	.section	.note.GNU-stack,"",@progbits
