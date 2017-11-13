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
#include <pthread.h>
#include <omp.h>

#ifndef _MAIN_H
#define _MAIN_H
#define FIELDW 620
#define FIELDH 380
#define CENTERX FIELDW/2
#define CENTERY FIELDH/2
#define BIT16(u) (u) * 255
#define SB 1
#define RB 0
#define DASSET 0
#define MAXTEXB 10
#define MAXTEXW 256
#define MAXTEXH 256
#define TIMERS 32
#define PS 4

// ==================
// =
// = GLOBALS
// =
// ==================

extern Display *session;
extern Window window;
extern XEvent cur_event;
extern uint8_t cur_screen;
extern uint16_t playerIndex;
extern uint32_t gc_mask;
extern uint64_t timer[TIMERS];
extern GC gc;
extern XGCValues gc_val;
extern Visual *visual;
extern Colormap colormap;
extern Pixmap pixmap;

//coords struct
typedef struct 
{
    uint16_t x;
    uint16_t y;
} coords;

//long buffers
struct
{
    uint8_t *bitmap;
    uint8_t *bitmap2;
    uint8_t *bitmap3;
} buffer;

//level tiles
struct
{
    uint8_t  *map;
    uint16_t length;
} level;

//all uniq assets mapped in mem w dynamic list
struct asset
{
    uint8_t   id;
    uint8_t  *name;
    uint8_t  *type;
    uint8_t  *path;
    uint16_t  width;
    uint16_t  height;
    uint8_t  *data;
    uint8_t   data_length;
    struct    asset *n, *p;
} *e, *l, *f;

struct afldata
{
    uint8_t   p; 
    uint32_t  i; 
    uint32_t  j; 
    uint32_t  buffer_length; 
    uint16_t  width; 
    double   *factors; 
    uint8_t  *buffer_link;
};

//ingame assets count, should be equal to objNames & objIds length
#define GAMEOBJECTS 8

//game obj definitions
int8_t objNames[GAMEOBJECTS][128] = 
{
    "../assets/unix/packs/Pak2/textures/algiers/brick1.jpg",
    "../assets/unix/packs/Pak2/textures/central_europe/frenchdoor_wood1.jpg",
    "../assets/unix/packs/Pak2/textures/central_europe/interiorwall_set2chrrl.jpg",
    "../assets/unix/packs/Pak2/textures/central_europe/interiorwall_set3chrrl.jpg",
    "../assets/unix/packs/Pak2/textures/general_structure/floor4.jpg",
    "../assets/unix/packs/Pak2/textures/general_structure/frenchfloor_wood1.jpg",
    "../assets/unix/packs/Pak2/textures/general_structure/garagefloor.jpg",
    "../assets/unix/packs/Pak2/textures/mohtest/wlppr_tan.jpg" 
};

uint8_t objIds[GAMEOBJECTS] = 
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

// ==================
// =
// = LIB.C
// =
// ==================


static void loadAssetItem(struct asset *);
static void doYTransform(uint16_t, uint16_t, uint16_t, uint8_t *, uint8_t *, uint32_t);
static void doXTransform(uint16_t, uint16_t, uint16_t, uint8_t *, uint8_t *, uint32_t);
static void doATransform(uint16_t, uint16_t, int8_t, uint8_t, uint8_t *, uint8_t *, double *);
extern void seekAssets(void);
extern void loadAssets(void);
extern void finishBench(void);
extern uint64_t getCycles(void);
extern void loadTileMap(int8_t *);
extern uint16_t getPlayer(uint8_t *, uint16_t);
extern void getAssetById(uint8_t, struct asset **);

// ==================
// =
// = TRANSFORM.C
// =
// ==================

static uint8_t getPowOf2(uint16_t);
extern void solveAffineMatrix(double *, double *);
extern void getAPoints(uint16_t, uint16_t, double *, coords *);
extern void drawAssetMT(struct asset *, float, float, int8_t, uint16_t, uint16_t, uint8_t);
extern void drawAssetST(struct asset *, float, float, int8_t, uint16_t, uint16_t, uint8_t);
static void *afl(void *);

// ==================
// =
// = RENDER
// =
// ==================

extern void draw3d(void);

#endif