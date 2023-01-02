PUBLIC AddPeiceToAnimationQueue, StartAnimation

EXTRN PlayerSelectedCell:BYTE
EXTRN playerCells:BYTE
EXTRN board:BYTE
EXTRN board:BYTE
EXTRN CellToRowCol:FAR       ;al = cell => al = row , cl = col
EXTRN RowColToCell:FAR       ;al = row  cl = col  =>> si = CellNumber
EXTRN RowColToStartPos:FAR;  ;al =row    cl=col   =>di=StartPos
EXTRN GetCellColor:FAR
EXTRN DrawSquare:FAR;  
EXTRN DrawImg:FAR;  
EXTRN DisplayMessage:FAR;  
EXTRN kingsCells:BYTE
EXTRN kingsRows:BYTE
EXTRN kingsCols:BYTE
EXTRN playersState:BYTE
EXTRN isGameEnded:BYTE
EXTRN killedPeicePos:WORD
EXTRN killedPeiceRow:BYTE
EXTRN killedPeiceCol:BYTE
.286
.MODEL HUGE
.STACK 256
.DATA
    peiceArr db 33 dup(0)
    fromCell db 33 dup(0)
    toCell   db 33 dup(0)
    tail     db 0

    currFromRow db 0
    currFromCol db 0
    currFromPos dw 0
    currToRow db 0
    currToCol db 0
    currToPos dw 0

    emptyCell      equ 0
    pawn           equ 1
    rook           equ 2
    knight         equ 3
    bishop         equ 4
    queen          equ 5
    king           equ 6 
    ; ____ peice color ____ ;
    black          equ 8
    white          equ 0
    ; ____ peice mask ____ ;
    peice          equ 7
    
    PlayerLose equ 2
    PlayerWin equ 3
    playerMoveToChoosePeice equ 0

.CODE
;=== utilites
waitSec PROC   FAR                                                ;ax = row, cx = col =>>>> ax = current start point
                    push     ax


                    mov      ah, 07
                    int      21h

                    pop      ax
                    RET
waitSec ENDP
GetDi   PROC  FAR   ;al peice
        and al, black
        shr al, 3
        mov ah, 0
        mov di, ax

        cmp di, 0   ;white => convert it to two
        jne extSi
        mov di, 2
    extSi:
        RET
GetDi   ENDP

; ================================ handel moves
; === 4 main
handelUpDir PROC FAR    ;si = current index
            sub  fromCell[si], 8
            RET
handelUpDir ENDP

handelDownDir PROC FAR
            add  fromCell[si], 8
            RET
handelDownDir ENDP

handelLeftDir PROC FAR
            sub  fromCell[si], 1
            RET
handelLeftDir ENDP


handelRightDir PROC FAR
            add  fromCell[si], 1
            RET
handelRightDir ENDP
; === 4 main


; === 4 sub
handelUPRightDir PROC FAR
            CALL handelUpDir
            CALL handelRightDir
            RET
handelUPRightDir ENDP

handelDownRightDir PROC FAR
            CALL handelDownDir
            CALL handelRightDir
            RET
handelDownRightDir ENDP


handelUPLeftDir PROC FAR
            CALL handelUpDir
            CALL handelLeftDir
            RET
handelUPLeftDir ENDP

handelDownLeftDir PROC FAR
            CALL handelDownDir
            CALL handelLeftDir
            RET
handelDownLeftDir ENDP
; === 4 sub


; =========== handel by peices type ===========;
;ax = [row, col] from
;bx = [row, col] to
;si = current index
handelPawn  PROC FAR   
            mov ah, currFromRow
            mov bh, currToRow

            cmp ah, bh  ;chk if up
            ja jmpUpPawn
            CALL handelDownDir
            RET

        jmpUpPawn:
            CALL handelUpDir
            RET
handelPawn  ENDP

handelRook  PROC FAR
            mov ah, currFromRow
            mov bh, currToRow
            mov al, currFromCol
            mov bl, currToCol


            cmp ah, bh  ;chk if up
            ja jmpUpRk
            je jmpRightRk
            CALL handelDownDir
            RET
            
        jmpUpRk:
            CALL handelUpDir
            RET

        jmpRightRk: 
            cmp al, bl
            ja jmpLeftRk
            je extRook
            CALL handelRightDir
            RET


        jmpLeftRk:
            CALL handelLeftDir
            RET
    extRook:
            RET
handelRook  ENDP

handelKnight  PROC FAR

            mov ah, toCell[si]
            mov fromCell[si], ah
            ;cmp ah, bh  ;chk if up
            ;ja jmpUpKn
            ;je jmpRightKn
            ;CALL handelDownDir
            ;RET
            
        ;jmpUpKn:
            ;CALL handelUpDir
            ;RET

        ;jmpRightKn: 
            ;cmp al, bl
            ;ja jmpLeftKn
            ;je extKnight
            ;CALL handelRightDir
            ;RET


        ;jmpLeftKn:
            ;CALL handelLeftDir
            ;RET
    ;extKnight:
            RET
handelKnight  ENDP

handelBishop  PROC FAR
            mov ah, toCell[si]
            mov fromCell[si], ah
            RET
handelBishop  ENDP

handelQueen  PROC FAR
            mov ah, toCell[si]
            mov fromCell[si], ah
            RET
handelQueen  ENDP

handelKing  PROC FAR
            mov ah, toCell[si]
            mov fromCell[si], ah
            RET
handelKing  ENDP

; =========== handel by peices type ===========;

MvePieceFromGraphics    PROC    FAR ;si = cirremt omdex

                        mov bl, fromCell[si];       bl = cell
                        mov bh, currFromRow          ;bh = row
                        CALL GetCellColor             ;al = cell color
                        mov di, currFromPos
                        CALL DrawSquare               ;clear cell
                
RET
MvePieceFromGraphics    ENDP  ;===> bx=cell ===> al = cell color, di = pos **bl = cell

MvePieceToGraphics      PROC    FAR;si = playerNumber, al = peice =====> di = pos, bx = cell

                        mov bh, 0
                        mov bl, fromCell[si]         ;bx = bl = cell
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
                        mov bh, currFromRow         ;bh = row
                        mov bl, fromCell[si]         ;bh = row
                        push ax                         ;store al
                        CALL GetCellColor               ;al = cell color
                        mov di, currFromPos
                        CALL DrawSquare                 ;clear cell
                        pop ax                          ;store al = peice

                stMvPc: mov al, peiceArr[si]
                        mov di, currFromPos
                        CALL DrawImg                    ;move peice graphically     

RET
MvePieceToGraphics      ENDP

handelMoveFrom          PROC    FAR ;di = player number 
                        CALL MvePieceFromGraphics 
                        mov bl, fromCell[si];       bl = cell
                        mov bh, 0
                        mov board[bx], emptyCell      ;set empty cell
                
                        RET
handelMoveFrom          ENDP


handelMoveTo PROC    FAR ;si = playerNumber
                pusha
                mov al, peiceArr[si]    ;al = peice array
                CALL GetDi          ;(al = peice) => di = player number
                mov bh, 0
                mov bl, toCell[si]    ;bx = player to cell
                ;======= handel move cell **to  ======;
                ;== hande if pawn and about to promote
                mov dl, al      ;copy peice 
                and dl, 7       ;get peice  type only
                cmp dl, pawn    ;chk if pawn
                jne skpPwn      ;if not pawn skip
                cmp currFromRow, 0        ;if first row 
                je  PrmPwn
                cmp currFromRow, 7        ; or last row
                jne skpKng                   ;he is pawn so skip king
        PrmPwn: or al, 4        ;transfer peice to queen by set third bit
                jmp skpKng
        skpPwn: cmp dl, king    ;chk if king
                jne skpKng
                mov ah, fromCell[si]
                mov kingsCells[di], ah

                mov ah, currFromCol
                mov kingsCols[di], ah

                mov ah, currFromRow
                mov kingsRows[di], ah
                ;== Graphically
        skpKng: CALL MvePieceToGraphics      ;out ===> bx = cell
                ;== Logically
                mov dl, board[bx]               ;get peice type that killed
                and dl, peice
                cmp dl, king                    ;chk if king
                jne skipKingDead
                mov playersState[di], PlayerWin ;if king win
                xor si, 3           ; to toggle the player number to change states
                mov playersState[di], PlayerLose
                xor si, 3           ;to return the number of the player again
                mov isGameEnded, 1
        skipKingDead:        mov board[bx], al
EXITMVEPEICE:   
                cmp isGameEnded, 1
                jne chngState
                popa
                RET
        chngState:        mov playersState[si], playerMoveToChoosePeice
                popa
                RET
handelMoveTo ENDP



handelOnePeice  PROC    FAR ;si = current index
                pusha

                mov al, fromCell[si]
                CALL CellToRowCol      ;al = cell => al = row , cl = col
                mov currFromRow, al             ;ax = [row, col] from
                mov currFromCol, cl
                CALL RowColToStartPos   ;di = position
                mov currFromPos, di

                mov al, toCell[si]
                CALL CellToRowCol      ;al = cell => al = row , cl = col
                mov currToRow, al             ;ax = [row, col] from
                mov currToCol, cl
                
                mov cl, peiceArr[si]
                and cl, peice
            chkPwn:
                cmp cl, pawn
                jne chkRook
                Call handelMoveFrom
                CALL handelPawn
                jmp ExtHan
            chkRook:
                cmp cl, rook
                jne chkKnight
                CALL handelRook
                jmp ExtHan
            chkKnight:
                cmp cl, knight
                jne chkBishop
                CALL handelKnight
                jmp ExtHan
            chkBishop:
                cmp cl, bishop
                jne chkQueen
                CALL handelBishop
                jmp ExtHan
            chkQueen:
                cmp cl, queen
                jne chkKing
                CALL handelQueen
                jmp ExtHan
            chkKing:
                cmp cl, king
                jne ExtHan
                CALL handelKing
            
            ExtHan:
                mov al, fromCell[si]
                CALL CellToRowCol      ;al = cell => al = row , cl = col
                mov currFromRow, al             ;ax = [row, col] from
                mov currFromCol, cl
                CALL RowColToStartPos   ;di = position
                mov currFromPos, di
                CALL handelMoveTo
                popa
                RET
handelOnePeice  ENDP


AddPeiceToAnimationQueue    PROC    far ;si = player number
                            mov bl, tail
                            mov bh, 0
                            mov di, bx
                            ; ==== add peice type
                            mov bl, PlayerSelectedCell[si] ;bl = from cell
                            mov bh, 0                       ;bx = cell
                            mov al, board[bx]               ;al=peice

                            ; ====  update
                            mov peiceArr[di], al
                            mov fromCell[di], bl

                            mov bl, playerCells[si] ;bl = cell
                            mov toCell[di], bl
                            ; ====  update

                            add tail,1 
                            
RET
AddPeiceToAnimationQueue    ENDP

RemoveFromAnimationQueue    PROC    far ;si = player number
                            dec tail    ;new tail 
                            mov bl, tail
                            mov bh, 0

                            cmp bx, si  ;chk if the last element
                            jne contRmv ;if not
                            RET         ;else just exit [enough decrease tail]
                        contRmv:
                            mov al, peiceArr
                            mov peiceArr[si], al

                            mov al, fromCell[bx]
                            mov fromCell[si], al

                            mov al, toCell[bx]      
                            mov toCell[si], al                          
RET
RemoveFromAnimationQueue    ENDP

StartAnimation  PROC    FAR
                pusha
                
            lp: 
                mov bl, tail
                mov bh, 0
                mov si, 0
                cmp si, bx        ;check if end
                je ExitAn
                CALL handelOnePeice
                mov al, fromCell[si]    ;al = from cell
                cmp al, toCell[si]      ;chk if from = to
                jne continueLoop        ;if not continue
                    CALL RemoveFromAnimationQueue
                    jmp lp
                continueLoop:
                    inc si
                    jmp lp

            ExitAn:
                popa
                RET
StartAnimation  ENDP

END