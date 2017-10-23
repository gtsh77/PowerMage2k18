#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "jpeglib.h"

#define FIELDW 640
#define FIELDH 480
#define CENTERX FIELDW/2
#define CENTERY FIELDH/2
#define BIT16(u) (u) * 255

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
extern dbyte playerIndex;
extern Visual *visual;
extern Colormap colormap;

struct
{
    byte *map;
    dbyte length;
} level;

struct asset
{
	char *type;
    char *name;
    byte *data;
    int_u length;
};

struct gameObj
{
	char * name;
	byte id;
	struct gameObj *n;
} gameObject[10];

// enum gameObjects 
// {
//     z = 0,
//     player = z + 1,
//     strongwall = z + 10,
//     easywall = z + 20,
//     lockeddoor = z + 30,
//     key = z + 40,
//     item1 = z + 50,
//     item2 = z + 51,
//     item3 = z + 52,
//     mana_potion = z + 53,
//     portal = z + 60,
//     horde_mage = z + 101,
//     horde_grunt = z + 102,
//     allience_vendor = z + 201
// };

//libs: protos
long_u getCycles(void);
dbyte getPlayer(byte *, dbyte);
void loadTileMap(char *);
void loadAsset(char *, char *, struct asset *);