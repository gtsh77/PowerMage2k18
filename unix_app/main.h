#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
#include "jpeglib.h"
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <gsl/gsl_linalg.h>

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
extern long_u start, end, totals, totale;
extern dbyte playerIndex;
extern Visual *visual;
extern Colormap colormap;

struct
{
    byte *map;
    dbyte length;
} level;

//ingame assets count, should be equal to objNames & objIds length
#define GAMEOBJECTS 8 

char objNames[GAMEOBJECTS][64] = 
{
    "../assets/unix/brick1.jpg",
    "../assets/unix/frenchdoor_wood1.jpg",
    "../assets/unix/interiorwall_set2chrrl.jpg",
    "../assets/unix/interiorwall_set3chrrl.jpg",
    "../assets/unix/floor4.jpg",
    "../assets/unix/frenchfloor_wood1.jpg",
    "../assets/unix/garagefloor.jpg",
    "../assets/unix/wlppr_tan.jpg"
};

byte objIds[GAMEOBJECTS] = 
{
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17
};

struct asset
{
    byte id;
    char *name;
    char *type;
    char *path;
    dbyte width;
    dbyte height;
    byte *data;
    int_u data_length;
    struct asset *n, *p;
} *e, *l, *f;

struct coords
{
	dbyte x;
	dbyte y;
};

//libs: protos
long_u getCycles(void);
dbyte getPlayer(byte *, dbyte);
void finishBench(void);
void loadTileMap(char *);
void seekAssets(void);
void loadAssets(void);
void loadAssetItem(struct asset *);
void getAssetById(byte, struct asset **);
void solveAffineMatrix(double *, double *);
void getAPoints(dbyte, dbyte, double *, struct coords *);
void doATransform(struct asset *, byte, byte *);

//mainframes
void draw3d(void);