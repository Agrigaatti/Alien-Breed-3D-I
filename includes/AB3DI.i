******************************************************************

  IFND       AB3DI_i
AB3DI_i                  EQU 1

******************************************************************

  incdir     "includes"

******************************************************************
; Exec
  include    "exec/FUNCDEF.i"
  include    "exec/exec_lib.i"

******************************************************************
; Dos

  include    "dos/dos_lib.i"

_LVOExamineFH            EQU -390

******************************************************************
; Graphics
  
  include    "graphics/graphics_lib.i"

******************************************************************
; Intuition

  include    "intuition/intuition_lib.i"

******************************************************************
 ; lowlevel.library

  include    "libraries/lowlevel.i"

_LVOReadJoyPort          EQU -30
_LVOGetLanguageSelection EQU -36
_LVOGetKey               EQU -48
_LVOQueryKeys            EQU -54
_LVOAddKBInt             EQU -60
_LVORemKBInt             EQU -66
_LVOSystemControlA       EQU -72
_LVOAddTimerInt          EQU -78
_LVORemTimerInt          EQU -84
_LVOStopTimerInt         EQU -90
_LVOStartTimerInt        EQU -96
_LVOElapsedTime          EQU -102
_LVOSetJoyPortAttrsA     EQU -132
_LVOAddVBlankInt         EQU -108
_LVORemVBlankInt         EQU -114

******************************************************************
; Hardware 
 
vhposr                   equ $006
vhposrl                  equ $007
ADKCONR                  equ $010
dmaconr                  equ $012
DMACONR                  equ $012
POTINP                   equ $016
SERDATR                  equ $018 
INTENAR                  equ $01C
intenar                  equ $01C
intreqr                  equ $01e
INTREQR                  equ $01e
intreqrl                 equ $01f
SERDAT                   equ $030
SERPER                   equ $032
potgo                    equ $034
cop1lch                  equ $080
cop1lcl                  equ $082
cop2lch                  equ $084
cop2lcl                  equ $086
COPJMP1                  equ $088
copjmp1                  equ $088
COPJMP2                  equ $08a
copjmp2                  equ $08a
DIWSTRT                  equ $08E
diwstrt                  equ $08e           ; Screen hardware registers.
diwstart                 equ $08e
DIWSTOP                  equ $090	
diwstop                  equ $090
ddfstrt                  equ $092
ddfstart                 equ $092
ddfstop                  equ $094
DMACON                   equ $096
dmacon                   equ $096
INTENA                   equ $09A
intena                   equ $09A
intreq                   equ $09C
INTREQ                   equ $09C
adkcon                   equ $09E
ADKCON                   equ $09e
aud0vol                  equ $0a8
aud1vol                  equ $0b8
aud2vol                  equ $0c8
aud3vol                  equ $0d8
bpl1pth                  equ $0e0
bpl1ptl                  equ $0e2
bpl2pth                  equ $0e4
bpl2ptl                  equ $0e6
bpl3pth                  equ $0e8
bpl3ptl                  equ $0ea
bpl4pth                  equ $0ec
bpl4ptl                  equ $0ee
bpl5pth                  equ $0f0
bpl5ptl                  equ $0f2
bpl6pth                  equ $0f4
bpl6ptl                  equ $0f6
bpl7pth                  equ $0f8
bpl7ptl                  equ $0fa
bpl8pth                  equ $0fc
bpl8ptl                  equ $0fe
bplcon0                  equ $100
bplcon1                  equ $102
BPLCON3                  equ $106
bplcon3                  equ $106
BPL1MOD                  equ $108
bpl1mod                  equ $108
BPL2MOD                  equ $10a
bpl2mod                  equ $10a
bplcon4                  equ $10c
spr0pth                  equ $120
spr0ptl                  equ $122
spr1pth                  equ $124
spr1ptl                  equ $126
spr2pth                  equ $128
spr2ptl                  equ $12a
spr3pth                  equ $12c
spr3ptl                  equ $12e
spr4pth                  equ $130
spr4ptl                  equ $132
spr5pth                  equ $134
spr5ptl                  equ $136
spr6pth                  equ $138
spr6ptl                  equ $13a
spr7pth                  equ $13c
spr7ptl                  equ $13e
spr0ctl                  equ $142
spr1ctl                  equ $14a
spr2ctl                  equ $152
spr3ctl                  equ $15a
spr4ctl                  equ $162
spr5ctl                  equ $16a
spr6ctl                  equ $172
spr7ctl                  equ $17a
spr0pos                  equ $140
spr1pos                  equ $148
spr2pos                  equ $150
spr3pos                  equ $158
spr4pos                  equ $160
spr5pos                  equ $168
spr6pos                  equ $170
spr7pos                  equ $178

; +--------+-------------+-------------+-------------+-------------+
; | BIT#   | 15,14,13,12 | 11,10,09,08 | 07,06,05,04 | 03,02,01,00 |
; +--------+-------------+-------------+-------------+-------------+
; | LOCT=0 | T  X  X  X  | R7 R6 R5 R4 | G7 G6 G5 G4 | B7 B6 B5 B4 |
; | LOCT=1 | X  X  X  X  | R3 R2 R1 R0 | G3 G2 G1 G0 | B3 B2 B1 B0 |
; +--------+-------------+-------------+-------------+-------------+
; 
; T = TRANSPARENCY, R = RED, G = GREEN, B = BLUE, X = UNUSED
; 
; T bit of COLOR00 thru COLOR31 sets ZD_pin HI, When that color is
;   selected in all video modes.
; 
; SEE ALSO: BPLCON3 for color bank switching, LOCT-bit and
; using transparency bit with a Genlock

color00                  equ $180
color01                  equ $182
color02                  equ $184
color03                  equ $186
color04                  equ $188
color05                  equ $18a
color06                  equ $18c
color07                  equ $18e
color08                  equ $190
color09                  equ $192
color10                  equ $194
color11                  equ $196
color12                  equ $198
color13                  equ $19a
color14                  equ $19c
color15                  equ $19e
beamcon0                 equ $1dc
fmode                    equ $1fc

******************************************************************

  endc  