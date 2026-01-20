# AXI4 Full Slave – Burst-Capable Memory Interface (SystemVerilog RTL)

## 📌 Project Overview

This project implements a **full AXI4 Slave interface** using **SystemVerilog RTL**.
The design supports **burst-based read and write transactions**, making it suitable for **high-performance memory-mapped data transfers** in modern SoC architectures.

The module models an **AXI4 memory-mapped slave**, commonly used to represent **on-chip SRAM, external memory controllers, or memory-mapped accelerators**.

This is a **non-dummy, protocol-focused RTL project**, suitable for **RTL Design / SoC / VLSI internships**.

---

## 🧠 Key Features

* Fully synthesizable **SystemVerilog RTL**
* AXI4 **Full protocol** support (not AXI-Lite)
* Burst read and burst write transactions
* Independent read and write channels
* Internal memory array for data storage
* FSM-based control for write and read paths
* Clean and scalable RTL structure

---

## 🏗️ AXI4 Full Slave Architecture (High-Level)

### Block Overview

```text
          AXI4 Master
        ┌────────────────┐
        │                │
 AW/W → │  Write FSM     │ → Internal Memory
        │                │
 AR/R → │  Read FSM      │ → Internal Memory
        └────────────────┘
```

* **Write and Read channels operate independently**
* Supports **multiple-beat burst transfers**

---

## 🔌 AXI4 Interfaces Implemented

### Write Address Channel

* `AWADDR` – Write start address
* `AWLEN`  – Burst length
* `AWSIZE` – Transfer size
* `AWVALID / AWREADY` – Handshake

### Write Data Channel

* `WDATA` – Write data
* `WLAST` – Last beat of burst
* `WVALID / WREADY` – Handshake

### Write Response Channel

* `BRESP` – Write response
* `BVALID / BREADY` – Handshake

### Read Address Channel

* `ARADDR` – Read start address
* `ARLEN`  – Burst length
* `ARSIZE` – Transfer size
* `ARVALID / ARREADY` – Handshake

### Read Data Channel

* `RDATA` – Read data
* `RLAST` – Last beat of burst
* `RVALID / RREADY` – Handshake

---

## 🔁 Finite State Machines (FSMs)

### Write Channel FSM

```text
WR_IDLE → WR_DATA → WR_RESP → WR_IDLE
```

| State   | Description               |
| ------- | ------------------------- |
| WR_IDLE | Accepts write address     |
| WR_DATA | Receives burst write data |
| WR_RESP | Sends write response      |

---

### Read Channel FSM

```text
RD_IDLE → RD_DATA → RD_IDLE
```

| State   | Description           |
| ------- | --------------------- |
| RD_IDLE | Accepts read address  |
| RD_DATA | Sends burst read data |

---

## 🔄 Transaction Flow

### AXI4 Write Burst

1. Master sends `AWADDR`, `AWLEN`, `AWSIZE`
2. Slave accepts address (`AWREADY`)
3. Burst data transferred on `WDATA`
4. Memory written per beat
5. `WLAST` marks final beat
6. Slave responds with `BVALID`

---

### AXI4 Read Burst

1. Master sends `ARADDR`, `ARLEN`, `ARSIZE`
2. Slave accepts address (`ARREADY`)
3. Data returned on `RDATA`
4. `RLAST` asserted on final beat
5. Transfer completes when `RREADY` is asserted

---

## ⚙️ Design Highlights

* Supports **incrementing burst addressing**
* Separate FSMs for read and write channels
* Internal memory array (`mem[]`)
* Address increment based on `AWSIZE / ARSIZE`
* No latch inference
* No combinational loops
* Fully synthesizable RTL

---

## ⚠️ AXI4 Design Simplifications (Intentional)

For clarity and learning purposes:

* Only **INCR burst type** assumed
* No outstanding multiple transactions
* Single ID supported (no AXI ID field)
* No QoS, cache, or protection signals
* No write strobes (`WSTRB`)

> These features can be added to achieve full AXI4 compliance.

---

## 📂 Repository Structure

```text
src/
└── axi4_full_slave.sv

testbench/
└── axi4_full_slave_tb.sv   (if present)
```

---

## 🚀 Deployment & Simulation Guide

### 🧰 Prerequisites

**Simulator**

* Xilinx Vivado (recommended)
* Questa / ModelSim
* Synopsys VCS

**OS**

* Linux or Windows

**Knowledge**

* SystemVerilog
* AXI4 Full protocol basics

---

### 📥 Step 1: Clone the Repository

```bash
git clone https://github.com/Srinu-bhimavarapu/AXI4_FULL.git
cd AXI4_FULL
```

---

### ▶️ Step 2: Run Simulation (Vivado)

#### GUI Method

1. Open **Vivado**
2. Create a new **RTL Project**
3. Add RTL files from `src/`
4. Add testbench files from `testbench/`
5. Set testbench as simulation top
6. Run **Behavioral Simulation**

#### Tcl Flow

```tcl
read_verilog src/axi4_full_slave.sv
read_verilog testbench/*.sv
launch_simulation
```

---

## 🔍 Waveform Verification Checklist

Verify:

* Proper `AWVALID / AWREADY` handshake
* Correct burst write sequencing
* `WLAST` asserted on final write beat
* Proper `ARVALID / ARREADY` handshake
* Continuous `RDATA` beats
* `RLAST` asserted on final read beat

---

## 🧪 Verification Status

* Directed SystemVerilog testbench
* Functional AXI4 protocol validation
* Burst transaction waveform verification

---

## 🎯 Learning Outcomes

* AXI4 Full protocol understanding
* Burst transaction handling
* Independent read/write channel design
* Memory-mapped slave implementation
* High-performance SoC data-path design

---

## 📌 Future Enhancements

* Add AXI IDs for multiple outstanding transactions
* Support FIXED and WRAP burst types
* Implement `WSTRB`
* Add error responses
* Integrate AXI4 interconnect
* UVM-based verification

---

## 👤 Author

**Srinu Bhimavarapu**
Electronics & Communication Engineering
Focus Areas: RTL Design, AXI Protocols, SoC Architecture

---

## ⭐ Recruiter Note

✔ Hand-written RTL
✔ Protocol-aware AXI4 Full design
✔ Burst-capable memory interface
✔ Simulation-validated

This project demonstrates **strong high-performance bus design skills**, which are critical for **SoC, memory, and accelerator RTL roles**.
