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
    printf("Total: %.9f\n",(double)(totale-totals)/3.5e9);
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

void getAPoints(dbyte x, dbyte y, double *factors, struct coords *coords)
{
	coords->x = trunc((factors[0] * x + factors[1] * y + factors[2])/(factors[6] * x + factors[7] * y + 1));
	coords->y = trunc((factors[3] * x + factors[4] * y + factors[5])/(factors[6] * x + factors[7] * y + 1));
	return;
}

void doATransform(struct asset *asset, byte deg, byte *buffer)
{
    //calculate factors (tan10), get new coords
    struct coords ncoords;
    int_u i,j;
    dbyte x,y, diff;
    diff = floor(asset->width * tan(deg * (M_PI/180)));
    double points[] = {asset->width,0,asset->width,asset->height,0,asset->height,0,0,asset->width-diff*2,diff,asset->width-diff*2,asset->height-diff,0,asset->height,0,0}, factors[8];
    solveAffineMatrix(factors,points);
    
    for(i=0,j=0;i<asset->data_length;i+=4,j++)
    {
		y = floor(j / asset->width);
		x = j - y*asset->width;
    	getAPoints(x,y,factors,&ncoords);
		buffer[ncoords.x * 4 + ncoords.y * asset->width * 4] = asset->data[i];
		buffer[ncoords.x * 4 + (ncoords.y * asset->width * 4) + 1] = asset->data[i + 1];
		buffer[ncoords.x * 4 + (ncoords.y * asset->width * 4) + 2] = asset->data[i + 2];
		buffer[ncoords.x * 4 + (ncoords.y * asset->width * 4) + 3] = asset->data[i + 3];
    }
    return;
}