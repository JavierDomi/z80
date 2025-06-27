; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "Newfi1e"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; ----
; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
Origin                  equ 5061                        ; Starting address of source string
BirthMonth              defb 6                          ; Your birth month (used to extend copy length)
SourceLength            equ 11                          ; Base length of the string to copy
OutputArray             equ $8100                       ; Destination array starts at memory address 8100H

AppEntry:
                        ld a, (BirthMonth)              ; Load the birth month value into A
                        add SourceLength                ; Add the base length to calculate total number of characters
                        ld b, a                         ; Store result in B as loop counter

                        ld de, OutputArray              ; Set DE to point to the output array
                        ld hl, Origin                   ; Set HL to point to the source string

mainLoop:
                        ld a, '#'                       ; Load '#' character into A
                        ld (de), a                      ; Store '#' in the output array
                        inc de                          ; Move DE to next output position

                        ld a, (hl)                      ; Load character from source string
                        ld (de), a                      ; Store it in output array
                        inc de                          ; Move to next output slot
                        inc hl                          ; Move to next source character

                        djnz mainLoop                   ; Loop until B reaches 0

End:
                        halt                            ; Halt the CPU (simulation stop)
                        jp End                          ; Infinite loop after halt

; Stop planting code after this. (When generating a tape file we save bytes below here)


AppLast                 equ *+1                         ; The last used byte's address



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


