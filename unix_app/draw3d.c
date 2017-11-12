// TRIX 3-D GAME ENGINE
// Copyright (C) <2017>  <Anton Makridin>
// Telegram: http://t.me/gtsh77, Email: me@anton-makridin.ru

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

#include "lib.c"

uint16_t playerIndex;

extern void draw3d(void)
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
	//XSetForeground(session, gc, floor_color.pixel);
	XSetForeground(session, gc, BlackPixel(session,cur_screen));

	XFillRectangle(session, window, gc, 0, (FIELDH/2), FIELDW, FIELDH);

	//
	// === DRAW FENCE BEHIN PLAYER
	//

	playerIndex = getPlayer(level.map,level.length);
	//printf("%d\n",playerIndex);
	#if RB	
	timer[2] = getCycles();
	#endif

	//60 FPS test
	uint8_t i;
	timer[4] = getCycles();
	for(i=0;i<5;i++)
	{
		timer[2] = getCycles();
		//test visualisation
		struct asset *asset;
		//floor
		getAssetById(14,&asset);
		drawAssetMT(asset, 2.1, 1, 106, CENTERX-asset->width/2*3, 270, 3);
		//walls	
	 	getAssetById(12,&asset);
		//left
		drawAssetMT(asset, 1.25, 1, 15, CENTERX-5*asset->width/2 + 4, CENTERY-asset->height*1.25/2, 2);
		//center
		drawAssetMT(asset, 0.74, 1, 0, CENTERX-asset->width/2*3, CENTERY-asset->height*0.74/2, 3);
		//right
		drawAssetMT(asset, 1.25, 1, -15, CENTERX+3*asset->width/2 + 0, CENTERY-asset->height*1.25/2, 2);
		timer[3] = getCycles();
		printf("Render[%d]: %.9f\n",i,(double)(timer[3]-timer[2])/3.5e9);
	}
	//60 FPS test end
	// struct asset *asset;
	// getAssetById(12,&asset);
	// drawAsset(asset, 1, 2, 0, CENTERX-asset->width/2, CENTERY-asset->height/2, 1);


	//XCopyArea(session, pixmap, window, gc, 0, 0, FIELDW, FIELDH, 0, 0);

	//
	// === BENCH STUFF
	//

	#if RB	
	timer[3] = getCycles();
	printf("Render: %.9f\n",(double)(timer[3]-timer[2])/3.5e9);
	#endif
	return;
}