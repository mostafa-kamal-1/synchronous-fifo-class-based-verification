module FIFO_top();
bit clk;

// clock generation
initial begin
    clk = 0;
forever begin
    #5 clk = ~clk;
end
end
//instantiate interface and design
FIFO_if  f_if(clk);
FIFO DUT(f_if);
FIFO_tb TEST(f_if);
FIFO_monitor MONITOR(f_if);
endmodule
