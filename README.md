# Z80 Assembly Practice

This repository contains educational Z80 assembly programs developed as part of my learning process.  
Each project focuses on a specific concept or exercise, such as string manipulation, loops, memory addressing, or conditional logic.

## 💾 Structure

- Each `.ASM` file is self-contained and follows a skeleton-style format.
- Programs are written to be tested in common Z80 emulators such as SPASM, z80pack, Zeus Z80, or any other compatible environment.
- Source code is commented in English for clarity.

## 🧪 Exercises Included

- Sum of natural numbers until a limit is reached
- Transform uppercase names into lowercase and remove spaces
- Insert formatted characters into memory arrays
- Count characters, vowels, or specific symbols in a string
- Store positions of matches in memory
- Memory manipulation using direct and indirect addressing

## ⚙️ Requirements

- Zeus Z80 or any other z80 emulator/assembler
- Basic knowledge of Z80 instruction set and memory addressing

## 🚀 Running the programs

### Option 1: Using SPASM

1. Open terminal in the repository folder.
2. Compile the `.ASM` file:
   `spasm -T program.asm program.bin`
3. Load `program.bin` into your Z80 emulator.

### Option 2: Using Zeus Z80 Assembler (Windows)

1. Open Zeus Z80 IDE.
2. Load your `.ASM` file via `File > Open`.
3. Compile with `F9` or `Assemble > Assemble`.
4. If a test environment is configured, press `F10` to launch it.
5. Alternatively, load the output `.bin` manually into your emulator.

## 📚 Learning goals

- Understand how Z80 registers work
- Practice loops, branches, and calls
- Improve debugging skills through memory inspection
- Build solid habits for structured and commented assembly code

---

Feel free to fork and contribute!
