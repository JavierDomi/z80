# Z80 Assembly Practice

This repository contains educational Z80 assembly programs developed as part of my learning process.  
Each program focuses on practical exercises like string manipulation, counting words or vowels, reversing strings, memory formatting, and sum calculations.

## 💾 Structure

- Each `.asm` file is self-contained and follows a skeleton-style format with clearly marked code sections.
- Programs start at the label `AppEntry` and usually end with a `halt` instruction and an infinite loop.
- Source code is commented in English for clarity and easier understanding.
- Designed to be tested in common Z80 emulators such as Zeus Z80, SPASM, or any other compatible environment.

## 🧪 Exercises Included

- Counting words in a string ignoring multiple spaces
- Counting vowels in uppercase strings
- Transforming uppercase names into lowercase without spaces
- Reversing a string into a separate buffer
- Creating a formatted memory array combining characters and data
- Summing natural numbers until reaching a specific total

## ⚙️ Requirements

- Zeus Z80 or any other Z80 assembler and emulator
- Basic knowledge of Z80 instructions, registers, and memory addressing
- Familiarity with assembly programming concepts such as loops, conditionals, and subroutines

## 🚀 Running the programs

### Option 1: Using Zeus Z80 Assembler (Windows)

1. Open Zeus Z80 IDE.
2. Load your `.asm` file via `File > Open`.
3. Click ResetZ80, then Assemble and then RUN. Once you are done hit WAIT. 
4. Run the program on the integrated emulator or export the binary for your preferred Z80 emulator.

### Option 2: Using command-line assemblers (e.g., SPASM)

1. Open terminal in the repository folder.
2. Compile the `.asm` file:
   `spasm -T program.asm program.bin`
3. Load `program.bin` into your Z80 emulator.

## 📚 Learning goals

- Master working with registers HL, DE, BC, and flags
- Implement loops and conditional jumps effectively
- Handle strings and arrays in memory with pointers
- Write clean, well-commented, and modular assembly code
- Develop debugging skills through memory inspection and step execution

---

Feel free to fork, star ⭐, and contribute improvements or new exercises!
