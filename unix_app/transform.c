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

extern void drawAssetMT(struct asset *asset, float h, float w, int8_t deg, uint16_t xsrc, uint16_t ysrc, uint8_t mult)
{

	// ==================
	// = VARS
	// ==================

	
    uint16_t height = trunc(asset->height * h);
    uint16_t width = trunc(asset->width * w * mult);
    uint16_t x, X, y, Y, nx, ny, d, d2;
    uint8_t p = getPowOf2(width);
    uint32_t i, j, index;
    uint32_t buffer_length = sizeof(uint8_t)*width*height*4;
    uint32_t mem_line_length = sizeof(uint8_t)*asset->width*4;
    uint8_t *buffer_link;
    
    double points[16], factors[8];
    double diff;

    Pixmap clipMask;
    GC clipMaskGC;
    coords ncoords;

	// ==================
	// = XL
	// ==================

    if(mult < 1) mult = 1;

	// ==================
	// = PREPARE BUFFERS
	// ==================

    memset(buffer.bitmap, 0, buffer_length);
    memset(buffer.bitmap2, 0, buffer_length);
    memset(buffer.bitmap3, 0, buffer_length);

	// ==================
	// = CPY DATA FROM ASSET TO 1st BUFFER
	// ==================

    for(j=0;j<mult;j++)
    {
    	for(i=0;i<asset->height;i++)
	    {
	    	memcpy(buffer.bitmap + mem_line_length*j + mem_line_length*mult*i, asset->data + mem_line_length*i, mem_line_length);
	    }   	
    }

	// ==================
	// = PREPARE MASK
	// ==================

	clipMask = XCreatePixmap(session, window, width, height, 1);
	clipMaskGC = XCreateGC(session, clipMask, 0, 0);

	// ==================
	// = Y SCALE ROUTINES
	// ==================	
    
    if(asset->height != height)
    {
	    diff = (double)(asset->height -1)/(double)(height-1);	    
	    for(i=0,j=0;i<buffer_length;i+=4,j++)
	    {
	    	if(p)
	    	{
		    	y = j >> p;
				Y = round(y *diff);
		    	x = j - (y << p);		
				index = (Y << (p + 2)) + (x << 2);
	    	}
	    	else
	    	{
				y = floor(j / width);
				Y = round(y *diff);
		    	x = j - y*width;			
				index = Y * width * 4 + x * 4;    		
	    	}

			buffer.bitmap2[i] = buffer.bitmap[index];
			buffer.bitmap2[i + 1] = buffer.bitmap[index + 1];
			buffer.bitmap2[i + 2] = buffer.bitmap[index + 2];
			buffer.bitmap2[i + 3] = buffer.bitmap[index + 3];
	    }	    
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

	// ==================
	// = AFFINE ROUTINES
	// ==================

    if(deg != 0)
    {	    
	    d = floor(width * sin(abs(deg>90?deg-90:deg) * (M_PI/180)));
	    d2 = d << 1;

	    buffer_link = asset->height != height?buffer.bitmap2:buffer.bitmap;

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
	    	points[8] = width-d2;
	    	points[9] = 0;
	    	points[10] = width-d2;
	    	points[11] = height;
	    	points[12] = 0;
	    	points[13] = height-d;
	    	points[14] = 0;
	    	points[15] = d;    	
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
	    	points[8] = width-d;
	    	points[9] = 0;
	    	points[10] = width;
	    	points[11] = height - d2;
	    	points[12] = 0;
	    	points[13] = height-d2;
	    	points[14] = d;
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
	    	points[8] = width-d2;
	    	points[9] = d;
	    	points[10] = width-d2;
	    	points[11] = height-d;
	    	points[12] = 0;
	    	points[13] = height;
	    	points[14] = 0;
	    	points[15] = 0;
	    }

		// ==================
		// = SOLVE MATRIX
		// ==================	    

	    solveAffineMatrix(factors,points);

		// ====================================
		// = pthread affine loop ver
		// ====================================	 

	    #if 0  
		//first th
	    struct afldata data_1;
	    void *data_p_1 = &data_1;
	    data_1.p = p;
	    data_1.i = trunc(buffer_length/PS*0);
	    data_1.j = trunc(buffer_length/PS/4*0);
	    data_1.buffer_length = trunc(buffer_length/PS*(0+1));
	    data_1.width = width;
	    data_1.factors = factors;
	    data_1.buffer_link = buffer_link;
	    
	    pthread_t afl_thread_1;
		pthread_create(&afl_thread_1, NULL, &afl, data_p_1);

		//second th
	    struct afldata data_2;
	    void *data_p_2 = &data_2;
	    data_2.p = p;
	    data_2.i = trunc(buffer_length/PS*1);
	    data_2.j = trunc(buffer_length/PS/4*1);
	    data_2.buffer_length = trunc(buffer_length/PS*(1+1));
	    data_2.width = width;
	    data_2.factors = factors;
	    data_2.buffer_link = buffer_link;

	    pthread_t afl_thread_2;
		pthread_create(&afl_thread_2, NULL, &afl, data_p_2);	    

		//third th
	    struct afldata data_3;
	    void *data_p_3 = &data_3;
	    data_3.p = p;
	    data_3.i = trunc(buffer_length/PS*2);
	    data_3.j = trunc(buffer_length/PS/4*2);
	    data_3.buffer_length = trunc(buffer_length/PS*(1+2));
	    data_3.width = width;
	    data_3.factors = factors;
	    data_3.buffer_link = buffer_link;

	    pthread_t afl_thread_3;
		pthread_create(&afl_thread_3, NULL, &afl, data_p_3);	

		//4th th
	    struct afldata data_4;
	    void *data_p_4 = &data_4;
	    data_4.p = p;
	    data_4.i = trunc(buffer_length/PS*3);
	    data_4.j = trunc(buffer_length/PS/4*3);
	    data_4.buffer_length = trunc(buffer_length/PS*(1+3));
	    data_4.width = width;
	    data_4.factors = factors;
	    data_4.buffer_link = buffer_link;

		afl(data_p_4);

		//join
		pthread_join(afl_thread_1, NULL);
		pthread_join(afl_thread_2, NULL);
		pthread_join(afl_thread_3, NULL); 

		#endif

		// ====================================
		// = different omp affine loop ver
		// ====================================	    		

 // #pragma omp parallel
 // {
 //  #pragma omp for
 //  for(int n=0; n<10; ++n) printf(" %d", n);
 // }
 // printf(".\n");

 // #pragma omp parallel // starts a new team
 // {
 //   //Work0(); // this function would be run by all threads.
   
	// #pragma omp sections // divides the team into sections
	// { 
	// 	// everything herein is run only once.
	// 	#pragma omp section
	// 	{
	// 	    struct afldata data_1;
	// 	    void *data_p_1 = &data_1;
	// 	    data_1.p = p;
	// 	    data_1.i = trunc(buffer_length/PS*0);
	// 	    data_1.j = trunc(buffer_length/PS/4*0);
	// 	    data_1.buffer_length = trunc(buffer_length/PS*(0+1));
	// 	    data_1.width = width;
	// 	    data_1.factors = factors;
	// 	    data_1.buffer_link = buffer_link;
	// 	    afl(data_p_1);
	// 	}
	// 	#pragma omp section
	// 	{ 
	// 	    struct afldata data_2;
	// 	    void *data_p_2 = &data_2;
	// 	    data_2.p = p;
	// 	    data_2.i = trunc(buffer_length/PS*1);
	// 	    data_2.j = trunc(buffer_length/PS/4*1);
	// 	    data_2.buffer_length = trunc(buffer_length/PS*(1+1));
	// 	    data_2.width = width;
	// 	    data_2.factors = factors;
	// 	    data_2.buffer_link = buffer_link;
	// 	    afl(data_p_2);
	// 	}
	// 	#pragma omp section
	// 	{
	// 		//Work4(); 
	// 	}
	// }
   
 //   //Work5(); // this function would be run by all threads.
 // }		

		// #pragma omp parallel
		// {
			omp_set_num_threads(2); 
			#pragma omp parallel for private(i) shared(j)
		    for(i=j=0;i<buffer_length;i+=4)
		    {
		    	if(p)
		    	{
		    		j = i >> 2;
		    		y = j >> p;
		    		x = j - (y << p); 
					nx = trunc((factors[0] * x + factors[1] * y + factors[2])/(factors[6] * x + factors[7] * y + 1));
					ny = trunc((factors[3] * x + factors[4] * y + factors[5])/(factors[6] * x + factors[7] * y + 1));
		    		index = (nx << 2) + (ny << (p + 2)); 
		    	}
		    	else
		    	{
		    		j = trunc(i/4);
					y = floor(j / width);
					x = j - y*width;
					nx = trunc((factors[0] * x + factors[1] * y + factors[2])/(factors[6] * x + factors[7] * y + 1));
					ny = trunc((factors[3] * x + factors[4] * y + factors[5])/(factors[6] * x + factors[7] * y + 1));
					index = nx * 4 + ny * width * 4;
		    	}

				buffer.bitmap3[index] = buffer_link[i];
				buffer.bitmap3[index + 1] = buffer_link[i + 1];
				buffer.bitmap3[index + 2] = buffer_link[i + 2];
				buffer.bitmap3[index + 3] = buffer_link[i + 3];
		    }
		//} 

		// ==================
		// = end affine loop
		// ==================

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

	// ==================
	// = X11 STUFF
	// ==================    

    //aloc buffer on x-serv
	XImage *xbitmap;
	xbitmap = XCreateImage(session, visual, 24, ZPixmap, 0, (deg != 0?buffer.bitmap3:(asset->height != height?buffer.bitmap2:buffer.bitmap)), asset->width*mult, height, 32, 0);
	//transfer & render
	XPutImage(session, window, gc, xbitmap, 0, 0, xsrc, ysrc, width*mult, height);
	//free pixmap
	XFreePixmap(session, clipMask);
	//dealloc x11 buffer
	//XDestroyImage(xbitmap);
	//free client buffer
	XFree(xbitmap);
	//safe exit
	return;
}

extern void drawAssetST(struct asset *asset, float h, float w, int8_t deg, uint16_t xsrc, uint16_t ysrc, uint8_t mult)
{

	// ==================
	// = VARS
	// ==================

	
    uint16_t height = trunc(asset->height * h);
    uint16_t width = trunc(asset->width * w * mult);
    uint16_t x, X, y, Y, nx, ny, d, d2;
    uint8_t p = getPowOf2(width);
    uint32_t i, j, index;
    uint32_t buffer_length = sizeof(uint8_t)*width*height*4;
    uint32_t buffer_quat = buffer_length/4;
    uint32_t buffer_half = buffer_length/2;
    uint32_t buffer_3quat = buffer_half + buffer_quat;
    uint32_t mem_line_length = sizeof(uint8_t)*asset->width*4;
    uint8_t *buffer_link;
    
    double points[16], factors[8];
    double diff;

    Pixmap clipMask;
    GC clipMaskGC;
    coords ncoords;

	// ==================
	// = XL
	// ==================

    if(mult < 1) mult = 1;

	// ==================
	// = PREPARE BUFFERS
	// ==================

	timer[16] = getCycles();

    memset(buffer.bitmap, 0, buffer_length);
    memset(buffer.bitmap2, 0, buffer_length);
    memset(buffer.bitmap3, 0, buffer_length);

	// ==================
	// = CPY DATA FROM ASSET TO 1st BUFFER
	// ==================

	timer[17] = getCycles();

    for(j=0;j<mult;j++)
    {
    	for(i=0;i<asset->height;i++)
	    {
	    	memcpy(buffer.bitmap + mem_line_length*j + mem_line_length*mult*i, asset->data + mem_line_length*i, mem_line_length);
	    }   	
    }

    timer[18] = getCycles();

	// ==================
	// = PREPARE MASK
	// ==================

	clipMask = XCreatePixmap(session, window, width, height, 1);
	clipMaskGC = XCreateGC(session, clipMask, 0, 0);

	// ==================
	// = Y SCALE ROUTINES
	// ==================	
    
    if(asset->height != height)
    {
	    diff = (double)(asset->height -1)/(double)(height-1);	

	    timer[19] = getCycles();    

	    for(i=0,j=0;i<buffer_length;i+=4,j++)
	    {
	    	if(p)
	    	{
		    	y = j >> p;
				Y = round(y *diff);
		    	x = j - (y << p);		
				index = (Y << (p + 2)) + (x << 2);
	    	}
	    	else
	    	{
				y = floor(j / width);
				Y = round(y *diff);
		    	x = j - y*width;			
				index = Y * width * 4 + x * 4;    		
	    	}

			buffer.bitmap2[i] = buffer.bitmap[index];
			buffer.bitmap2[i + 1] = buffer.bitmap[index + 1];
			buffer.bitmap2[i + 2] = buffer.bitmap[index + 2];
			buffer.bitmap2[i + 3] = buffer.bitmap[index + 3];
	    }	    

	    timer[20] = getCycles();  

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

	// ==================
	// = AFFINE ROUTINES
	// ==================

    if(deg != 0)
    {	    
	    d = floor(width * sin(abs(deg>90?deg-90:deg) * (M_PI/180)));
	    d2 = d << 1;

	    buffer_link = asset->height != height?buffer.bitmap2:buffer.bitmap;

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
	    	points[8] = width-d2;
	    	points[9] = 0;
	    	points[10] = width-d2;
	    	points[11] = height;
	    	points[12] = 0;
	    	points[13] = height-d;
	    	points[14] = 0;
	    	points[15] = d;    	
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
	    	points[8] = width-d;
	    	points[9] = 0;
	    	points[10] = width;
	    	points[11] = height - d2;
	    	points[12] = 0;
	    	points[13] = height-d2;
	    	points[14] = d;
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
	    	points[8] = width-d2;
	    	points[9] = d;
	    	points[10] = width-d2;
	    	points[11] = height-d;
	    	points[12] = 0;
	    	points[13] = height;
	    	points[14] = 0;
	    	points[15] = 0;
	    }
	    timer[11] = getCycles();
	    solveAffineMatrix(factors,points);
	    timer[12] = getCycles();

	    for(i=0,j=0;i<buffer_length;i+=4,j++)
	    {
	    //#if 0
	    	if(p)
	    	{
	    		// if(i == buffer_quat) timer[21] = getCycles();
	    		// else if(i == buffer_half) timer[22] = getCycles();
	    		// else if(i == buffer_3quat) timer[23] = getCycles();
	    		y = j >> p;
	    		x = j - (y << p); 
				nx = trunc((factors[0] * x + factors[1] * y + factors[2])/(factors[6] * x + factors[7] * y + 1));
				ny = trunc((factors[3] * x + factors[4] * y + factors[5])/(factors[6] * x + factors[7] * y + 1));
	    		index = (nx << 2) + (ny << (p + 2)); 
	    	}
	    	else
	    	{
				y = floor(j / width);
				x = j - y*width;
				nx = trunc((factors[0] * x + factors[1] * y + factors[2])/(factors[6] * x + factors[7] * y + 1));
				ny = trunc((factors[3] * x + factors[4] * y + factors[5])/(factors[6] * x + factors[7] * y + 1));
				index = nx * 4 + ny * width * 4;		    	   		
	    	}

			buffer.bitmap3[index] = buffer_link[i];
			buffer.bitmap3[index + 1] = buffer_link[i + 1];
			buffer.bitmap3[index + 2] = buffer_link[i + 2];
			buffer.bitmap3[index + 3] = buffer_link[i + 3];
		//#endif
			// buffer.bitmap3[i] = buffer_link[i];
			// buffer.bitmap3[i + 1] = buffer_link[i + 1];
			// buffer.bitmap3[i + 2] = buffer_link[i + 2];
			// buffer.bitmap3[i + 3] = buffer_link[i + 3];		

	    }

	    timer[13] = getCycles();

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

		timer[14] = getCycles();
    }

	// ==================
	// = X11 STUFF
	// ==================    

    //aloc buffer on x-serv
	XImage *xbitmap;
	xbitmap = XCreateImage(session, visual, 24, ZPixmap, 0, (deg != 0?buffer.bitmap3:(asset->height != height?buffer.bitmap2:buffer.bitmap)), asset->width*mult, height, 32, 0);
	//transfer & render
	XPutImage(session, window, gc, xbitmap, 0, 0, xsrc, ysrc, width*mult, height);
	timer[15] = getCycles();
	//free pixmap
	XFreePixmap(session, clipMask);
	//dealloc x11 buffer
	//XDestroyImage(xbitmap);
	//free client buffer
	XFree(xbitmap);
	//safe exit
	return;
}

extern void solveAffineMatrix(double *factors, double *points)
{
	uint8_t i;
	int32_t s;	
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

//for b-comp
extern void getAPoints(uint16_t x, uint16_t y, double *factors, coords *coords)
{
	coords->x = trunc((factors[0] * x + factors[1] * y + factors[2])/(factors[6] * x + factors[7] * y + 1));
	coords->y = trunc((factors[3] * x + factors[4] * y + factors[5])/(factors[6] * x + factors[7] * y + 1));
	return;
}

static uint8_t getPowOf2(uint16_t num)
{
	uint16_t num2 = 2;
	uint8_t p = 1;
	while(num2 < num)
	{
		num2 *= 2;
		p++;
	}
	if(num2 == num) return p;
	else return 0;
}

static void *afl(void *p)
{
	struct afldata *data = p;
	uint32_t index;
	uint16_t nx, ny, y ,x;
    for(;data->i<data->buffer_length;data->i+=4,data->j++)
    {
    	if(p)
    	{
    		y = data->j >> data->p;
    		x = data->j - (y << data->p); 
			nx = trunc((data->factors[0] * x + data->factors[1] * y + data->factors[2])/(data->factors[6] * x + data->factors[7] * y + 1));
			ny = trunc((data->factors[3] * x + data->factors[4] * y + data->factors[5])/(data->factors[6] * x + data->factors[7] * y + 1));
    		index = (nx << 2) + (ny << (data->p + 2)); 
    	}
    	else
    	{
			y = floor(data->j / data->width);
			x = data->j - y*data->width;
			nx = trunc((data->factors[0] * x + data->factors[1] * y + data->factors[2])/(data->factors[6] * x + data->factors[7] * y + 1));
			ny = trunc((data->factors[3] * x + data->factors[4] * y + data->factors[5])/(data->factors[6] * x + data->factors[7] * y + 1));
			index = nx * 4 + ny * data->width * 4;
    	}

		buffer.bitmap3[index] = data->buffer_link[data->i];
		buffer.bitmap3[index + 1] = data->buffer_link[data->i + 1];
		buffer.bitmap3[index + 2] = data->buffer_link[data->i + 2];
		buffer.bitmap3[index + 3] = data->buffer_link[data->i + 3];
    }
    return NULL;
}