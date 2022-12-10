.MODEL SMALL
.stack 64
.DATA
.CODE

MAIN PROC FAR
        MOV ax, @DATA
        mov DS, ax
        ;_________________________
        mov bl, '9'
        

lp1:    mov ah, 86h
        mov cx, 0h
        mov dx, 0ah
        int 15h

        mov ah, 02
        mov dl, bl
        int 21h
        dec bl
        cmp bl, '0'
        jne lp1

        ;_________________________
        MOV      AH, 4CH
        INT      21H
MAIN ENDP
END MAIN
