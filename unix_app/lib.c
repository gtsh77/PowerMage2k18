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
	    	
	}
	return;

}

void loadAsset(char *type, char *path, struct asset *ptr)
{
	if(type == "jpg")
	{
		byte **buffer;
		dbyte i, buffer_length;
		FILE *file;
		struct jpeg_decompress_struct cinfo;
		struct jpeg_error_mgr jerr;
		cinfo.err = jpeg_std_error(&jerr);
		jpeg_create_decompress(&cinfo);	
		file = fopen(path, "rb");
		if(!file) printf("error: can't read asset file: %s\n",path);
		else 
		{
			jpeg_stdio_src(&cinfo, file);
			jpeg_read_header(&cinfo, TRUE);
			jpeg_start_decompress(&cinfo);
			buffer = (byte **)malloc(cinfo.output_height);
			buffer_length = sizeof(byte)*cinfo.output_width*cinfo.output_components;
			buffer[0] = (byte *)malloc(buffer_length);
			ptr->data = (byte *)malloc(buffer_length*cinfo.output_height);
			while (cinfo.output_scanline < cinfo.output_height)
			{
				(void)jpeg_read_scanlines(&cinfo, buffer, 1);
				for(i=0;i<buffer_length;i+=3)
				{
					ptr->data[cinfo.output_scanline * i + 0] = buffer[0][i];
					ptr->data[cinfo.output_scanline * i + 1] = buffer[0][i + 1];
					ptr->data[cinfo.output_scanline * i + 2] = buffer[0][i + 2];
				}
			}
			ptr->type = type;
			ptr->length = buffer_length*cinfo.output_height;
			jpeg_finish_decompress(&cinfo);
			jpeg_destroy_decompress(&cinfo);
			fclose(file);		
		}
	}
	return;
}