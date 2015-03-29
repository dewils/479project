//
// EECE 479: Project Verilog File: controller.v
//
// This is the stub for the controller block.  Please start with this
// template when writing your Verilog code.
//
// Names:  Derrick Wilson
// Number:  76674068
//

module controller(	load,		// output
					add,		// output
					shift,		// output
					inbit,		// output
					sel,		// output (2 buts)
					valid,		// output
					start,		// input
					sign, 		// input
					clk,		// clock input
					reset);		// async reset

// Outputs
output load;
output add;
output shift;
output inbit;
output [1:0] sel;
output valid;   

// Inputs
input start;
input sign;
input clk;
input reset;

// Regs
reg [1:0] curr_state;
reg [1:0] next_state;
reg [4:0] rep_counter;
reg load;
reg add;
reg shift;
reg inbit;
reg [1:0] sel;
reg valid;

// Wires


// Behavioural Description

// State Register
always @(posedge clk or posedge reset) 
begin
	if (reset == 1'b1) begin
		// async reset, current state is 0
		curr_state = 2'b00;
	end
	else begin
		// go to next state
		curr_state = next_state;
	end
end

// Next State Logic
always @(curr_state or start) begin
	if(start) begin
		// start is strobed, next state is 0
		next_state = 2'b00;
	end
	else begin
		case (curr_state)
			2'b01:	begin
				// current state is 1
				if (sign) begin
					// sign is 1, next state is 2
					next_state = 2'b10;
				end
				else begin
					// sign is 0, next state is 3
					next_state = 2'b11;
				end
			end
			2'b10: begin 
				// current state is 2, next state is 1	
				next_state = 2'b01;
			end
			2'b11: begin 
				// current state is 3, next state is 1
				next_state = 2'b01;
			end
			2'b00: begin 
				// current state 0, next state is 1
				next_state = 2'b01;
			end	
		endcase
	end
end

// Output Logic
always @(curr_state) begin
	case (curr_state)
		3'b00: begin
			// current state is 0
			load <= 1'b1;	// load Divisor register with divisor
			add <= 1'bz;	// don't care
			shift <= 1'b1;	// shift Remainder register input left 1 bit
			inbit <= 1'b0;	// inbit on shift is 0
			sel <= 2'b10;	// load Remainder Register with dividen
			valid <= 1'b0;	// result is not valid
			rep_counter = 0;	// initialize repetition counter to 0
		end
		3'b01: begin 
			// current state is 1
			load <= 1'b0;	// keep initial value in Divisor register
			add <= 1'b0;	// subtract Divisor[7..0] from Remainder[15..8]
			shift <= 1'b0;	// no shift operation
			inbit <= 1'bz;	// don't care
			sel <= 2'b01;	// load Remainder[15..8] with add/subtract value and Remainder[7..0] with previous value
			valid <= 1'b0;	// result is not valid
			rep_counter = rep_counter + 1;	// increment repetition counter value
		end	
		3'b10: begin
			// current state is 2
			load <= 1'b0;	// keep initial value in Divisor register
			add <= 1'b1;	// add Divisor[7..0] to Remainder[15..8]
			shift <= 1'b1;	// shift Remainder register input left 1 bit
			inbit <= 1'b0;	// inbit on shift is 0
			sel <= 2'b01;	// load Remainder[15..8] with add/subtract value and Remainder[7..0] with previous value
			if (rep_counter == 8) begin
				// 8th Repetition
				valid <= 1'b1;	// result is valid
				rep_counter = 0;	// reset repetition counter
			end
			else begin
				valid <= 1'b0;	// result is not valid
			end
		end	
		3'b11: begin
			// current state is 3
			load <= 1'b0;	// keep initial value in Divisor register
			add <= 1'bz;	// don't care
			shift <= 1'b1;	// shift Remainder register input left 1 bit
			inbit <= 1'b1;	// inbit on shift is 1
			sel <= 2'b11;	// load Remainder[15..8] with previous value and Remainder[7..0] with previous value
			if (rep_counter == 8) begin
				// 8th Repetition
				valid <= 1'b1;	// result is valid
				rep_counter = 0;	// reset repetition counter
			end
			else begin
				valid <= 1'b0;	// result is not valid
			end
		end	
	endcase
end

endmodule
