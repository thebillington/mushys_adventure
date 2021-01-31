   IF !DEF(MEMORY_MAP_INC)
MEMORY_MAP_INC SET 1

; -------- OAM ------\

; Sprite VRAM map location
_SPRITE_VRAM EQU _BLOCK2

; Sprites
PLAYER EQU $00

; -------- Usable RAM ------

; 2 bytes to store the pointer to the level tile data (top tile of the next column)
LEVEL_COLUMN_POINTER_LOW EQU _RAM + $A0
LEVEL_COLUMN_POINTER_HIGH EQU LEVEL_COLUMN_POINTER_LOW + $01

; A byte to store the x-offset of the next tile to load
COLUMN_OFFSET_X EQU LEVEL_COLUMN_POINTER_HIGH + $01

; Bytes to store the column and row loading counters for initialising a level
COLUMN_LOAD_COUNTER EQU COLUMN_OFFSET_X + $01
ROW_LOAD_COUNTER EQU COLUMN_LOAD_COUNTER + $01

; Store previous button state
PREV_BTN_STATE EQU ROW_LOAD_COUNTER + $01

; Store interrupt state
INTR_STATE EQU PREV_BTN_STATE + $01

ENDC