	.file	"main.c"
	.comm	level,16,16
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
.LC1:
	.string	"../maps/unix1.json.bin"
.LC2:
	.string	"can't read lvl file"
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
	subq	$16, %rsp
	movl	$.LC0, %esi
	movl	$.LC1, %edi
	call	fopen
	movq	%rax, -8(%rbp)
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
	cmpq	$0, -8(%rbp)
	jne	.L9
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	jmp	.L8
.L9:
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
	.comm	playerIndex,2,2
	.section	.rodata
.LC3:
	.string	"%d\n"
.LC5:
	.string	"Render: %.9f\n"
	.text
	.globl	draw1
	.type	draw1, @function
draw1:
.LFB10:
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
	movl	$.LC3, %edi
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
	js	.L13
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L14
.L13:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L14:
	movsd	.LC4(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movl	$.LC5, %edi
	movl	$1, %eax
	call	printf
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
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
.LC6:
	.string	"Cannot open server\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	call	loadTileMap
	movl	$0, %edi
	call	XOpenDisplay
	movq	%rax, session(%rip)
	movq	session(%rip), %rax
	testq	%rax, %rax
	jne	.L17
	movq	__stderrp(%rip), %rax
	movq	%rax, %rcx
	movl	$19, %edx
	movl	$1, %esi
	movl	$.LC6, %edi
	call	fwrite
	movl	$1, %edi
	call	exit
.L17:
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
.L21:
	movq	session(%rip), %rax
	movl	$cur_event, %esi
	movq	%rax, %rdi
	call	XNextEvent
	movl	cur_event(%rip), %eax
	cmpl	$12, %eax
	jne	.L18
	call	draw1
	jmp	.L21
.L18:
	movl	cur_event(%rip), %eax
	cmpl	$2, %eax
	je	.L24
	jmp	.L21
.L24:
	nop
	movq	session(%rip), %rax
	movq	%rax, %rdi
	call	XCloseDisplay
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC4:
	.long	1610612736
	.long	1105859512
	.ident	"GCC: (FreeBSD Ports Collection) 6.4.0"
	.section	.note.GNU-stack,"",@progbits
