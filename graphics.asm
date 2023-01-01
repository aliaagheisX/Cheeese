PUBLIC DrawBoard, DrawSquareBord,DrawSquareBordSm, MvePlayerFromGraphics 
PUBLIC DrawHighlightedMvs, ClrHighlightedMvs, MvePieceToGraphics, MvePieceFromGraphics
PUBLIC DrawPlayers
PUBLIC killedPeicePos ,killedPeiceRow, killedPeiceCol 


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
EXTRN PlayerGameNumber:WORD


.286
.MODEL SMALL
.data
;__________Messages________;
Knightkill db 'A Knight has been killed$'
Clearcheckmes db '                        $'
Pawnnkill db 'A Pawn has been killed$'
Queenkill db 'A Queen has been killed$'
Kingkill db 'A King has been killed$'
Rookkill db 'A Rook has been killed$'
Bishopkill db 'A Bishop has been killed$'
varkilled db ?
        ;------- peices -----------;
        emptyCell      equ 0
        pawn           equ 1
        rook           equ 2
        knight         equ 3
        bishop         equ 4
        queen          equ 5
        king           equ 6
        ;-------- peice colors -----;
        black          equ 8
        white          equ 0

        boardWidth     equ 23
        imageWidth     equ 23
        imageWidthSm     equ 7
        emptyCell     equ 0
        killedPeicePos dw 20664 ;23*8
        killedPeiceRow db 0 ;23*8
        killedPeiceCol db 0 ;23*8
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


DrawSquareBordSm PROC    FAR ;di = start position, al = highlight color 
                pusha
                ;=========== draw first row ==========;
                add di, 320+1   
                mov cx, boardWidth-2
                REP STOSB
                
                ;=========== draw columns ==========;
                add di, 320-boardWidth+2 ;to return di to first col next row
                mov cx, boardWidth-4   ;number of pixels of one column to draw
        DWSQ3:  STOSB                  ;draw pixel in first col
                add di, boardWidth-4   ;update pos for nxt col
                STOSB                  ;draw pixel in sec col
                add di, 320-boardWidth+2 ;update di to first col next row
        loop DWSQ3


                ;=========== draw last row ==========;
                mov cx, boardWidth-2
                REP STOSB

        popa
        RET
DrawSquareBordSm ENDP 

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

DrawBoard       PROC    FAR ;inialize first with all peices
                CALL DrawGrid 
                pusha
                mov ah,6  ; function 6
                mov al,15  ; scroll by 1 line
                mov bh,3h  ; normal video attribute


                mov ch,8  ; upper left row after you:
                mov cl,23  ; upper left col
                mov dh,22 ; lower right row
                mov dl,39 ; lower right col
                int 10h
                popa

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
        mov al, 4
        mov di, PlayerPos[2]
        CALL DrawSquareBord
        mov di, PlayerPos[4]
        CALL DrawSquareBord
        RET
DrawBoard       ENDP     

DrawPlayers     PROC    FAR
                push ax
                push di
                push si
                
                mov si, PlayerGameNumber
                shl si, 1
                mov di, PlayerPos[si]
                mov al, 4
                CALL DrawSquareBord

                pop si
                pop di
                pop ax
                RET
DrawPlayers     ENDP

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

GetCellColor PROC  FAR;bl=cell number, bh=row ===> al = color of cell
push bx
        add bl, bh
        and bl, 1
        mov bh, 0
        mov al, color[bx]
pop bx
RET
ENDP GetCellColor

MvePlayerFromGraphics   PROC FAR;si=player number ====> al = color of cell player on, di = player pos

        push bx
                                mov bl, playerCells[si] ;bl = playerCell
                                cmp validateMoves[bx], 1;chk if one of valid moves
                                jl clearSquare          ;if not => clearSquare=> get color of cell
                                mov al, 0              ;else al = highligh move color
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



MvePieceFromGraphics    PROC    FAR ;si = playerNumber, bx=cell ===> al = cell color, di = pos **bl = cell

                        mov bl, PlayerSelectedCell[si];bl = cell
                        mov bh, PlayerSelectedRow[si] ;bh = row
                        shl si, 1                     ;
                        mov di, PlayerSelectedPos[si] ;di = position
                        shr si, 1                     ;
                        CALL GetCellColor             ;al = cell color
                        CALL DrawSquare               ;clear cell
                
RET
MvePieceFromGraphics    ENDP  ;si = playerNumber, bx=cell ===> al = cell color, di = pos **bl = cell

DisplayMessage Proc far ;bx --> input(to cell)
        pusha
        mov bh, 0;pg number
                                mov dh, 24;row
                                mov dl, 00
                                mov ah, 2
                                int 10h
                                ; lea si , Kingkill
                                ; mov si,0
                                ;------------------Clearing status--------------------;
                                pusha
                                mov di,0
                                printclear:
                                mov al,Clearcheckmes[di]
                                        mov ah, 09h
                                        mov bh, 0
                                        mov bl, 0fh
                                        mov cx, 1
                                        int 10h
                                        inc dl
                                        mov bh, 0;pg number
                                        mov dh, 24;row
                                        mov ah, 2
                                        int 10h
                                        inc di
                                

                                        cmp Clearcheckmes[di],'$'
                                        jnz printclear     
                                        popa
                        ;----------------------------------------------;
                        mov bh, 0;pg number
                                mov dh, 24;row
                                mov dl, 00
                                mov ah, 2
                                int 10h
        mov cl,board[bx]   
        mov ch,00
        and cl,00000111b
        cmp cx,pawn
        jnz crook 
              pusha
                mov di,0
                printP:
                mov al,Pawnnkill[di]
                        mov ah, 09h
                        mov bh, 0
                        mov bl, 0fh
                        mov cx, 1
                        int 10h
                        inc dl
                        mov bh, 0;pg number
                        mov dh, 24;row
                        mov ah, 2
                        int 10h
                        inc di
                

                        cmp Pawnnkill[di],'$'
                        jnz printP     
                        popa
        jmp Ex
        crook:
        cmp cx,rook
        jnz cKing
              pusha
                mov di,0
                printRo:
                mov al,Rookkill[di]
                        mov ah, 09h
                        mov bh, 0
                        mov bl, 0fh
                        mov cx, 1
                        int 10h
                        inc dl
                        mov bh, 0;pg number
                        mov dh, 24;row
                        mov ah, 2
                        int 10h
                        inc di
                

                        cmp Rookkill[di],'$'
                        jnz printRo    
                        popa
        jmp Ex
        cKing:
        cmp cx,king
        jnz cKnight 
               pusha
                mov di,0
                printK:
                mov al,Kingkill[di]
                        mov ah, 09h
                        mov bh, 0
                        mov bl, 0fh
                        mov cx, 1
                        int 10h
                        inc dl
                        mov bh, 0;pg number
                        mov dh, 24;row
                        mov ah, 2
                        int 10h
                        inc di
                        
                        cmp Kingkill[di],'$'
                        jnz printK    
                        popa
        jmp Ex
        cKnight:
        cmp cx,knight
        jnz cQueen
               pusha
                mov di,0
                printKn:
                mov al,Knightkill[di]
                        mov ah, 09h
                        mov bh, 0
                        mov bl, 0fh
                        mov cx, 1
                        int 10h
                        inc dl
                        mov bh, 0;pg number
                        mov dh, 24;row
                        mov ah, 2
                        int 10h
                        inc di
                        

                        cmp Knightkill[di],'$'
                        jnz printKn    
                        popa
        jmp Ex
        cQueen:
        cmp cx,Queen
        jnz cBishop 
               pusha
                mov di,0
                printQ:
                mov al,Queenkill[di]
                        mov ah, 09h
                        mov bh, 0
                        mov bl, 0fh
                        mov cx, 1
                        int 10h
                        inc dl
                        mov bh, 0;pg number
                        mov dh, 24;row
                        mov ah, 2
                        int 10h
                        inc di
                

                        cmp Queenkill[di],'$'
                        jnz printQ    
                        popa
        jmp Ex
        cBishop:
        cmp cx,bishop
        jnz Ex
               pusha
                mov di,0
                printB:
                mov al,Bishopkill[di]
                        mov ah, 09h
                        mov bh, 0
                        mov bl, 0fh
                        mov cx, 1
                        int 10h
                        inc dl
                        mov bh, 0;pg number
                        mov dh, 24;row
                        mov ah, 2
                        int 10h
                        inc di

                        cmp Bishopkill[di],'$'
                        jnz printB   
                        popa
Ex:
popa
ret
DisplayMessage EndP


MvePieceToGraphics      PROC    FAR;si = playerNumber, al = peice =====> di = pos, bx = cell
                        shl si, 1                       ;
                        mov di, PlayerPos[si]           ;di = position
                        shr si, 1                       ;

                        mov bh, 0
                        mov bl, playerCells[si]         ;bx = bl = cell
                        cmp board[bx], emptyCell        ;chk if empty
                        je  stMvPc                      ;if empty skip clear part
                        ;START clear square
                        pusha
                        mov al, board[bx]
                        mov di, killedPeicePos
                        CALL DrawImg          ;di = position , al = peice
                        add killedPeicePos, 23
                        add killedPeiceCol, 1
                        cmp killedPeiceCol, 6
                        jne skpUpdateRow
                        mov killedPeiceCol, 0
                        add killedPeicePos, 320*23;to go down row of peices
                        sub killedPeicePos, 23*6;to return to first col

                        
        skpUpdateRow:                 popa
                        Call DisplayMessage
                        mov bh, playerRows[si]          ;bh = row
                        push ax                         ;store al
                        CALL GetCellColor               ;al = cell color
                        CALL DrawSquare                 ;clear cell
                        pop ax                          ;store al = peice

                        mov bh, 0                       ;bx = cell
                stMvPc: CALL DrawImg                    ;move peice graphically      
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
                                mov al, 0          ;al = highlightcolor
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
                        ;======== return player cells ======;
                        CALL DrawPlayers
        popa
        RET
ClrHighlightedMvs      ENDP



END
