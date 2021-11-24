	.file	"proc.c"
	.text
	.globl	proc
	.type	proc, @function
proc:
.LFB0:
	.cfi_startproc
	movq	16(%rsp), %rax
	addq	%rdi, (%rsi)
	addl	%edx, (%rcx)
	addw	%r8w, (%r9)
	addb	%dil, (%rax)
	ret
	.cfi_endproc
.LFE0:
	.size	proc, .-proc
	.globl	call_proc
	.type	call_proc, @function
call_proc:
.LFB1:
	.cfi_startproc
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	$1, 16(%rsp)
	movl	$2, 12(%rsp)
	movw	$3, 10(%rsp)
	movb	$4, 9(%rsp)
	leaq	12(%rsp), %rcx
	leaq	16(%rsp), %rsi
	leaq	9(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 56
	pushq	$4
	.cfi_def_cfa_offset 64
	leaq	26(%rsp), %r9
	movl	$3, %r8d
	movl	$2, %edx
	movl	$1, %edi
	call	proc
	movslq	28(%rsp), %rax
	addq	32(%rsp), %rax
	movswl	26(%rsp), %edx
	movsbl	25(%rsp), %ecx
	subl	%ecx, %edx
	movslq	%edx, %rdx
	imulq	%rdx, %rax
	addq	$16, %rsp
	.cfi_def_cfa_offset 48
	movq	24(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L5
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L5:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE1:
	.size	call_proc, .-call_proc
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$0, %eax
	call	call_proc
	movl	$0, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
	.section	.note.GNU-stack,"",@progbits
