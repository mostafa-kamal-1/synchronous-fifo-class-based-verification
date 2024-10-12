# synchronous-fifo-class-based-verification
SystemVerilog - class based verification of a parameterized Synchronous FIFO with code coverage, functional coverage, and assertions.
## Project Overview
This project focuses on the design and verification of a **Synchronous FIFO** (First-In-First-Out) module. The FIFO is designed to efficiently store and retrieve data, with parameters that allow for flexible configurations of data width and memory depth.

## Parameters
- **FIFO_WIDTH**: The width of the data input/output bus (Default: 16 bits).
- **FIFO_DEPTH**: The depth of the memory array (Default: 8 words).

## Ports
| Port Name    | Direction | Description                                                                                                                                   |
|--------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| `data_in`    | Input     | Data input bus used to write data into the FIFO.                                                                                              |
| `wr_en`      | Input     | Write Enable: Writing occurs when this signal is high, if the FIFO is not full.                                                               |
| `rd_en`      | Input     | Read Enable: Reading occurs when this signal is high, if the FIFO is not empty.                                                               |
| `clk`        | Input     | Clock signal.                                                                                                                                 |
| `rst_n`      | Input     | Asynchronous reset (active low).                                                                                                              |
| `data_out`   | Output    | Data output bus for reading from the FIFO.                                                                                                    |
| `full`       | Output    | Full flag: High when FIFO is full, preventing further writes.                                                                                 |
| `almostfull` | Output    | Almost full flag: High when only one more word can be written before the FIFO becomes full.                                                    |
| `empty`      | Output    | Empty flag: High when FIFO is empty, preventing further reads.                                                                                |
| `almostempty`| Output    | Almost empty flag: High when only one more word can be read before the FIFO becomes empty.                                                     |
| `overflow`   | Output    | Overflow flag: Indicates a write attempt when the FIFO is full.                                                                               |
| `underflow`  | Output    | Underflow flag: Indicates a read attempt when the FIFO is empty.                                                                              |
| `wr_ack`     | Output    | Write Acknowledge: High when a write operation is successfully performed.                                                                     |

## Testbench Overview
The testbench generates a clock and interfaces with the FIFO Design Under Test (DUT). It includes modules for resetting the DUT and randomizing the input signals. The key verification components include:

- **Monitor Module**: Samples data from the FIFO interface and passes it to the scoreboard for checking output correctness and to the coverage block for functional coverage collection.
- **Shared Package**: Contains common signals like `error_count`, `correct_count`, and `test_finished` used across the testbench.

## Classes Used in Verification
- **FIFO_transaction**: Holds the data for input/output transactions in the FIFO. Includes randomized constraints for write and read enables.
- **FIFO_scoreboard**: Implements the reference model for checking correctness of the FIFO outputs. Errors and correct outputs are counted and reported.
- **FIFO_coverage**: Collects functional coverage by crossing `wr_en`, `rd_en`, and FIFO output control signals to ensure all combinations of states are covered.

## Verification Plan
The verification includes both dynamic and static checks:
- **Assertions**: Added to the design to monitor output flags (e.g., `full`, `empty`, `almostfull`, etc.) and internal FIFO counters.
- **Functional Coverage**: Crosses `wr_en`, `rd_en`, and output control signals to verify that all FIFO states have been exercised.
- **Scoreboard Checking**: Compares the outputs of the DUT with the reference model outputs and reports mismatches.

## Code Coverage and Simulation
- The design is simulated using **QuestaSim**. Code coverage, functional coverage, and assertion coverage are measured and targeted to reach 100%.
- Conditional compilation (`ifdef SIM`) is used to include assertions only during simulation.

## Running the Simulation
A **Do file** is provided to run the simulation. The testbench performs reset, input randomization, and coverage collection, and generates reports at the end of the simulation.


