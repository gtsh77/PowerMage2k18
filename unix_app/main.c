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

 

int main(void)
{
    //printf("%d\n",sizeof(long));


    //connect to xserv
    session = XOpenDisplay(NULL);
    if (session == NULL)
    {
        fprintf(stderr, "Cannot open server\n");
        exit(1);
    }
 
    //get screen id from xserv
    cur_screen = (byte)DefaultScreen(session);

    //get some info??
    //printf("%d\n",ConnectionNumber(session));
    //printf("%d\n",ConnectionNumber(session));
 
    //create window
    window = XCreateSimpleWindow(session, RootWindow(session, cur_screen), 0, 0, FIELDW, FIELDH, 1,
                           BlackPixel(session, cur_screen), WhitePixel(session, cur_screen));
 
    //select events??
    XSelectInput(session, window, ExposureMask | KeyPressMask);
 
    //map => show the window
    XMapWindow(session, window);
 
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

 long_u getCycles(void)
 {
    long_u lo,hi;
    __asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
    return ((long_u)hi << 32) | lo;
 }





    //XFillRectangle(session, window, DefaultGC(session, cur_screen), 20, 20, 10, 10);
            //XDrawString(session, window, DefaultGC(session, cur_screen), 50, 50, "Hello, World!", strlen("Hello, World!"));