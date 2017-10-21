#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define FIELDW 640
#define FIELDH 480

//own types
typedef char byte_u;
typedef unsigned char byte;
typedef unsigned short dbyte;
typedef unsigned int int_u;
typedef unsigned long int long_u;

//globals
extern Display *session;
extern Window window;
extern XEvent cur_event;
extern byte cur_screen;
extern GC gc;
extern int_u gc_mask;
extern XGCValues gc_val;
extern long_u start, end;

//protos
long_u getCycles(void);