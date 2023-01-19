*********************************************************************************************

              opt        P=68020

*********************************************************************************************

              incdir     "includes"
              include    "AB3DI.i"

*********************************************************************************************
; Format of copperlist:

COPSCRNBUFF:  dc.l       0

*********************************************************************************************
;104*80 lots of $1fe0000 initially.
;$106,$c42
;$80
;pch: 0
;$82
;pcl: 0
;
;$88,$0
;
;Length= (104*80*4)+16
*********************************************************************************************

INITCOPPERSCRN:
; Get copper screen memory

              move.l     #2,d1
              move.l     #(104*80*4)+16,d0
              move.l     4.w,a6
              jsr        _LVOAllocMem(a6)
              move.l     d0,COPSCRN1
              
              move.l     #2,d1
              move.l     #(104*80*4)+16,d0
              move.l     4.w,a6
              jsr        _LVOAllocMem(a6)
              move.l     d0,COPSCRN2

              move.l     #1,d1
              move.l     #(104*80*4)+16,d0
              move.l     4.w,a6
              jsr        _LVOAllocMem(a6)
              move.l     d0,COPSCRNBUFF

              move.l     COPSCRN1,a1
              move.l     COPSCRN2,a2

 *********************************************************************
; View setup

              move.l     #(104*80)-1,d0       ; Copper view size 104*4*80
              move.l     #$01fe0000,d1        ; Copper NOP
              
clrcop:
              move.l     d1,(a1)+             ; +4
              move.l     d1,(a2)+             ; +4
              dbra       d0,clrcop
 
              ; add.l #104*4*80,a1
              ; add.l #104*4*80,a2

*********************************************************************
; Panel setup

              move.l     #$01060c42,(a1)+     ; BPLCON3
              move.l     #$01060c42,(a2)+     ; BPLCON3

              move.w     #$0080,(a1)+         ; cop1lch
              move.w     #$0080,(a2)+         ; cop1lch

              move.l     #PanelCop,d0
              swap       d0
              move.w     d0,(a1)+
              move.w     d0,(a2)+
              move.w     #$0082,(a1)+         ; cop1lcl
              move.w     #$0082,(a2)+         ; cop1lcl
              swap       d0
              move.w     d0,(a1)+
              move.w     d0,(a2)+

              move.l     #$00880000,(a1)+     ; COPJMP1
              move.l     #$00880000,(a2)+     ; COPJMP1
  
              clr.b      BIGsmall
              jsr        putinsmallscr
  
              rts
