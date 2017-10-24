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
	    printf("world: %p (%d)\n",level.map, level.length);   	
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
				for(i=0,k=0;i<buffer_length;i+=3,k++)
				{
					//24 rgb => 32bgra ?? x11 case
					asset->data[scanlinelength + (k* 4)] = buffer[0][i + 2];
					asset->data[scanlinelength + (k* 4) + 1] = buffer[0][i + 1];
					asset->data[scanlinelength + (k* 4) + 2] = buffer[0][i];
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