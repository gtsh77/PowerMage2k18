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
	XSetForeground(session, gc, BlackPixel(session,cur_screen));

	XFillRectangle(session, window, gc, 0, 0, FIELDW, FIELDH/2);

	//FLOORCOLOR
	floor_color.red = BIT16(49);
	floor_color.green = BIT16(49);
	floor_color.blue = BIT16(49);

	XAllocColor(session, colormap, &floor_color);
	//XSetForeground(session, gc, floor_color.pixel);
	XSetForeground(session, gc, BlackPixel(session,cur_screen));

	XFillRectangle(session, window, gc, 0, (FIELDH/2), FIELDW, FIELDH);

	//
	// === DRAW FENCE BEHIN PLAYER
	//

	playerIndex = getPlayer(level.map,level.length);
	//printf("%d\n",playerIndex);
	#ifdef RB	
	start = getCycles();
	#endif

	//60 FPS test
	byte i;
	long_u start2, end2;
	start2 = getCycles();
	for(i=0;i<10;i++)
	{
		start = getCycles();
		//test visualisation
		struct asset *asset;
		//floor
		getAssetById(14,&asset);
		drawAsset(asset, 2, 1, 105, CENTERX-asset->width/2*3, 370, 3);
		//walls	
	 	getAssetById(12,&asset);
		//left
		drawAsset(asset, 1.25, 1, 15, CENTERX-5*asset->width/2 + 4, CENTERY-asset->height*1.25/2, 2);
		//center
		drawAsset(asset, 0.74, 1, 0, CENTERX-asset->width/2*3, CENTERY-asset->height*0.74/2, 3);
		//right
		drawAsset(asset, 1.25, 1, -15, CENTERX+3*asset->width/2 + 0, CENTERY-asset->height*1.25/2, 2);
		end = getCycles();
		printf("Render[%d]: %.9f\n",i,(double)(end-start)/3.5e9);
	}
		end2 = getCycles();
		printf("Time[%d]: %.9f",i,(double)(end2-start2)/3.5e9);
	//60 FPS test end


	// //test visualisation
	// struct asset *asset;
	// //floor
	// getAssetById(14,&asset);
	// drawAsset(asset, 2, 1, 105, CENTERX-asset->width/2*3, 370, 3);
	// //walls	
 // 	 getAssetById(12,&asset);
	// //left
	// drawAsset(asset, 1.25, 1, 15, CENTERX-5*asset->width/2 + 4, CENTERY-asset->height*1.25/2, 2);
	// //center
	// drawAsset(asset, 0.74, 1, 0, CENTERX-asset->width/2*3, CENTERY-asset->height*0.74/2, 3);
	// //right
	// drawAsset(asset, 1.25, 1, -15, CENTERX+3*asset->width/2 + 0, CENTERY-asset->height*1.25/2, 2);

	//
	// === BENCH STUFF
	//

	#ifdef RB	
	end = getCycles();
	printf("Render: %.9f\n",(double)(end-start)/3.5e9);
	#endif
	return;
}