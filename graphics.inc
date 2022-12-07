DrawGrid    MACRO boardWidth, color
            pusha
            mov si, 0
            mov di, 0
            mov cx, 8

;___ draw rank by rank ____;
lr:     push cx 
        mov cx, boardWidth
        ;___ draw line ____;
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
DrawGrid ENDM



Available_BackGround    MACRO boardWidth, position
        pusha                
                mov cx,boardWidth            ;height
                mov di, position
                highlightLoop: push cx
                        ;draw line 
                        mov  al, highlightColor      ;Background color of available move
                        mov  cx, boardWidth          ;width   
                        REP  STOSB 
                        sub  di,boardWidth           
                        add  di,320     
                        pop cx
                loop highlightLoop
        popa
Available_BackGround ENDM 


DrawImg     MACRO ;bx = offset img, di = startPoint
            pusha
            mov cx, imageWidth
lp1:    push cx
        mov cx, imageWidth
        lp2:    mov al, [bx]
                cmp al, 4
                je skip

                mov es:[di], al

        skip:   inc di
                inc bx
        loop    lp2
        add di, 320-imageWidth
        pop cx
loop lp1
            popa
DrawImg ENDM