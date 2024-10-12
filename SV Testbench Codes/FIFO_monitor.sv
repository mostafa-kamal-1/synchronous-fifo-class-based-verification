import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
import shared_pkg::*;
module FIFO_monitor (FIFO_if.MONITOR f_if);

  FIFO_transaction fifo_txn = new();;
  FIFO_scoreboard fifo_scoreboard = new();;
  FIFO_coverage fifo_coverage = new();;

  initial begin
  forever begin
    @(negedge f_if.clk);
    fifo_txn.rst_n = f_if.rst_n;
    fifo_txn.data_in = f_if.data_in;
    fifo_txn.wr_en = f_if.wr_en;
    fifo_txn.rd_en = f_if.rd_en;
    fifo_txn.data_out = f_if.data_out;
    fifo_txn.empty = f_if.empty;
    fifo_txn.full = f_if.full;
    fifo_txn.almostfull = f_if.almostfull;
    fifo_txn.almostempty = f_if.almostempty;
    fifo_txn.wr_ack = f_if.wr_ack;
    fifo_txn.overflow = f_if.overflow;
    fifo_txn.underflow = f_if.underflow;

  fork
    begin
      fifo_coverage.sample_data(fifo_txn); 
    end

    begin
      @(posedge f_if.clk);
      #2;
      fifo_scoreboard.check_data(fifo_txn); 
    end
  join
  if (test_finished) begin
  $display("Test finished!");
  $display("Correct Count: %0d",correct_count);
  $display("Error Count: %0d", error_count);
  $stop;
  end
  end
  end
endmodule