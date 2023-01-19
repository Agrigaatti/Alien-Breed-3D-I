*********************************************************************************************

                  IFND           macros_i
macros_i EQU 1

*********************************************************************************************

FILTER            macro
                  bchg           #1,$bfe001
                  endm

*********************************************************************************************

BLACK             macro
                  move.w         #0,$dff180
                  endm

RED               macro
                  move.w         #$f00,$dff180
                  endm

GREEN             macro
                  move.w         #$0f0,$dff180
                  endm

BLUE              macro
                  move.w         #$f,$dff180
                  endm

*********************************************************************************************

SAVEREGS          MACRO
                  movem.l        d0-d7/a0-a6,-(a7)
                  ENDM

*********************************************************************************************

GETREGS           MACRO
                  movem.l        (a7)+,d0-d7/a0-a6
                  ENDM

*********************************************************************************************
; This waits for the blitter to finish before allowing program
; execution to continue.

WB                MACRO
\@bf:
                  btst           #6,dmaconr(a6)
                  bne.s          \@bf
                  ENDM

*********************************************************************************************
; Another version for when d6 <> dff000

WBSLOW            MACRO
\@bf:
                  btst           #6,$dff000+dmaconr
                  bne.s          \@bf
                  ENDM

*********************************************************************************************

WT                MACRO
\@bf:
                  btst           #6,(a3)
                  bne.s          \@bd
                  rts
\@bd: 
                  btst           #4,(a0)
                  beq.s          \@bf
                  ENDM

*********************************************************************************************

WTNOT             MACRO
\@bf:
                  btst           #6,(a3)
                  bne.s          \@bd
                  rts
\@bd: 
                  btst           #4,(a0)
                  bne.s          \@bf
                  ENDM

*********************************************************************************************

SUPERVISOR  MACRO
            SAVEREGS
            move.l      $4,a6
            lea.l       \1(pc),a5                                                       
            jsr         _LVOSupervisor(a6)
            GETREGS
            ENDM

*********************************************************************************************

*---------------------------------------------------------------------------*
DUGDOS            MACRO
                  Move.l         DosBase,a6
                  Jsr            _LVO\1(a6)		DosCall
                  ENDM
*---------------------------------------------------------------------------*
DUGREQ            MACRO
                  Move.l         ReqBase,a6
                  Jsr            _LVO\1(a6)		ReqCall
                  ENDM
*---------------------------------------------------------------------------*
BLIT_NASTY        MACRO
                  Move.w         #$8400,Dmacon(a6)	Blitter Nasty On
                  ENDM
*---------------------------------------------------------------------------*
BLIT_NICE         MACRO
                  Move.w         #$0400,Dmacon(a6)	Blitter Nasty Off
                  ENDM
*---------------------------------------------------------------------------*
WAIT_BLIT         MACRO
.\@
                  Btst           #6,DMACONR(a6)		Wait for Blitter End
                  Bne.s          .\@
                  ENDM

*---------------------------------------------------------------------------*
SCROLL_WB         MACRO
.\@
                  Btst           #6,DMACONR-BLTSIZE(a3)		Wait for Blitter End
                  Bne.s          .\@
                  ENDM
*---------------------------------------------------------------------------*
PALETTE32COL      MACRO
                  dc.l           $1800000,$1820000,$1840000,$1860000,$1880000,$18a0000
                  dc.l           $18c0000,$18e0000,$1900000,$1920000,$1940000,$1960000
                  dc.l           $1980000,$19a0000,$19c0000,$19e0000,$1a00000,$1a20000
                  dc.l           $1a40000,$1a60000,$1a80000,$1aa0000,$1ac0000,$1ae0000
                  dc.l           $1b00000,$1b20000,$1b40000,$1b60000,$1b80000,$1ba0000
                  dc.l           $1bc0000,$1be0000
                  ENDM
*---------------------------------------------------------------------------*
* QMOVE  move a constant into a reg the quickest way (probbly)              *
* qmove.w 123,d0 NB:if word or byte, will still use moveq!!! if it can      *
*---------------------------------------------------------------------------*
QMOVE             MACRO
                  IFGE           \1
                  IFLE           \1-127
                  Moveq          #\1,\2
                  MEXIT
                  ENDC
                  IFLE           \1-255
                  Moveq          #256-\1,\2
                  Neg.b          \2
                  MEXIT
                  ENDC
                  move.\0        #\1,\2
                  MEXIT
                  ELSEIF
                  move.\0        #\1,\2
                  ENDC
                  ENDM

;*---------------------------------------------------------------------------*
;STRUCTURE	MACRO		; structure name, initial offset
;*---------------------------------------------------------------------------*
;\1		EQU	0
;SOFFSET		SET     0
;		ENDM
;*---------------------------------------------------------------------------*
;BYTE		MACRO		;byte (8 bits)
;*---------------------------------------------------------------------------*
;\1		EQU	SOFFSET
;SOFFSET		SET	SOFFSET+1
;		ENDM
;*---------------------------------------------------------------------------*
;WORD	    	MACRO		; word (16 bits)
;*---------------------------------------------------------------------------*
;\1	    	EQU     SOFFSET
;SOFFSET     	SET     SOFFSET+2
;	    	ENDM
;*---------------------------------------------------------------------------*
;LONG	    	MACRO		; long (32 bits)
;*---------------------------------------------------------------------------*
;\1		EQU     SOFFSET
;SOFFSET		SET     SOFFSET+4
;	    	ENDM
;*---------------------------------------------------------------------------*
;NBYTE		MACRO		;byte (8 bits)
;*---------------------------------------------------------------------------*
;SOFFSET		SET	SOFFSET+1
;		ENDM
;*---------------------------------------------------------------------------*
;NWORD	    	MACRO		; word (16 bits)
;*---------------------------------------------------------------------------*
;SOFFSET     	SET     SOFFSET+2
;	    	ENDM
;*---------------------------------------------------------------------------*
;NLONG	    	MACRO		; long (32 bits)
;*---------------------------------------------------------------------------*
;SOFFSET		SET     SOFFSET+4
;	    	ENDM
;*---------------------------------------------------------------------------*
;LABEL	    	MACRO		; Define a label without bumping the offset
;*---------------------------------------------------------------------------*
;\1	    	EQU     SOFFSET
;	    	ENDM
;*---------------------------------------------------------------------------*
;STRUCT	    	MACRO		; Define a sub-structure
;*---------------------------------------------------------------------------*
;\1		EQU     SOFFSET
;SOFFSET		SET     SOFFSET+\2
;		ENDM
;*---------------------------------------------------------------------------*
;ALIGNWORD   	MACRO		; Align structure offset to nearest word
;*---------------------------------------------------------------------------*
;SOFFSET		SET     (SOFFSET+1)&$fffffffe
;	    	Even
;	    	ENDM
;*---------------------------------------------------------------------------*
;ALIGNLONG	MACRO		; Align structure offset to nearest longword
;*---------------------------------------------------------------------------*
;SOFFSET		SET     (SOFFSET+3)&$fffffffc
;		CNOP	0,4
;		ENDM
;*---------------------------------------------------------------------------*
;AGAALIGN	MACRO		; Align structure offset to nearest longword
;*---------------------------------------------------------------------------*
;		CNOP	0,8
;		ENDM
;*---------------------------------------------------------------------------*

******************************************************************

SCALE             MACRO
                  dc.w           64*0
                  dc.w           64*1
                  dc.w           64*1
                  dc.w           64*2
                  dc.w           64*2
                  dc.w           64*3
                  dc.w           64*3
                  dc.w           64*4
                  dc.w           64*4
                  dc.w           64*5
                  dc.w           64*5
                  dc.w           64*6
                  dc.w           64*6
                  dc.w           64*7
                  dc.w           64*7
                  dc.w           64*8
                  dc.w           64*8
                  dc.w           64*9
                  dc.w           64*9
                  dc.w           64*10
                  dc.w           64*10
                  dc.w           64*11
                  dc.w           64*11
                  dc.w           64*12
                  dc.w           64*12
                  dc.w           64*13
                  dc.w           64*13
                  dc.w           64*14
                  dc.w           64*14
                  dc.w           64*15
                  dc.w           64*15
                  dc.w           64*16
                  dc.w           64*16
                  dc.w           64*17
                  dc.w           64*17
                  dc.w           64*18
                  dc.w           64*18
                  dc.w           64*19
                  dc.w           64*19
                  dc.w           64*20
                  dc.w           64*20
                  dc.w           64*21
                  dc.w           64*21
                  dc.w           64*22
                  dc.w           64*22
                  dc.w           64*23
                  dc.w           64*23
                  dc.w           64*24
                  dc.w           64*24
                  dc.w           64*25
                  dc.w           64*25
                  dc.w           64*26
                  dc.w           64*26
                  dc.w           64*27
                  dc.w           64*27
                  dc.w           64*28
                  dc.w           64*28
                  dc.w           64*29
                  dc.w           64*29
                  dc.w           64*30
                  dc.w           64*30
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  dc.w           64*31
                  ENDM
                  
******************************************************************

                  endc  