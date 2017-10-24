#include "main.h"
#include "draw1.c"

//base vars
Display *session;
Window window;
XEvent cur_event;
byte cur_screen;
GC gc;
int_u gc_mask;
XGCValues gc_val;
long_u start, end;
Visual *visual;
Colormap colormap;

int main(void)
{
    //load level from tct's binary output into memory
    loadTileMap("../maps/unix1.json.bin");
    //load and map textures into memory
    loadAssets();
    //connect to xserv
    session = XOpenDisplay(NULL);
    if (session == NULL)
    {
        fprintf(stderr, "Cannot open server\n");
        exit(1);
    }
 
    //get screen id from xserv
    cur_screen = (byte)DefaultScreen(session);
 
    //create window
    window = XCreateSimpleWindow(session, RootWindow(session, cur_screen), 0, 0, FIELDW, FIELDH, 0,
                           BlackPixel(session, cur_screen), WhitePixel(session, cur_screen));
 
    //select events??
    XSelectInput(session, window, ExposureMask | KeyPressMask);
 
    //map => show the window
    XMapWindow(session, window);
    XFlush(session);
 
    //event loop
    while(1)
    {
        XNextEvent(session, &cur_event); 
        //draw
        if (cur_event.type == Expose) draw1();
        //exit point
        else if (cur_event.type == KeyPress)
            break;
        else;
    }

    //XSync(session,False);

    //sleep(5);
 
    //bb to xserv
    XCloseDisplay(session); 
    return 0;
 }