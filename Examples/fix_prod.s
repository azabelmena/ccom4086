	.file	"fix_prod.c"
	.text
	.globl	fix_prod
	.type	fix_prod, @function
fix_prod:
.LFB11:
	.cfi_startproc
	salq	$6, %rdx
	addq	%rdx, %rdi
	movl	(%rdi,%rcx,4), %edi
	salq	$6, %rcx
	addq	%rcx, %rsi
	leaq	64(%rsi), %rcx
	movl	$0, %eax
.L2:
	movl	%edi, %edx
	imull	(%rsi), %edx
	addl	%edx, %eax
	addq	$4, %rsi
	cmpq	%rcx, %rsi
	jne	.L2
	ret
	.cfi_endproc
.LFE11:
	.size	fix_prod, .-fix_prod
	.globl	fix_prod_opt
	.type	fix_prod_opt, @function
fix_prod_opt:
.LFB12:
	.cfi_startproc
	salq	$6, %rdx
	addq	%rdx, %rdi
	salq	$2, %rcx
	leaq	(%rsi,%rcx), %rax
	leaq	1024(%rsi,%rcx), %rsi
	movl	$0, %ecx
.L5:
	movl	(%rdi), %edx
	imull	(%rax), %edx
	addl	%edx, %ecx
	addq	$4, %rdi
	addq	$64, %rax
	cmpq	%rax, %rsi
	jne	.L5
	movl	%ecx, %eax
	ret
	.cfi_endproc
.LFE12:
	.size	fix_prod_opt, .-fix_prod_opt
	.globl	var_ele
	.type	var_ele, @function
var_ele:
.LFB13:
	.cfi_startproc
	imulq	%rdx, %rdi
	leaq	(%rdi,%rcx), %rax
	movl	(%rsi,%rax,4), %eax
	ret
	.cfi_endproc
.LFE13:
	.size	var_ele, .-var_ele
	.globl	var_prod
	.type	var_prod, @function
var_prod:
.LFB14:
	.cfi_startproc
	testq	%rdi, %rdi
	jle	.L11
	imulq	%rdi, %rcx
	leaq	0(,%r8,4), %rax
	leaq	(%rax,%rcx,4), %rax
	movl	(%rsi,%rax), %r9d
	imulq	%rdi, %r8
	leaq	(%rdx,%r8,4), %rsi
	movl	$0, %eax
	movl	$0, %edx
.L10:
	movl	%r9d, %ecx
	imull	(%rsi,%rax,4), %ecx
	addl	%ecx, %edx
	addq	$1, %rax
	cmpq	%rax, %rdi
	jne	.L10
.L8:
	movl	%edx, %eax
	ret
.L11:
	movl	$0, %edx
	jmp	.L8
	.cfi_endproc
.LFE14:
	.size	var_prod, .-var_prod
	.globl	var_prod_opt
	.type	var_prod_opt, @function
var_prod_opt:
.LFB15:
	.cfi_startproc
	leaq	0(,%rdi,4), %r9
	imulq	%rdi, %rcx
	leaq	(%rsi,%rcx,4), %rcx
	leaq	(%rdx,%r8,4), %rax
	testq	%rdi, %rdi
	jle	.L16
	movl	(%rcx,%r8,4), %r8d
	movl	$0, %ecx
	movl	$0, %edx
.L15:
	movl	%r8d, %esi
	imull	(%rax), %esi
	addl	%esi, %ecx
	addq	%r9, %rax
	addl	$1, %edx
	cmpl	%edi, %edx
	jne	.L15
.L13:
	movl	%ecx, %eax
	ret
.L16:
	movl	$0, %ecx
	jmp	.L13
	.cfi_endproc
.LFE15:
	.size	var_prod_opt, .-var_prod_opt
	.ident	"GCC: (GNU) 11.1.0"
	.section	.note.GNU-stack,"",@progbits
