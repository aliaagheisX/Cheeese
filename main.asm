;Author: 
;DATE:
;This Progam
;; after killed => exit in same menu
;; after killed => and return home => print win
;; after defat => print win
;;
;;
;;
;======================
        PUBLIC PlayerGameNumber, player1, player2,PrintMessageSt
        PUBLIC PrintMessageSt
        EXTRN StartGame:FAR
        EXTRN StartChat:FAR
        EXTRN InializeChar:FAR

        .286
        .MODEL HUGE
        .STACK 256
        .DATA
         ;________chat__________;
       
        value                db  ?,  0AH, 0DH, "$"
        messsage             DB  'serial communication Receive', 0AH, 0DH, "$"
        player1              db  16 dup('$') 
        player2              db  16 dup('$') 
        position1            dw  ?
        position2            dw  ?
        variable             db  '$'

        ;__________-main___________;
        ;________chat__________;
        InDATA               db  100,?,100 dup('$')

;__________-main___________;
        FLINE DB 'To start chatting press F1$'
        SLINE db 'To start the game press F2$'
        TLINE DB 'To end the program press ESC$'
;___________usernames_________________________;
        mes db 'Please Enter Your Name$'   
        mes2 db 'Press Enter To Continue$'
        

        playerGetChatInvMess db  'play get chat invitation from$'
        playerSendChatInvMess db 'play send chat invitation to:$'
        playerGetGameInvMess  db 'play get game invitation from$'
        playerSendGameInvMess db 'play send game invitation to:$'

        playerCantSentInv db 'there`s no another player in the room$'
        playerSendingNamemess db 'sendgin... $'
        playerRcvNamemess db 'reciving....$'
        ;________screen states _________;

        playerEnterUserName     equ 0
        playerWaiting           equ 1

        playerSendingChatInv    equ 2   ;
        playerSendingGameInv    equ 3
        playerAcceptChatInv     equ 4
        playerAcceptGameInv     equ 5

        PlayersChattingNow      equ 6
        PlayersPlayerNow        equ 7

        PlayerGameNumber        dw  0
        ;si = 1 => player number = 1 => black
        ;si = 2 => player number = 2 => white
        PlayerCanChat db 0 ;1
        PlayerCanGame db 0 ;1

        .CODE

waitSec PROC   FAR                                                ;ax = row, cx = col =>>>> ax = current start point
                    push     ax


                    mov      ah, 07
                    int      21h

                    pop      ax
                    RET
waitSec ENDP
DRAWMAINSCREEN PROC FAR
        mov ax, 0003h                                  ; clear screen
        int 10H          
        lea DX,FLINE  
        PUSH DX
        MOV AH,2 ;SETTING CURSOR
        MOV BH,0
        MOV DX,0915H
        INT 10h
        POP DX ;PRINTING FIRST LINE 
        MOV AH,9
        INT 21H
        MOV DX,OFFSET SLINE 
        PUSH DX
        MOV AH,2 ;SETTING CURSOR
        MOV DX,0B15H
        MOV BH,0
        INT 10h   
        POP DX ;PRINTING SECOND LINE 
        MOV AH,9
        INT 21H
        MOV DX,OFFSET TLINE 
        PUSH DX
        MOV AH,2 ;SETTING CURSOR
        MOV BH,0
        MOV DX,0D15H
        INT 10h   
        POP DX ;PRINTING FIRST LINE 
        MOV AH,9
        INT 21H 
        ;line of status bar
        MOV AH,2 ;SETTING CURSOR
        MOV BH,0
        MOV DX,1600H
        INT 10h     

        mov ah,9
        mov bh,0
        MOV AL,45
        MOV CX,80
        MOV BL,000FH
        INT 10H
RET

DRAWMAINSCREEN ENDP


ChattingScreen Proc FAR                                       ; al ==> startfor x ;cl ==>start for y
                             pusha
        
                             mov   ah, 09
                             mov   dx, offset messsage
                             int   21h


                             mov   ah,0
                             mov   al,3
                             int   10H

                             mov   ah, 09
                             mov   dx, offset player1
                             int   21h

        ;line of status bar
                             MOV   AH,2                       ;SETTING CURSOR
                             MOV   BH,0
                             MOV   Dh,0bh
                             mov   dl,00h
                             INT   10h
        ;printing loop
                             mov   ah,9
                             mov   bh,0
                             MOV   AL,45
                             MOV   CX,80
                             MOV   BL,000FH
                             INT   10H

                             MOV   AH,2                       ;SETTING CURSOR
                             MOV   BH,0
                             MOV   Dh,12
                             mov   dl,00
                             INT   10h





                             mov   ah, 09
                             mov   dx, offset player2
                             int   21h
        ; initinalize COM
        ;Set Divisor Latch Access Bit
                             mov   dx,3fbh                    ; Line Control Register
                             mov   al,10000000b               ;Set Divisor Latch Access Bit
                             out   dx,al                      ;Out it

        ;Set LSB byte of the Baud Rate Divisor Latch register.
                             mov   dx,3f8h
                             mov   al,0ch
                             out   dx,al

        ;Set MS1B byte of the Baud Rate Divisor Latch register.
                             mov   dx,3f9h
                             mov   al,00h
                             out   dx,al

        ;Set port configuration
                             mov   dx,3fbh
                             mov   al,00011011b
                             out   dx,al
                             mov   position2,0d00h
                             mov   position1,0100h

              
        ;reading char
        again1:              mov   al,0
                             mov   ah,01
                             int   16h
                             cmp   al,0
                             jz    AGAINk
                             mov   ah,0
                             int   16h
                             cmp   ah,61d
                             jz    MS1
        continuechattingmode:cmp   ah,28
                             jne   art
                             push  CX
                             mov   cx,position1
                             add   ch,1
                             mov   cl,0
                             mov   position1,cx
                             pop   cx
                             jmp   again1
        art:                 mov   variable,al
                             mov   dx,position1
                             cmp   dh,0bh
                             jb    comm1
                             pusha
                             mov   ax,0601h                   ;scrolling the page
                             mov   bh,07
                             mov   cx,0100h
                             mov   dx,0a4fh                   ;dh row
                             int   10h
        ;dec dl
        ; dec dh
                             mov   ah,3h
                             mov   bh,0h
                             int   10h
        ;inc   dh
                       

                             mov   position1,dx
                             popa
                             push  CX
                             mov   cx,position1
                             sub   ch,1
                             mov   position1,cx
                             pop   cx
                             JMP   comm1
        MS1:                 
                             JMP   MS
        comm1:               MOV   AH,2                       ;SETTING CURSOR
                             MOV   BH,0
                             INT   10h
                             add   position1 ,0001
                             mov   dl,al
                             mov   ah,2
                             int   21h
                             push  ax
                             cmp   al,1bh
                             je    exit20
                             jmp   AGAINk
        againagain:          
                             jmp   again1

        AGAINk:              mov   dx , 3FDH                  ; Line Status Register
                             In    al , dx                    ;Read Line Status
                             AND   al , 00100000b
                             JZ    CHK
                             cmp   variable,'$'
                             jz    chk
                             pop   ax
                             mov   dx , 3F8H                  ; Transmit data register
                             mov   al,variable
                             out   dx , al
                             mov   variable,'$'
        CHK:                 mov   dx , 3FDH                  ; Line Status Register
                             in    al , dx
                             AND   al , 1
                             JZ    againagain


        ;If Ready read the VALUE in Receive data register
                             mov   dx , 03F8H
                             in    al , dx
                             mov   VALUE , al

        ;displaying char
                             mov   dx,position2
                             MOV   AH,2                       ;SETTING CURSOR
                             MOV   BH,0
                             INT   10h
                             add   position2 ,0001

                             mov   ah, 09
                             mov   dx, offset value
                             int   21h
                             jmp   again1
        exit20:              
                             mov   ah, 4ch
                             int   21h
                                
                           
        MS:                  
                             popa
                             ret                           
ChattingScreen Endp

;game
PrintMessageSt1    PROC FAR        ;dx = offset of message
                pusha
                mov dh, 24   ;y
                mov dl, 0    ;x
                mov bh, 0
                mov ah, 2
                int 10H
                popa
                ;;;;;;
                mov ah, 09
                int 21h
                
                RET
PrintMessageSt1    ENDP

;game player
PrintMessageStP1    PROC FAR        ;dx = offset of message
                pusha
                mov dh, 24   ;y
                mov dl, 30    ;x
                mov bh, 0
                mov ah, 2
                int 10H
                popa
                ;;;;;;
                mov ah, 09
                int 21h
                
                RET
PrintMessageStP1    ENDP

;chat player
PrintMessageStP    PROC FAR        ;dx = offset of message
                pusha
                mov dh, 23   ;y
                mov dl, 30    ;x
                mov bh, 0
                mov ah, 2
                int 10H
                popa
                ;;;;;;
                mov ah, 09
                int 21h
                
                RET
PrintMessageStP    ENDP

;chat
PrintMessageSt    PROC FAR        ;dx = offset of message
                pusha
                mov dh, 23 ; row
                mov dl, 0 
                mov bh, 0
                mov ah, 2 
                int 10H
                popa
                ;;;;;;
                mov ah, 09
                int 21h
                
                RET
PrintMessageSt    ENDP

port_initializatiion PROC FAR
        pusha 
        mov dx,3fbh ; Line Control Register
        mov al,10000000b ;Set Divisor Latch Access Bit
        out dx,al 
        mov dx,3f8h
        mov al,0ch
        out dx,al
        mov dx,3f9h
        mov al,00h
        out dx,al
        mov dx,3fbh
        mov al,00011011b
        out dx,al
        popa
        ret
port_initializatiion EndP
SEND            PROC   
                pusha
                mov dx , 3FDH 
        AG:     in al, dx       ;Read Line Status
                AND al , 00100000b
                JZ AG
                mov dx , 3F8H ; Transmit data register
                mov al,VALUE
                out dx , al 
                popa
                RET
SEND            ENDP

Usernames Proc FAR
        pusha
        mov ah,0
                mov al, 3
                int 10h  
                ;set cursur
                mov ah,2
                mov dx,0510h
                int 10h
                
                ;display mes
                mov ah,9
                mov dx,offset mes
                int 21h   
                
                ;set cursur
                mov ah,2
                mov dx,1010h
                int 10h
                        
                ;display mes
                mov ah,9
                mov dx,offset mes2
                int 21h 
                
                ;set cursur
                mov ah,2
                mov dx,0910h
                int 10h
                        
                mov bx,0
                ;Read Name  
                mov cx,15
                
                line: 
                
                mov ah,0
                int 16h          
                
                cmp al,13
                jz Exit 
                
                
                cmp al,8
                jnz line4
                cmp cx,15
                jz line
                
                ;______ print space ;
                MOV AH,0Eh ;INT 10,E outputs the character in AL
                MOV BH,0 ;Page number
                MOV BL,7 ;Normal light gray text on a black background
                INT 10h 
                MOV AL,20h ;20h is Space!
                MOV AH,9 ;INT 10,9 outputs the character in AL without moving the cursor
                MOV BH,0 ;Page number
                MOV BL,7 ;Normal light gray text on a black background
                INT 10h  
                inc cx
                
                line4:
                cmp al,41h
                jl line
                cmp al,5Bh
                jl print
                cmp al,61h
                jl line
                cmp al,7Bh
                jl print
                jmp line         

                Here:
                loop line
                Exit:
                jmp Exit2   
                print:
                ;__________print macro
                mov ah,2
                mov dl,al
                int 21h
                mov player1[bx],al
                inc bx  
                jmp Here 
                Exit2: 

        popa

RET
Usernames endp



RcvName        PROC FAR
                mov bx, 0
        keepWaitOnCh:
                mov dx , 3FDH   ; Line Status Register
                in al , dx      ;chk if i recived something
                AND al , 1    
                cmp al, 1       
                jne keepWaitOnCh      ;if not continue looping
                
                mov dx , 03F8H  ;else get character in al|value
                in al , dx
                mov player2[bx], al
                inc bx
                cmp al, '$'
                jne keepGoingOnRcv
                RET
        keepGoingOnRcv:
                mov VALUE, 1    ;send acceptance
                CALL SEND
                jmp keepWaitOnCh
                RET
RcvName        ENDP

SendName        PROC FAR
                lea dx, playerCantSentInv
                CALL PrintMessageSt
                mov bx, 0
        lpSn:   mov al, player1[bx]
                cmp al, '$'
                jne keepNormalLp
                mov VALUE, al   ;send that it's the end
                CALL SEND       ;then return
                RET
                ;== send and keep waiting for acc
        keepNormalLp:        
                mov VALUE, al
                CALL SEND
        keepWaitingForAcc:  mov dx , 3FDH   ; Line Status Register
                in al , dx      ;chk if i recived something
                AND al , 1    
                cmp al, 1       
                jne keepWaitingForAcc      ;if not continue looping
                mov dx , 03F8H  ;else get character in al|value
                in al , dx

                inc bx  ;update character
        jmp lpSn
                RET
SendName        ENDP

WaitUserName    PROC FAR
;1 - chk if anything recived
;       if - get the byte as first character 
;       if - and send acceptance chatacter
;       if - keep recive till last character
;       then - start sending my name

;2 - if not
;       send character
;       wait for acceptance
;       send another character and go on
;       then - start reciving other name

                pusha

                mov dx , 3FDH   ; Line Status Register
                in al , dx      ;chk if i recived something
                AND al , 1    
                cmp al, 1       
                jne SntThenRcv      ;if not continue sent then recive
                Call RcvName
                CALL SendName
                popa
                RET
        SntThenRcv:
                CALL SendName
                Call RcvName
                popa
                RET
WaitUserName    ENDP




MAIN    PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        ;

    ;=======================;
    CALL port_initializatiion 
    CALL Usernames
    ;=========== inialize
    CALL DrawMainScreen  
    CALL WaitUserName

returnHme:    CALL DrawMainScreen             ;main graphically
    MnLoop: 
        mov ah, 1
        int 16h
        jz shrtChkRcv       ;if no ch
        mov ah, 0
        int 16h
        chkF1:  cmp ah, 03bh    ;chk f2
                jne chkF2
                cmp PlayerCanChat, 0    ;if no invitation
                je InviteChatL         ;if not send invit
                mov VALUE, playerAcceptChatInv;send to white you accept invitation
                CALL SEND                     ;send you accept invitation
                CALL StartChat          ;and start game
                mov PlayerCanChat, 0    ;return to not can
                jmp MnLoop
                InviteChatL:
                        mov VALUE, playerSendingChatInv        ;send invitation
                        CALL SEND
                        lea dx, playerSendChatInvMess
                        CALL PrintMessageSt
                        lea dx, player2
                        CALL PrintMessageStP
                shrtChkRcv:     jmp ChkRcv
                shrtMnLoop:     jmp MnLoop
        chkF2:  cmp ah, 03Ch    ;chk f2
                jne chkE
                cmp PlayerCanGame, 0    ;if no invitation
                je InviteGameL         ;if not send invit
                mov PlayerGameNumber, 1 ;else be black
                mov VALUE, playerAcceptGameInv;send to white you accept invitation
                CALL SEND                     ;send you accept invitation
                CALL StartGame          ;and start game
                mov PlayerCanGame, 0    ;return to not can
                jmp returnHme
                InviteGameL:
                        mov PlayerGameNumber, 2                ;be white in next game
                        mov VALUE, playerSendingGameInv        ;send invitation
                        CALL SEND
                        lea dx, playerSendGameInvMess
                        CALL PrintMessageSt1
                        lea dx, player2
                        CALL PrintMessageStP1
                        jmp ChkRcv
        chkE:   cmp ah, 1h
                jne ChkRcv
                mov ax, 0003h                                  ; clear screen
                int 10H
                jmp EXTMN
                ;===================== reciving ======================;
        ChkRcv: mov dx , 3FDH   ; Line Status Register
                in al , dx      ;chk if i recived something
                AND al , 1    
                cmp al, 1       
                jne shrtMnLoop      ;if not continue looping
                mov dx , 03F8H  ;else get character in al|value
                in al , dx
                mov VALUE, al
                cmp al, playerSendingGameInv    ;if another player send game inv
                jne chkIfAcceptGme              ;if not
                lea dx, playerGetGameInvMess
                CALL PrintMessageSt1
                lea dx, player2
                CALL PrintMessageStP1
                mov PlayerCanGame, 1            ;can player
                mov PlayerGameNumber,1          ;black
                jmp shrtMnLoop
chkIfAcceptGme: cmp al, playerAcceptGameInv     ;if player accept invite
                jne ChlIfSendChat
                mov PlayerGameNumber,2          ;white
                CALL StartGame                  ;start game
                jmp returnHme                   ;return home screen
ChlIfSendChat:  cmp al, playerSendingChatInv    ;if another player send game inv
                jne chkIfAcceptCht              ;if not
                lea dx, playerGetChatInvMess
                CALL PrintMessageSt
                lea dx, player2
                CALL PrintMessageStP

                mov PlayerCanChat, 1            ;can player
        shrtMnLoop2:        jmp shrtMnLoop
chkIfAcceptCht: cmp al, playerAcceptChatInv     ;if player accept invite
                jne shrtMnLoop2
                CALL StartChat                  ;start game
                jmp MnLoop                   ;return home screen

        jmp MnLoop
        ;
         ;__end___;
        EXTMN:
        MOV      AH, 4CH
        INT      21H
MAIN    ENDP
        END MAIN