void draw1(void)
{
	start = getCycles();
	//
	// === GC INIT ===
	//
	//XFillRectangle(session, window, DefaultGC(session, cur_screen), 20, 20, 10, 10);
            //XDrawString(session, window, DefaultGC(session, cur_screen), 50, 50, "Hello, World!", strlen("Hello, World!"));

	//set graphical context mask
	gc_mask = GCCapStyle | GCJoinStyle;
	//set gc vals
	gc_val.cap_style = CapButt;
	gc_val.join_style = JoinBevel;
	//create gc
	gc = XCreateGC(session, window, gc_mask, &gc_val);
	//printf("%d\n",gc);
	//set foreground
	//XSetForeground(session, gc, WhitePixel(session,cur_screen));
	//set background
	XSetBackground(session, gc, BlackPixel(session,cur_screen));
	//set fill style
	XSetFillStyle(session, gc, FillSolid);
	//set line attrs
	XSetLineAttributes(session, gc, 2, LineSolid, CapRound, JoinRound);

	//
	// === DRAW SHAPES ===
	//

	//multi-lines
	XPoint points[] = 
	{
		{0,130},
		{15,130},
		{0,160},
		{0,130}
	};

	//XDrawLines(session, window, gc, points, 4, CoordModeOrigin);
	//XFillPolygon(session, window, gc, points, 4, Complex, CoordModeOrigin);


	//draw single line
	//XDrawLine(session, window, gc, 0, 120, 100, 120);

	//draw & fill rectangle
	//XDrawRectangle(session, window, gc, 0, 0, 100, 100);
	XFillRectangle(session, window, gc, 0, 0, 320, 320);


	//get core freq
	// long_u start, end;
	// start = getCycles();
	// sleep(1);
	end = getCycles();



	printf("%ld\n",(long_u)(end-start));
	printf("%.9f\n",(double)(getCycles()-start)/3.5e9);

}






