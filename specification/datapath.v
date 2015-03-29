//
// EECE 479: Project Verilog File: datapath.v
//
// This is the stub for the datapath block.  Please start with this
// template when writing your Verilog code.
//
// Names:  Derrick Wilson
// Number:  76674068
//

module datapath(	remainder,              // output (7 bits)
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

// Outputs
output [6:0] remainder;
output [7:0] quotient;
output sign;

// Inputs
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
reg [7:0] divisor_reg;
reg [15:0] mux_value;
reg [15:0] shift_value;
reg [15:0] remainder_reg;

// Wires
wire [7:0] adder_result;

// Behavioural Description

// 8-Bit Divisor Register Module
always @(posedge clk or posedge reset) begin
	if (reset) begin
		// async reset
		divisor_reg = 8'b00000000;		// reset register value    
	end
	else if (load) begin
		// load register selected
		divisor_reg[7] = 1'b0;				// bit 8 of register loaded with 0
		divisor_reg[6:0] = divisorin;		// bits [6:0] of register loaded with value of divisorin input
	end
end

assign adder_result = (add) ? remainder_reg[15:8] + divisor_reg : remainder_reg[15:8] - divisor_reg;

// assign adder_result = (add) ? 8'b00000000 + divisor_reg : 8'b00000000 - divisor_reg;


// 16-bit 3-to-1 Mux Module

always @(sel or remainder_reg or adder_result or dividendin) begin
	case (sel)
		2'b01: begin
			// 1 is selected
			mux_value[15:8] <= adder_result;	// mux[15:8] is the output of the adder
			mux_value[7:0] <= remainder_reg[7:0];	// mux[7:0] is Remainder[7:0]
		end
		2'b10: begin
			// 2 is selected
			mux_value[15:8] <= 8'b00000000;	// mux[15:8] is 00000000
			mux_value[7:0] <= dividendin;	// mux[7:0] is value of dividendin input
		end
		2'b11: begin
			// 3 is selected
			mux_value[15:8] <= remainder_reg[15:8];	// mux[15:8] is Remainder[15:8]
			mux_value[7:0] <= remainder_reg[7:0];	// mux[7:0] is Remainder[7:0]
		end
		2'b00: begin
			// default case is 0, controller shouldn't select this value but just in case need to assign a value to mux_value to not infer any latches
			mux_value[15:8] <= 8'bzzzzzzzz;	// mux[15:8] is high impedance
			mux_value[7:0] <= 8'bzzzzzzzz;	// mux[7:0] is high impedance
		end
	endcase
end

// Shift/No Shift Module
always @(shift or mux_value or inbit) begin
	if (shift) begin
		// shift is selected
		shift_value[15:1] <= mux_value[14:0];	// shift remainder register input left 1 bit
		shift_value[0] <= inbit;	// remainder register input is value of inbit input from controller
	end
	else begin
		// shift not selected
		shift_value[15:0] <= mux_value[15:0];	// do not shift remainder register input
	end
end

// 16-Bit Remainder Register
always @(posedge clk or reset) begin
	if (reset) begin
		// sync reset
		remainder_reg = 16'b0000000000000000;	// reset remainder value
	end
	else begin
		// rising edge of clock
		remainder_reg = shift_value;	// Remainder Register stores output of shifter for 1 clock cycle
	end
end

// DataPath Outputs
assign remainder = remainder_reg[15:9];	// remainder is Remainder[15:9]
assign quotient = remainder_reg[7:0];		// quotient is Remainder[7:0]
assign sign = adder_result[7];			// sign is the 7th bit of the adder


endmodule
