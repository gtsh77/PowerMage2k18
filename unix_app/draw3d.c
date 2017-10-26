#include "lib.c"

dbyte playerIndex;

void draw3d(void)
{
	
	//
	// === GC INIT ===
	//
	//set background
	XSetBackground(session, gc, BlackPixel(session,cur_screen));
	//set fill style
	XSetFillStyle(session, gc, FillSolid);
	//set line attrs
	XSetLineAttributes(session, gc, 1, LineSolid, CapRound, JoinRound);

	//
	// === DRAW SHAPES ===
	//

	//multi-lines
	// XPoint points[] = 
	// {
	// 	{0,130},
	// 	{15,130},
	// 	{0,160},
	// 	{0,130}
	// };	

	//XDrawLines(session, window, gc, points, 4, CoordModeOrigin);
	//XFillPolygon(session, window, gc, points, 4, Complex, CoordModeOrigin);


	//draw single line
	//XDrawLine(session, window, gc, 0, 120, 100, 120);

	//draw & fill rectangle
	//XDrawRectangle(session, window, gc, 0, 0, 100, 100);
	//XFillRectangle(session, window, gc, 0, 0, 320, 320);

	//
	// === DRAW CEIL/FLOOR ===
	//
	
	colormap = XCreateColormap(session, window, visual, AllocNone);
	

	XColor ceil_color, floor_color;

	//CEILCOLOR
	ceil_color.red = BIT16(125);
	ceil_color.green = BIT16(125);
	ceil_color.blue = BIT16(125);

	XAllocColor(session, colormap, &ceil_color);
	XSetForeground(session, gc, ceil_color.pixel);

	XFillRectangle(session, window, gc, 0, 0, FIELDW, FIELDH/2);

	//FLOORCOLOR
	floor_color.red = BIT16(49);
	floor_color.green = BIT16(49);
	floor_color.blue = BIT16(49);

	XAllocColor(session, colormap, &floor_color);
	XSetForeground(session, gc, floor_color.pixel);

	XFillRectangle(session, window, gc, 0, (FIELDH/2), FIELDW, FIELDH);

	//
	// === DRAW FENCE BEHIN PLAYER
	//

	playerIndex = getPlayer(level.map,level.length);
	//printf("%d\n",playerIndex);
	#ifdef SB
	start = getCycles();
	#endif

	//test visualisation

	drawAsset(12, 1.245, 1, 15, CENTERX-5*128/2 + 8, CENTERY-256*1.245/2);
	drawAsset(12, 0.98, 1, 15, CENTERX-4*128/2 + 4, CENTERY-256*0.98/2);

	drawAsset(12, 0.72, 1, 0, CENTERX-128/2, CENTERY-256*0.72/2);
	drawAsset(12, 0.72, 1, 0, CENTERX+128/2, CENTERY-256*0.72/2);
	drawAsset(12, 0.72, 1, 0, CENTERX-3*128/2, CENTERY-256*0.72/2);	

	//
	// === BENCH STUFF
	//

	#ifdef SB
	end = getCycles();
	printf("Render: %.9f\n",(double)(end-start)/3.5e9);
	#endif
	return;
}






