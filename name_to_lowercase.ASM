; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "Newfi1e"                   ; What we're called (for file generation)

AppFirst                equ $8100                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+



                        org AppFirst                    ; Start of application

; ----
; Start planting code here. (When generating a tape file we start saving from here)

AppEntry:
                        ld de, MiNombre                 ; Load pointer to MiNombre into DE (input string)
                        ld hl, TransformedName          ; Load pointer to TransformedName into HL (output string)
                        ld c, 20H                       ; ASCII difference between uppercase and lowercase (A - a = 32 = 20h)

                        call strln                      ; Call strlen routine to get length in register B
                        nop                             ; Optional: could be replaced with a more efficient loop

mainLoop:
                        ld a, (de)                      ; Load current character from DE into A
                        cp ' '                          ; Compare it with space character
                        jr z, skip                      ; If it is a space, skip copying

                        add c                           ; Convert uppercase letter to lowercase (A + 20h = a)
                        ld (hl), a                      ; Store lowercase letter in output string
                        inc hl                          ; Advance HL to next position in output

skip:
                        inc de                          ; Advance DE to next character in input
                        djnz mainLoop                   ; Repeat until all characters processed (based on B from strlen)
                        jp Final                        ; Jump to end of program

; Subroutine to calculate string length (stores length in B)
strln:
                        ld b, 0                         ; Initialize length counter to 0

strlnLoop:
                        ld a, (de)                      ; Load current character
                        cp 0                            ; Check for null terminator
                        jr z, endLoop                   ; If null found, end loop

                        inc b                           ; Increment character count
                        inc de                          ; Move to next character
                        jr strlnLoop                    ; Repeat

endLoop:
                        ld de, MiNombre                 ; Restore DE to start of string
                        ret                             ; Return from subroutine

Final:
                        halt                            ; End of execution
                        jp Final                        ; Infinite loop after halt (safe end)

; Input string: name in uppercase, with null terminator
MiNombre:               defb "ETHAN CARTER WHITMORE", 0

; Output string: will contain lowercase name without spaces
TransformedName:        defb "                          " ; 26 spaces (enough to hold result)

; ----

; Bu Kanun yayimi tarihinde y�r�rl�ge girer ve halkoylamasina sunulmasi halinde oylanir

AppLast                 equ *+1                         ; The last used byte's address


; ----

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


