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
.LFB23:
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
.LFE23:
	.size	getCycles, .-getCycles
	.globl	getPlayer
	.type	getPlayer, @function
getPlayer:
.LFB24:
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
.LFE24:
	.size	getPlayer, .-getPlayer
	.section	.rodata
.LC0:
	.string	"rb"
	.align 8
.LC1:
	.string	"error: can't read world file: %s\n"
.LC2:
	.string	"world: %p (%d)\n"
	.text
	.globl	loadTileMap
	.type	loadTileMap, @function
loadTileMap:
.LFB25:
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
	movzwl	level+8(%rip), %eax
	movzwl	%ax, %edx
	movq	level(%rip), %rax
	movq	%rax, %rsi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	nop
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	loadTileMap, .-loadTileMap
	.section	.rodata
.LC3:
	.string	"env %d\n"
	.text
	.globl	seekAssets
	.type	seekAssets, @function
seekAssets:
.LFB26:
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
	movl	$.LC3, %edi
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
.LFE26:
	.size	seekAssets, .-seekAssets
	.globl	getAssetById
	.type	getAssetById, @function
getAssetById:
.LFB27:
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
.LFE27:
	.size	getAssetById, .-getAssetById
	.globl	loadAssets
	.type	loadAssets, @function
loadAssets:
.LFB28:
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
.LFE28:
	.size	loadAssets, .-loadAssets
	.section	.rodata
.LC4:
	.string	"jpg"
	.align 8
.LC5:
	.string	"error: can't read asset file: %s\n"
	.align 8
.LC6:
	.string	"error: unsupported extension: %s\n"
	.text
	.globl	loadAssetItem
	.type	loadAssetItem, @function
loadAssetItem:
.LFB29:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$896, %rsp
	movq	%rdi, -888(%rbp)
	movq	-888(%rbp), %rax
	movq	24(%rax), %rax
	movl	$46, %esi
	movq	%rax, %rdi
	call	strrchr
	addq	$1, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movl	$.LC4, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L26
	leaq	-880(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_std_error
	movq	%rax, -704(%rbp)
	leaq	-704(%rbp), %rax
	movl	$664, %edx
	movl	$90, %esi
	movq	%rax, %rdi
	call	jpeg_CreateDecompress
	movq	-888(%rbp), %rax
	movq	24(%rax), %rax
	movl	$.LC0, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L27
	movq	-888(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rsi
	movl	$.LC5, %edi
	movl	$0, %eax
	call	printf
	jmp	.L25
.L27:
	movq	-24(%rbp), %rdx
	leaq	-704(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	jpeg_stdio_src
	leaq	-704(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	jpeg_read_header
	leaq	-704(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_start_decompress
	movl	$1, %edi
	call	malloc
	movq	%rax, -32(%rbp)
	movl	-568(%rbp), %eax
	movl	-556(%rbp), %edx
	imull	%edx, %eax
	movl	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, (%rax)
	movl	-36(%rbp), %eax
	movl	-564(%rbp), %edx
	movl	%edx, %edx
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, %rdx
	movq	-888(%rbp), %rax
	movq	%rdx, 40(%rax)
	movl	-568(%rbp), %eax
	movl	%eax, %edx
	movq	-888(%rbp), %rax
	movw	%dx, 32(%rax)
	movl	-564(%rbp), %eax
	movl	%eax, %edx
	movq	-888(%rbp), %rax
	movw	%dx, 34(%rax)
	movq	-888(%rbp), %rax
	movq	-16(%rbp), %rdx
	movq	%rdx, 16(%rax)
	jmp	.L29
.L32:
	movq	-32(%rbp), %rcx
	leaq	-704(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	jpeg_read_scanlines
	movl	$0, -4(%rbp)
	jmp	.L30
.L31:
	movq	-888(%rbp), %rax
	movq	40(%rax), %rdx
	movl	-536(%rbp), %eax
	imull	-4(%rbp), %eax
	movl	%eax, %eax
	addq	%rax, %rdx
	movq	-32(%rbp), %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movq	-888(%rbp), %rax
	movq	40(%rax), %rdx
	movl	-536(%rbp), %eax
	imull	-4(%rbp), %eax
	addl	$1, %eax
	movl	%eax, %eax
	addq	%rax, %rdx
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movl	-4(%rbp), %ecx
	addl	$1, %ecx
	movl	%ecx, %ecx
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movq	-888(%rbp), %rax
	movq	40(%rax), %rdx
	movl	-536(%rbp), %eax
	imull	-4(%rbp), %eax
	addl	$2, %eax
	movl	%eax, %eax
	addq	%rax, %rdx
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movl	-4(%rbp), %ecx
	addl	$2, %ecx
	movl	%ecx, %ecx
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$3, -4(%rbp)
.L30:
	movl	-4(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jb	.L31
.L29:
	movl	-536(%rbp), %edx
	movl	-564(%rbp), %eax
	cmpl	%eax, %edx
	jb	.L32
	movl	-536(%rbp), %eax
	imull	-36(%rbp), %eax
	movl	%eax, %edx
	movq	-888(%rbp), %rax
	movl	%edx, 48(%rax)
	leaq	-704(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_finish_decompress
	leaq	-704(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_destroy_decompress
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	jmp	.L25
.L26:
	movq	-888(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rsi
	movl	$.LC6, %edi
	movl	$0, %eax
	call	printf
	nop
.L25:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	loadAssetItem, .-loadAssetItem
	.comm	playerIndex,2,2
	.section	.rodata
.LC8:
	.string	"Render: %.9f\n"
	.text
	.globl	draw1
	.type	draw1, @function
draw1:
.LFB30:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
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
	movw	$-511, -8(%rbp)
	movw	$0, -6(%rbp)
	movw	$0, -4(%rbp)
	movq	colormap(%rip), %rcx
	movq	session(%rip), %rax
	leaq	-16(%rbp), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	XAllocColor
	movq	-16(%rbp), %rdx
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
	movw	$0, -24(%rbp)
	movw	$-511, -22(%rbp)
	movw	$0, -20(%rbp)
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
	call	getCycles
	movq	%rax, end(%rip)
	movq	end(%rip), %rdx
	movq	start(%rip), %rax
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
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	draw1, .-draw1
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
	.comm	rusage,144,32
	.section	.rodata
.LC9:
	.string	"../maps/unix1.json.bin"
.LC10:
	.string	"Cannot open server\n"
.LC11:
	.string	"Total: %.9f\n"
.LC12:
	.string	"Memory: %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB31:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	call	getCycles
	movq	%rax, totals(%rip)
	movl	$.LC9, %edi
	call	loadTileMap
	call	loadAssets
	movl	$0, %edi
	call	XOpenDisplay
	movq	%rax, session(%rip)
	movq	session(%rip), %rax
	testq	%rax, %rax
	jne	.L40
	movq	__stderrp(%rip), %rax
	movq	%rax, %rcx
	movl	$19, %edx
	movl	$1, %esi
	movl	$.LC10, %edi
	call	fwrite
	movl	$1, %edi
	call	exit
.L40:
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
.L46:
	movq	session(%rip), %rax
	movl	$cur_event, %esi
	movq	%rax, %rdi
	call	XNextEvent
	movl	cur_event(%rip), %eax
	cmpl	$12, %eax
	jne	.L41
	call	draw1
	call	getCycles
	movq	%rax, totale(%rip)
	movl	$rusage, %esi
	movl	$0, %edi
	call	getrusage
	movq	totale(%rip), %rdx
	movq	totals(%rip), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	testq	%rax, %rax
	js	.L42
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L43
.L42:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L43:
	movsd	.LC7(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movl	$.LC11, %edi
	movl	$1, %eax
	call	printf
	movq	rusage+32(%rip), %rax
	movq	%rax, %rsi
	movl	$.LC12, %edi
	movl	$0, %eax
	call	printf
	jmp	.L46
.L41:
	movl	cur_event(%rip), %eax
	cmpl	$2, %eax
	je	.L49
	jmp	.L46
.L49:
	nop
	movq	session(%rip), %rax
	movq	%rax, %rdi
	call	XCloseDisplay
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC7:
	.long	1610612736
	.long	1105859512
	.ident	"GCC: (FreeBSD Ports Collection) 6.4.0"
	.section	.note.GNU-stack,"",@progbits
