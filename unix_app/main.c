#include "main.h"
#include "draw3d.c"

//base vars
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
    //start bench
    totals = getCycles();
    #endif
    
    //load level from tct's binary output into memory
    loadTileMap("../maps/unix1.json.bin");
    //load and map textures into memory
    loadAssets();
    //seekAssets();

    //connect to xserv
    session = XOpenDisplay(NULL);   
    if (session == NULL)
    {
        fprintf(stderr, "Cannot open server\n");
        exit(1);
    }     
 
    //get screen id from xserv
    cur_screen = (byte)DefaultScreen(session);
    visual = DefaultVisual(session, DefaultScreen(session));

    gc_mask = GCCapStyle | GCJoinStyle;
    gc_val.cap_style = CapButt;
    gc_val.join_style = JoinBevel;

    window = XCreateSimpleWindow(session, RootWindow(session, cur_screen), 0, 0, FIELDW, FIELDH, 0, BlackPixel(session, cur_screen), WhitePixel(session, cur_screen));
    colormap = XCreateColormap(session, window, visual, AllocNone);
    gc = XCreateGC(session, window, gc_mask, &gc_val);
 
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
        if (cur_event.type == Expose)
        {
            draw3d();
            #ifdef SB
            finishBench();
            #endif

        }
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