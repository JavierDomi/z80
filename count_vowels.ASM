; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry:
                        ld hl, InputText               ; Load pointer to the input string into HL
                        ld b, 0                        ; B will count the number of vowels found

countVowels:
                        ld a, (hl)                     ; Load current character into A
                        cp 0                           ; Check if it's the null terminator
                        jr z, saveResult               ; If end of string, jump to save the result

                        call isUppercaseVowel          ; Check if character is a vowel
                        cp 0                           ; If A == 0 ? not a vowel
                        jr z, skipIncrement            ; If not a vowel, skip increment

                        inc b                          ; It's a vowel ? increment vowel count

skipIncrement:
                        inc hl                         ; Move to the next character
                        jr countVowels                 ; Loop back to check next character

; --------------------------------
; Subroutine: isUppercaseVowel
; Description: Sets A ? 0 if character in A is an uppercase vowel ('A', 'E', 'I', 'O', 'U'), 0 otherwise
; --------------------------------
isUppercaseVowel:
                        cp 'A'                          ; Compare with 'A'
                        ret z

                        cp 'E'                          ; Compare with 'E'
                        ret z

                        cp 'I'                          ; Compare with 'I'
                        ret z

                        cp 'O'                          ; Compare with 'O'
                        ret z

                        cp 'U'                          ; Compare with 'U'
                        ret z

                        ld a, 0                         ; Not a vowel ? set A = 0
                        ret

saveResult:
                        ld a, b                         ; Copy vowel count into A
                        ld (VowelCount), a              ; Store the result in VowelCount variable
                        jp End                          ; End of program

End:
                        halt                            ; Halt the CPU (useful for simulation)
                        jp AppEntry                     ; Infinite loop after halt

InputText:
                        defb "BIENVENIDO A Z80", 0      ; Input string (null-terminated)
VowelCount:
                        defb 0                          ; Variable to store the number of vowels found

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


