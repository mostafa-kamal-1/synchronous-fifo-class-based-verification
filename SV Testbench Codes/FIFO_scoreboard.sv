package FIFO_scoreboard_pkg;
  import FIFO_transaction_pkg::*;
  import shared_pkg::*;

  class FIFO_scoreboard;
  
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);

    bit [FIFO_WIDTH-1:0] data_out_ref;
    bit wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
    bit [max_fifo_addr:0] count;

    bit [FIFO_WIDTH-1:0] mem_queue[$]; 

    FIFO_transaction fifo_txn = new();
    //function to check DUT against REF.
    function void check_data(input FIFO_transaction fifo_txn);
      bit [6:0] ref_flags, dut_flags;

      reference_model(fifo_txn);

 
      ref_flags = {full_ref, empty_ref, almostfull_ref, almostempty_ref, overflow_ref, underflow_ref, wr_ack_ref};
      dut_flags = {fifo_txn.full, fifo_txn.empty, fifo_txn.almostfull, fifo_txn.almostempty, fifo_txn.overflow, fifo_txn.underflow, fifo_txn.wr_ack};

      if (fifo_txn.data_out !== data_out_ref) begin
        error_count++;
        $display("time:%0t Error: Data out mismatch. Expected: %0h, Got: %0h", $time, data_out_ref, fifo_txn.data_out);
      end else begin
        correct_count++;
      end

      if (ref_flags !== dut_flags) begin
        error_count++;
        $display("time:%0t Error: Flags mismatch. Expected: %b, Got: %b", $time, ref_flags, dut_flags);
      end else begin
        correct_count++;
      end
    endfunction
    
    //reference model
    function void reference_model(input FIFO_transaction fifo_txn);
      fork
        begin // write
          if (!fifo_txn.rst_n) begin
            wr_ack_ref = 0;
            overflow_ref = 0;
            full_ref = 0;
            almostfull_ref = 0;
            mem_queue.delete(); 
          end else if (fifo_txn.wr_en && count < FIFO_DEPTH) begin
            wr_ack_ref = 1;
            mem_queue.push_back(fifo_txn.data_in); 
          end else begin
            wr_ack_ref = 0;
            overflow_ref = (full_ref && fifo_txn.wr_en) ? 1 : 0;
          end
        end

        begin //read
          if (!fifo_txn.rst_n) begin
            empty_ref = 1;
            underflow_ref = 0;
            almostempty_ref = 0;
          end else if (fifo_txn.rd_en && count != 0) begin
            data_out_ref = mem_queue.pop_front(); 
          end else begin
            underflow_ref = (empty_ref && fifo_txn.rd_en) ? 1 : 0;
          end
        end
      join

      if (!fifo_txn.rst_n) begin // count
        count = 0;
      end else if (fifo_txn.wr_en && !fifo_txn.rd_en && !full_ref) begin
        count = count + 1;  
      end else if (!fifo_txn.wr_en && fifo_txn.rd_en && !empty_ref) begin
        count = count - 1; 
      end else if (fifo_txn.wr_en && fifo_txn.rd_en && full_ref) begin
        count = count - 1;  
      end else if (fifo_txn.wr_en && fifo_txn.rd_en && empty_ref) begin
        count = count + 1;  
      end
       //flags
      full_ref = (count == FIFO_DEPTH) ? 1 : 0;
      empty_ref = (count == 0) ? 1 : 0;
      almostfull_ref = (count == FIFO_DEPTH - 1) ? 1 : 0;
      almostempty_ref = (count == 1) ? 1 : 0;
    endfunction
  endclass
endpackage
