PUBLIC DrawGrid, DrawBoard

EXTRN color:BYTE
EXTRN board:BYTE
EXTRN Bpawn:BYTE
EXTRN validateMoves:BYTE
EXTRN highlightPeiceMvs:BYTE

.286
.MODEL SMALL
.data
        boardWidth     equ 23
        imageWidth     equ 23
        emptyCell     equ 0
.CODE

DrawGrid    PROC FAR
            pusha
            mov si, 0
            mov di, 0
            mov cx, 8


;___ draw rank by rank ____;
lr:     push cx 
        mov cx, boardWidth
        ;___ draw line by line ____;
        lh: push cx
                mov cx, 8   
                ;___ draw square line ___; 
                lw:
                        push cx

                        mov al, color[si];color
                        mov cx, boardWidth   ;width
                        REP STOSB        ;draw a width of square
                        XOR si, 1        ;toggle color for next square
                        

                        pop cx
                loop lw
                add di, 320-8*boardWidth
                pop cx
        loop lh
        XOR si, 1        ;toggle color for next square
        pop cx
loop lr
            
            popa
            RET
DrawGrid ENDP 

DrawImg     PROC         ;al = peice bx = offset img, di = startPoint
            pusha
                                lea bx, Bpawn
                                cmp ax, emptyCell
                                je DONTDRAWIMG
                                mov dx, ax

                                and ax, 7;peice type
                                shl ax, 1;2*p
                                sub ax, 1;2*p-1

                                and dx, 8;peice color
                                shr dx, 3

                                sub ax, dx;

                                mov dx, boardWidth*boardWidth
                                mul dx
                                add bx, ax
            mov cx, imageWidth
            

lp1:    push cx
        mov cx, imageWidth
        lp2:    mov al, [bx]
                cmp al, 4
                je skip

                mov es:[di], al

        skip:   inc di
                inc bx
        loop    lp2
        add di, 320-imageWidth
        pop cx
loop lp1
            popa
            RET
DrawImg ENDP 

DrawBoard       PROC    FAR
                pusha 
                mov si, 0 ;cell      
                mov di, 0 ;position
                mov cx, 8
        DrawBoardLoop1: push cx
                        mov cx, 8
                        DrawBoardLoop2:
                                mov ah, 0
                                mov al, board[si]
                                CALL DrawImg

                        DONTDRAWIMG:    inc si
                                        add di, boardWidth
                        loop DrawBoardLoop2
                        add di, 320*boardWidth-boardWidth*8

        pop cx
        loop DrawBoardLoop1
                popa
                RET
DrawBoard       ENDP     




END