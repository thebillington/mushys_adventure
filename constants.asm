PLAYER_START_POS EQU $60

JUMP_POWER EQU 3
TERMINAL_VEL EQU 2

GRAVITY EQU -1
GRAVITY_DELAY EQU 18                    ; Only apply gravity once every X frames, where X is the GRAVITY_DELAY

TOP_OF_FLOOR EQU 16 * 8                 ; $80 (128 denary) which is the top of the floor (the floor is 16 tiles from the top, 16 * 8 = 128)