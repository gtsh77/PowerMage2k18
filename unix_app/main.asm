	.file	"main.c"
	.comm	level,16,16
	.globl	objNames
	.data
	.align 32
	.type	objNames, @object
	.size	objNames, 512
objNames:
	.string	"../assets/unix/brick1.jpg"
	.zero	38
	.string	"../assets/unix/frenchdoor_wood1.jpg"
	.zero	28
	.string	"../assets/unix/interiorwall_set2chrrl.jpg"
	.zero	22
	.string	"../assets/unix/interiorwall_set3chrrl.jpg"
	.zero	22
	.string	"../assets/unix/floor4.jpg"
	.zero	38
	.string	"../assets/unix/frenchfloor_wood1.jpg"
	.zero	27
	.string	"../assets/unix/garagefloor.jpg"
	.zero	33
	.string	"../assets/unix/wlppr_tan.jpg"
	.zero	35
	.globl	objIds
	.align 8
	.type	objIds, @object
	.size	objIds, 8
objIds:
	.byte	10
	.byte	11
	.byte	12
	.byte	13
	.byte	14
	.byte	15
	.byte	16
	.byte	17
	.comm	e,8,8
	.comm	l,8,8
	.comm	f,8,8
	.text
	.globl	getCycles
	.type	getCycles, @function
getCycles:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
#APP
# 4 "lib.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movq	%rax, -8(%rbp)
	movq	%rdx, -16(%rbp)
	movq	-16(%rbp), %rax
	salq	$32, %rax
	orq	-8(%rbp), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	getCycles, .-getCycles
	.globl	getPlayer
	.type	getPlayer, @function
getPlayer:
.LFB27:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, %eax
	movw	%ax, -28(%rbp)
	movw	$0, -2(%rbp)
	jmp	.L4
.L7:
	movzwl	-2(%rbp), %edx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$1, %al
	jne	.L5
	movzwl	-2(%rbp), %eax
	jmp	.L3
.L5:
	movzwl	-2(%rbp), %eax
	addl	$1, %eax
	movw	%ax, -2(%rbp)
.L4:
	movzwl	-2(%rbp), %eax
	cmpw	-28(%rbp), %ax
	jb	.L7
.L3:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	getPlayer, .-getPlayer
	.section	.rodata
.LC0:
	.string	"rb"
	.align 8
.LC1:
	.string	"error: can't read world file: %s\n"
	.text
	.globl	loadTileMap
	.type	loadTileMap, @function
loadTileMap:
.LFB28:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	$.LC0, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L9
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	jmp	.L8
.L9:
	movq	-8(%rbp), %rax
	movl	$2, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	ftell
	movw	%ax, -10(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	rewind
	movzwl	-10(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc
	movq	%rax, level(%rip)
	movzwl	-10(%rbp), %esi
	movq	level(%rip), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rcx
	movl	$1, %edx
	movq	%rax, %rdi
	call	fread
	movzwl	-10(%rbp), %eax
	movw	%ax, level+8(%rip)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	nop
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	loadTileMap, .-loadTileMap
	.section	.rodata
.LC2:
	.string	"env %d\n"
	.text
	.globl	seekAssets
	.type	seekAssets, @function
seekAssets:
.LFB29:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	e(%rip), %rax
	movq	%rax, -8(%rbp)
	jmp	.L13
.L14:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	movq	-8(%rbp), %rax
	movq	56(%rax), %rax
	movq	%rax, -8(%rbp)
.L13:
	movq	f(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jb	.L14
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	seekAssets, .-seekAssets
	.globl	getAssetById
	.type	getAssetById, @function
getAssetById:
.LFB30:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %eax
	movq	%rsi, -32(%rbp)
	movb	%al, -20(%rbp)
	movq	e(%rip), %rax
	movq	%rax, -8(%rbp)
	jmp	.L17
.L19:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	-20(%rbp), %al
	jne	.L18
	movq	-32(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	f(%rip), %rax
	movq	%rax, -8(%rbp)
	jmp	.L17
.L18:
	movq	-8(%rbp), %rax
	movq	56(%rax), %rax
	movq	%rax, -8(%rbp)
.L17:
	movq	f(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jb	.L19
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	getAssetById, .-getAssetById
	.globl	loadAssets
	.type	loadAssets, @function
loadAssets:
.LFB31:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset 3, -24
	movl	$72, %edi
	call	malloc
	movq	%rax, e(%rip)
	movq	e(%rip), %rax
	movq	%rax, f(%rip)
	movq	f(%rip), %rax
	movq	%rax, l(%rip)
	movb	$0, -17(%rbp)
	jmp	.L22
.L23:
	movq	l(%rip), %rax
	movzbl	-17(%rbp), %edx
	movslq	%edx, %rdx
	salq	$6, %rdx
	addq	$objNames, %rdx
	movq	%rdx, 24(%rax)
	movq	l(%rip), %rax
	movzbl	-17(%rbp), %edx
	movslq	%edx, %rdx
	movzbl	objIds(%rdx), %edx
	movb	%dl, (%rax)
	movq	l(%rip), %rax
	movq	%rax, %rdi
	call	loadAssetItem
	movq	l(%rip), %rbx
	movl	$72, %edi
	call	malloc
	movq	%rax, 56(%rbx)
	movq	l(%rip), %rax
	movq	56(%rax), %rax
	movq	%rax, l(%rip)
	movzbl	-17(%rbp), %eax
	addl	$1, %eax
	movb	%al, -17(%rbp)
.L22:
	cmpb	$7, -17(%rbp)
	jbe	.L23
	movq	l(%rip), %rax
	movq	%rax, f(%rip)
	nop
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	loadAssets, .-loadAssets
	.section	.rodata
.LC3:
	.string	"jpg"
	.align 8
.LC4:
	.string	"error: can't read asset file: %s\n"
	.align 8
.LC5:
	.string	"error: unsupported extension: %s\n"
	.text
	.globl	loadAssetItem
	.type	loadAssetItem, @function
loadAssetItem:
.LFB32:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$912, %rsp
	movq	%rdi, -904(%rbp)
	movq	-904(%rbp), %rax
	movq	24(%rax), %rax
	movl	$46, %esi
	movq	%rax, %rdi
	call	strrchr
	addq	$1, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	$.LC3, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L26
	leaq	-896(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_std_error
	movq	%rax, -720(%rbp)
	leaq	-720(%rbp), %rax
	movl	$664, %edx
	movl	$90, %esi
	movq	%rax, %rdi
	call	jpeg_CreateDecompress
	movq	-904(%rbp), %rax
	movq	24(%rax), %rax
	movl	$.LC0, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -32(%rbp)
	cmpq	$0, -32(%rbp)
	jne	.L27
	movq	-904(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rsi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
	jmp	.L25
.L27:
	movq	-32(%rbp), %rdx
	leaq	-720(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	jpeg_stdio_src
	leaq	-720(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	jpeg_read_header
	leaq	-720(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_start_decompress
	movl	$1, %edi
	call	malloc
	movq	%rax, -40(%rbp)
	movl	-584(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	movl	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, (%rax)
	movl	-584(%rbp), %eax
	movl	%eax, %edx
	movl	-580(%rbp), %eax
	movl	%eax, %eax
	imulq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, %rdx
	movq	-904(%rbp), %rax
	movq	%rdx, 40(%rax)
	movl	-584(%rbp), %eax
	movl	%eax, %edx
	movq	-904(%rbp), %rax
	movw	%dx, 32(%rax)
	movl	-580(%rbp), %eax
	movl	%eax, %edx
	movq	-904(%rbp), %rax
	movw	%dx, 34(%rax)
	movq	-904(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movl	$0, -8(%rbp)
	jmp	.L29
.L32:
	movl	-584(%rbp), %eax
	imull	-8(%rbp), %eax
	sall	$2, %eax
	movl	%eax, -48(%rbp)
	movq	-40(%rbp), %rcx
	leaq	-720(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	jpeg_read_scanlines
	movl	$0, -4(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L30
.L31:
	movq	-904(%rbp), %rax
	movq	40(%rax), %rax
	movl	-48(%rbp), %ecx
	movl	-12(%rbp), %edx
	addl	%ecx, %edx
	movl	%edx, %edx
	addq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movl	-4(%rbp), %ecx
	addl	$2, %ecx
	movl	%ecx, %ecx
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movq	-904(%rbp), %rax
	movq	40(%rax), %rax
	movl	-48(%rbp), %ecx
	movl	-12(%rbp), %edx
	addl	%ecx, %edx
	addl	$1, %edx
	movl	%edx, %edx
	addq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movl	-4(%rbp), %ecx
	addl	$1, %ecx
	movl	%ecx, %ecx
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movq	-904(%rbp), %rax
	movq	40(%rax), %rax
	movl	-48(%rbp), %ecx
	movl	-12(%rbp), %edx
	addl	%ecx, %edx
	addl	$2, %edx
	movl	%edx, %edx
	addq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$3, -4(%rbp)
	addl	$4, -12(%rbp)
.L30:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jb	.L31
	addl	$1, -8(%rbp)
.L29:
	movl	-580(%rbp), %eax
	cmpl	-8(%rbp), %eax
	ja	.L32
	movl	-584(%rbp), %edx
	movl	-580(%rbp), %eax
	imull	%edx, %eax
	leal	0(,%rax,4), %edx
	movq	-904(%rbp), %rax
	movl	%edx, 48(%rax)
	leaq	-720(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_finish_decompress
	leaq	-720(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_destroy_decompress
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	jmp	.L25
.L26:
	movq	-904(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rsi
	movl	$.LC5, %edi
	movl	$0, %eax
	call	printf
	nop
.L25:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	loadAssetItem, .-loadAssetItem
	.section	.rodata
.LC6:
	.string	"\n\n======== BENCHS ========\n"
.LC8:
	.string	"Total: %.9f\n"
.LC9:
	.string	"Memory: %d\n"
.LC10:
	.string	"\n======== BENCHS END ========"
	.text
	.globl	finishBench
	.type	finishBench, @function
finishBench:
.LFB33:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$144, %rsp
	call	getCycles
	movq	%rax, totale(%rip)
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	getrusage
	movl	$.LC6, %edi
	call	puts
	movq	totale(%rip), %rdx
	movq	totals(%rip), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	testq	%rax, %rax
	js	.L36
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L37
.L36:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L37:
	movsd	.LC7(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movl	$.LC8, %edi
	movl	$1, %eax
	call	printf
	movq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC9, %edi
	movl	$0, %eax
	call	printf
	movl	$.LC10, %edi
	call	puts
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE33:
	.size	finishBench, .-finishBench
	.globl	solveAffineMatrix
	.type	solveAffineMatrix, @function
solveAffineMatrix:
.LFB34:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$728, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -728(%rbp)
	movq	%rsi, -736(%rbp)
	movq	-736(%rbp), %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -560(%rbp)
	movq	-736(%rbp), %rax
	movsd	8(%rax), %xmm0
	movsd	%xmm0, -552(%rbp)
	movsd	.LC11(%rip), %xmm0
	movsd	%xmm0, -544(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -536(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -528(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -520(%rbp)
	movq	-736(%rbp), %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$64, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -512(%rbp)
	movq	-736(%rbp), %rax
	addq	$8, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$64, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -504(%rbp)
	movq	-736(%rbp), %rax
	movsd	16(%rax), %xmm0
	movsd	%xmm0, -496(%rbp)
	movq	-736(%rbp), %rax
	movsd	24(%rax), %xmm0
	movsd	%xmm0, -488(%rbp)
	movsd	.LC11(%rip), %xmm0
	movsd	%xmm0, -480(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -472(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -464(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -456(%rbp)
	movq	-736(%rbp), %rax
	addq	$16, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$80, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -448(%rbp)
	movq	-736(%rbp), %rax
	addq	$24, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$80, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -440(%rbp)
	movq	-736(%rbp), %rax
	movsd	32(%rax), %xmm0
	movsd	%xmm0, -432(%rbp)
	movq	-736(%rbp), %rax
	movsd	40(%rax), %xmm0
	movsd	%xmm0, -424(%rbp)
	movsd	.LC11(%rip), %xmm0
	movsd	%xmm0, -416(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -408(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -400(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -392(%rbp)
	movq	-736(%rbp), %rax
	addq	$32, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$96, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -384(%rbp)
	movq	-736(%rbp), %rax
	addq	$40, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$96, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -376(%rbp)
	movq	-736(%rbp), %rax
	movsd	48(%rax), %xmm0
	movsd	%xmm0, -368(%rbp)
	movq	-736(%rbp), %rax
	movsd	56(%rax), %xmm0
	movsd	%xmm0, -360(%rbp)
	movsd	.LC11(%rip), %xmm0
	movsd	%xmm0, -352(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -344(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -336(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -328(%rbp)
	movq	-736(%rbp), %rax
	addq	$48, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$112, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -320(%rbp)
	movq	-736(%rbp), %rax
	addq	$56, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$112, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -312(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -304(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -296(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -288(%rbp)
	movq	-736(%rbp), %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -280(%rbp)
	movq	-736(%rbp), %rax
	movsd	8(%rax), %xmm0
	movsd	%xmm0, -272(%rbp)
	movsd	.LC11(%rip), %xmm0
	movsd	%xmm0, -264(%rbp)
	movq	-736(%rbp), %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$72, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -256(%rbp)
	movq	-736(%rbp), %rax
	addq	$8, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$72, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -248(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -240(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -232(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -224(%rbp)
	movq	-736(%rbp), %rax
	movsd	16(%rax), %xmm0
	movsd	%xmm0, -216(%rbp)
	movq	-736(%rbp), %rax
	movsd	24(%rax), %xmm0
	movsd	%xmm0, -208(%rbp)
	movsd	.LC11(%rip), %xmm0
	movsd	%xmm0, -200(%rbp)
	movq	-736(%rbp), %rax
	addq	$16, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$88, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -192(%rbp)
	movq	-736(%rbp), %rax
	addq	$24, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$88, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -184(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -176(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -168(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -160(%rbp)
	movq	-736(%rbp), %rax
	movsd	32(%rax), %xmm0
	movsd	%xmm0, -152(%rbp)
	movq	-736(%rbp), %rax
	movsd	40(%rax), %xmm0
	movsd	%xmm0, -144(%rbp)
	movsd	.LC11(%rip), %xmm0
	movsd	%xmm0, -136(%rbp)
	movq	-736(%rbp), %rax
	addq	$32, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$104, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -128(%rbp)
	movq	-736(%rbp), %rax
	addq	$40, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$104, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -120(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -112(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
	movq	-736(%rbp), %rax
	movsd	48(%rax), %xmm0
	movsd	%xmm0, -88(%rbp)
	movq	-736(%rbp), %rax
	movsd	56(%rax), %xmm0
	movsd	%xmm0, -80(%rbp)
	movsd	.LC11(%rip), %xmm0
	movsd	%xmm0, -72(%rbp)
	movq	-736(%rbp), %rax
	addq	$48, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$112, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -64(%rbp)
	movq	-736(%rbp), %rax
	addq	$56, %rax
	movsd	(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movq	-736(%rbp), %rax
	addq	$112, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -56(%rbp)
	movq	-736(%rbp), %rax
	movsd	64(%rax), %xmm0
	movsd	%xmm0, -624(%rbp)
	movq	-736(%rbp), %rax
	movsd	80(%rax), %xmm0
	movsd	%xmm0, -616(%rbp)
	movq	-736(%rbp), %rax
	movsd	96(%rax), %xmm0
	movsd	%xmm0, -608(%rbp)
	movq	-736(%rbp), %rax
	movsd	112(%rax), %xmm0
	movsd	%xmm0, -600(%rbp)
	movq	-736(%rbp), %rax
	movsd	72(%rax), %xmm0
	movsd	%xmm0, -592(%rbp)
	movq	-736(%rbp), %rax
	movsd	88(%rax), %xmm0
	movsd	%xmm0, -584(%rbp)
	movq	-736(%rbp), %rax
	movsd	104(%rax), %xmm0
	movsd	%xmm0, -576(%rbp)
	movq	-736(%rbp), %rax
	movsd	120(%rax), %xmm0
	movsd	%xmm0, -568(%rbp)
	movl	$8, %edi
	call	gsl_vector_alloc
	movq	%rax, -32(%rbp)
	leaq	-672(%rbp), %rax
	leaq	-560(%rbp), %rsi
	movl	$8, %ecx
	movl	$8, %edx
	movq	%rax, %rdi
	call	gsl_matrix_view_array
	leaq	-720(%rbp), %rax
	leaq	-624(%rbp), %rcx
	movl	$8, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	gsl_vector_view_array
	movl	$8, %edi
	call	gsl_permutation_alloc
	movq	%rax, -40(%rbp)
	leaq	-44(%rbp), %rdx
	movq	-40(%rbp), %rcx
	leaq	-672(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	gsl_linalg_LU_decomp
	movq	-32(%rbp), %rcx
	leaq	-720(%rbp), %rdx
	movq	-40(%rbp), %rsi
	leaq	-672(%rbp), %rax
	movq	%rax, %rdi
	call	gsl_linalg_LU_solve
	movq	-32(%rbp), %rcx
	leaq	-720(%rbp), %rdx
	movq	-40(%rbp), %rsi
	leaq	-672(%rbp), %rax
	movq	%rax, %rdi
	call	gsl_linalg_LU_solve
	movb	$0, -17(%rbp)
	jmp	.L40
.L41:
	movzbl	-17(%rbp), %eax
	leaq	0(,%rax,8), %rdx
	movq	-728(%rbp), %rax
	leaq	(%rdx,%rax), %rbx
	movzbl	-17(%rbp), %edx
	movq	-32(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	gsl_vector_get
	movq	%xmm0, %rax
	movq	%rax, (%rbx)
	movzbl	-17(%rbp), %eax
	addl	$1, %eax
	movb	%al, -17(%rbp)
.L40:
	cmpb	$7, -17(%rbp)
	jbe	.L41
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	gsl_permutation_free
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	gsl_vector_free
	nop
	addq	$728, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE34:
	.size	solveAffineMatrix, .-solveAffineMatrix
	.globl	getAPoints
	.type	getAPoints, @function
getAPoints:
.LFB35:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%esi, %eax
	movq	%rdx, -16(%rbp)
	movq	%rcx, -24(%rbp)
	movw	%di, -4(%rbp)
	movw	%ax, -8(%rbp)
	movq	-16(%rbp), %rax
	movsd	(%rax), %xmm1
	movzwl	-4(%rbp), %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	mulsd	%xmm0, %xmm1
	movq	-16(%rbp), %rax
	addq	$8, %rax
	movsd	(%rax), %xmm2
	movzwl	-8(%rbp), %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	mulsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movq	-16(%rbp), %rax
	addq	$16, %rax
	movsd	(%rax), %xmm1
	addsd	%xmm1, %xmm0
	movq	-16(%rbp), %rax
	addq	$48, %rax
	movsd	(%rax), %xmm2
	movzwl	-4(%rbp), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sd	%eax, %xmm1
	mulsd	%xmm1, %xmm2
	movq	-16(%rbp), %rax
	addq	$56, %rax
	movsd	(%rax), %xmm3
	movzwl	-8(%rbp), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sd	%eax, %xmm1
	mulsd	%xmm3, %xmm1
	addsd	%xmm2, %xmm1
	movsd	.LC11(%rip), %xmm2
	addsd	%xmm2, %xmm1
	divsd	%xmm1, %xmm0
	call	trunc
	cvttsd2si	%xmm0, %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movw	%dx, (%rax)
	movq	-16(%rbp), %rax
	addq	$24, %rax
	movsd	(%rax), %xmm1
	movzwl	-4(%rbp), %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	mulsd	%xmm0, %xmm1
	movq	-16(%rbp), %rax
	addq	$32, %rax
	movsd	(%rax), %xmm2
	movzwl	-8(%rbp), %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	mulsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movq	-16(%rbp), %rax
	addq	$40, %rax
	movsd	(%rax), %xmm1
	addsd	%xmm1, %xmm0
	movq	-16(%rbp), %rax
	addq	$48, %rax
	movsd	(%rax), %xmm2
	movzwl	-4(%rbp), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sd	%eax, %xmm1
	mulsd	%xmm1, %xmm2
	movq	-16(%rbp), %rax
	addq	$56, %rax
	movsd	(%rax), %xmm3
	movzwl	-8(%rbp), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sd	%eax, %xmm1
	mulsd	%xmm3, %xmm1
	addsd	%xmm2, %xmm1
	movsd	.LC11(%rip), %xmm2
	addsd	%xmm2, %xmm1
	divsd	%xmm1, %xmm0
	call	trunc
	cvttsd2si	%xmm0, %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movw	%dx, 2(%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE35:
	.size	getAPoints, .-getAPoints
	.globl	doATransform
	.type	doATransform, @function
doATransform:
.LFB36:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$256, %rsp
	movq	%rdi, -232(%rbp)
	movl	%esi, %eax
	movq	%rdx, -248(%rbp)
	movb	%al, -236(%rbp)
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %eax
	pxor	%xmm2, %xmm2
	cvtsi2sd	%eax, %xmm2
	movsd	%xmm2, -256(%rbp)
	movzbl	-236(%rbp), %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	.LC14(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	call	tan
	mulsd	-256(%rbp), %xmm0
	call	floor
	cvttsd2si	%xmm0, %eax
	movw	%ax, -10(%rbp)
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -160(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -152(%rbp)
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -144(%rbp)
	movq	-232(%rbp), %rax
	movzwl	34(%rax), %eax
	movzwl	%ax, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -136(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -128(%rbp)
	movq	-232(%rbp), %rax
	movzwl	34(%rax), %eax
	movzwl	%ax, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -120(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -112(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %eax
	movzwl	-10(%rbp), %edx
	addl	%edx, %edx
	subl	%edx, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -96(%rbp)
	movzwl	-10(%rbp), %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -88(%rbp)
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %eax
	movzwl	-10(%rbp), %edx
	addl	%edx, %edx
	subl	%edx, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -80(%rbp)
	movq	-232(%rbp), %rax
	movzwl	34(%rax), %eax
	movzwl	%ax, %edx
	movzwl	-10(%rbp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -72(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -64(%rbp)
	movq	-232(%rbp), %rax
	movzwl	34(%rax), %eax
	movzwl	%ax, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -56(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -40(%rbp)
	leaq	-160(%rbp), %rdx
	leaq	-224(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	solveAffineMatrix
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L46
.L49:
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %edi
	movl	-8(%rbp), %eax
	movl	$0, %edx
	divl	%edi
	movl	%eax, %eax
	testq	%rax, %rax
	js	.L47
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L48
.L47:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L48:
	call	floor
	cvttsd2si	%xmm0, %eax
	movw	%ax, -12(%rbp)
	movl	-8(%rbp), %eax
	movl	%eax, %edx
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	imulw	-12(%rbp), %ax
	subl	%eax, %edx
	movl	%edx, %eax
	movw	%ax, -14(%rbp)
	movzwl	-12(%rbp), %esi
	movzwl	-14(%rbp), %eax
	leaq	-18(%rbp), %rcx
	leaq	-224(%rbp), %rdx
	movl	%eax, %edi
	call	getAPoints
	movzwl	-18(%rbp), %eax
	movzwl	%ax, %edx
	movzwl	-16(%rbp), %eax
	movzwl	%ax, %ecx
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %eax
	imull	%ecx, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movslq	%eax, %rdx
	movq	-248(%rbp), %rax
	addq	%rax, %rdx
	movq	-232(%rbp), %rax
	movq	40(%rax), %rcx
	movl	-4(%rbp), %eax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movzwl	-18(%rbp), %eax
	movzwl	%ax, %edx
	movzwl	-16(%rbp), %eax
	movzwl	%ax, %ecx
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %eax
	imull	%ecx, %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-248(%rbp), %rax
	addq	%rax, %rdx
	movq	-232(%rbp), %rax
	movq	40(%rax), %rax
	movl	-4(%rbp), %ecx
	addl	$1, %ecx
	movl	%ecx, %ecx
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movzwl	-18(%rbp), %eax
	movzwl	%ax, %edx
	movzwl	-16(%rbp), %eax
	movzwl	%ax, %ecx
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %eax
	imull	%ecx, %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-248(%rbp), %rax
	addq	%rax, %rdx
	movq	-232(%rbp), %rax
	movq	40(%rax), %rax
	movl	-4(%rbp), %ecx
	addl	$2, %ecx
	movl	%ecx, %ecx
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movzwl	-18(%rbp), %eax
	movzwl	%ax, %edx
	movzwl	-16(%rbp), %eax
	movzwl	%ax, %ecx
	movq	-232(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %eax
	imull	%ecx, %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	3(%rax), %rdx
	movq	-248(%rbp), %rax
	addq	%rax, %rdx
	movq	-232(%rbp), %rax
	movq	40(%rax), %rax
	movl	-4(%rbp), %ecx
	addl	$3, %ecx
	movl	%ecx, %ecx
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$4, -4(%rbp)
	addl	$1, -8(%rbp)
.L46:
	movq	-232(%rbp), %rax
	movl	48(%rax), %eax
	cmpl	-4(%rbp), %eax
	ja	.L49
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE36:
	.size	doATransform, .-doATransform
	.comm	playerIndex,2,2
	.section	.rodata
.LC15:
	.string	"Render: %.9f\n"
	.text
	.globl	draw3d
	.type	draw3d, @function
draw3d:
.LFB37:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	call	getCycles
	movq	%rax, start(%rip)
	movl	$192, gc_mask(%rip)
	movl	$1, gc_val+40(%rip)
	movl	$2, gc_val+44(%rip)
	movl	gc_mask(%rip), %eax
	movl	%eax, %edx
	movq	window(%rip), %rsi
	movq	session(%rip), %rax
	movl	$gc_val, %ecx
	movq	%rax, %rdi
	call	XCreateGC
	movq	%rax, gc(%rip)
	movq	session(%rip), %rax
	movq	232(%rax), %rax
	movzbl	cur_screen(%rip), %edx
	movzbl	%dl, %edx
	salq	$7, %rdx
	addq	%rdx, %rax
	movq	96(%rax), %rdx
	movq	gc(%rip), %rcx
	movq	session(%rip), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	XSetBackground
	movq	gc(%rip), %rcx
	movq	session(%rip), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	XSetFillStyle
	movq	gc(%rip), %rsi
	movq	session(%rip), %rax
	movl	$1, %r9d
	movl	$2, %r8d
	movl	$0, %ecx
	movl	$1, %edx
	movq	%rax, %rdi
	call	XSetLineAttributes
	movq	session(%rip), %rax
	movq	232(%rax), %rdx
	movq	session(%rip), %rax
	movl	224(%rax), %eax
	cltq
	salq	$7, %rax
	addq	%rdx, %rax
	movq	64(%rax), %rax
	movq	%rax, visual(%rip)
	movq	visual(%rip), %rdx
	movq	window(%rip), %rsi
	movq	session(%rip), %rax
	movl	$0, %ecx
	movq	%rax, %rdi
	call	XCreateColormap
	movq	%rax, colormap(%rip)
	movw	$31875, -24(%rbp)
	movw	$31875, -22(%rbp)
	movw	$31875, -20(%rbp)
	movq	colormap(%rip), %rcx
	movq	session(%rip), %rax
	leaq	-32(%rbp), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	XAllocColor
	movq	-32(%rbp), %rdx
	movq	gc(%rip), %rcx
	movq	session(%rip), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	XSetForeground
	movq	gc(%rip), %rdx
	movq	window(%rip), %rsi
	movq	session(%rip), %rax
	subq	$8, %rsp
	pushq	$240
	movl	$640, %r9d
	movl	$0, %r8d
	movl	$0, %ecx
	movq	%rax, %rdi
	call	XFillRectangle
	addq	$16, %rsp
	movw	$12495, -40(%rbp)
	movw	$12495, -38(%rbp)
	movw	$12495, -36(%rbp)
	movq	colormap(%rip), %rcx
	movq	session(%rip), %rax
	leaq	-48(%rbp), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	XAllocColor
	movq	-48(%rbp), %rdx
	movq	gc(%rip), %rcx
	movq	session(%rip), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	XSetForeground
	movq	gc(%rip), %rdx
	movq	window(%rip), %rsi
	movq	session(%rip), %rax
	subq	$8, %rsp
	pushq	$480
	movl	$640, %r9d
	movl	$240, %r8d
	movl	$0, %ecx
	movq	%rax, %rdi
	call	XFillRectangle
	addq	$16, %rsp
	movzwl	level+8(%rip), %eax
	movzwl	%ax, %edx
	movq	level(%rip), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	getPlayer
	movw	%ax, playerIndex(%rip)
	leaq	-56(%rbp), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	getAssetById
	movq	-56(%rbp), %rax
	movl	48(%rax), %eax
	movl	%eax, %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -8(%rbp)
	movq	-56(%rbp), %rax
	movq	-8(%rbp), %rdx
	movl	$10, %esi
	movq	%rax, %rdi
	call	doATransform
	movq	-56(%rbp), %rax
	movzwl	34(%rax), %eax
	movzwl	%ax, %ecx
	movq	-56(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %edx
	movq	visual(%rip), %rsi
	movq	session(%rip), %rax
	movq	-8(%rbp), %rdi
	pushq	$0
	pushq	$32
	pushq	%rcx
	pushq	%rdx
	movq	%rdi, %r9
	movl	$0, %r8d
	movl	$2, %ecx
	movl	$24, %edx
	movq	%rax, %rdi
	call	XCreateImage
	addq	$32, %rsp
	movq	%rax, -16(%rbp)
	movq	-56(%rbp), %rax
	movzwl	34(%rax), %eax
	movzwl	%ax, %r8d
	movq	-56(%rbp), %rax
	movzwl	32(%rax), %eax
	movzwl	%ax, %edi
	movq	gc(%rip), %rdx
	movq	window(%rip), %rsi
	movq	session(%rip), %rax
	movq	-16(%rbp), %rcx
	pushq	%r8
	pushq	%rdi
	pushq	$0
	pushq	$0
	movl	$0, %r9d
	movl	$0, %r8d
	movq	%rax, %rdi
	call	XPutImage
	addq	$32, %rsp
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free
	call	getCycles
	movq	%rax, end(%rip)
	movq	end(%rip), %rdx
	movq	start(%rip), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	testq	%rax, %rax
	js	.L52
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L53
.L52:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L53:
	movsd	.LC7(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movl	$.LC15, %edi
	movl	$1, %eax
	call	printf
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE37:
	.size	draw3d, .-draw3d
	.comm	session,8,8
	.comm	window,8,8
	.comm	cur_event,192,32
	.comm	cur_screen,1,1
	.comm	gc,8,8
	.comm	gc_mask,4,4
	.comm	gc_val,128,32
	.comm	start,8,8
	.comm	end,8,8
	.comm	totals,8,8
	.comm	totale,8,8
	.comm	visual,8,8
	.comm	colormap,8,8
	.section	.rodata
.LC16:
	.string	"../maps/unix1.json.bin"
.LC17:
	.string	"Cannot open server\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB38:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	call	getCycles
	movq	%rax, totals(%rip)
	movl	$.LC16, %edi
	call	loadTileMap
	call	loadAssets
	movl	$0, %edi
	call	XOpenDisplay
	movq	%rax, session(%rip)
	movq	session(%rip), %rax
	testq	%rax, %rax
	jne	.L56
	movq	__stderrp(%rip), %rax
	movq	%rax, %rcx
	movl	$19, %edx
	movl	$1, %esi
	movl	$.LC17, %edi
	call	fwrite
	movl	$1, %edi
	call	exit
.L56:
	movq	session(%rip), %rax
	movl	224(%rax), %eax
	movb	%al, cur_screen(%rip)
	movq	session(%rip), %rax
	movq	232(%rax), %rax
	movzbl	cur_screen(%rip), %edx
	movzbl	%dl, %edx
	salq	$7, %rdx
	addq	%rdx, %rax
	movq	88(%rax), %rcx
	movq	session(%rip), %rax
	movq	232(%rax), %rax
	movzbl	cur_screen(%rip), %edx
	movzbl	%dl, %edx
	salq	$7, %rdx
	addq	%rdx, %rax
	movq	96(%rax), %rdx
	movq	session(%rip), %rax
	movq	232(%rax), %rax
	movzbl	cur_screen(%rip), %esi
	movzbl	%sil, %esi
	salq	$7, %rsi
	addq	%rsi, %rax
	movq	16(%rax), %rsi
	movq	session(%rip), %rax
	subq	$8, %rsp
	pushq	%rcx
	pushq	%rdx
	pushq	$0
	movl	$480, %r9d
	movl	$640, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	XCreateSimpleWindow
	addq	$32, %rsp
	movq	%rax, window(%rip)
	movq	window(%rip), %rcx
	movq	session(%rip), %rax
	movl	$32769, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	XSelectInput
	movq	window(%rip), %rdx
	movq	session(%rip), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	XMapWindow
	movq	session(%rip), %rax
	movq	%rax, %rdi
	call	XFlush
.L60:
	movq	session(%rip), %rax
	movl	$cur_event, %esi
	movq	%rax, %rdi
	call	XNextEvent
	movl	cur_event(%rip), %eax
	cmpl	$12, %eax
	jne	.L57
	call	draw3d
	call	finishBench
	jmp	.L60
.L57:
	movl	cur_event(%rip), %eax
	cmpl	$2, %eax
	je	.L63
	jmp	.L60
.L63:
	nop
	movq	session(%rip), %rax
	movq	%rax, %rdi
	call	XCloseDisplay
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE38:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC7:
	.long	1610612736
	.long	1105859512
	.align 8
.LC11:
	.long	0
	.long	1072693248
	.align 16
.LC13:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 8
.LC14:
	.long	2723323193
	.long	1066524486
	.ident	"GCC: (FreeBSD Ports Collection) 6.4.0"
	.section	.note.GNU-stack,"",@progbits
