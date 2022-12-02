;Author: Aliaa Gheis
;DATE:
;This Progam
;======================
        PUBLIC color, boardWidth, imageWidth
;======================
        .286
        include graphics.inc
        .MODEL SMALL
        .STACK 64
        .DATA
color           db 15, 9 
highlightColor  equ 72
boardWidth      equ 25
imageWidth      equ 25  
; ____ game peice ____ ;
emptyCell       equ 0
pawn            equ 1
rook            equ 2
knight          equ 3
bishop          equ 4
queen           equ 5
king            equ 6
; ____ peice color ____ ;
black           equ 8
white           equ 0
; ____ peice mask ____ ;
peice           equ 7
; ____ board ____ ;
board           db  rook+black, knight+black, bishop+black, queen+black, king+black, bishop+black, knight+black, rook+black
                db  8 dup(pawn+black)
                db  4 dup( 8 dup ( emptyCell) )
                db  8 dup(pawn)
                db  rook, knight, bishop, queen, king, bishop, knight, rook

Bbishop DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 15, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 15, 15, 15, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 15, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4
 DB 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4



Wbishop DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 16, 16, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 16, 16, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 15, 15, 15, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4



Bknight DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 15, 16, 16, 16, 16, 16, 16, 16, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 15, 16, 16, 16, 16, 16, 16, 16, 16, 15, 15, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 4, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 15, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 4, 4, 4, 4
 DB 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4



Wknight DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 16, 15, 15, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 15, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 16, 15, 15, 15, 15, 15, 15, 16, 4, 4, 4, 4, 4
 DB 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 16, 16, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 16, 16, 16, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 15, 15, 15, 15, 16, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 16, 4, 4, 4, 4
 DB 4, 4, 16, 15, 15, 15, 15, 15, 16, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 15, 16, 15, 16, 16, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4



Brook DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 4, 4, 16, 16, 16, 16, 4, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4



Wrook DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 4, 4, 16, 16, 16, 16, 4, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 15, 16, 16, 16, 16, 15, 15, 16, 16, 16, 15, 15, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4



Bqueen DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 16, 16, 4, 4, 16, 16, 16, 4, 4, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 16, 16, 16, 4, 4, 4
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 16, 16, 16, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 16, 16, 16, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4
 DB 16, 16, 16, 16, 4, 16, 16, 16, 16, 4, 16, 16, 16, 4, 16, 16, 16, 4, 16, 16, 16, 16, 16, 4, 4
 DB 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 16, 16, 16, 4, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 15, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 15, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4



Wqueen DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 15, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 16, 16, 16, 16, 4, 16, 16, 16, 16, 4, 16, 16, 16, 16, 16, 16, 15, 16, 16, 16, 16, 16, 16, 4, 4
 DB 16, 16, 15, 16, 16, 16, 16, 16, 16, 4, 16, 16, 16, 4, 16, 16, 16, 16, 4, 16, 16, 16, 16, 4, 4
 DB 16, 16, 16, 16, 16, 4, 16, 16, 16, 4, 16, 16, 16, 4, 16, 16, 16, 16, 4, 16, 16, 16, 16, 4, 4
 DB 4, 16, 16, 16, 16, 4, 16, 16, 16, 4, 16, 16, 16, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4
 DB 4, 4, 16, 16, 16, 4, 16, 16, 16, 16, 16, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 16, 16, 16, 15, 16, 16, 16, 15, 16, 16, 16, 15, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 15, 16, 16, 15, 15, 16, 16, 15, 16, 16, 16, 15, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 15, 16, 16, 15, 15, 16, 16, 15, 15, 16, 15, 15, 16, 16, 15, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 16, 15, 15, 16, 16, 15, 16, 16, 15, 16, 16, 15, 15, 16, 15, 15, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 15, 15, 15, 15, 15, 15, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4



Bking DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 4, 4, 4, 16, 16, 16, 16, 16, 4, 4, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 16, 16, 15, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 15, 15, 15, 15, 15, 16, 4, 4, 4, 4
 DB 4, 16, 16, 15, 16, 16, 16, 16, 15, 15, 16, 16, 16, 15, 15, 16, 16, 16, 16, 15, 15, 16, 4, 4, 4
 DB 4, 16, 15, 16, 16, 16, 16, 16, 16, 16, 15, 16, 15, 16, 16, 16, 16, 16, 16, 16, 15, 16, 4, 4, 4
 DB 4, 16, 15, 16, 16, 16, 16, 16, 16, 16, 16, 15, 15, 16, 16, 16, 16, 16, 16, 16, 15, 16, 4, 4, 4
 DB 4, 16, 15, 15, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 16, 16, 16, 16, 16, 16, 15, 16, 4, 4, 4
 DB 4, 4, 16, 15, 16, 16, 16, 16, 16, 16, 16, 15, 16, 16, 16, 16, 16, 16, 16, 15, 16, 4, 4, 4, 4
 DB 4, 4, 4, 16, 15, 15, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 15, 15, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 15, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 15, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 15, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4



Wking DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 4, 4, 16, 16, 15, 15, 16, 16, 4, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 15, 15, 15, 15, 16, 16, 16, 15, 15, 16, 16, 15, 15, 15, 15, 16, 16, 4, 4, 4, 4
 DB 4, 4, 16, 16, 15, 15, 15, 15, 15, 16, 16, 15, 15, 16, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4
 DB 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 4, 4, 4
 DB 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4
 DB 4, 4, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 4, 4, 4
 DB 4, 4, 16, 16, 15, 15, 15, 15, 15, 15, 15, 16, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4
 DB 4, 4, 4, 16, 16, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 15, 16, 16, 16, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 16, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 16, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
 DB 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
        .CODE

MAIN    PROC FAR
        MOV AX, @DATA
        MOV DS, AX

        mov ax, 0a000h  ;for inline drawing        
        mov es, ax

        ; ____ inialize video mode ____;
        CLRS            ; clear screen
        mov ax, 0013h   ; to video mode        
        int 10h
        
        
        DrawGrid boardWidth, color


        DrawImg Bbishop, imageWidth, 25
        DrawImg Bking, 25, 0
        DrawImg Wking, 25, 50
            


        ;__end___;
        CALL waitSec
        CALL waitSec
        MOV AH, 4CH
        INT 21H
MAIN    ENDP

clcWhere    PROC  ;ax = row, cx = col =>>>> ax = current start point
push dx

            mov dx, 320
            mul dx
            add ax, cx
            ;ax = current start point
pop dx
RET
ENDP    clcWhere


waitSec     PROC  ;ax = row, cx = col =>>>> ax = current start point
            push ax

            mov ah, 07
            int 21h

            pop ax
            RET
ENDP    waitSec

drawBoard       PROC
                RET
                ENDP
END MAIN