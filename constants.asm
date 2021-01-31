PLAYER_START_POS_Y EQU $60
PLAYER_START_POS_X EQU $10

JUMP_POWER EQU 3
TERMINAL_VEL EQU 2

GRAVITY EQU -1
GRAVITY_DELAY EQU 18                    ; Only apply gravity once every X frames, where X is the GRAVITY_DELAY

TOP_OF_FLOOR EQU 16 * 8                 ; $80 (128 denary) which is the top of the floor (the floor is 16 tiles from the top, 16 * 8 = 128)
RIGHT_BOUND EQU 9 * 8                   ; $30 (78 denary) which is the right bound (the bound is 9 tiles from the left, 9 * 8 = 78)