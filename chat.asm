;Author: Aliaa Gheis
;DATE:
;This Progam
;======================
        PUBLIC StartChat, InializeChar
        EXTRN player1:BYTE
        EXTRN player2:BYTE
        EXTRN PrintMessageSt:FAR
        .MODEL HUGE
        .286
        .STACK 64
        .DATA
        VALUE DB '$$'
        c1 DW 0103h
        c2 DW 0c03h
        startCol db 0
        rowSize db 80
        exitMsg db 'press ESC to exit$'
        clrMsg db '                                            $'
        columnMsg db ': $'
        activePage equ 2
        stausLineRow equ 21      ;endRow-2 => 
                                ;line sepreate status from chat
        
        ChatLineRow equ  10       ;line seperate two chats
                                ;(end-start)/2
                                ;start = 0
                                ;end line => 24- (2 lines for status + 1 line sep)

        

        .CODE

        


InializeChar    PROC    FAR
                ;__________ print me ________;
                mov dl, 0      ;set cursor
                mov dh, 0      ;set cursor
                mov bh, activePage
                mov ah, 02
                int 10h

                lea dx, player1    ;print ME:
                mov ah, 9
                int 21h

                lea dx, columnMsg    ;print ME:
                mov ah, 9
                int 21h

                ;___________________print YOU_______________________;
                mov dl, 0      ;set cursor
                mov dh, 11      ;set cursor
                mov bh, activePage      ;page
                mov ah, 02      ;interrupt
                int 10h

                lea dx, player2    ;print YOU:
                mov ah, 9
                int 21h

                lea dx, columnMsg    ;print ME:
                mov ah, 9
                int 21h
                
                ;_____________ draw line seperate between chats___________________;
                mov dh, ChatLineRow
                mov dl, startCol       ;lineCol
                mov bh, activePage       ;set cusor to line row
                mov ah, 02
                int 10h

                mov al, '_'     ;charcter
                mov bl, 03h     ;color
                mov bh, activePage       ;page
                mov ch, 0
                mov cl, rowSize      ;count
                sub cl, startCol
                mov ah, 09      ;repeat count
                int 10h
                ;_____________ draw line___________________;
                mov dh, stausLineRow
                mov dl, 0       ;lineCol
                mov bh, activePage       ;set cusor to line row
                mov ah, 02
                int 10h

                mov al, '_'     ;charcter
                mov bl, 03h     ;color
                mov bh, activePage       ;page
                mov ch, 0
                mov cl, rowSize      ;count
                mov ah, 09      ;repeat count
                int 10h
                ;=========== print in status
                mov dl, 0      ;set cursor
                mov dh, 23      ;set cursor
                mov bh, activePage
                mov ah, 02
                int 10h

                lea dx, exitMsg    ;print ME:
                mov ah, 9
                int 21h

                RET
InializeChar    ENDP


PORT_INIT       PROC
                mov dx,3fbh     ; Line Control Register
                mov al,10000000b ;Set Divisor Latch Access Bit
                out dx,al       ;Out it

                mov dx,3f8h     ;Set LSB byte of the Baud Rate Divisor Latch register.
                mov al,0ch
                out dx,al

                mov dx,3f9h     ;Set MSB byte of the Baud Rate Divisor Latch register.
                mov al,00h
                out dx,al

                mov dx,3fbh
                mov al,00011011b
                out dx,al

                RET
PORT_INIT       ENDP


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

PrnChar         PROC    ;(dx = cursor position to print) ==> (dx = updated cursor position)
                
                mov bh, activePage       ;set cursor position to (dx = cursor position to print)
                mov ah, 02      ;
                int 10h         ;

                mov al, VALUE   ;get character to print
                cmp  al, 13     ;check if not enter
                jne prnN        ;if not print it as normal

                add dh, 1
                mov dl, startCol;set cursor col to start col
                mov bh, activePage       ;set cursor position to (dx = cursor position to print)
                mov ah, 02      ;
                int 10h         ;
                RET   ;and exit
                ;__________________________________________________;
                
prnN:     
                mov dl, al      ;print character normally
                mov ah, 2
                int 21h

ExPrnChar:      
                mov ah, 3       ;get updated cursor (in dx)
                mov bh, activePage
                int 10h

                RET
PrnChar         ENDP


ScrollUP1       PROC           ;dx = cursor poisiotn

                mov ah,6                ; function 6 to scroll up
                mov al,1                ; scroll by 1 line
                mov bh,15                ; normal video attribute = black
                mov ch,1                ; upper left row
                mov cl,startCol         ; upper left col
                mov dh,ChatLineRow      ; lower right row before chat line sep
                dec dh
                mov dl,rowSize          ; lower right col
                int 10h
                RET
ScrollUP1        ENDP

ScrollUP2        PROC    ;dx = cursor poisiotn
                mov ah,6  ; function 6
                mov al,1  ; scroll by 1 line
                mov bh,15  ; normal video attribute

                mov ch,ChatLineRow  ; upper left row after you:
                add ch, 2
                mov cl,startCol  ; upper left col

                mov dh,stausLineRow ; lower right row
                dec dh
                mov dl,rowSize ; lower right col
                int 10h
                RET
ScrollUP2        ENDP


ChkCusrorUpdate PROC
                pusha
chkMeCursor:    mov dx, c1                      ;dx = me cursor
                cmp dh, ChatLineRow             ;chk if in nxt state row = chat line seperator
                jne chkYouCursor                ;if not chk if enter new col         
                CALL ScrollUP1                  ;else scroll up
                mov dh, ChatLineRow             ;update to be in row before line
                dec dh                          ;
                mov dl, startCol                ;update col to be in start col
                mov c1, dx                      ;mov value into cursor
                jmp chkYouCursor                ;chk nxt cursor


chkYouCursor:   mov dx, c2                      ;dx = you cursor
                cmp dh, stausLineRow            ;chk if in nxt state row = status line seperator
                jne EXITChkCur                ;if not chk if enter new col   
                CALL ScrollUP2                  ;else scroll up
                mov dh, stausLineRow            ;update to be in row before line
                dec dh
                mov dl, startCol                ;update col to be in start col
                mov c2, dx                      ;mov value into cursor
                jmp EXITChkCur                  ;and exit function

EXITChkCur:
                popa
                RET
ChkCusrorUpdate ENDP


;===========================================================;
StartChat    PROC FAR

       ;=================== scroll to new page
       mov ah, 05
       mov al, activePage
       int 10h
       ;=================== scroll to new page

        mov ax, 0b800h
        mov es, ax
        
        ;___________    port & message ________;
        CALL PORT_INIT
        CALL InializeChar
        ;_________________________


        

MNLOOP:         
                mov ah, 1       ;read buffer
                int 16h         ;
                jz PrnRvs       ;if no char print recive
                mov ah, 0       ;else get char
                int 16h         
                
                cmp al, 1bh     ;chk if esc
                je EXIT         ;if yes ext
                
                mov VALUE, al   ;put character in vluae for SEND call
                CALL SEND       ;send character

                mov dx, c1      ;set me cursor
                CALL PrnChar    ;print character
                mov c1, dx      ;update me cursor
                CALL ChkCusrorUpdate    ;scroll if not
                

PrnRvs:         mov dx , 3FDH   ; Line Status Register
                in al , dx      ;chk if i recived something
                AND al , 1    
                cmp al, 1       
                jne MNLOOP      ;if not continue looping

                mov dx , 03F8H  ;else get character in al|value
                in al , dx
                mov VALUE, al

                cmp al, 1bh     ;chk if esc
                je AnotherExit        


                mov dx, c2      ;set you cursor
                CALL PrnChar    ;print character
                mov c2, dx      ;upate you cursor
                CALL ChkCusrorUpdate

                jmp MNLOOP      ;loop


        EXIT:
        mov VALUE, al
        CALL SEND
        AnotherExit:
        ;=================== scroll to new page
        mov ah, 05
        mov al, 0
        int 10h
       ;=================== scroll to new page

       ;=================== clear
                mov dl, 0      ;set cursor
                mov dh, 23      ;set cursor
                mov bh, 0      ;page
                mov ah, 02      ;interrupt
                int 10h

                lea dx, clrMsg    ;print YOU:
                mov ah, 9
                int 21h
                
                mov ah,01
                mov ch, 0fh
                mov cl, 0
                int 10h
       ;=================== clear

        RET
        ;=========== scroll to other page
StartChat    ENDP


END