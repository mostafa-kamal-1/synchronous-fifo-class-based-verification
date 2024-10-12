package FIFO_coverage_pkg;

    import FIFO_transaction_pkg::*; 

    class FIFO_coverage;

        FIFO_transaction F_cvg_txn = new();


        function void sample_data(input FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            FIFO_cvgr.sample();
        endfunction

 
    covergroup FIFO_cvgr;
    // Coverpoints 
    wr_en_cp:       coverpoint F_cvg_txn.wr_en;
    rd_en_cp:       coverpoint F_cvg_txn.rd_en;
    full_cp:        coverpoint F_cvg_txn.full;
    empty_cp:       coverpoint F_cvg_txn.empty;
    almostfull_cp:  coverpoint F_cvg_txn.almostfull;
    almostempty_cp: coverpoint F_cvg_txn.almostempty;
    overflow_cp:    coverpoint F_cvg_txn.overflow;
    underflow_cp:   coverpoint F_cvg_txn.underflow;
    wr_ack_cp:      coverpoint F_cvg_txn.wr_ack;

    // Cross coverage 
    wr_full:        cross wr_en_cp, full_cp;
    wr_empty:       cross wr_en_cp, empty_cp;
    wr_almostfull:  cross wr_en_cp, almostfull_cp;
    wr_almostempty: cross wr_en_cp, almostempty_cp;
    wr_overflow:    cross wr_en_cp, overflow_cp{
         
        ignore_bins wr_en0_overflow1 = !binsof(wr_en_cp) intersect{1} && binsof(overflow_cp) intersect{1};    
    }
    wr_underflow:   cross wr_en_cp, underflow_cp;
    wr_wr_ack:      cross wr_en_cp, wr_ack_cp{
         
        ignore_bins wr_en0_wr_ack1 = !binsof(wr_en_cp) intersect{1} && binsof(wr_ack_cp) intersect{1};    
    }

    rd_full:        cross rd_en_cp, full_cp{
         
        ignore_bins rd_en1_full1 = binsof(rd_en_cp) intersect{1} && binsof(full_cp) intersect{1};    
    }
    rd_empty:       cross rd_en_cp, empty_cp;
    rd_almostfull:  cross rd_en_cp, almostfull_cp;
    rd_almostempty: cross rd_en_cp, almostempty_cp;
    rd_overflow:    cross rd_en_cp, overflow_cp;
    rd_underflow:   cross rd_en_cp, underflow_cp{
         
        ignore_bins rd_en0_underflow1 = !binsof(rd_en_cp) intersect{1} && binsof(underflow_cp) intersect{1};    
    }
    rd_wr_ack:      cross rd_en_cp, wr_ack_cp;
endgroup


        // Constructor 
        function new();
            FIFO_cvgr = new();
        endfunction
    endclass
endpackage
