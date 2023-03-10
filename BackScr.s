*********************************************************************************************

  opt       P=68020

*********************************************************************************************

              incdir     "includes"
              include    "AB3DI.i"

*********************************************************************************************

putinlargescr:

  move.l    #$1000000,statskip
  move.l    #$fffffffe,statskip+4

  move.l    #healthpal,a5
  move.l    COPSCRN1,a0
  move.l    COPSCRN2,a2
  move.w    #scrheight-1,d0
  move.l    #0,d6
  move.w    #0,d3
  move.w    #$29df,startwait
  move.w    #$2b01,endwait

.fillcop:
  move.w    #$180,d1

  move.l    a0,a1
  move.l    a2,a3
  move.w    #$10c,(a1)+
  move.w    #$10c,(a3)+
  move.w    d3,(a1)+
  move.w    d3,(a3)+
  eor.w     #$8000,d3

  move.w    #$106,(a1)+
  move.w    #$106,(a3)+
  move.w    #$2c42,d5
  or.w      d3,d5
  and.w     #$fffe,d5
  move.w    d5,(a1)+
  move.w    d5,(a3)+
  bsr       do32

  move.w    #$106,(a1)+
  move.w    #$106,(a3)+
  move.w    #$4c42,d5
  or.w      d3,d5
  and.w     #$fffe,d5
  move.w    d5,(a1)+
  move.w    d5,(a3)+
  bsr       do32

  move.w    #$106,(a1)+
  move.w    #$106,(a3)+
  move.w    #$6c42,d5
  or.w      d3,d5
  and.w     #$fffe,d5
  move.w    d5,(a1)+
  move.w    d5,(a3)+
  bsr       do32
 
  move.w    startwait,(a1)+
  move.w    #$fffe,(a1)+
  move.w    endwait,(a1)+
  move.w    #$ff00,(a1)+
  move.w    startwait,(a3)+
  move.w    #$fffe,(a3)+
  move.w    endwait,(a3)+
  move.w    #$ff00,(a3)+
 
 
  add.w     #$300,startwait
  add.w     #$300,endwait

; move.l #$1060c42,(a1)+
; move.l #$1060c42,(a3)+
; move.w #$19e,(a1)+
; move.w (a5),(a1)+
; move.w #$19e,(a3)+
; move.w (a5)+,(a3)+

**********************************

  adda.w    #widthOffset,a0
  adda.w    #widthOffset,a2
  dbra      d0,.fillcop

  move.w    #$38,fetchstart
  move.w    #$b8,fetchstop
  move.w    #$2c81,winstart
  move.w    #$2cc1,winstop
  move.w    #-40,modulo
  move.w    #-40,modulo+4

  move.l    #nullspr,d0
  move.w    d0,s0l
  move.w    d0,s1l
  move.w    d0,s2l
  move.w    d0,s3l
  move.w    d0,s4l
  move.w    d0,s5l
  move.w    d0,s6l
  move.w    d0,s7l
  swap      d0
  move.w    d0,s0h
  move.w    d0,s1h
  move.w    d0,s2h
  move.w    d0,s3h
  move.w    d0,s4h
  move.w    d0,s5h
  move.w    d0,s6h
  move.w    d0,s7h 
 
  move.l    #scrn+40,a0
  move.l    #scrn+160,a1
  move.l    #scrn+280,a2
  move.l    #scrntab,a3
  move.w    #319,d7                  ; counter
  move.w    #0,d1                    ; xpos

.plotscrnloop:
  move.b    (a3)+,d0
  move.w    d1,d2
  asr.w     #3,d2
  move.b    d1,d3
  not.b     d3
  bclr.b    d3,-40(a0,d2.w)
  bclr.b    d3,(a0,d2.w)
  bclr.b    d3,40(a0,d2.w)
  bclr.b    d3,-40(a1,d2.w)
  bclr.b    d3,(a1,d2.w)
  bclr.b    d3,40(a1,d2.w)
  bclr.b    d3,-40(a2,d2.w)
  btst      #0,d0
  beq.s     .nobp1
  bset.b    d3,-40(a0,d2.w)

.nobp1:
  btst      #1,d0
  beq.s     .nobp2
  bset.b    d3,(a0,d2.w)

.nobp2:
  btst      #2,d0
  beq.s     .nobp3
  bset.b    d3,40(a0,d2.w)

.nobp3:
  btst      #3,d0
  beq.s     .nobp4
  bset.b    d3,-40(a1,d2.w)

.nobp4:
  btst      #4,d0
  beq.s     .nobp5
  bset.b    d3,(a1,d2.w)

.nobp5:
  btst      #5,d0
  beq.s     .nobp6
  bset.b    d3,40(a1,d2.w)

.nobp6:
  btst      #6,d0
  beq.s     .nobp7
  bset.b    d3,-40(a2,d2.w)
 
.nobp7:
  addq      #1,d1
  dbra      d7,.plotscrnloop

  rts

*********************************************************************************************