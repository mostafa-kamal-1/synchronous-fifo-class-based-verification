package FIFO_transaction_pkg;

class FIFO_transaction;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
rand logic rst_n,wr_en, rd_en;
rand logic [FIFO_WIDTH-1:0] data_in;
logic [FIFO_WIDTH-1:0] data_out;
logic full, empty, almostfull, almostempty, underflow, wr_ack, overflow;

int RD_EN_ON_DIST = 30;
int WR_EN_ON_DIST = 70;

constraint rst_dist{rst_n dist {0:=1, 1:=99};} //rst
constraint write_enable_dist { wr_en dist {0 := 100 - WR_EN_ON_DIST, 1 := WR_EN_ON_DIST}; } //write
constraint read_enable_dist { rd_en dist {0 := 100 - RD_EN_ON_DIST, 1 := RD_EN_ON_DIST}; } //read

endclass
    
endpackage
