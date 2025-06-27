; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Entry point of the program

AppEntry:
                        ld hl, InputString              ; HL points to the beginning of the source string
                        ld de, ReversedString           ; DE points to the destination for reversed output

                        ld b, 0                         ; B will be used to store the length of the string

; --- Count the length of the string by moving through it ---
move_pointer_loop:
                        ld a, (hl)                      ; Load current character from HL
                        cp 0                            ; Check if it's the null terminator
                        jr z, reverse_string            ; If end of string, jump to start reversing

                        inc b                           ; Increment length counter
                        inc hl                          ; Move HL to the next character
                        jr move_pointer_loop            ; Repeat loop

; --- Reverse the string by copying characters backward ---
reverse_string:
                        nop                             ; At this point, HL points to the null terminator
                        inc b                           ; Adjust count to include the last valid character

reverse_string_loop:
                        ld a, (hl)                      ; Load character at current HL position
                        ld (de), a                      ; Store it at current DE position (output)

                        dec hl                          ; Move HL backward (to previous char)
                        inc de                          ; Move DE forward (to next output slot)

                        djnz reverse_string_loop        ; Loop B times

                        jr End                          ; Done, jump to end of program

End:
                        halt                            ; Stop execution (used in simulators)
                        jp AppEntry                     ; Optional infinite loop after halt

; --- Data Section ---
InputString:            defb "HELLO Z80 USERS", 0       ; Original input string (null-terminated)
ReversedString:         defs 50                         ; Destination buffer for reversed string

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


