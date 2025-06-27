; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of the program

AppEntry:
                        ld hl, SourceText               ; HL points to the input string
                        ld b, 0                         ; B will hold the word count (initially 0)
                        ld c, 0                         ; C is a flag: inWord = 0 (we're not inside a word)

scanLoop:
                        ld a, (hl)                      ; Load current character into A
                        cp 0                            ; Check if it's the null terminator (end of string)
                        jr z, saveWordCount             ; If so, jump to save the result

                        cp ' '                          ; Compare with space character
                        jr z, setOutsideWord            ; If it's a space, we're outside a word

                        ld a, c                         ; Load current inWord flag into A
                        cp 0                            ; Were we outside a word?
                        jr nz, nextChar                 ; If already inside a word, skip increment

                        inc b                           ; Found the start of a new word ? increment count
                        ld c, 1                         ; Set inWord = 1 (we're inside a word)
                        jr nextChar                     ; Continue processing

setOutsideWord:
                        ld c, 0                         ; Mark inWord = 0 (we're outside a word)

nextChar:
                        inc hl                          ; Move HL to the next character
                        jr scanLoop                     ; Repeat the loop

saveWordCount:
                        ld a, b                         ; Copy word count to A
                        ld (TotalWords), a              ; Store result in TotalWords
                        jp End                          ; End of program

End:
                        halt                            ; Halt CPU (for emulator)
                        jp End                          ; Infinite loop to prevent exit

SourceText:
                        defb "  HELLO  WORLD  Z80 IS COOL  ", 0 ; Null-terminated input string

TotalWords:
                        defb 0                          ; Memory location to store total word count

; Stop planting code after this. (When generating a tape file we save bytes below here)

AppLast                 equ *-1                         ; The last used byte's address

; Generate some useful debugging commands

                        profile AppFirst,AppLast-AppFirst+1 ; Enable profiling for all the code

; Setup the emulation registers, so Zeus can emulate this code correctly

Zeus_PC                 equ AppEntry                    ; Tell the emulator where to start
Zeus_SP                 equ $FF40                       ; Tell the emulator where to put the stack

; These generate some output files

                        ; Generate a SZX file
                        output_szx AppFilename+".szx",$0000,AppEntry ; The szx file

                        ; If we want a fancy loader we need to load a loading screen
;                        import_bin AppFilename+".scr",$4000            ; Load a loading screen

                        ; Now, also generate a tzx file using the loader
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry ; A tzx file using the loader


