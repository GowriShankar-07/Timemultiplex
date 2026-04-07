# 🖥️ Multiplexed 4-Digit Seven-Segment Display on FPGA

A VHDL implementation of a time-multiplexed 4-digit seven-segment display that counts from **0000 to 9999** on a **Digilent Basys 2 (Spartan-3)** FPGA board.

---

## 📸 Hardware Demo

![Basys2 running the counter](hardware_result.jpg)

*The display showing live count on the Basys 2 FPGA board*

---

## 🧠 How It Works

Driving 4 seven-segment displays simultaneously would require 4×7 = **28 segment pins**. Instead, this design uses **time-division multiplexing** — only one digit is active at any instant, but they cycle so fast (~2.5 kHz) that the human eye perceives all four as continuously lit.

### Signal Flow

```
50 MHz CLK
    │
    ▼
┌─────────────┐     1 Hz      ┌──────────────────┐    16-bit BCD
│  Clock      │─────────────▶│  4-Digit BCD     │──────────────┐
│  Divider    │               │  Counter (0–9999)│              │
└─────────────┘               └──────────────────┘              │
    │                                                            ▼
    │  ~2.5 kHz         ┌──────────────────────────────────────────────┐
    └──────────────────▶│  Digit Selector (2-bit MUX)                  │
                        │  Picks one of 4 BCD digits per cycle         │
                        └───────────────────────┬──────────────────────┘
                                                │  4-bit BCD
                                                ▼
                                   ┌────────────────────────┐
                                   │  BCD-to-7Seg Decoder   │
                                   │  (active-low outputs)  │
                                   └───────────┬────────────┘
                                               │
                                    seg[6:0] ──┘   digit_en[3:0] ──▶ Anodes
                                               └──────────────────▶ Segments
```

---

## 🗂️ Project Structure

```
├── src/
│   ├── display_with_counter.vhd   # Top-level module
│   ├── clk_div.vhd                # Clock divider (50MHz → 1Hz & 2.5kHz)
│   ├── counter_4digit.vhd         # Structural 4-digit BCD counter
│   ├── mod10_counter.vhd          # Single decade (mod-10) counter
│   ├── T_FF_PC.vhd                # T Flip-Flop with preset & clear
│   ├── and_gate.vhd               # Basic AND gate
│   └── or_gate.vhd                # Basic OR gate
├── constraints/
│   └── basys2.ucf                 # Pin constraints for Basys 2
├── testbench/
│   └── counter4digit_tb.vhd       # Testbench for BCD counter
├── sim/
│   └── simulation_waveform.png    # Xilinx ISE simulation output
├── assets/
│   └── hardware_result.jpg        # Photo of board running the design
└── README.md
```

---

## ⚙️ Module Breakdown

| Module | Type | Description |
|---|---|---|
| `display_with_counter` | Behavioral | Top-level; integrates all submodules |
| `clk_div` | Behavioral | Divides 50 MHz → ~1 Hz (counter) and ~2.5 kHz (mux) |
| `counter_4digit` | Structural | Chains four mod-10 counters for BCD output |
| `mod10_counter` | Structural | Decade counter using T flip-flops and logic gates |
| `T_FF_PC` | - | T Flip-Flop primitive with preset and clear |

---

## 📌 Pin Constraints (Basys 2 UCF)

```ucf
NET seg[0] LOC="M12";   # Segment a
NET seg[1] LOC="L13";   # Segment b
NET seg[2] LOC="P12";   # Segment c
NET seg[3] LOC="N11";   # Segment d
NET seg[4] LOC="N14";   # Segment e
NET seg[5] LOC="H12";   # Segment f
NET seg[6] LOC="L14";   # Segment g
NET Clk    LOC="B8";    # 50 MHz onboard clock
NET Clr    LOC="G12";   # Reset button
NET digit_en[0] LOC="F12";
NET digit_en[1] LOC="J12";
NET digit_en[2] LOC="M13";
NET digit_en[3] LOC="K14";
```

---

## 🔬 Simulation

Simulated using **Xilinx ISE Design Suite**. The waveform confirms:
- Correct sequential activation of `digit_en` (one-hot, active-low)
- Correct `seg[6:0]` output per digit
- BCD count incrementing properly

![Simulation waveform](sim/simulation_waveform.png)

---

## 🛠️ Tools & Hardware

| Item | Details |
|---|---|
| FPGA Board | Digilent Basys 2 (Xilinx Spartan-3) |
| Clock | 50 MHz on-board crystal oscillator |
| EDA Tool | Xilinx ISE Design Suite |
| HDL | VHDL (IEEE Std 1076) |
| Display | Common-anode 4-digit seven-segment |

---

## 🚀 How to Run

1. Clone this repo and open **Xilinx ISE Design Suite**
2. Create a new project targeting **Spartan-3 / XC3S100E** (Basys 2)
3. Add all `.vhd` files from `src/` to the project
4. Add `constraints/basys2.ucf` as the constraints file
5. Run **Synthesize → Implement → Generate Programming File**
6. Program the Basys 2 board using iMPACT
7. Press the reset button (Clr) to start the counter from 0000

To simulate:
- Add `testbench/counter4digit_tb.vhd` and run the **ISim** behavioral simulation

---

## 💡 Key Concepts Demonstrated

- **Time-division multiplexing** to minimize I/O pin usage
- **Structural VHDL design** — hierarchical component instantiation
- **BCD counting** using chained mod-10 counters
- **Clock domain management** — separate clocks for counting and display refresh
- **Active-low logic** for common-anode seven-segment displays
- **UCF constraint mapping** for FPGA pin assignment

---

## 📚 References

- Pong P. Chu, *FPGA Prototyping by VHDL Examples*, Wiley, 2017
- Douglas L. Perry, *VHDL: Programming by Example*, McGraw-Hill
- [fpga4student.com](https://www.fpga4student.com) — Seven Segment Display Tutorials
- Xilinx ISE Design Suite Documentation

---

## 👥 Team

| Name | Register No. |
|---|---|
| Akshaya VV | 3122233001005 |
| Deepak Sakthivel | 3122233001017 |
| Gayathri M | 3122233001029 |
| Gowri Shankar Narayanan | 3122233001034 |

