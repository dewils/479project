//
// EECE 479: Project Verilog File: divider.v
//
// This is the stub for your top-level block.  Please start with this
// template when writing your Verilog code.
//
// Names:  <insert your names here>
// Number:  <insert your student numbers here>
//


module divider(
         remainder,
         quotient,
	 valid,
         divisorin,
         dividendin,
         start,
         clk,
         reset);

output [6:0] remainder;
output [7:0] quotient;
output valid;  
input [6:0] divisorin;
input [7:0] dividendin;
input start;
input clk;
input reset;


-- Insert your code here (you should just be including
-- datapath and control subblocks.  Unlikely to be any logic
-- in this file)

endmodule
