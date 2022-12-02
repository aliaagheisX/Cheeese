from PIL import Image
files = {
    'Bbishop':[], 
    'Wbishop':[], 
    'Bknight':[], 
    'Wknight':[],
    'Brook':[],
    'Wrook':[],
    'Bqueen':[],
    'Wqueen':[],
    'Bking':[],
    'Wking':[],
}
""" for filename in files.keys():
    
    im = Image.open("r/" + filename + ".png").convert('LA') ####greyscal, alpha
    pixels = list(im.getdata())
    px =  []
    for elm in pixels:
        px.append(elm[:-1])
        
    C = []
    for c,i in enumerate(px):
        if pixels[c][1] == 0:
            C.append(4)
        elif  pixels[c][0] - 0 < 255 - pixels[c][0]:
            C.append(16)
        else :C.append(15)

    StrC = f"{filename} DB "

    # Split the array into multiple lines cause it will be too long for one line for the tasm/masm.
    for i in range(len(C)):
        if i!=0 and i % 25 == 0:
            StrC = StrC + str(C[i]) + " " + "\n DB "
        else:
            StrC = StrC + str(C[i]) + ", "

    StrC = StrC[:-2]
    print(StrC)
    print('\n\n') """
    

    
for i in range(8*8):
    print(f"{25*i}, ", end='')
    
# Used pallete: https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/VGA_palette_with_black_borders.svg/1200px-VGA_palette_with_black_borders.svg.png
# This pallete is the default 256 colors in the Tasm/Masm Extension for VS code, Note that the original asm86 only supported the first 16 colors
# So make sure while drawing your art to pick (via color picker) from this palette, btw: Krita(~30mb) is a great and easy app for creating pixel art:
# How to set up Krita for pixel art(5 mins): https://www.youtube.com/watch?v=aaRzNTCanIQ
# Nice Pixel art tutorials playlist (each video is 5~15 mins): https://www.youtube.com/playlist?list=PLmac3HPrav-9UWt-ahViIZxpyQxJ2wPSH

    # It is okay tho to use black(0) as escaping since there are other codes for the same color like 16, 248..255.
    # if it is .png with some pixels having 0 in alpha channel (making them tranparent: use black(0) as escaping color)
