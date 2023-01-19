*********************************************************************************************

                        opt       P=68020

*********************************************************************************************
; Inline source
; For : Plr2Control.s
; Description : Plr2 mouse+keyboard control (activate by 'n' -> 'wasd' move + mouse angle + lmb fire + rmb space)
*********************************************************************************************
; Definitions

Plr2WalkSpeed               EQU 2 
Plr2RunSpeed                EQU 3
Plr2MouseActinDelay         EQU 15

****************************************************************
; Mouse

                    jsr         ReadMouse

                    move.l      #SineTable,a0
                    move.w      PLR2s_angspd,d1
                    move.w      angpos,d0
                    and.w       #8190,d0
                    move.w      d0,PLR2s_angpos
                    move.w      (a0,d0.w),PLR2s_sinval
                    adda.w      #2048,a0
                    move.w      (a0,d0.w),PLR2s_cosval

****************************************************************

                    tst.b       PLR2_fire
                    beq.s       .firenotpressedPlr2MouseLMB
; fire was pressed last time.
                    btst        #6,$bfe001
                    bne.s       .firenownotpressedPlr2MouseLMB
; fire is still pressed this time.
                    st          PLR2_fire
                    bra         .donePLR2MouseLMB
 
.firenownotpressedPlr2MouseLMB:
; fire has been released.
                    clr.b       PLR2_fire
                    bra         .donePLR2MouseLMB
 
.firenotpressedPlr2MouseLMB:
; fire was not pressed last frame...
                    btst        #6,$bfe001
; if it has still not been pressed, go back above
                    bne.s       .firenownotpressedPlr2MouseLMB
; fire was not pressed last time, and was this time, so has
; been clicked.
                    st          PLR2_clicked
                    st          PLR2_fire

.donePLR2MouseLMB:

****************************************************************

                    move.w      $dff016,d0
                    btst        #10,d0
                    bne.s       .donePLR2MouseRMB

                    move.w      PLR2_msbActinDelay,d1
                    sub.w       #1,d1
                    bpl.s       .donePLR2MouseRMB
                    st          PLR2_SPCTAP
                    move.w      #Plr2MouseActinDelay,d1

.donePLR2MouseRMB:
                    move.w      d1,PLR2_msbActinDelay

****************************************************************
; Kbd

                    move.l      #SineTable,a0
                    move.l      #KeyMap,a5
                    move.l      #0,d7

                    move.w      PLR2s_angspd,d3
                    move.w      #Plr2WalkSpeed,d2
                    moveq       #0,d7

                    move.b      run_key,d7
                    tst.b       (a5,d7.w)
                    beq.s       .nofasterPlr2Kbd
                    move.w      #Plr2RunSpeed,d2

.nofasterPlr2Kbd:
                    tst.b       PLR2_Ducked
                    beq.s       .nohalvePlr2Kbd
                    asr.w       #1,d2

.nohalvePlr2Kbd:
                    moveq       #0,d4 
                  
                    move.w      d3,d5
                    add.w       d5,d5
                    add.w       d5,d3
                    asr.w       #2,d3
                    bge.s       .nnegPlr2Kbd
                    addq        #1,d3

.nnegPlr2Kbd:

                    tst.b       $20(a5)                             ; A
                    beq.s       noleftslidePlr2Kbd
                    add.w       d2,d4
                    add.w       d2,d4
                    asr.w       #1,d4

noleftslidePlr2Kbd:
                    tst.b       $22(a5)                             ; D
                    beq.s       norightslidePlr2Kbd
                    add.w       d2,d4
                    add.w       d2,d4
                    asr.w       #1,d4
                    neg.w       d4

norightslidePlr2Kbd:

                    move.l      PLR2s_xspdval,d6
                    move.l      PLR2s_zspdval,d7

                    neg.l       d6
                    ble.s       .nobug1Plr2Kbd
                    asr.l       #3,d6
                    add.l       #1,d6
                    bra.s       .bug1Plr2Kbd

.nobug1Plr2Kbd:
                    asr.l       #3,d6

.bug1Plr2Kbd:
                    neg.l       d7
                    ble.s       .nobug2Plr2Kbd
                    asr.l       #3,d7
                    add.l       #1,d7
                    bra.s       .bug2Plr2Kbd

.nobug2Plr2Kbd:
                    asr.l       #3,d7

.bug2Plr2Kbd: 
                    moveq       #0,d3
                    moveq       #0,d5

                    tst.b       $11(a5)                             ; W 
                    beq.s       noforwardPlr2Kbd
                    neg.w       d2
                    move.w      d2,d3
 
noforwardPlr2Kbd:
                    tst.b       $21(a5)                             ;  S
                    beq.s       nobackwardPlr2Kbd
                    move.w      d2,d3

nobackwardPlr2Kbd:

****************************************************************

                    move.w      d3,d2
                    asl.w       #6,d2
                    move.w      d2,d1
                    move.w      d1,d2

                    add.w       PLR2_bobble,d1
                    and.w       #8190,d1
                    move.w      d1,PLR2_bobble

                    add.w       PLR2_clumptime,d2
                    move.w      d2,d1
                    and.w       #4095,d2
                    move.w      d2,PLR2_clumptime

                    and.w       #-4096,d1
                    beq.s       .noclumpPlr2Kbd

                    bsr         PLR2clump
 
.noclumpPlr2Kbd:

****************************************************************

                    move.w      PLR2s_sinval,d1
                    muls        d3,d1
                    move.w      PLR2s_cosval,d2
                    muls        d3,d2

                    sub.l       d1,d6
                    sub.l       d2,d7
                    move.w      PLR2s_sinval,d1
                    muls        d4,d1
                    move.w      PLR2s_cosval,d2
                    muls        d4,d2
                    sub.l       d2,d6
                    add.l       d1,d7
                  
                    add.l       d6,PLR2s_xspdval
                    add.l       d7,PLR2s_zspdval
                    move.l      PLR2s_xspdval,d6
                    move.l      PLR2s_zspdval,d7
                    add.l       d6,PLR2s_xoff
                    add.l       d7,PLR2s_zoff
 
.donePLR2Kbd:

****************************************************************

                    move.l      #KeyMap,a5
                    move.l      #0,d7

                    move.b      forward_key,d7
                    clr.b       (a5,d7.w)
                    move.b      backward_key,d7
                    clr.b       (a5,d7.w)

                    move.b      duck_key,d7
                    move.w      d7,-(a7) 
                    move.b      #$23,duck_key                            ; F

                    jsr         PLR2_alwayskeys

                    move.l      #0,d7
                    move.w      (a7)+,d7
                    move.b      d7,duck_key 

****************************************************************

                    bsr         PLR2_fall

*********************************************************************************************