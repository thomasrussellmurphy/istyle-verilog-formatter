module fifo#(parameter D_SIZE = 8,
           parameter A_SIZE = 4,
           parameter W_SIZE = 8,
           parameter R_SIZE = 8
       )
       (
           input W_CLK, // Writing
           input W_INC,
           input W_RST_N,
           input [D_SIZE - 1: 0] W_DATA,
           output FULL,
           // Reading
           input R_CLK,
           input R_INC,
           input R_RST_N,
           output [D_SIZE - 1: 0] R_DATA,
           output EMPTY
       );
       
       endmodule