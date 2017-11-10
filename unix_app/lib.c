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

#include "transform.c"

extern uint64_t getCycles(void)
{
	uint64_t lo,hi;
	__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
	return ((uint64_t)hi << 32) | lo;
}

extern uint16_t getPlayer(uint8_t *arr, uint16_t size)
{
	uint16_t i;
	for(i=0;i<size;i++){
	    if(arr[i] == 1) return i;
	}
}

extern void loadTileMap(int8_t *path)
{
    FILE *bin;
    uint16_t binlen;
    bin = fopen(path,"rb");
    if(!bin) printf("error: can't read world file: %s\n",path);
	else
	{
	    fseek(bin, 0, SEEK_END);
	    binlen = ftell(bin);
	    rewind(bin);
	    level.map = (uint8_t *)malloc(sizeof(uint8_t)*(binlen + 1));
	    fread(level.map,binlen,1,bin);
	    level.length = binlen;
	    fclose(bin);	
	}
	return;

}

extern void seekAssets(void)
{
	struct asset *cur = e;
	while(cur < f)
	{
		printf("env %d\n",cur->id);
		cur = cur->n;
	}
    return;
}

extern void getAssetById(uint8_t id, struct asset **p)
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

extern void loadAssets()
{
	uint8_t i;
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

static void loadAssetItem(struct asset *asset)
{
	int8_t *type = strrchr(asset->path,'.') + 1;
	if(strcmp(type,"jpg") == 0)
	{
		uint8_t **buffer;
		uint32_t i, index, k, buffer_length;
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
			buffer = (uint8_t **)malloc(sizeof(uint8_t));
			buffer_length = cinfo.output_width*3;
			//jpeg 24rgb
			buffer[0] = (uint8_t *)malloc((sizeof(uint8_t))*buffer_length);
			//x11 32bgra
			asset->data = (uint8_t *)malloc((sizeof(uint8_t))*cinfo.output_width*cinfo.output_height*4);
			asset->width = cinfo.output_width;	
			asset->height = cinfo.output_height;
			asset->type = type;
			uint32_t scanlinelength;
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
    timer[1] = getCycles();
    getrusage(0, &rusage);
    printf("\n\n======== BENCHS ========\n\n");
    printf("Time: %.9f\n",(double)(timer[1]-timer[0])/3.5e9);
    printf("Memory: %d\n",rusage.ru_maxrss);
    printf("\n======== BENCHS END ========\n");
    return;
}