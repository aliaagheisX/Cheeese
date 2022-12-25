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
        Playername1          db  "Adam",'$'                       ;
        Playername2          db  "Gasser",'$'
        ;this is a test for phase 1
        talk                 db  "Hello.How are you ?",'$'
        ;the speech from chat
        InDATA               db  100,?,100 dup('$')

;__________-main___________;
        FLINE DB 'To start chatting press F1$'
        SLINE db 'To start the game press F2$'
        TLINE DB 'To end the program press ESC$'
;___________usernames_________________________;
mes db 'Please Enter Your Name$'   
 mes2 db 'Press Enter To Continue$'
 playername db 15 dup('$') 

        
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
ChattingScreen Proc FAR                                          ; al ==> startfor x ;cl ==>start for y
        ; For Chat Mode cl=0 al=0
                             pusha
                             
                      
                             mov   bh,al
                             mov   ah,0                          ;switch to text mode
                             mov   al,3h
                             int   10H
                             mov   ah,2

                             mov   dl,0                          ;x
                             mov   dh,0                          ;y
                             int   10h
                           
                             mov   ah, 9
                             mov   dx, offset Playername1
                             int   21h
                             mov   ah,2
                             mov   dl,':'
                             int   21h
                             mov   ah,2
                             mov   dl,10
                             int   21h
                             mov   ah,2
                             mov   dl,13
                             int   21h
                             mov   ah, 9
                             mov   dx, offset talk
                             int   21h
                             mov ah,2
                             mov   dl,0                          ;x
                             mov   dh,12                         ;y
                             int   10h
                             mov   cx,80
        Seperate:            
                             mov   ah,2
                             mov   bl,dl
                             mov   dl,'-'
                             int   21h
                             mov   dl,bl
                             inc   dl
                             int   10h
                             Loop  Seperate
                             mov   ah, 9
                             mov   dx, offset Playername2
                             int   21h
                             mov   ah,2
                             mov   dl,':'
                             int   21h
                             mov   ah,2
                             mov   dl,10
                             int   21h
                             mov   ah,2
                             mov   dl,10
                             int   21h
                             mov   si,1000
                             mov   dl,0
                             mov   dh,17
                             mov   ah,00
                             mov   al,00
        Reading:             
                                ; check: 
                                mov ah, 1
                                int 16h
                                jz reading
                                mov ah, 0
                                int 16h
                                cmp ah,03dh 
                                je comp   

                             push  dx
                             cmp   dh,24
                             jb   continuewriting
                        ;      mov   ah,2
                        ;      mov   dl,0                          ;x                 
                        ;      int   10h
                             mov   ax,0601h
                             mov   bh,07
                             mov   cx,0
                             mov   dx,184FH
                             int   10h
                             pop   dx
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        continuewriting:     
                             push  dx
                             mov   ah,0AH
                             mov   dx,offset InDATA
                             int   21h
                                    
                             mov   ah,2
                             pop   dx
                             mov   dl,0
                             inc   dh
                             int   10h
                              
                             dec   si
                             cmp   si,0
                             jnz   Reading

                       

        
comp:
CALL DrawMainScreen    


                             popa
                             ret
ChattingScreen Endp
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
                mov playername[bx],al
                inc bx  
                jmp Here 
                Exit2: 

        popa


ret

Usernames endp



MAIN    PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        ;
    ;=======================;
    CALL Usernames
    
returnHme:    CALL DrawMainScreen             ;main graphically
    MnLoop: 
        mov ah, 1
        int 16h
        jz MnLoop

        mov ah, 0
        int 16h

        chkF1:  cmp ah, 03bh    ;chk f2
                jne chkF2
                CALL ChattingScreen

        chkF2:  cmp ah, 03Ch    ;chk f2
                jne chkE
                CALL StartGame
                jmp returnHme
                
        chkE:   cmp ah, 1h
                jne MnLoop
                ; CALL StartGame
                mov ax, 0003h                                  ; clear screen
                int 10H
                jmp EXTMN
        jmp MnLoop
        ;
         ;__end___;
        EXTMN:
        MOV      AH, 4CH
        INT      21H
MAIN    ENDP
        END MAIN