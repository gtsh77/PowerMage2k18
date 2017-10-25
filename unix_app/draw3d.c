#include "lib.c"

dbyte playerIndex;

void draw3d(void)
{
	start = getCycles();
	//
	// === GC INIT ===
	//
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
	visual = DefaultVisual(session, DefaultScreen(session));
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

	//get asset address
	struct asset *asset;
    getAssetById(10,&asset);
    //create empty buffer
    byte *bitmap;
    bitmap = (byte *)malloc(sizeof(byte)*asset->data_length);
    //start transform
    doATransform(asset, 10, bitmap);
    //alloc memory on x-server
	XImage *xbitmap;
	xbitmap = XCreateImage(session, visual, 24, ZPixmap, 0, bitmap, asset->width, asset->height, 32, 0);
	//transfer and render
	XPutImage(session, window, gc, xbitmap, 0, 0, 0, 0, asset->width, asset->height);
	//free mem
	free(bitmap);

	//
	// === BENCH STUFF
	//

	end = getCycles();
	printf("Render: %.9f\n",(double)(end-start)/3.5e9);
	return;
}






