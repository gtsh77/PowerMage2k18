	.file	"main.c"
	.comm	level,16,16
	.comm	gameObject,240,32
	.text
	.globl	getCycles
	.type	getCycles, @function
getCycles:
.LFB7:
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
.LFE7:
	.size	getCycles, .-getCycles
	.globl	getPlayer
	.type	getPlayer, @function
getPlayer:
.LFB8:
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
.LFE8:
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
.LFB9:
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
.LFE9:
	.size	loadTileMap, .-loadTileMap
	.section	.rodata
.LC2:
	.string	"jpg"
	.align 8
.LC3:
	.string	"error: can't read asset file: %s\n"
	.text
	.globl	loadAsset
	.type	loadAsset, @function
loadAsset:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$912, %rsp
	movq	%rdi, -888(%rbp)
	movq	%rsi, -896(%rbp)
	movq	%rdx, -904(%rbp)
	cmpq	$.LC2, -888(%rbp)
	jne	.L21
	leaq	-880(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_std_error
	movq	%rax, -704(%rbp)
	leaq	-704(%rbp), %rax
	movl	$664, %edx
	movl	$90, %esi
	movq	%rax, %rdi
	call	jpeg_CreateDecompress
	movq	-896(%rbp), %rax
	movl	$.LC0, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L14
	movq	-896(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	jmp	.L21
.L14:
	movq	-16(%rbp), %rdx
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
	movl	-564(%rbp), %eax
	movl	%eax, %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -24(%rbp)
	movl	-568(%rbp), %eax
	movl	%eax, %edx
	movl	-556(%rbp), %eax
	cltq
	imull	%edx, %eax
	movw	%ax, -26(%rbp)
	movzwl	-26(%rbp), %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, (%rax)
	movzwl	-26(%rbp), %edx
	movl	-564(%rbp), %eax
	imull	%edx, %eax
	movl	%eax, %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, %rdx
	movq	-904(%rbp), %rax
	movq	%rdx, 16(%rax)
	jmp	.L16
.L19:
	movq	-24(%rbp), %rcx
	leaq	-704(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	jpeg_read_scanlines
	movw	$0, -2(%rbp)
	jmp	.L17
.L18:
	movq	-904(%rbp), %rax
	movq	16(%rax), %rax
	movl	-536(%rbp), %ecx
	movzwl	-2(%rbp), %edx
	imull	%ecx, %edx
	movl	%edx, %edx
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rcx
	movzwl	-2(%rbp), %eax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movq	-904(%rbp), %rax
	movq	16(%rax), %rax
	movl	-536(%rbp), %ecx
	movzwl	-2(%rbp), %edx
	imull	%ecx, %edx
	addl	$1, %edx
	movl	%edx, %edx
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movzwl	-2(%rbp), %ecx
	addq	$1, %rcx
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movq	-904(%rbp), %rax
	movq	16(%rax), %rax
	movl	-536(%rbp), %ecx
	movzwl	-2(%rbp), %edx
	imull	%ecx, %edx
	addl	$2, %edx
	movl	%edx, %edx
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movzwl	-2(%rbp), %ecx
	addq	$2, %rcx
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addw	$3, -2(%rbp)
.L17:
	movzwl	-2(%rbp), %eax
	cmpw	-26(%rbp), %ax
	jb	.L18
.L16:
	movl	-536(%rbp), %edx
	movl	-564(%rbp), %eax
	cmpl	%eax, %edx
	jb	.L19
	movq	-904(%rbp), %rax
	movq	-888(%rbp), %rdx
	movq	%rdx, (%rax)
	movzwl	-26(%rbp), %edx
	movl	-564(%rbp), %eax
	imull	%eax, %edx
	movq	-904(%rbp), %rax
	movl	%edx, 24(%rax)
	leaq	-704(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_finish_decompress
	leaq	-704(%rbp), %rax
	movq	%rax, %rdi
	call	jpeg_destroy_decompress
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	nop
.L21:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	loadAsset, .-loadAsset
	.comm	playerIndex,2,2
	.section	.rodata
.LC4:
	.string	"%d\n"
.LC6:
	.string	"Render: %.9f\n"
	.text
	.globl	draw1
	.type	draw1, @function
draw1:
.LFB11:
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
	movzwl	playerIndex(%rip), %eax
	movzwl	%ax, %eax
	movl	%eax, %esi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
	call	getCycles
	movq	%rax, end(%rip)
	call	getCycles
	movq	%rax, %rdx
	movq	start(%rip), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	testq	%rax, %rax
	js	.L23
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L24
.L23:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L24:
	movsd	.LC5(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movl	$.LC6, %edi
	movl	$1, %eax
	call	printf
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
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
	.comm	visual,8,8
	.comm	colormap,8,8
	.section	.rodata
.LC7:
	.string	"../maps/unix1.json.bin"
.LC8:
	.string	"../assets/current/brick1.jpg"
.LC9:
	.string	"Cannot open server\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	$.LC7, %edi
	call	loadTileMap
	leaq	-32(%rbp), %rax
	movq	%rax, %rdx
	movl	$.LC8, %esi
	movl	$.LC2, %edi
	call	loadAsset
	movl	$0, %edi
	call	XOpenDisplay
	movq	%rax, session(%rip)
	movq	session(%rip), %rax
	testq	%rax, %rax
	jne	.L27
	movq	__stderrp(%rip), %rax
	movq	%rax, %rcx
	movl	$19, %edx
	movl	$1, %esi
	movl	$.LC9, %edi
	call	fwrite
	movl	$1, %edi
	call	exit
.L27:
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
.L31:
	movq	session(%rip), %rax
	movl	$cur_event, %esi
	movq	%rax, %rdi
	call	XNextEvent
	movl	cur_event(%rip), %eax
	cmpl	$12, %eax
	jne	.L28
	call	draw1
	jmp	.L31
.L28:
	movl	cur_event(%rip), %eax
	cmpl	$2, %eax
	je	.L34
	jmp	.L31
.L34:
	nop
	movq	session(%rip), %rax
	movq	%rax, %rdi
	call	XCloseDisplay
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC5:
	.long	1610612736
	.long	1105859512
	.ident	"GCC: (FreeBSD Ports Collection) 6.4.0"
	.section	.note.GNU-stack,"",@progbits
