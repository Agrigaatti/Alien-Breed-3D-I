*********************************************************************************************

              opt        P=68020

*********************************************************************************************

              incdir     "includes"
              include    "exec/memory.i"

              include    "AB3DI.i"

*********************************************************************************************
; Format of copperlist:
;104*80 lots of $1fe0000 initially.
;bplcon3,$c42
;$80
;pch: 0
;$82
;pcl: 0
;
;$88,$0
;
;Length= (widthOffset*scrheight)+16
*********************************************************************************************

InitCopperScrn:
; Get copper screen memory

              move.l     #MEMF_CHIP|MEMF_CLEAR,d1
              move.l     #(widthOffset*scrheight)+16,d0
              move.l     4.w,a6
              jsr        _LVOAllocMem(a6)
              move.l     d0,COPSCRN1
              
              move.l     #MEMF_CHIP|MEMF_CLEAR,d1
              move.l     #(widthOffset*scrheight)+16,d0
              move.l     4.w,a6
              jsr        _LVOAllocMem(a6)
              move.l     d0,COPSCRN2

              move.l     #MEMF_FAST|MEMF_CLEAR,d1
              move.l     #(widthOffset*scrheight)+16,d0
              move.l     4.w,a6
              jsr        _LVOAllocMem(a6)
              move.l     d0,copScrnBuff


 *********************************************************************
; View setup

              move.l     COPSCRN1,a1
              move.l     COPSCRN2,a2
              move.l     copScrnBuff,a3

              move.l     #(scrwidth*scrheight)-1,d0        ; Copper view size 104*4*80
              move.l     #copperNOP,d1                     ; Copper NOP
              
clrcop:
              move.l     d1,(a1)+                          ; +4
              move.l     d1,(a2)+                          ; +4
              move.l     d1,(a3)+                          ; +4
              dbra       d0,clrcop
 
              ; add.l #widthOffset*scrheight,a1
              ; add.l #widthOffset*scrheight,a2

*********************************************************************
; Panel setup

              move.l     #$01060c42,(a1)+                  ; BPLCON3
              move.l     #$01060c42,(a2)+                  ; BPLCON3

              move.w     #$0080,(a1)+                      ; cop1lch
              move.w     #$0080,(a2)+                      ; cop1lch

              move.l     #PanelCop,d0
              swap       d0
              move.w     d0,(a1)+
              move.w     d0,(a2)+
              move.w     #$0082,(a1)+                      ; cop1lcl
              move.w     #$0082,(a2)+                      ; cop1lcl
              swap       d0
              move.w     d0,(a1)+
              move.w     d0,(a2)+

              move.l     #$00880000,(a1)+                  ; copjmp1
              move.l     #$00880000,(a2)+                  ; copjmp1
  
              clr.b      bigSmall
              jsr        PutInSmallScr
  
              rts

*********************************************************************

copScrnBuff:  dc.l       0

*********************************************************************