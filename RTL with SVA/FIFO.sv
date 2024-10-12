module FIFO(FIFO_if.DUT f_if);
  localparam max_fifo_addr = $clog2(f_if.FIFO_DEPTH);

  reg [f_if.FIFO_WIDTH-1:0] mem [f_if.FIFO_DEPTH-1:0];
  reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
  reg [max_fifo_addr:0] count;

 `ifdef SIM
// reset
always_comb begin
if(!f_if.rst_n)
reset: assert final(!wr_ptr && !rd_ptr && !count);
end
//full
always_comb begin
if(f_if.rst_n && (count== f_if.FIFO_DEPTH))
one_full: assert final(f_if.full);
//almostfull
if(f_if.rst_n && (count== f_if.FIFO_DEPTH-1))
two_almostfull: assert final(f_if.almostfull);
//empty
if(f_if.rst_n && (count== 0))
three_empty: assert final(f_if.empty);
//almostempty
if(f_if.rst_n && (count== 1))
four_almostempty: assert final(f_if.almostempty);
end
//overflow
 property five;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.full && f_if.wr_en) |=> f_if.overflow;
 endproperty
 overflow_flag_assert: assert property(five);
 overflow_flag_cover: cover property(five);
//underflow
 property six;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.empty && f_if.rd_en) |=> f_if.underflow;
 endproperty
 underflow_flag_assert: assert property(six);
 underflow_flag_cover: cover property(six);
//wr_ack
 property seven;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.wr_en && count< f_if.FIFO_DEPTH) |=> f_if.wr_ack;
 endproperty
 wr_ack_flag_assert: assert property(seven);
 wr_ack_flag_cover: cover property(seven);
//write
 property eight;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.wr_en && !f_if.rd_en && !f_if.full) |=> $past(count+ 1'b1);
 endproperty
 write_assert: assert property(eight);
 write_cover: cover property(eight);
//read
 property nine;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (!f_if.wr_en && f_if.rd_en && !f_if.empty) |=> (count+ 1'b1);
 endproperty
 read_assert: assert property(nine);
 read_cover: cover property(nine);
//write priority
 property ten;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.wr_en && f_if.rd_en && f_if.full) |=> (count+ 1'b1);
 endproperty
 write_pri_assert: assert property(ten);
 write_pri_cover: cover property(ten);
//read priority
 property eleven;
 @(posedge f_if.clk) disable iff(!f_if.rst_n) (f_if.wr_en && f_if.rd_en && f_if.empty) |=> $past(count+ 1'b1);
 endproperty
 read_pri_assert: assert property(eleven);
 read_pri_cover: cover property(eleven);
`endif

  //write operation
  always @(posedge f_if.clk or negedge f_if.rst_n) begin
    if (!f_if.rst_n) begin
      wr_ptr <= 0;
      f_if.overflow <= 0; // reset overflow signal
      f_if.wr_ack <= 0; // reset wr_ack signal
    end
    else if (f_if.wr_en && count < f_if.FIFO_DEPTH) begin
      mem[wr_ptr] <= f_if.data_in;
      f_if.wr_ack <= 1;
      wr_ptr <= wr_ptr + 1;
    end
    else begin 
      f_if.wr_ack <= 0;
      if (f_if.full && f_if.wr_en)
        f_if.overflow <= 1;
      else
        f_if.overflow <= 0;
    end
  end
  
  //read operation
  always @(posedge f_if.clk or negedge f_if.rst_n) begin
    if (!f_if.rst_n) begin
      rd_ptr <= 0; 
      f_if.underflow <= 0; // reset underflow signal
    end
    else if (f_if.rd_en && count != 0) begin
      f_if.data_out <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
    end
    else begin
      if (f_if.empty && f_if.rd_en)  // make underflow signal sequential
        f_if.underflow <= 1;
      else
        f_if.underflow <= 0;
    end
  end
  // count operations
  always @(posedge f_if.clk or negedge f_if.rst_n) begin
    if (!f_if.rst_n) begin
      count <= 0;
    end
    else begin
      if ({f_if.wr_en, f_if.rd_en} == 2'b10 && !f_if.full) 
        count <= count + 1;
      else if ({f_if.wr_en, f_if.rd_en} == 2'b01 && !f_if.empty)
        count <= count - 1;
      else if ({f_if.wr_en, f_if.rd_en} == 2'b11 && f_if.full) // add unhandled case
        count <= count - 1;
      else if ({f_if.wr_en, f_if.rd_en} == 2'b11 && f_if.empty) // add unhandled case
        count <= count + 1;
    end
  end
  // flags operations
  assign f_if.full = (count == f_if.FIFO_DEPTH) ? 1 : 0;
  assign f_if.empty = (count == 0) ? 1 : 0;
  assign f_if.almostfull = (count == f_if.FIFO_DEPTH-1) ? 1 : 0; // modify the almostfull signal to match design specs
  assign f_if.almostempty = (count == 1) ? 1 : 0;

endmodule
