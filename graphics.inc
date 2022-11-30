CLRS        MACRO 
            pusha

            MOV  AX,0600h ;AH=06 to select scroll function
                          ;AL=00 the entire page
            MOV  BH,07    ;BH=07 for normal attribute
            MOV  CX,0000  ;CH=00 row value of start point
                          ;CL=00 column value of start paint
            MOV  DX,184fh ;DH=24 row value of ending point
                          ;DL=79 column value of ending point
            INT 10H       ;invoke the interrupt

            popa
ENDM CLRS

DrawGrid    MACRO w, color
            LOCAL lr, lw, lh
            pusha
            mov si, 0
            mov di, 0
            mov cx, 8

;___ draw rank by rank ____;
lr:     push cx 
        mov cx, w
        ;___ draw line ____;
        lh: push cx
                mov cx, 8   
                ;___ draw square line ___; 
                lw:
                        push cx

                        mov al, color[si];color
                        mov cx, w        ;width
                        REP STOSB        ;draw a width of square
                        XOR si, 1        ;toggle color for next square
                        

                        pop cx
                loop lw
                add di, 120
                pop cx
        loop lh
        XOR si, 1        ;toggle color for next square
        pop cx
loop lr
            
            popa
ENDM DrawGrid


DrawImg     MACRO img, imageWidth, startPoint
            LOCAL lp1, lp2, skip
            
            pusha

            mov cx, imageWidth
            mov di, startPoint
            lea si, img
            

lp1:    push cx
        mov cx, imageWidth
        lp2:    mov al, [si]
                cmp al, 4
                je skip

                mov es:[di], al

        skip:   inc di
                inc si
        loop    lp2
        sub di, imageWidth
        add di, 320
        pop cx
loop lp1
            popa
ENDM DrawImg