<img width="409" height="531" alt="{27198618-16A0-4AE1-82E1-557ED3540862}" src="https://github.com/user-attachments/assets/5805fccc-1509-43be-a6db-20f27015f63f" /># 8-Bit Custom Single-Cycle CPU in Verilog 💻⚙️

A custom 8-bit Central Processing Unit built from scratch in Verilog using a single-cycle RISC architecture. The CPU executes instructions in a single clock cycle through combinational decoding and execution, featuring a custom Instruction Set Architecture (ISA), onboard Data RAM, Instruction ROM, and an integrated ALU.

## Purpose
to learn by building from scratch, this cpu has drawbacks which will be improved in future versions


## 🚀 Features
* **Single-Cycle Datapath:** Executed via combinational control decoding with register updates on the positive clock edge.
* **8-Bit ALU:** Hardware support for ADD, SUB, OR, AND, XOR, SHL, SHR, and PASS operations with Carry/Borrow and Zero flags.
* **Memory System:** Integrated 256-byte Instruction Memory (ROM) and 256-byte Data Memory (RAM).
* **Branching Logic:** Supports unconditional jumps (`JMP`) and zero-flag conditional jumps (`JMPE`).
* **External I/O:** Custom `LOAD EXT` instruction to pull live 8-bit hardware input into CPU registers.

## 🧠 Instruction Set Architecture (ISA)

| Opcode | Instruction | Description |
| :--- | :--- | :--- |
| `0000` | **MOVE** | Moves data between registers (`A`, `B`, `RES`) based on operand bits. |
| `0001` | **ADD** | `ALU = A + B` |
| `0010` | **SUB** | `ALU = A - B` (Updates Zero and Carry/Borrow flags) |
| `0011` | **OR** | `ALU = A | B` |
| `0100` | **AND** | `ALU = A & B` |
| `0101` | **XOR** | `ALU = A ^ B` |
| `0110` | **SHL** | Logical Shift Left (`A << 1`) |
| `0111` | **SHR** | Logical Shift Right (`A >> 1`) |
| `1000` | **PASS A** | Passes Register A through the ALU unchanged. |
| `1001` | **LOAD** | Loads 8-bit data from Data RAM into Register A. |
| `1010` | **STORE** | Stores Register A into Data RAM at target address. |
| `1011` | **JMP** | Unconditional jump to specified PC address. |
| `1100` | **JMPE** | Jump to address if ALU `Zero` flag is high (`1`). |
| `1101` | **LOAD EXT** | Loads 8-bit data from external input pin into Register A. |
| `1111` | **HALT** | Stops program execution. |

---

## 📊 Simulation & Waveforms
Simulated using Icarus Verilog and EPWave. The waveform below demonstrates execution of a 16-instruction test suite verifying memory loads, ALU operations, flag generation, branching, and system halt.

![CPU Simulation Waveform]({23B33AC0-0D43-4754-AB5A-357B201BDE17}.png)
*(Note: Signals are displayed in Hexadecimal. e.g., `63` hex = `99` decimal)*

---
## 📈 Synthesis & Gate-Level Utilization

The RTL design was synthesized using **Yosys 0.37** to analyze gate-level cell counts and datapath complexity.

### Resource Summary
| Cell Type | Function | Count |
| :--- | :--- | :--- |
| **Total Cells** | **Gate Netlist Size** | **615** |
| `$_DFFE_PP_` / `$_SDFFCE_` | Sequential Logic / Registers | 88 |
| `$_MUX_` | Datapath Routing | 106 |
| Logic Gates (`AND`, `OR`, `XOR`, etc.) | Combinational / ALU Logic | ~416 |

### Yosys Output
![Yosys Synthesis Report](docs/synthesis_screenshot.png)

## 🔮 Future Improvements

* **3-Stage Pipelining (Highest Priority):** Restructure the single-cycle datapath into a 3-stage pipeline (**Fetch → Execute → Writeback**) using pipeline registers (`IF/EX`, `EX/WB`) to significantly shorten the critical path and boost clock frequency.
* **Data Forwarding & Hazard Unit:** Add hazard detection and bypassing logic to resolve Read-After-Write (RAW) register dependencies in the pipelined core without stalling.
* **Expanded Register File:** Expand beyond accumulator registers (`A`, `B`, `RES`) into a general-purpose Register File (R0–R7).
* **Stack Pointer & Subroutines:** Add a hardware Stack Pointer (SP) and call/return instructions (`CALL`, `RET`) to support nested functions.

---

## 🛠️ How to Run

### Run on EDA Playground
1. Open the project on EDA Playground: **https://www.edaplayground.com/x/gqGv**
2. Ensure **Icarus Verilog** is selected as the simulator.
3. Check **Open EPWave after run**.
4. Click **Run** to execute the testbench.

### Run Locally
```bash
iverilog -o cpu_sim tb.v design.v
vvp cpu_sim
