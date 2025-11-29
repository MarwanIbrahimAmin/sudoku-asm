# 🎮 Sudoku Puzzle Game

**An Interactive Sudoku Game Written in 8086 Assembly Language (TASM)**

A fully functional Sudoku implementation in x86 16-bit assembly with real-time input validation, a three-strike error system, and dynamic board rendering for DOS/DOSBox environments.

---

## 👥 Team Members

- **Marwan Ibrahim Amin Ibrahim**
- **Moataz Ibrahim Elsaied Saleh**
- **Mariam Mohamed Hassan Yassine**

---

## ✨ Features

- Interactive Sudoku gameplay with 9×9 grid display
- Real-time input validation against embedded solution
- 3-strike error system with automatic game reset
- Occupied field detection (prevents overwriting pre-filled cells)
- Win condition check (all cells filled → victory)
- Backtrack navigation ('0' to return to previous input stage)
- Formatted board rendering with section dividers

---

## 🔧 Core Concepts

- **16-bit x86 Real-Mode Architecture** – Segment:offset addressing
- **Index Calculation** – Converting 2D board coordinates to 1D array offset: `SI = (row × 9) + column`
- **Parallel Array Validation** – Comparing `board[SI]` against `sol[SI]` for instant feedback
- **State Machine Pattern** – Sequential input phases (row → column → value)
- **Conditional Branching** – Game flow control via JE, JNE, JL jumps
- **BIOS Interrupts** – INT 21h for keyboard input (AH=1) and string output (AH=9)

---

## 📊 Data Structures

| Array | Size | Purpose |
|-------|------|---------|
| `board[81]` | 81 bytes | Current puzzle state (0 = empty) |
| `orig_board[81]` | 81 bytes | Initial puzzle snapshot (for reset) |
| `sol[81]` | 81 bytes | Complete solution (validation reference) |
| `mistakes` | 1 byte | Error counter (0-3) |

**Layout:** Row-major order – cell at (row, col) is stored at offset `(row × 9) + col`

---

## 🎮 Program Flow

1. **Initialize** – Set `mistakes = 0`, restore `board` from `orig_board`
2. **Display** – Render 9×9 grid with column labels and section dividers
3. **Check Win** – Scan all 81 cells; if any = 0, proceed to input; otherwise victory
4. **Input Sequence:**
   - Ask for row (1-9) [0 = exit]
   - Ask for column (1-9) [0 = back]
   - Check if cell is empty; if occupied, return to display
   - Ask for value (1-9) [0 = back]
5. **Validate** – Compare `sol[SI]` with user input
   - **Correct** – Update `board[SI]`, show success, loop
   - **Incorrect** – Increment `mistakes`, show error
     - If `mistakes < 3` – loop back to display
     - If `mistakes = 3` – display game-over, reset game
6. **Win** – All cells filled → display "YOU WON!" and exit

---

## ✅ Validation & Error Handling

| Check | Action |
|-------|--------|
| **Invalid row/col input** | No validation; assumes user enters 1-9 |
| **Occupied field** | Before value input, verify `board[SI] == 0` |
| **Wrong answer** | Increment `mistakes`; loop on mismatch |
| **3 mistakes reached** | Display game-over, wait for keypress, reset |
| **All cells filled** | No zeros in array → victory |

---

## 🎮 Controls

| Input | Action |
|-------|--------|
| `1-9` (at row prompt) | Select row |
| `0` (at row prompt) | Exit game |
| `1-9` (at col prompt) | Select column |
| `0` (at col prompt) | Back to row selection |
| `1-9` (at val prompt) | Enter value |
| `0` (at val prompt) | Back to column selection |

---

## 🛠️ Build & Run

### Compile
```bash
tasm /m5 sudoku.asm sudoku.obj
tlink sudoku.obj -o sudoku.exe
```

### Execute
```bash
sudoku.exe          # On DOS/DOSBox
```

### DOSBox Setup
```bash
mount c: /path/to/project
c:
sudoku.exe
```

---

## 📁 File Structure

```
sudoku-project/
├── sudoku.asm       # Main source code (~380 instructions)
├── sudoku.obj       # Object file (generated)
├── sudoku.exe       # Executable (generated)
└── README.md        # Documentation
```

---

## ⚠️ Limitations

- Single hard-coded puzzle (no difficulty levels or puzzle selection)
- No input validation for invalid characters (assumes 1-9 only)
- No hint system or undo functionality
- Monochrome text-only display
- No save/load game feature
- No statistics tracking (time, move count)

---

## 🚀 Future Enhancements

- Multiple puzzle levels with difficulty selection
- Hint system (reveal correct cell)
- Undo/move history functionality
- Statistics tracking (time, accuracy, move count)
- Pause/resume capability
- Input validation with error messages
- Color support and improved UI
- Save/load game state to disk

---

## 📜 License

Educational use. Original implementation by Marwan, Moataz, and Mariam.

---

## 📊 Project Status

| Component | Status |
|-----------|--------|
| Core game loop | ✅ Complete |
| Board display & rendering | ✅ Complete |
| Input system (row/col/value) | ✅ Complete |
| Solution validation | ✅ Complete |
| 3-strike error system | ✅ Complete |
| Win/lose conditions | ✅ Complete |
| Occupied field detection | ✅ Complete |
| Game reset on lose | ✅ Complete |
| Build & execution | ✅ Complete |
| Multi-puzzle support | ❌ Not implemented |
| Input range validation | ⚠️ Partial |
| Statistics tracking | ❌ Not implemented |
| Save/load game | ❌ Not implemented |
