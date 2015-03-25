//
// EECE 479: Project Verilog File: datapath.v
//
// This is the stub for the datapath block.  Please start with this
// template when writing your Verilog code.
//
// Names:  Derrick Wilson
// Number:  76674068
//

module datapath(        remainder,              // output (7 bits)
                        quotient,               // output (8 bits)
                        sign,                   // output 
                        divisorin,              // input (7 bits)
                        dividendin,             // input (8 bits)
                        load,                   // input
                        add,                    // input
                        shift,                  // input
                        inbit,                  // input
                        sel,                    // input (2 bits)
                        clk,                    // clock input
                        reset);                 // async reset 

output [6:0] remainder;
output [7:0] quotient;
output sign;
input [6:0] divisorin;
input [7:0] dividendin;
input load;
input add;
input shift;
input inbit;
input [1:0] sel;
input clk;
input reset;


// Regs


// Wires


// Behavioural Description

endmodule
