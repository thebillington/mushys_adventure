   IF !DEF(MEMORY_MAP_INC)
MEMORY_MAP_INC SET 1

; 2 bytes to store the pointer to the level tile data (top tile of the next column)
LEVEL_COLUMN_POINTER_LOW EQU _RAM
LEVEL_COLUMN_POINTER_HIGH EQU LEVEL_COLUMN_POINTER_LOW + $01

; A byte to store the x-offset of the next tile to load
COLUMN_OFFSET_X EQU LEVEL_COLUMN_POINTER_HIGH + $01

; Bytes to store the column and row loading counters for initialising a level
COLUMN_LOAD_COUNTER EQU COLUMN_OFFSET_X + $01
ROW_LOAD_COUNTER EQU COLUMN_LOAD_COUNTER + $01

ENDC