*********************************************************************************************

             opt       P=68020

*********************************************************************************************

OrderZones:

             move.l    ListOfGraphRooms,a0

; a0=list of rooms to draw.

             move.l    #ToDrawTab,a1
             move.l    a1,a3

             moveq     #99,d0
             moveq     #0,d1

.clrtab:
             move.l    d1,(a1)+
             dbra      d0,.clrtab

             move.l    a0,a1
             move.l    #OrderTab,a5

settodraw:
             move.l    (a1),d0
             blt.s     nomoreset
 
             move.l    d0,a2
             move.w    (a2),d0
             st        (a3,d0.w)
             adda.w    #10,a1
             bra.s     settodraw
 
nomoreset:

; We now have a table with $ff rep.
; a room to be drawn at some stage.

             move.w    ([a0]),d0
             move.w    d0,OrderTab+2+8
             move.w    #-1,OrderTab+4+8
             move.w    #0,OrderTab+8
             move.w    #1,OrderTab+6+8
             move.w    #1,OrderTab+4
             move.w    #-1,OrderTab
             move.w    #-1,OrderTab+2
             move.w    #2,d5                  ; off end of list.
 
             move.w    #7,d7                  ; which ones to look at.

OrderLoop:
             clr.b     d6                     ; flag for new zones added.

             move.l    #OrderTab,a5
 		
RunThroughList:
             tst.w     6(a5)
             bra.s     anewone

             move.w    4(a5),d0
             blt       doneallthispass
             move.l    #OrderTab,a5	
             lea       (a5,d0.w*8),a5
             bra       RunThroughList

anewone:
             move.w    #0,6(a5)
             move.l    #FloorLines,a1

             move.w    2(a5),d0
             move.l    #ZoneAdds,a0
             move.l    (a0,d0.w*4),a0

             adda.w    #14,a0

findexits:
             move.w    (a0)+,d0
             bge.s     findexits
             addq      #2,a0

             bsr       InsertList

             move.w    4(a5),d0
             blt       doneallthispass
             move.l    #OrderTab,a5	
             lea       (a5,d0.w*8),a5
             bra       RunThroughList

doneallthispass:
             tst.b     d6
             bne       OrderLoop

             move.l    #OrderTab,a5
             move.w    4(a5),d0
             lea       (a5,d0.w*8),a5

             move.l    #FinalOrder,a0
 
showorder:
             move.w    2(a5),(a0)+
             move.w    4(a5),d0
             blt.s     doneorder
             move.l    #OrderTab,a5
             lea       (a5,d0.w*8),a5
             bra       showorder

doneorder:
             move.l    a0,endoflist
             move.w    #-1,(a0)+
             rts

*********************************************************************************************

endoflist:   dc.l      0

*********************************************************************************************

InsertList:

             move.w    (a0)+,d0               ; floor line
             blt       allinlist

             move.l    #ToDrawTab,a3

             asl.w     #4,d0
             move.l    8(a1,d0.w),a2
             move.w    (a2),d1
             tst.b     (a3,d1.w)
             beq       notindrawlist

; Here is a room in the draw list.
; Find out if it is further away
; or closer than the current zone.

             move.w    xoff,d2
             move.w    zoff,d3
             sub.w     (a1,d0.w),d2
             sub.w     2(a1,d0.w),d3
             muls      6(a1,d0.w),d2
             muls      4(a1,d0.w),d3
             sub.l     d3,d2
             bge       PutFurtherAway
 
************************************** 

             bra       PutDone

**************************************

PutFurtherAway:
             move.l    a5,a4

.lookfurther:
             move.w    4(a4),d0
             blt.s     .notfurther
             move.l    #OrderTab,a4
             lea       (a4,d0.w*8),a4
             cmp.w     2(a4),d1
             bne       .lookfurther

; Already in list so do nothing.
 
             bra       .wasfurther
 
.notfurther:

; Might be closer so check

             move.l    a5,a3

.lookcloser:
             move.w    (a3),d0
             blt       .notcloser
             move.l    #OrderTab,a3
             lea       (a3,d0.w*8),a3
             cmp.w     2(a3),d1
             bne       .lookcloser

; Oh dear! it is closer!
; Have to get rid of it!

             move.l    #OrderTab,a6
             move.w    4(a3),d0
             tst.w     6(a6,d0.w*8)
             beq.s     .nomoreafter

.moreafter:
             move.w    4(a6,d0.w*8),d0
             tst.w     6(a6,d0.w*8)
             bne.s     .moreafter

.nomoreafter:
             move.w    (a6,d0.w*8),d0
             move.l    #OrderTab,a6
             lea       (a6,d0.w*8),a6         ; end of list

             move.w    (a3),d0
             move.w    4(a6),d2
             move.l    #OrderTab,a2
             lea       (a2,d2.w*8),a4
             lea       (a2,d0.w*8),a2
 
             move.w    4(a2),d3
             move.w    (a4),d4
 
             move.w    d2,4(a2)
             move.w    d0,(a4)
 
             st        d6
 
             move.w    4(a5),d0
             blt.s     .append
 
             move.l    #OrderTab,a4
             lea       (a4,d0.w*8),a4
             move.w    d0,4(a6)
             move.w    (a4),(a3)
             move.w    d4,(a4)
             move.w    d3,4(a5)
 
             move.l    a6,a5

             bra       .wasfurther
 
.append:
             move.w    d0,4(a6)
             move.w    (a5),d0
             move.w    d3,4(a5)
             move.l    #OrderTab,a4
             move.w    4(a4,d0.w*8),(a3)
 
             move.l    a6,a5

             bra       .wasfurther

.notcloser:
; Now insert it after current one.
             move.l    #OrderTab,a3
             lea       (a3,d5.w*8),a3
             move.w    d1,2(a3)
             st        6(a3)

             move.w    4(a5),d0
             blt.s     .atfarend
             move.l    #OrderTab,a4
             move.w    d5,(a4,d0.w*8)

.atfarend:
             move.w    (a5),d0
             move.l    #OrderTab,a4
             lea       (a4,d0.w*8),a4
             move.w    4(a4),(a3)

             move.w    4(a5),4(a3)
             move.w    d5,4(a5)
             move.l    a3,a5
 
             addq      #1,d5

             st        d6
 
.wasfurther:
PutDone:
notindrawlist:
             bra       InsertList

allinlist:
             rts

*********************************************************************************************

ToDrawTab:   ds.l      100
OrderTab:    ds.l      100
             dc.w      -1
             
FinalOrder:  ds.l      100
doneone:     dc.w      0

*********************************************************************************************