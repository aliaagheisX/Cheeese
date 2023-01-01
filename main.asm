;Author: 
;DATE:
;This Progam
;======================
        EXTRN StartGame:FAR
        .286
        .MODEL HUGE
        .STACK 256
.DATA
        ;________chat__________;
       
        value                db  ?,  0AH, 0DH, "$"
        messsage             DB  'serial communication Receive', 0AH, 0DH, "$"
        player1              db  'me: ','$'
        player2              db  'you: ','$'
        position1            dw  ?
        position2            dw  ?
        variable             db  '$'

        ;__________-main___________;
        FLINE                DB  'To start chatting press F1$'
        SLINE                db  'To start the game press F2$'
        TLINE                DB  'To end the program press ESC$'
        ;___________usernames_________________________;
        mes                  db  'Please Enter Your Name$'
        mes2                 db  'Press Enter To Continue$'
        playername           db  15 dup('$')

        
        ;________screen states _________;
        playerEnterUserName  equ 0
        playerWaiting        equ 1

        playerSendingChatInv equ 2                                                    ;
        playerSendingGameInv equ 3
        playerCanAcceptGame  equ 4
        playerAcceptGameInv  equ 5

        PlayersChattingNow   equ 6
        PlayersPlayerNow     equ 7


        PlayerCanChat        db  0                                                    ;1
        PlayerCanGame        db  0                                                    ;1

.CODE
waitSec PROC   FAR                                            ;ax = row, cx = col =>>>> ax = current start point
                             push  ax


                             mov   ah, 07
                             int   21h

                             pop   ax
                             RET
waitSec ENDP
DRAWMAINSCREEN PROC FAR
                             mov   ax, 0003h                  ; clear screen
                             int   10H
                             lea   DX,FLINE
                             PUSH  DX
                             MOV   AH,2                       ;SETTING CURSOR
                             MOV   BH,0
                             MOV   DX,0915H
                             INT   10h
                             POP   DX                         ;PRINTING FIRST LINE
                             MOV   AH,9
                             INT   21H
                             MOV   DX,OFFSET SLINE
                             PUSH  DX
                             MOV   AH,2                       ;SETTING CURSOR
                             MOV   DX,0B15H
                             MOV   BH,0
                             INT   10h
                             POP   DX                         ;PRINTING SECOND LINE
                             MOV   AH,9
                             INT   21H
                             MOV   DX,OFFSET TLINE
                             PUSH  DX
                             MOV   AH,2                       ;SETTING CURSOR
                             MOV   BH,0
                             MOV   DX,0D15H
                             INT   10h
                             POP   DX                         ;PRINTING FIRST LINE
                             MOV   AH,9
                             INT   21H
        ;line of status bar
                             MOV   AH,2                       ;SETTING CURSOR
                             MOV   BH,0
                             MOV   DX,1600H
                             INT   10h

                             mov   ah,9
                             mov   bh,0
                             MOV   AL,45
                             MOV   CX,80
                             MOV   BL,000FH
                             INT   10H
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
Usernames Proc FAR
                             pusha
                             mov   ah,0
                             mov   al, 3
                             int   10h
        ;set cursur
                             mov   ah,2
                             mov   dx,0510h
                             int   10h
                
        ;display mes
                             mov   ah,9
                             mov   dx,offset mes
                             int   21h
                
        ;set cursur
                             mov   ah,2
                             mov   dx,1010h
                             int   10h
                        
        ;display mes
                             mov   ah,9
                             mov   dx,offset mes2
                             int   21h
                
        ;set cursur
                             mov   ah,2
                             mov   dx,0910h
                             int   10h
                        
                             mov   bx,0
        ;Read Name
                             mov   cx,15
                
        line:                
                
                             mov   ah,0
                             int   16h
                
                             cmp   al,13
                             jz    Exit9
                
                
                             cmp   al,8
                             jnz   line4
                             cmp   cx,15
                             jz    line
                
        ;______ print space ;
                             MOV   AH,0Eh                     ;INT 10,E outputs the character in AL
                             MOV   BH,0                       ;Page number
                             MOV   BL,7                       ;Normal light gray text on a black background
                             INT   10h
                             MOV   AL,20h                     ;20h is Space!
                             MOV   AH,9                       ;INT 10,9 outputs the character in AL without moving the cursor
                             MOV   BH,0                       ;Page number
                             MOV   BL,7                       ;Normal light gray text on a black background
                             INT   10h
                             inc   cx
                
        line4:               
                             cmp   al,41h
                             jl    line
                             cmp   al,5Bh
                             jl    print
                             cmp   al,61h
                             jl    line
                             cmp   al,7Bh
                             jl    print
                             jmp   line

        Here:                
                             loop  line
        Exit9:               
                             jmp   Exit2
        print:               
        ;__________print macro
                             mov   ah,2
                             mov   dl,al
                             int   21h
                             mov   playername[bx],al
                             inc   bx
                             jmp   Here
        Exit2:               

                             popa


                             ret

Usernames endp



MAIN PROC FAR
                             MOV   AX, @DATA
                             MOV   DS, AX
        ;
        ;=======================;
                             CALL  Usernames
    
        returnHme:           
                             CALL  DrawMainScreen             ;main graphically
        MnLoop:              
                             mov   ah, 1
                             int   16h
                             jz    MnLoop

                             mov   ah, 0
                             int   16h

        chkF1:               cmp   ah, 03bh                   ;chk f2
                             jne   chkF2
        ;___________    port & message ________;
            
                             CALL  ChattingScreen
                             jmp   returnHme

        chkF2:               cmp   ah, 03Ch                   ;chk f2
                             jne   chkE
                             CALL  StartGame
                             jmp   returnHme
                
        chkE:                cmp   ah, 1h
                             jne   MnLoop
        ; CALL StartGame
                             mov   ax, 0003h                  ; clear screen
                             int   10H
                             jmp   EXTMN
                             jmp   MnLoop
        ;
        ;__end___;
        EXTMN:               
                             MOV   AH, 4CH
                             INT   21H
MAIN ENDP
        END MAIN