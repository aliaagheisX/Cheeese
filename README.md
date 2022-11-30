
# Cheeese

A brief description of files & what in it

```
    ├── ...
    |── graphics.inc
    |   ├── CLRS                                          # clear screen
    |   ├── DrawGrid (width of square, colors)            # draw grid 
    |   ├── DrawImg  (img, width of image, startPoint)    # draw image **skipping color 4**
    ├── main.asm                    # main  running file
    │   ├── board peices code  
    │   ├── color code
    │   ├── gridColor, square width, image width
    │   ├── images of peices
    │   └── board 8x8 => peices|emptyCell
    ├── converter.py                    # convert png 25x25 to bitmap
    │   ├── filename                    # will print bitmap of it
    ├── r/                    # chess set png 25*25
    └── ...
```


## how to use DOsBOX

1. download it 
2. MASM/TASM extension
3. open vs code settings 
    - search on masm
    - Assembler option on ```tasm```
    - scroll down to ```emulator```
    - make sure it select ```dosBox```
