; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry:               ld hl, TextString               ; Load HL with the pointer to the beginning of the string
                        ld b, 0                         ; Initialize index counter to 0

searchLoop:             ld a, (hl)                      ; Load current character from HL into A
                        cp 0                            ; Check if it's the end of the string (null terminator)
                        jr z, storeResult               ; If it is, jump to storeResult

                        call isVowel                    ; Call the isVowel subroutine

                        cp 0                            ; Check result: 0 means it's NOT a vowel
                        jr nz, storeResult              ; If it's a vowel, jump to storeResult

                        inc b                           ; Increment index counter
                        inc hl                          ; Move HL to the next character
                        jr searchLoop                   ; Repeat the loop

storeResult:            ld a, b                         ; Load index value into A
                        ld (VowelIndex), a              ; Store the index in memory

                        ld (VowelPointer), hl           ; Store pointer to the vowel in memory

                        jp End                          ; Jump to program end

; ----------------
; Subroutine: isVowel
; Input:  A = character to check
; Output: A = non-zero if vowel (A, E, I, O, U), 0 otherwise
; ----------------

isVowel:                cp 'A'                          ; Compare with 'A'
                        ret z

                        cp 'E'                          ; Compare with 'E'
                        ret z

                        cp 'I'                          ; Compare with 'I'
                        ret z

                        cp 'O'                          ; Compare with 'O'
                        ret z

                        cp 'U'                          ; Compare with 'U'
                        ret z

                        xor a                           ; Not a vowel ? set A = 0
                        ret                             ; Return to caller

End:                    halt                            ; Halt the CPU (used in emulation)
                        jp AppEntry                     ; Infinite loop after HALT

TextString:             defb "XSZPAMBCDFG", 0           ; The input string (null-terminated)
VowelIndex:             defb 0                          ; Byte to store the index of the first vowel
VowelPointer:           defw 0                          ; Word to store the pointer to the first vowel

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


