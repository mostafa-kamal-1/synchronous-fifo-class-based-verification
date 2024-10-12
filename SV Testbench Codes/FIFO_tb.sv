import FIFO_transaction_pkg::*;
import shared_pkg::*;
module FIFO_tb (FIFO_if.TEST f_if);
FIFO_transaction fifo_txn = new();

initial begin
    f_if.data_in = 0; f_if.wr_en = 0; f_if.rd_en = 0;
    assert_reset();
    repeat(100000) begin
        assert(fifo_txn.randomize());
        f_if.rst_n = fifo_txn.rst_n;
        f_if.wr_en = fifo_txn.wr_en;
        f_if.rd_en = fifo_txn.rd_en;
        f_if.data_in = fifo_txn.data_in;
        @(negedge f_if.clk);
    end
    test_finished = 1; // singnal to be asserted when test finished
end

task assert_reset();
    f_if.rst_n = 0;
    @(negedge f_if.clk);
    f_if.rst_n = 1;
endtask
endmodule

