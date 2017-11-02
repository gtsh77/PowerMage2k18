// TRIX 3-D GAME ENGINE
// Copyright (C) 2017  Anton Makridin
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

#include "main.h"
#include "draw3d.c"

//define globals
Display *session;
Window window;
XEvent cur_event;
byte cur_screen;
GC gc;
int_u gc_mask;
XGCValues gc_val;
long_u start, end, totals, totale;
Visual *visual;
Pixmap pixmap;
Colormap colormap;


int main(void)
{   
    #ifdef SB
    totals = getCycles();
    #endif

    //
    // === ENGINE INIT ===
    //
    //load binary tilemap and map into mem
    loadTileMap("../maps/unix1.json.bin");
    //load textures and map as bitmap into mem
    loadAssets();
    //alloc long buffers
    buffer.bitmap = (byte *)malloc(sizeof(byte)*MAXTEXB*MAXTEXW*MAXTEXH*4);
    buffer.bitmap2 = (byte *)malloc(sizeof(byte)*MAXTEXB*MAXTEXW*MAXTEXH*4);
    buffer.bitmap3 = (byte *)malloc(sizeof(byte)*MAXTEXB*MAXTEXW*MAXTEXH*4);      

    //
    // === START X11 SESSION ===
    // 
    session = XOpenDisplay(NULL);   
    if (session == NULL)
    {
        fprintf(stderr, "Cannot open server\n");
        exit(1);
    }     
 
    cur_screen = (byte)DefaultScreen(session);
    visual = DefaultVisual(session, DefaultScreen(session));

    gc_mask = GCCapStyle | GCJoinStyle;
    gc_val.cap_style = CapButt;
    gc_val.join_style = JoinBevel;

    window = XCreateSimpleWindow(session, RootWindow(session, cur_screen), 0, 0, FIELDW, FIELDH, 0, BlackPixel(session, cur_screen), WhitePixel(session, cur_screen));
    colormap = XCreateColormap(session, window, visual, AllocNone);
    gc = XCreateGC(session, window, gc_mask, &gc_val);
 
    XSelectInput(session, window, ExposureMask | KeyPressMask);
 
    XMapWindow(session, window);
    XFlush(session);
 
    while(1)
    {
        XNextEvent(session, &cur_event); 
        if (cur_event.type == Expose)
        {
            draw3d();
            #ifdef SB
            finishBench();
            #endif

        }
        else if (cur_event.type == KeyPress)
            break;
        else;
    }

    XCloseDisplay(session);
    return 0;
 }