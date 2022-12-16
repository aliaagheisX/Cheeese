;Author: Aliaa Gheis
;DATE:
;This Progam
;======================
        EXTRN StartGame:FAR
        .286
        .MODEL HUGE
        .STACK 256
        .DATA
        ;________screen states _________;
        playerEnterUserName     equ 0
        playerWaiting           equ 1

        playerSendingChatInv    equ 2   ;
        playerSendingGameInv    equ 3
        playerCanAcceptGame     equ 4
        playerAcceptGameInv     equ 5

        PlayersChattingNow      equ 6
        PlayersPlayerNow        equ 7


        PlayerCanChat db 0 ;1
        PlayerCanGame db 0 ;1


        Playername1 db 16, ?, 16 dup('$') ;
        Playername2 db 16, ?, 16 dup('$')

        .CODE
waitSec PROC   FAR                                                ;ax = row, cx = col =>>>> ax = current start point
                    push     ax

                    mov      ah, 07
                    int      21h

                    pop      ax
                    RET
waitSec ENDP     



MAIN    PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        ;
    ;=======================;
    ;CALL EnterUserNameScreen
    ;CALL DrawMainScreen             ;main graphically
    MnLoop: 
        mov ah, 1
        int 16h
        jz MnLoop

        mov ah, 0
        int 16h

        chkF1:  cmp ah, 03bh    ;chk f2
                jne chkF2
                ;CALL ChattingScreen

        chkF2:  cmp ah, 03Ch    ;chk f2
                jne chkE
                ;CALL StartGame
        chkE:   cmp ah, 1h
                CALL StartGame
            
        jmp MnLoop
        ;
         ;__end___;
        CALL     waitSec
        CALL     waitSec
        MOV      AH, 4CH
        INT      21H
MAIN    ENDP
        END MAIN