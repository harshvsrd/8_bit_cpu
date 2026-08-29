# 8-Bit Custom CPU in Verilog 💻⚙️

A custom 8-bit Central Processing Unit built in Verilog. This repository documents the evolution of the CPU from a basic single-cycle architecture to a high-throughput 3-stage pipelined design. 

**Development Note:** The original single-cycle datapath, custom Instruction Set Architecture (ISA), and testbenches were designed and built entirely from scratch by me. The 3-stage pipelined architecture was conceptually modeled by me and refactored from the original codebase using AI to assist with structural partitioning and hazard logic integration.

## 📁 Repository Structure
* `/single_cycle/` - The original CPU where instructions decode and execute in one clock cycle.
* `/pipelined/` - The upgraded 3-stage pipelined CPU featuring a forwarding unit and control hazard flushing.

## 🧠 Instruction Set Architecture (ISA)
*(Common across both architectures)*

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

## 🛑 Version 1: Single-Cycle Architecture
Located in `/single_cycle/`. Executed via combinational control decoding with register updates on the positive clock edge. 

### Hand-Drawn Hardware Planning
The architecture was mapped out structurally before writing the RTL. Below is the initial logic flow and the detailed port-connection mapping used to wire the Control Unit, ALU, and Memories.

![Logic Architecture](single_cycle/logic_architecture.jpeg)
*High-level datapath and structural block planning.*

![Port Connections](single_cycle/port_conections_architecture.jpeg)
*Detailed module port mappings and control signal routing.*

### Simulation & Waveforms
Simulated using Icarus Verilog and EPWave. The waveform below demonstrates execution of a 16-instruction test suite verifying memory loads, ALU operations, flag generation, branching, and system halt.

![CPU Simulation Waveform](single_cycle/ep_wave.png)
this shows results for multiplication of 2 nos algorithm 

### Synthesis & Gate-Level Utilization
The RTL design was synthesized using **Yosys 0.37** to analyze gate-level cell counts and datapath complexity.

![Yosys Synthesis Report](single_cycle/synthesis.png)

**Resource Summary:**
* **Total Cells (Gate Netlist Size):** 615
* Sequential Logic / Registers: 88
* Datapath Routing MUXes: 106
* Combinational / ALU Logic: ~416

---

## ⚡ Version 2: 3-Stage Pipelined Architecture
Located in `/pipelined/`. The datapath was partitioned into three discrete stages to significantly shorten the critical path and boost maximum clock frequency ($F_{max}$).

### Why 3 Stages Instead of 5?
In standard computer architecture, a 5-stage pipeline is common. However, pipeline speed is bottlenecked by its slowest stage—typically memory access. If an SRAM memory read/write takes 10ns, the clock period must be at least 10ns. Because this custom 8-bit ALU and opcode decoder are extremely fast (e.g., 2–3ns total), artificially splitting Decode and Execute into separate stages would not increase the overall CPU frequency. Grouping them into a single 3-stage pipeline perfectly balances the combinational delay against the memory bottlenecks.

### Architecture Diagram
Below is the datapath flow showing the structural pipeline registers (`IF/ID`, `EX/MEM`), the Forwarding Unit, and the feedback flush loop for control hazards.

![Pipelined Architecture Diagram](Instruction-2026-08-26-132135.png)

### Hazard Management
* **Data Hazards (RAW) & The Forwarding Unit:** Pipelining creates Read-After-Write hazards (e.g., Instruction 2 needs a value Instruction 1 hasn't written to the Register File yet). Instead of stalling the CPU, a custom **Forwarding Unit** snoops the `EX/MEM` pipeline register. If it detects a RAW hazard, it intercepts the freshly calculated data and routes it directly into the ALU bypass muxes, overriding the stale Register File data.
* **Control Hazards:** Unconditional and conditional jumps trigger a `flush` signal to the `IF/ID` register, scrubbing the incorrect instruction fetched during the branch calculation.

---

## 🛠️ How to Run

### Run on EDA Playground
1. Open the project on EDA Playground.
2. Ensure **Icarus Verilog** is selected as the simulator.
3. Check **Open EPWave after run**.
4. Click **Run** to execute the testbench.

### Run Locally
Navigate to the directory of the version you want to run (`cd single_cycle` or `cd pipelined`), then execute:
```bash
iverilog -o cpu_sim tb.v design.sv
vvp cpu_sim
