PUBLIC DrawGrid, DrawBoard, Available_BackGround, DrawHighlightedMvs

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

DrawImg     PROC         ;bx = offset img, di = startPoint
            pusha

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

DrawBoard       PROC  FAR  
                pusha 
                mov si, 0 ;cell      
                mov di, 0 ;position
                mov cx, 8
        DrawBoardLoop1: push cx
                        mov cx, 8
                        DrawBoardLoop2:
                                lea bx, Bpawn
                                mov ah, 0
                                mov al, board[si]
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

Available_BackGround    PROC  FAR ;di = position, al = highlight color
        pusha                
                mov cx,boardWidth            ;height
                highlightLoop: push cx
                        ;draw line 
                        mov  cx, boardWidth          ;width   
                        REP  STOSB 
                        sub  di,boardWidth           
                        add  di,320     
                        pop cx
                loop highlightLoop
        popa
        RET
Available_BackGround ENDP 


DrawHighlightedMvs      PROC  FAR  
                        pusha 
                        mov si, 0 ;cell      
                        mov di, 0 ;position
                        mov cx, 8
        DrawHIGH1: push cx
                        mov cx, 8
                        DrawHIGH2:
                                mov ah, 0
                                mov al, validateMoves[si]       ;al = player
                                cmp al, 1                       ;if zero skip
                                jl DONTDRAWIMGHIGHT

                                push di
                                mov di, ax                      ;di = ax = player
                                mov al, highlightPeiceMvs[di]   ;al = highlightcolor of player
                                pop di
                                CALL Available_BackGround       ;
                        DONTDRAWIMGHIGHT:    inc si
                                        add di, boardWidth
                        loop DrawHIGH2
                        add di, 320*boardWidth-boardWidth*8

        pop cx
        loop DrawHIGH1
popa
RET
DrawHighlightedMvs      ENDP

END