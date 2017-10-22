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

void loadTileMap(void)
{
    FILE *bin;
    dbyte binlen;
    bin = fopen("../maps/unix1.json.bin","rb");
    fseek(bin, 0, SEEK_END);
    binlen = ftell(bin);
    rewind(bin);
    level.map = (byte *)malloc(sizeof(byte)*(binlen + 1));
    if(!bin)
    {
        printf("can't read lvl file");
    }
    else
    {
        fread(level.map,binlen,1,bin);
        level.length = binlen;
        fclose(bin);  
    }
    return;
}