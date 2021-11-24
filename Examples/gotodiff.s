	.file	"gotodiff.c"
	.text
	.globl	gotodiff
	.type	gotodiff, @function
gotodiff:
.LFB0:
	.cfi_startproc
	cmpq	%rsi, %rdi
	jge	.L4
	addq	$1, ltCnt(%rip)
	movq	%rsi, %rax
	subq	%rdi, %rax
	ret
.L4:
	addq	$1, geCnt(%rip)
	movq	%rdi, %rax
	subq	%rsi, %rax
	ret
	.cfi_endproc
.LFE0:
	.size	gotodiff, .-gotodiff
	.globl	diff
	.type	diff, @function
diff:
.LFB1:
	.cfi_startproc
	cmpq	%rsi, %rdi
	jl	.L6
	addq	$1, geCnt(%rip)
	movq	%rdi, %rax
	subq	%rsi, %rax
	ret
.L6:
	addq	$1, ltCnt(%rip)
	movq	%rsi, %rax
	subq	%rdi, %rax
	ret
	.cfi_endproc
.LFE1:
	.size	diff, .-diff
	.globl	geCnt
	.bss
	.align 8
	.type	geCnt, @object
	.size	geCnt, 8
geCnt:
	.zero	8
	.globl	ltCnt
	.align 8
	.type	ltCnt, @object
	.size	ltCnt, 8
ltCnt:
	.zero	8
	.ident	"GCC: (GNU) 11.1.0"
	.section	.note.GNU-stack,"",@progbits
