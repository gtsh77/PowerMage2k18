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

long_u getCycles(void)
{
	long_u lo,hi;
	__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
	return ((long_u)hi << 32) | lo;
}

dbyte getPlayer(byte *arr, dbyte size)
{
	dbyte i;
	for(i=0;i<size;i++){
	    if(arr[i] == 1) return i;
	}
}

void loadTileMap(char *path)
{
    FILE *bin;
    dbyte binlen;
    bin = fopen(path,"rb");
    if(!bin) printf("error: can't read world file: %s\n",path);
	else
	{
	    fseek(bin, 0, SEEK_END);
	    binlen = ftell(bin);
	    rewind(bin);
	    level.map = (byte *)malloc(sizeof(byte)*(binlen + 1));
	    fread(level.map,binlen,1,bin);
	    level.length = binlen;
	    fclose(bin);
	    //printf("world: %p (%d)\n",level.map, level.length);   	
	}
	return;

}

void seekAssets(void)
{
	struct asset *cur = e;
	while(cur < f)
	{
		printf("env %d\n",cur->id);
		cur = cur->n;
	}
    return;
}

void getAssetById(byte id, struct asset **p)
{
	struct asset *cur = e;
	while(cur < f)
	{
		if(cur->id == id)
		{
			*p = cur;
			cur = f;
		}
		else cur = cur->n;
	}
    return;
}

void loadAssets()
{
	byte i;
    e = (struct asset*)malloc(sizeof(struct asset));
    l = f = e;
    for(i=0;i<GAMEOBJECTS;i++)
    {
        l->path = objNames[i];
        l->id = objIds[i];
        loadAssetItem(l);
        l->n=(struct asset*)malloc(sizeof(struct asset));
        l=l->n;
    }
    f = l;
    return;
}

void loadAssetItem(struct asset *asset)
{
	char *type = strrchr(asset->path,'.') + 1;
	if(strcmp(type,"jpg") == 0)
	{
		byte **buffer;
		int_u i, index, k, buffer_length;
		FILE *file;
		struct jpeg_decompress_struct cinfo;
		struct jpeg_error_mgr jerr;
		cinfo.err = jpeg_std_error(&jerr);
		jpeg_create_decompress(&cinfo);
		file = fopen(asset->path, "rb");
		if(!file) printf("error: can't read asset file: %s\n",asset->path);
		else 
		{
			jpeg_stdio_src(&cinfo, file);
			jpeg_read_header(&cinfo, TRUE);
			jpeg_start_decompress(&cinfo);
			buffer = (byte **)malloc(sizeof(byte));
			buffer_length = cinfo.output_width*3;
			//jpeg 24rgb
			buffer[0] = (byte *)malloc((sizeof(byte))*buffer_length);
			//x11 32bgra
			asset->data = (byte *)malloc((sizeof(byte))*cinfo.output_width*cinfo.output_height*4);
			asset->width = cinfo.output_width;	
			asset->height = cinfo.output_height;
			asset->type = type;
			int_u scanlinelength;
			for(index=0;index<cinfo.output_height;index++)
			{
				scanlinelength = cinfo.output_width*index*4;
				(void)jpeg_read_scanlines(&cinfo, buffer,1);
				for(i=0,k=0;i<buffer_length;i+=3,k+=4)
				{
					//24 rgb => 32bgra ?? x11 case
					asset->data[scanlinelength + k] = buffer[0][i + 2];
					asset->data[scanlinelength + k + 1] = buffer[0][i + 1];
					asset->data[scanlinelength + k + 2] = buffer[0][i];
					asset->data[scanlinelength + k + 3] = 0;
				}
			}
			asset->data_length = cinfo.output_width*cinfo.output_height*4;
			jpeg_finish_decompress(&cinfo);
			jpeg_destroy_decompress(&cinfo);
			free(buffer[0]);
			free(buffer);
			fclose(file);
		}
	}
	else printf("error: unsupported extension: %s\n",asset->path);
	return;
}

void finishBench(void)
{
	struct rusage rusage;
    totale = getCycles();
    getrusage(0, &rusage);
    printf("\n\n======== BENCHS ========\n\n");
    printf("Time: %.9f\n",(double)(totale-totals)/3.5e9);
    printf("Memory: %d\n",rusage.ru_maxrss);
    printf("\n======== BENCHS END ========\n");
    return;
}

void solveAffineMatrix(double *factors, double *points)
{
	byte i;
	int s;	
	double a_data[] = 
	{ 
		points[0],points[1],1,0,0,0,-points[0]*points[8],-points[1]*points[8],
		points[2],points[3],1,0,0,0,-points[2]*points[10],-points[3]*points[10],
		points[4],points[5],1,0,0,0,-points[4]*points[12],-points[5]*points[12],
		points[6],points[7],1,0,0,0,-points[6]*points[14],-points[7]*points[14],
		0,0,0,points[0],points[1],1,-points[0]*points[9],-points[1]*points[9],
		0,0,0,points[2],points[3],1,-points[2]*points[11],-points[3]*points[11],
		0,0,0,points[4],points[5],1,-points[4]*points[13],-points[5]*points[13],
		0,0,0,points[6],points[7],1,-points[6]*points[14],-points[7]*points[14]
	};

  	double b_data[] = {points[8],points[10],points[12],points[14],points[9],points[11],points[13],points[15]};

  	gsl_vector *x = gsl_vector_alloc (8);
	gsl_matrix_view m = gsl_matrix_view_array (a_data, 8, 8);
	gsl_vector_view b = gsl_vector_view_array (b_data, 8);	
	gsl_permutation * p = gsl_permutation_alloc (8);
	gsl_linalg_LU_decomp (&m.matrix, p, &s);
	gsl_linalg_LU_solve (&m.matrix, p, &b.vector, x);
	gsl_linalg_LU_solve (&m.matrix, p, &b.vector, x);
	for(i=0;i<8;i++)
	{
		factors[i] = gsl_vector_get(x,i);
	}
	gsl_permutation_free (p);
	gsl_vector_free (x);
	return;
}

void getAPoints(dbyte x, dbyte y, double *factors, coords *coords)
{
	coords->x = trunc((factors[0] * x + factors[1] * y + factors[2])/(factors[6] * x + factors[7] * y + 1));
	coords->y = trunc((factors[3] * x + factors[4] * y + factors[5])/(factors[6] * x + factors[7] * y + 1));
	return;
}

void doATransform(dbyte width, dbyte height, char deg, byte mult, byte *src_buffer, byte *buffer, double *points)
{
    coords ncoords;
    int_u i, j, index, data_length;
    dbyte x,y, diff, dComp;
    // if(deg <0) deg = -1 * deg;
    // else if(deg > 90) deg = deg - 90;
    // else ;
    diff = floor(width * sin(abs(deg>90?deg-90:deg) * (M_PI/180)));
    dComp = diff*2;
    data_length = width*height*4;
    double factors[8];
    //double points1[] = {width,0,width,height,0,height,0,0,width-dComp,diff,width-dComp,height-diff,0,height,0,0},points2[] = {width,0,width,height,0,height,0,0,width-dComp,0,width-dComp,height,0,height-diff,0,diff},points3[] = {width,0,width,height,0,height,0,0,width-diff,0,width,height-dComp,0,height-dComp,diff,0},factors[8];

    if(deg < 0)
    {
    	points[0] = width;
    	points[1] = 0;
    	points[2] = width;
    	points[3] = height;
    	points[4] = 0;
    	points[5] = height;
    	points[6] = 0;
    	points[7] = 0;
    	points[8] = width-dComp;
    	points[9] = 0;
    	points[10] = width-dComp;
    	points[11] = height;
    	points[12] = 0;
    	points[13] = height-diff;
    	points[14] = 0;
    	points[15] = diff;
    }
    else if(deg > 90)
    {
    	points[0] = width;
    	points[1] = 0;
    	points[2] = width;
    	points[3] = height;
    	points[4] = 0;
    	points[5] = height;
    	points[6] = 0;
    	points[7] = 0;
    	points[8] = width-diff;
    	points[9] = 0;
    	points[10] = width;
    	points[11] = height - dComp;
    	points[12] = 0;
    	points[13] = height-dComp;
    	points[14] = diff;
    	points[15] = 0;    	
    }
    else
    {
    	points[0] = width;
    	points[1] = 0;
    	points[2] = width;
    	points[3] = height;
    	points[4] = 0;
    	points[5] = height;
    	points[6] = 0;
    	points[7] = 0;
    	points[8] = width-dComp;
    	points[9] = diff;
    	points[10] = width-dComp;
    	points[11] = height-diff;
    	points[12] = 0;
    	points[13] = height;
    	points[14] = 0;
    	points[15] = 0;     	
    }
    solveAffineMatrix(factors,points);

    for(i=0,j=0;i<data_length;i+=4,j++)
    {
		y = floor(j / width);
		x = j - y*width;
    	getAPoints(x,y,factors,&ncoords);
    	index = ncoords.x * 4 + ncoords.y * width * 4;
		buffer[index] = src_buffer[i];
		buffer[index + 1] = src_buffer[i + 1];
		buffer[index + 2] = src_buffer[i + 2];
		buffer[index + 3] = src_buffer[i + 3];
    }
    return;
}
void doYTransform(dbyte original_height, dbyte height, dbyte width, byte *src_buffer, byte *buffer, int_u buffer_length)
{
    int_u i, j, index;
    dbyte x, y, Y;
    double diff;
    //buffer_length = sizeof(byte)*asset->width*height*4;

    diff = (double)(original_height -1)/(double)(height-1);
    
    for(i=0,j=0;i<buffer_length;i+=4,j++)
    {
		y = floor(j / width);
		Y = round(y *diff);
    	x = j - y*width;
		
		index = Y * width * 4 + x * 4;

		buffer[i] = src_buffer[index];
		buffer[i + 1] = src_buffer[index + 1];
		buffer[i + 2] = src_buffer[index + 2];
		buffer[i + 3] = src_buffer[index + 3];
    }
    return;
}

void drawAsset(struct asset *asset, float h, float w, byte perspective, dbyte xsrc, dbyte ysrc, byte mult)
{
    //chk width & height req
    dbyte height, width, i, j;
    height = trunc(asset->height * h);
    width = trunc(asset->width * w * mult);
    int_u buffer_length = width*height*4;
    int_u mem_line_length = sizeof(byte)*asset->width*4;
    double points[16];
    Pixmap clipMask;
    GC clipMaskGC;

    if(mult < 1) mult = 1;

    //clear long buffers
    memset(buffer.bitmap, 0, sizeof(byte)*buffer_length);
    memset(buffer.bitmap2, 0, sizeof(byte)*buffer_length);
    memset(buffer.bitmap3, 0, sizeof(byte)*buffer_length);

    //copy data from asset src
    for(j=0;j<mult;j++)
    {
    	for(i=0;i<asset->height;i++)
	    {
	    	memcpy(buffer.bitmap + mem_line_length*j + mem_line_length*mult*i, asset->data + mem_line_length*i, mem_line_length);
	    }   	
    }

	//create clip mask
	clipMask = XCreatePixmap(session, window, width, height, 1);
	clipMaskGC = XCreateGC(session, clipMask, 0, 0);    
    //do scale if nes
    if(asset->height != height)
    {
    	//calc stuff
    	doYTransform(asset->height, height, width, buffer.bitmap, buffer.bitmap2, buffer_length);
		//full area
		XSetForeground(session, clipMaskGC, BlackPixel(session, cur_screen));
		XFillRectangle(session, clipMask, clipMaskGC, 0, 0, width, height);
		//visible area
		XSetForeground(session, clipMaskGC, WhitePixel(session, cur_screen));
		XFillRectangle(session, clipMask, clipMaskGC, 0, 0, width, height);
		//clip
		XSetClipMask(session, gc, clipMask);
		XSetClipOrigin(session, gc, xsrc, ysrc);
    }
    //do pers if nes
    if(perspective > 0)	
    {
    	//calc stuff
    	doATransform(width, height, perspective, mult, asset->height != height?buffer.bitmap2:buffer.bitmap, buffer.bitmap3, points);
		//full area
		XSetForeground(session, clipMaskGC, BlackPixel(session, cur_screen));
		XFillRectangle(session, clipMask, clipMaskGC, 0, 0, width, height);    	
    	//points for vis
		XPoint xpoints[] = 
		{
			{points[8],points[9]},
			{points[10],points[11]},
			{points[12],points[13]},
			{points[14],points[15]}
		};
		//visible area
		XSetForeground(session, clipMaskGC, WhitePixel(session, cur_screen));
		XFillPolygon(session, clipMask, clipMaskGC, xpoints, 4, Complex, CoordModeOrigin);	
		//clip
		XSetClipMask(session, gc, clipMask);
		XSetClipOrigin(session, gc, xsrc, ysrc);    		
    }

    //aloc buffer on x-serv
	XImage *xbitmap;
	xbitmap = XCreateImage(session, visual, 24, ZPixmap, 0, (perspective > 0?buffer.bitmap3:(asset->height != height?buffer.bitmap2:buffer.bitmap)), asset->width*mult, height, 32, 0);
	//transfer & render
	XPutImage(session, window, gc, xbitmap, 0, 0, xsrc, ysrc, width*mult, height);
	//free pixmap
	XFreePixmap(session, clipMask);

	return;
    	
}