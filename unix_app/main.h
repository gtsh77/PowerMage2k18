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

#ifndef _MAIN_H
#define _MAIN_H
#define FIELDW 620
#define FIELDH 380
#define CENTERX FIELDW/2
#define CENTERY FIELDH/2
#define BIT16(u) (u) * 255
#define SB 1
#define RB 1
#define MAXTEXB 10
#define MAXTEXW 256
#define MAXTEXH 256

//own types
typedef char byte_u;
typedef unsigned char byte;
typedef unsigned short dbyte;
typedef unsigned int int_u;
typedef unsigned long int long_u;
typedef struct 
{
    dbyte x;
    dbyte y;
} coords;

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
extern Pixmap pixmap;

//long buffers
struct
{
    byte *bitmap;
    byte *bitmap2;
    byte *bitmap3;
} buffer;

//level tiles
struct
{
    byte *map;
    dbyte length;
} level;

//all uniq assets mapped as bitmap in mem
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

//libs
long_u getCycles(void);
dbyte getPlayer(byte *, dbyte);
void finishBench(void);
void loadTileMap(char *);
void seekAssets(void);
void loadAssets(void);
void loadAssetItem(struct asset *);
void getAssetById(byte, struct asset **);
void solveAffineMatrix(double *, double *);
void getAPoints(dbyte, dbyte, double *, coords *);
void doATransform(dbyte, dbyte, char, byte, byte *, byte *, double *);
void doYTransform(dbyte, dbyte, dbyte, byte *, byte *, int_u);
void drawAsset(struct asset *, float, float, byte, dbyte, dbyte, byte);

//render
void draw3d(void);

#endif