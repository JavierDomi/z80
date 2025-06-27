; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "Newfi1e"                   ; What we're called (for file generation)

AppFirst                equ $8010                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+

                        org AppFirst                    ;

Suma                    defb 0                          ;
NumElementos            defb 0                          ;

; ----
; Start planting code here. (When generating a tape file we start saving from here)

AppEntry:
                        ld b, 0                         ; Initialize next number to add (starting from 0)
                        ld c, 0                         ; Initialize accumulator for the total sum
                        ld d, 0                         ; Initialize the counter for number of elements added

loop:
                        ld a, c                         ; Load current sum into A
                        add b                           ; Add the next number (B) to the sum
                        ld c, a                         ; Store updated sum back into C
                        inc d                           ; Increment number of elements added (D)

                        cp 210                          ; Check if the sum has reached 210
                        jr z, storeResult               ; If so, exit loop and store results

                        inc b                           ; Prepare the next number to add (increment B)
                        jr loop                         ; Repeat loop

storeResult:
                        ld a, c                         ; Load final sum into A
                        ld (Suma), a                    ; Store sum into the variable Suma

                        ld a, d                         ; Load number of elements into A
                        ld (NumElementos), a            ; Store count into variable NumElementos

                        jr AppOut                       ; Jump to end of program

AppOut:
                        halt                            ; Halt CPU (end of simulation)
                        jp AppOut                       ; Infinite loop after halt

; Stop planting code after this. (When generating a tape file we save bytes below here)

; ----

AppLast                 equ *+1                         ; The last used byte's address

; Regler om manntallsf�ringen og om innf�ringen av de stemmeberettigede i manntallet fastsettes ved lov.

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


