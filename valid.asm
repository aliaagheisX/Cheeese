PUBLIC ValidatePawn, ValidateRook, ValidateBishop, ValidateKnight, ValidateQueen, ValidateKing

EXTRN validateMoves:BYTE
EXTRN board:BYTE
EXTRN playerCells:BYTE
EXTRN playerCols:BYTE
EXTRN playerRows:BYTE
EXTRN PlayerPos:WORD
.286
.MODEL SMALL
.data
        ; ____ game peice ____ ;
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
        ;____ players _____;
        player1         equ 1
        player2         equ 2
.code


;==== helpers 
GetPlayerColorV2 Proc   FAR; si = player   ; cl=piece    ;ch =output 
                push si
                ;for empty cell
                cmp cl,emptyCell
                je result
                ; if si =1 => 8  || si = 2 =>0
                and si ,1
                shl si, 3
                and cl ,black
                mov ch,0
                ;compare if the color is the same
                cmp cx,si 
                jne result

                mov cx, 0
                pop si
                RET
                


        result: pop si
                mov cx,si
                
ret
GetPlayerColorV2 Endp


GetPlayerColor Proc far  ; si = player   ; cl =color
                push si
                shr si,3            
                and si,1   
                mov ch,0
                mov cx,si
                pop si
    ret
GetPlayerColor Endp

ispeice Proc  FAR; si = palyer ; dl = 1 if piece and 0 if not piece
                push si
                and si ,peice
                shl si,5
                jnz PeiceExist
                mov dl,0 
                jmp Ex
                PeiceExist:
                mov dl,1
                Ex:
                pop si
    ret
ispeice Endp
; === helpers
ValidatePawn    Proc FAR       
                mov bh, 0
                mov  bl, playerCells[si]
                add bl, 8
                mov validateMoves[bx], 1
                RET
ValidatePawn ENDP



ValidateRook    Proc ;al = row cl = col si = player di = cell
                pusha

                
                mov ax, 0
                mov al, playerCells[si]
                mov di, ax 

                mov al, playerRows[si] 
                mov cl, playerCols[si]
                
                push cx
                push si
                mov cl,board[di]
                mov ch,0
                mov si,cx
                Call GetPlayerColor  ; bx=color of the player to get its validation pos
                mov bx,cx  
                pop si
                pop cx
                push ax
                mov ax,si 
                mov ch,al
                pop ax
                pusha             
        verticalDown:
                cmp al,7
                jz VP
                inc al
                add di,8
                mov dl,board[di]
                mov dh,0
                mov si ,dx
                Call ispeice          ;dl=1 if peice and dl =0 if not peice     
                cmp dl,0
                jz Helight
                push cx
                Call GetPlayerColor   ; cx=color of the player in this cell
                cmp cx,bx
                jz  NH
                pop cx
                jmp Helight
                NH:
                pop cx
                jmp NotHelight
                Helight:
                mov validateMoves[di],ch
                NotHelight:
                cmp dl,1
        jnz verticalDown
                VP:
                popa
                pusha
                
        verticalUP: 
                cmp al,0
                jz  HR
                dec al
                sub di,8 
                mov dl,board[di]
                mov dh,0
                mov si ,dx
                Call ispeice          ;dl=1 if peice and dl =0 if not peice     
                cmp dl,0
                jz Helight1
                push cx
                Call GetPlayerColor   ; cx=color of the player in this cell
                cmp cx,bx
                jz  NH1
                pop cx
                jmp Helight1
                NH1:
                pop cx
                jmp NotHelight1
                Helight1:
                mov validateMoves[di],ch
                NotHelight1:
                cmp dl,1
        jnz verticalUP

                HR:
                popa
                pusha

        HorizontalRight:  
                cmp cl,7
                jz HL
                inc cl
                add di,1 
                mov dl,board[di]
                mov dh,0
                mov si,dx
                Call ispeice          ;dl=1 if peice and dl =0 if not peice     
                cmp dl,0
                jz Helight2
                push cx
                Call GetPlayerColor   ; cx=color of the player in this cell
                cmp cx,bx
                jz  NH2
                pop cx
                jmp Helight2
                NH2:
                pop cx
                jmp NotHelight2
                Helight2:
                mov validateMoves[di],ch
                NotHelight2:
                cmp dl,1
        jnz HorizontalRight

                HL:
                popa
                
                pusha
                
        HorizontalLeft:  
                cmp cl,0
                jz  EndValidate
                dec cl
                sub di,1
                mov dl,board[di]
                mov dh,0
                mov si ,dx
                Call ispeice          ;dl=1 if peice and dl =0 if not peice     
                cmp dl,0
                jz Helight3
                push cx
                Call GetPlayerColor   ; cx=color of the player in this cell
                cmp cx,bx
                jz  NH3
                pop cx
                jmp Helight3
                NH3:
                pop cx
                jmp NotHelight3
                Helight3:
                mov validateMoves[di],ch
                NotHelight3:
                cmp dl,1
        jnz HorizontalLeft
                EndValidate:
                popa
                popa
                RET
ValidateRook    ENDP 


ValidateBishop  Proc ;al = row cl = col si = player di = cell
                pusha
                mov ax, 0
                mov al, playerCells[si]
                mov di, ax 

                mov al, playerRows[si] 
                mov cl, playerCols[si]
                ; mov al,2
                ; mov cl,5
                ; mov di,21
                push cx
                push si
                mov cl,board[di]
                mov ch,0
                mov si,cx                
                Call GetPlayerColor  ; bx=color of the player to get its validation pos
                mov bx,cx  
                pop si
                pop cx
                push ax
                mov ax,si 
                mov ch,al
                pop ax
                pusha             
        TopLeft:
                cmp al,0
                jz TRt 
                cmp cl,0
                jz TRt 
                dec al 
                dec cl
                sub di,9
                mov dl,board[di]
                mov dh,0
                mov si ,dx
                Call ispeice          ;dl=1 if peice and dl =0 if not peice     
                cmp dl,0
                jz HelightBishop
                push cx
                Call GetPlayerColor   ; cx=color of the player in this cell
                cmp cx,bx
                jz  NHBishop
                pop cx
                jmp HelightBishop
                NHBishop:
                pop cx
                jmp NotHelightBishop
                HelightBishop:
                mov validateMoves[di],ch
                NotHelightBishop:
                cmp dl,1
        jnz TopLeft
                TRt:
                popa
                pusha
                
        TopRight: 
                cmp al,0
                jz  DLt
                cmp cl,7 
                jz  DLt
                dec al
                inc cl
                sub di,7 
                mov dl,board[di]
                mov dh,0
                mov si ,dx
                Call ispeice          ;dl=1 if peice and dl =0 if not peice     
                cmp dl,0
                jz HelightBishop1
                push cx
                Call GetPlayerColor   ; cx=color of the player in this cell
                cmp cx,bx
                jz  NHBishop1
                pop cx
                jmp HelightBishop1
                NHBishop1:
                pop cx
                jmp NotHelightBishop1
                HelightBishop1:
                mov validateMoves[di],ch
                NotHelightBishop1:
                cmp dl,1
        jnz TopRight

                DLt:
                popa
                pusha

        DownLeft:  
                cmp cl,0
                jz DRt
                cmp al,7
                jz DRt
                inc al
                dec cl
                add di,7 
                mov dl,board[di]
                mov dh,0
                mov si,dx
                Call ispeice          ;dl=1 if peice and dl =0 if not peice     
                cmp dl,0
                jz HelightBishop2
                push cx
                Call GetPlayerColor   ; cx=color of the player in this cell
                cmp cx,bx
                jz  NHBishop2
                pop cx
                jmp HelightBishop2
                NHBishop2:
                pop cx
                jmp NotHelightBishop2
                HelightBishop2:
                mov validateMoves[di],ch
                NotHelightBishop2:
                cmp dl,1
        jnz DownLeft

                DRt:
                popa
                
                pusha
                
        DownRight:  
                cmp cl,7
                jz  EndValidateBishop
                cmp al,7 
                jz  EndValidateBishop
                inc cl 
                inc al
                add di,9 
                mov dl,board[di]
                mov dh,0
                mov si ,dx
                Call ispeice          ;dl=1 if peice and dl =0 if not peice     
                cmp dl,0
                jz HelightBishop3
                push cx
                Call GetPlayerColor   ; cx=color of the player in this cell
                cmp cx,bx
                jz  NHBishop3
                pop cx
                jmp HelightBishop3
                NHBishop3:
                pop cx
                jmp NotHelightBishop3
                HelightBishop3:
                mov validateMoves[di],ch
                NotHelightBishop3:
                cmp dl,1
        jnz DownRight
        EndValidateBishop:
                popa
                popa
                RET
ValidateBishop  ENDP 



ValidateKnight Proc FAR                                         ;player 1==>black   ;al = row cl = col si = player di = cell
                              pusha
                             ;CALL GetPlayerColor ;cl = color
                                mov bx,si       ;bl = player number


                                mov al, playerCells[si]
                                mov ah, 0
                                mov di, ax
                                
                                mov al, playerRows[si]
                                mov dl, PlayerCols[si]
                                ;_______________________________;

                                cmp   dl,6
                                jae   mvKn1
                                cmp   al,7
                                je mvKn1
                                mov cl, board[di+10]
                                CALL GetPlayerColorV2
                                mov   validateMoves[di+10],cl
                        mvKn1:  cmp   dl,1
                                jbe   mvKn2
                                cmp al, 7
                                je   mvKn2
                                mov cl, board[di+6]
                                CALL GetPlayerColorV2
                                mov   validateMoves[di+6],cl
                        mvKn2:  cmp   dl, 7
                                je mvKn3
                                cmp al, 6
                                jae mvKn3
                                mov cl, board[di+17]
                                CALL GetPlayerColorV2
                                mov   validateMoves[di+17],cl
                        mvKn3: cmp dl,0
                                je mvKn4
                                cmp al,6
                                jae mvKn4
                                mov cl, board[di+15]
                                CALL GetPlayerColorV2
                                mov   validateMoves[di+15],cl
                        mvKn4:  cmp dl,6
                                jae mvKn5
                                cmp al,0
                                je mvKn5
                                mov cl, board[di-6]
                                CALL GetPlayerColorV2
                                mov   validateMoves[di-6],cl
                        mvKn5:   cmp dl,1
                                jbe mvKn6
                                cmp al,0
                                je mvKn6
                                mov cl, board[di-10]
                                CALL GetPlayerColorV2
                                mov   validateMoves[di-10],cl
                        mvKn6:   cmp dl,7
                                je mvKn7
                                cmp al,1
                                jbe mvKn7
                                mov cl, board[di-15]
                                CALL GetPlayerColorV2
                                mov   validateMoves[di-15],cl
                        mvKn7:   cmp dl,0
                                je mvKn8
                                cmp al,1
                                jbe mvKn8
                                mov cl, board[di-17]
                                CALL GetPlayerColorV2
                                mov   validateMoves[di-17],cl
                                
                        mvKn8:          popa
                                        RET
ValidateKnight ENDP


ValidateQueen Proc  FAR                                                                 ;al = row cl = col si = player di = cell
                                CALL  ValidateBishop
                                CALL  ValidateRook
                                RET
ValidateQueen ENDP


;VALIDTE KING
;VALIDTE KING
ValidateKing    Proc FAR ;al = row cl = col si = player di = cell

            MOV AL,playerRows[SI]
            MOV CL,PlayerCols[SI]
            ;mov di,playerCells[SI]

            ;LEFT CELL
            PUSH DI
            CMP CL,1 
            JC GO ;IF COLUMN=0 it'll be negative then it's invalid
            PUSH SI
            PUSH AX 
            ;IF CARRY NOT 1 THEN IT'S A VALID CELL
            SUB DI,1
            CMP board[DI],emptyCell
            JE HERE;IF EMPTY CELL 
            ;IF NOTE EMPTY

            AND SI,1
            SHL SI,3
            ;SI NOW HAVE COLOR OF PLAYER
            MOV AL,BOARD[DI]
            AND AL,8 ;CHECK
            MOV AH,0
            ; NOW AX HAVE COLOR OF PIECE
            CMP AX,SI 
            JE P;IF THEY HAVE SAME COLOR THEN IT ISN'T A VALID MOVE
            HERE:
            POP AX
            POP SI
            PUSH CX
            mov cx,si
            MOV validateMoves[DI],cl
            POP CX
            JMP GO
           P:
           POP AX 
           POP SI     
    ;RIGHT CELL                 
    GO:
    POP DI
    PUSH DI
    PUSH CX
                ADD CL,1
                PUSH BX
                MOV BL,8
                CMP BL,CL
                JE GO1 
                ;IF CL NOT EQUAL 8 THEN WE STILL IN RANGE OF 0 TO 7 COLUMNS --> IT'S A VALID CELL
                PUSH SI
                PUSH AX
                ADD DI,1
                CMP board[DI],emptyCell
                JE HERE1;IF EMPTY CELL 
                ;IF NOT EMPTY

                AND SI,1
                SHL SI,3
                ;SI NOW HAVE COLOR OF PLAYER
                MOV AL,BOARD[DI]
                AND AL,8 ;CHECK
                MOV AH,0
                ; NOW AX HAVE COLOR OF PIECE
                CMP AX,SI 
                JE P1;IF THEY HAVE SAME COLOR THEN IT ISN'T A VALID MOVE
                HERE1:
                POP AX
                POP SI
                PUSH CX
                mov cx,si
                MOV validateMoves[DI],cl
                POP CX
                
                JMP GO1
            P1:
            POP AX 
            POP SI     
    ;UP CELL
        GO1:
        POP BX
        POP CX
        POP DI
        PUSH DI
                    CMP DI,8
                    JC GO2
                    ;IF CARRY NOT 1 THEN IT'S A VALID CELL
                    PUSH SI
                    PUSH AX
                    SUB DI,8
                    CMP board[DI],emptyCell
                    JE HERE2;IF EMPTY CELL 
                    ;IF NOTE EMPTY
                    AND SI,1
                    SHL SI,3
                    ;SI NOW HAVE COLOR OF PLAYER
                    MOV AL,BOARD[DI]
                    AND AL,8 ;CHECK
                    MOV AH,0
                    ; NOW AX HAVE COLOR OF PIECE
                    CMP AX,SI 
                    JE P2;IF THEY HAVE SAME COLOR THEN IT ISN'T A VALID MOVE
                    HERE2:
                    POP AX
                    POP SI
                    PUSH CX
                    mov cx,si
                    MOV validateMoves[DI],cl
                    POP CX
                    
                    JMP GO2
                P2:
                POP AX 
                POP SI 
        ;DOWN CELL    
        GO2:
        POP DI
        PUSH DI
            ADD DI,8
            PUSH BX
            MOV BX,63 ;LAST CELL INDEX
            CMP BX,DI
            JC GO3
            ;IF CARRY NOT 1 THEN IT'S A VALID CELL
            PUSH SI
            PUSH AX
            CMP board[DI],emptyCell
            JE HERE3;IF EMPTY CELL 
            ;IF NOTE EMPTY
            AND SI,1
            SHL SI,3
            ;SI NOW HAVE COLOR OF PLAYER
            MOV AL,BOARD[DI]
            AND AL,8 ;CHECK
            MOV AH,0
            ; NOW AX HAVE COLOR OF PIECE
            CMP AX,SI 
            JE P3;IF THEY HAVE SAME COLOR THEN IT ISN'T A VALID MOVE
            HERE3:
            POP AX
            POP SI
            PUSH CX
            mov cx,si
            MOV validateMoves[DI],cl
            POP CX
            JMP GO3
           P3:
           POP AX 
           POP SI 

    GO3:
    POP BX
    POP DI
    ;LEFT UP CELL
    PUSH DI
            CMP CL,1 
            JC GO4 ;IF COLUMN=0 it'll be negative then it's invalid 
            CMP AL,1
            JC GO4 ;IF ROW=0 it'll be negative then it's invalid
            ;IF CARRY NOT 1 THEN IT'S A VALID CELL
            PUSH SI
            PUSH AX
            SUB DI,9
            CMP board[DI],emptyCell
            JE HERE4;IF EMPTY CELL 
            ;IF NOTE EMPTY

            AND SI,1
            SHL SI,3
            ;SI NOW HAVE COLOR OF PLAYER
            MOV AL,BOARD[DI]
            AND AL,8 ;CHECK
            MOV AH,0
            ; NOW AX HAVE COLOR OF PIECE
            CMP AX,SI 
            JE P4;IF THEY HAVE SAME COLOR THEN IT ISN'T A VALID MOVE
            HERE4:
            POP AX
            POP SI
            PUSH CX
            mov cx,si
            MOV validateMoves[DI],cl
            POP CX
            
            JMP GO4
           P4:
           POP AX 
           POP SI

    GO4:
    POP DI
    PUSH DI
    ;RIGHT DOWN
    push cx
            ADD CL,1
            PUSH BX
            MOV BL,7
            CMP BL,CL;LAST COLUMN NO RIGHT
            JC GO5
            POP BX
            ADD DI,9
            PUSH BX
            MOV BX,63 ;LAST CELL INDEX
            CMP BX,DI
            JC GO5 ;LAST ROW NO DOWN
            ;IF CARRY NOT 1 THEN IT'S A VALID CELL
            PUSH SI
            PUSH AX
            CMP board[DI],emptyCell
            JE HERE5;IF EMPTY CELL 
            ;IF NOTE EMPTY

            AND SI,1
            SHL SI,3
            ;SI NOW HAVE COLOR OF PLAYER
            MOV AL,BOARD[DI]
            AND AL,8 ;CHECK
            MOV AH,0
            ; NOW AX HAVE COLOR OF PIECE
            CMP AX,SI 
            JE P5;IF THEY HAVE SAME COLOR THEN IT ISN'T A VALID MOVE
            HERE5:
            POP AX
            POP SI
           PUSH CX
            mov cx,si
            MOV validateMoves[DI],cl
            POP CX
            
            JMP GO5
           P5:
           POP AX 
           POP SI 
           

    GO5:

    POP BX
    pop cx
    POP DI
    PUSH DI
    ;LEFT DOWN
            CMP CL,0 ;first column no left ;;;not working 
            JE GO6
            ;ADD DI,7
            ;PUSH BX
            ;MOV BX,63 ;LAST CELL INDEX
            ;CMP BX,DI
            ;JC GO6 ;LAST ROW NO DOWN
            CMP AL,7
            JE GO6 
            ;NOT LAST ROW
            ADD DI,7
            ;IF CARRY NOT 1 THEN IT'S A VALID CELL
            PUSH SI
            PUSH AX
            CMP board[DI],emptyCell
            JE HERE6;IF EMPTY CELL 
            ;IF NOTE EMPTY

            AND SI,1
            SHL SI,3
            ;SI NOW HAVE COLOR OF PLAYER
            MOV AL,BOARD[DI]
            AND AL,8 ;CHECK
            MOV AH,0
            ; NOW AX HAVE COLOR OF PIECE
            CMP AX,SI 
            JE P6;IF THEY HAVE SAME COLOR THEN IT ISN'T A VALID MOVE
            HERE6:
            POP AX
            POP SI
            PUSH CX
            mov cx,si
            MOV validateMoves[DI],cl
            POP CX
            
            JMP GO6
           P6:
           POP AX 
           POP SI

    GO6: 

    POP DI
    ;RIGHT UP CELL
    PUSH DI
    push cx
            ADD CL,1
            PUSH BX
            MOV BL,7
            CMP BL,CL;LAST COLUMN NO RIGHT
            JC GO7
            CMP AL,1
            JC GO7 ;IF ROW=0 it'll be negative then it's invalid
            ;IF CARRY NOT 1 THEN IT'S A VALID CELL
             PUSH SI
           PUSH AX
            SUB DI,7
            CMP board[DI],emptyCell
            JE HERE7;IF EMPTY CELL 
            ;IF NOTE EMPTY
          

            AND SI,1
            SHL SI,3
            ;SI NOW HAVE COLOR OF PLAYER
            MOV AL,BOARD[DI]
            AND AL,8 ;CHECK
            MOV AH,0
            ; NOW AX HAVE COLOR OF PIECE
            CMP AX,SI 
            JE P7;IF THEY HAVE SAME COLOR THEN IT ISN'T A VALID MOVE
            HERE7:
            POP AX
            POP SI
            PUSH CX
            mov cx,si
            MOV validateMoves[DI],cl
            POP CX
            
            JMP GO7
           P7:
           POP AX 
           POP SI


    GO7:               
    POP DI
    pop cx
    POP BX
                ;mov validateMoves[16], 1
                RET
ValidateKing    ENDP

END