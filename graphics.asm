PUBLIC DrawGrid, DrawBoard, DrawSquareBord, MvePlayerFromGraphics, MvePlayerToGraphics, DrawHighlightedMvs, ClrHighlightedMvs, MvePieceFromGraphics, MvePieceToGraphics

EXTRN color:BYTE
EXTRN board:BYTE
EXTRN Bpawn:BYTE
EXTRN validateMoves:BYTE
EXTRN highlightPeiceMvs:BYTE
EXTRN playerCells:BYTE
EXTRN playerCols:BYTE
EXTRN playerRows:BYTE
EXTRN highlightColor:BYTE
EXTRN PlayerPos:WORD
EXTRN PlayerSelectedPos:WORD
EXTRN PlayerSelectedCell:BYTE
EXTRN PlayerSelectedRow:BYTE

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

DrawImg     PROC        FAR ;al = peice di = startPoint
                                cmp ax, emptyCell ;check if empty cell
                                jne DrawImglabel  ;if not start drawing
                                RET               ;else return 

                DrawImglabel:   pusha
                                lea bx, Bpawn;bx = offset of first image in mem  
                                mov dx, ax;dx=peice 
                                and ax, 7;peice type
                                shl ax, 1;2*p
                                sub ax, 1;2*p-1
                                and dx, 8;peice color
                                shr dx, 3;peice color/8
                                sub ax, dx;(2*p-1)-pc/8

                                mov dx, boardWidth*boardWidth;23*23
                                mul dx;ax = ((2*p-1)-pc/8)*23*23
                                add bx, ax;bx = offset of image that should drawn
                                mov cx, imageWidth
            
                        ;======= start loop row by row =======;
                        lp1:    push cx
                                mov cx, imageWidth
                        ;======= start loop col by col =======;
                                lp2:    mov al, [bx]
                                        cmp al, 4 ;skip if color is transparent = [4]
                                        je skip
                                        mov es:[di], al ;draw color of pixel

                                skip:   inc di;update cursor
                                        inc bx;update pixel of img
                                loop    lp2
                                add di, 320-imageWidth;return to first col next row
                                pop cx
                        loop lp1
        popa
        RET
DrawImg ENDP 

DrawBoard       PROC    FAR ;inialize first with all peices
                pusha 
                        mov si, 0 ;initial cell      
                        mov di, 0 ;initial position

                        mov cx, 2
                ;========= loop on pair rows =========;
                DrawBoardLoop1: push cx
                ;========= loop on row in the pair of rows =========;
                                mov cx, 2
                DrawBoardLoop2: push cx
                                mov cx, 8
                ;========= loop for all cells in row =========;
                                DrawBoardLoop3:
                                        mov ah, 0
                                        mov al, board[si]
                                        CALL DrawImg

                                        inc si                  ;to next cell
                                        add di, boardWidth      ;to next position in row
                                loop DrawBoardLoop3
                                add di, 320*boardWidth-boardWidth*8 ;for next row and return to next col
                pop cx
                loop DrawBoardLoop2
                mov si, 48   ;cell    of before last row, first col
                mov di, boardWidth*320*6 ;position of before last row, first col
                pop cx
                loop DrawBoardLoop1
        popa
        RET
DrawBoard       ENDP     


DrawSquareBord PROC    FAR ;di = start position, al = highlight color 
                pusha
                ;=========== draw first row ==========;
                mov cx, boardWidth
                REP STOSB
                
                ;=========== draw columns ==========;
                add di, 320-boardWidth ;to return di to first col next row
                mov cx, boardWidth-2   ;number of pixels of one column to draw
        DWSQ1:  STOSB                  ;draw pixel in first col
                add di, boardWidth-2   ;update pos for nxt col
                STOSB                  ;draw pixel in sec col
                add di, 320-boardWidth ;update di to first col next row
        loop DWSQ1


                ;=========== draw last row ==========;
                mov cx, boardWidth
                REP STOSB

        popa
        RET
DrawSquareBord ENDP 

DrawSquare PROC    FAR ;di = start position, al = highlight color 
        pusha
                ;=========== draw row by row ==========;
                mov cx, boardWidth      ;number of rows of one cell
        DWSquareL:  push cx             ;store cx
                mov cx, boardWidth      ;width of one row
                REP STOSB               ;draw col
                add di, 320-boardWidth ;update di to first col next row
        pop cx
        loop DWSquareL

        popa
        RET
DrawSquare ENDP 

GetCellColorofPlayer PROC  FAR;di=player number ===> al = color of cell
push bx
        mov bl, playerCells[si]
        add bl, playerRows[si]
        and bl, 1
        mov bh, 0
        mov al, color[bx]
pop bx
RET
ENDP GetCellColorofPlayer

MvePlayerFromGraphics   PROC FAR;si=player number ====> al = color of cell player on, di = player pos

        push bx
                                mov bl, playerCells[si] ;bl = playerCell
                                cmp validateMoves[bx], 1;chk if one of valid moves
                                jl clearSquare          ;if not => clearSquare=> get color of cell
                                mov al, 72              ;else al = highligh move color
                                jmp startMvePlayerFrom  ;and start draing

                        ;=========== get color of cell that player stand on =====;
        clearSquare:            add bl, playerRows[si]  ;bl= row + cell
                                and bl, 1               ;if odd => cell color index 1 
                                mov bh, 0               ;if even=> cell color index 0
                                mov al, color[bx]       ;load color
                        ;=========== get color of cell that player stand on =====;
        startMvePlayerFrom:     pop bx
                                shl si, 1 ;2*si
                                mov di, PlayerPos[si]
                                CALL DrawSquareBord
                                shr si, 1 ;si/2
RET
MvePlayerFromGraphics   ENDP

MvePlayerToGraphics     PROC FAR ;si = player number

                        mov al, 4
                        mov di, playerPos[si]
                        CALL DrawSquareBord

RET
MvePlayerToGraphics   ENDP


MvePieceFromGraphics   PROC FAR;si = player
                                push bx

                                mov bh, 0
                                mov bl, PlayerSelectedCell[si]

                                mov validateMoves[bx], 0        ;for not clear again in ClrHighlight..
                        ;=========== get color of cell that player stand on =====;
                                add bl, PlayerSelectedRow[si]   ;bl= row + cell
                                and bl, 1                       ;if odd => cell color index 1 
                                mov bh, 0                       ;if even=> cell color index 0
                                mov al, color[bx]               ;load color
                        ;=========== get color of cell that player stand on =====;
                                pop bx
                                shl si, 1 ;2*si
                                mov di, PlayerSelectedPos[si]

                                CALL DrawSquare
                                shr si, 1 ;si/2
RET
MvePieceFromGraphics   ENDP

MvePieceToGraphics      PROC    FAR;si = player number
                        push bx
                        mov bh, 0
                        mov bl, PlayerSelectedCell[si]
                        mov ah, 0
                        mov al, board[bx]       ;al = player peice
                        pop bx

                        shl si, 1
                        MOV di, PlayerPos[si]   ;di = player pos
                        shr si, 1

                        CALL DrawImg

                        pop bx
RET
MvePieceToGraphics      ENDP

DrawHighlightedMvs      PROC    FAR     ;si = player number
        pusha 
                        mov bx, 0 ;cell      
                        mov di, 0 ;position
        ;======== loop row by row ==========;
                        mov cx, 8 ;row
        DrawHIGH1:      push cx
                        mov cx, 8
        ;======== loop col by col ==========;
                        DrawHIGH2:
                                mov ah, 0
                                mov al, validateMoves[bx]        ;al = valid move state of cell
                                cmp ax, si                       ;check that's one of player valid mvs
                                jne DontDrawMve                  ;if not skip
                                mov al, 72          ;al = highlightcolor
                                CALL DrawSquareBord            ;Draw

                        DontDrawMve:    inc bx                  ;update cell number
                                        add di, boardWidth      ;update position to nxt col
                        loop DrawHIGH2              

                        add di, 320*boardWidth-boardWidth*8     ;update position to nxt row first col
                        pop cx
                        loop DrawHIGH1
        popa
        RET
DrawHighlightedMvs      ENDP

ClrHighlightedMvs      PROC    FAR     ;si = player number
        pusha 
                        mov bx, 0 ;cell      
                        mov di, 0 ;position
                        mov dx, 0 ;color of cell
        ;======== loop row by row ==========;
                        mov cx, 8 ;row
        ClrHIGH1:      push cx
                        mov cx, 8
        ;======== loop col by col ==========;
                        ClrHIGH2:
                                mov ah, 0
                                mov al, validateMoves[bx]        ;al = valid move state of cell
                                cmp ax, si                       ;check that's one of player valid mvs
                                jne DontClrMve                  ;if not skip
                                mov validateMoves[bx], 0        ;else Clear Cell by move zero and clear graphically
                                ;== Clear Cell by Draw it's color on Border ==;
                                push bx                         ;store bx
                                mov bx, dx                      ;bx = index of cell color
                                mov al, color[bx]               ;al = highlightcolor
                                CALL DrawSquareBord            ;Draw
                                pop bx                          ;return bx
                                ;== Clear Cell by Draw it's color on Border ==;

                        DontClrMve:    inc bx                  ;update cell number
                                        add di, boardWidth      ;update position to nxt col
                                        xor dx, 1               ;toggle cell color
                        loop ClrHIGH2              

                        add di, 320*boardWidth-boardWidth*8     ;update position to nxt row first col
                        xor dx, 1                               ;toggle cell color
                        pop cx
                        loop ClrHIGH1
        popa
        RET
ClrHighlightedMvs      ENDP
END

