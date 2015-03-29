//
// EECE 479: Project Verilog File: divisor_register.v
//
//
// Names:  Derrick Wilson
// Number:  76674068
//

module divisor_reg(	reg_output,              // output (8 bits)
					reg_input,              // input (8 bits)
					load,					// input
					clk,                    // clock input
					reset);                 // async reset 

// Outputs
output [7:0] reg_output;

// Inputs
input [7:0] reg_input;
input load;
input clk;
input reset;


// Regs
reg [7:0] reg_output;

// Wires

// Behavioural Description

always @(posedge clk or posedge reset) begin
	if (reset) begin
		// async reset
		reg_output = 8'b00000000;		// reset register value    
	end
	else if (load) begin
		// load register selected
		reg_output = reg_input;		// bits [6:0] of register loaded with value of  input
	end
end

endmodule
