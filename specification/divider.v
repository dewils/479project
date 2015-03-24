//
// EECE 479: Project Verilog File: divider.v
//
// This is the stub for your top-level block.  Please start with this
// template when writing your Verilog code.
//
// Names:  Derrick Wilson
// Number:  76674068
//


module 	divider(
		remainder,
		quotient,
		valid,
		divisorin,
		dividendin,
		start,
		clk,
		reset);

// Outputs
output [6:0] remainder;
output [7:0] quotient;
output valid;  
// Inputs
input [6:0] divisorin;
input [7:0] dividendin;
input start;
input clk;
input reset;

// Wires (not sure if I need these, if current configuration doesn't work, use these wires)
// wire load_w;
// wire add_w;
// wire sign_w;
// wire [1:0] sel_w;
// wire shift_w;
// wire inbit_w:

controller controller(	load,		// output
						add,		// output
						shift,		// output
						inbit,		// output
						sel,		// output (2 buts)
						valid,		// output
						start,		// input
						sign, 		// input
						clk,		// clock input
						reset);		// async reset

datapath datapath(	remainder,		// output (7 bits)
					quotient, 		// output (8 bits)
					sign,			// output 
					divisorin,		// input (7 bits)
					dividendin,		// input (8 bits)
					load,			// input
					add,			// input
					shift,			// input
					inbit,			// input
					sel,			// input (2 bits)
					clk,			// clock input
					reset);			// async reset 

endmodule
