//
// EECE 479: Project Verilog File: test_controller.v
//

module  test_controller;

wire load;
wire add;
wire [1:0] sel;
wire shift;
wire inbit;
wire valid;
reg start;
reg sign;
reg clk;
reg reset;

//////////////////////////////////////////////////////////////////////////
// Instantiate the module
//////////////////////////////////////////////////////////////////////////

controller u0(
         .load(load),
         .add(add),
         .shift(shift),
         .inbit(inbit),
         .sel(sel),
         .valid(valid),
         .start(start),
         .sign(sign),
         .clk(clk),
         .reset(reset));

// Create a clock...

`define    HALF_PERIOD    5000
always 
  fork
      #(`HALF_PERIOD)   clk = 1'b1;
      #(`HALF_PERIOD*2) clk = 1'b0;
    join


//////////////////////////////////////////////////////////////////////////
// The test commands
//////////////////////////////////////////////////////////////////////////

initial begin
   test_controller("test_controller.vec");
   $finish;
end


//////////////////////////////////////////////////////////////////////////
// The code that actually runs the test
//////////////////////////////////////////////////////////////////////////


task test_controller;

 
  input [255:0] file;
  reg[1:12] test_vector_input[5999:0];  // we can have up to 6000 test vectors
  reg[1:11] line;

  reg expected_load;
  reg expected_add;
  reg[1:0] expected_sel;
  reg expected_shift;
  reg expected_inbit;
  reg expected_valid;
  reg[1:0] expected_state;

  reg actual_load;
  reg actual_add;
  reg[1:0] actual_sel;
  reg actual_shift;
  reg actual_inbit;
  reg actual_valid;
  reg[1:0] actual_state;

  integer cnt, num, numfail;
  
  begin

    // Read in the input file into an array

    $readmemb(file, test_vector_input);

    // The first line of the file should specify the 
    // number of entries in the file
       
    num = test_vector_input[0];
    $display("Number of test vectors: %d\n",num);
    numfail = 0;

    reset = 1'b1;

    // pull out of reset   
    #10 reset = 1'b0;

    // Step through each test vector 

    for(cnt=0; cnt<num; cnt=cnt+1) begin
       line = test_vector_input[1+cnt];

       // Set the inputs. 
     @(negedge clk)
       start = line[1];
       sign = line[2];
       expected_load = line[3];
       expected_sel = line[4:5];
       expected_shift = line[6];
       expected_inbit = line[7];
       expected_add = line[8];
       expected_valid = line[9];
       expected_state = line[10:11];
       
       

     @(posedge clk)
     #10;
       $display("**** Clock Cycle: %d ****", cnt);

       // See if we have the right value for the state
       case (sel)
       2'b01: begin
        if (add) begin
          actual_state = 2'b10;
        end
        else begin
          actual_state = 2'b01;
        end
       end
       2'b10: begin
         actual_state = 2'b00;
       end
       2'b11: begin
         actual_state = 2'b11;
       end
       default: begin
         actual_state = 2'bxx;
       end
       endcase
       if (actual_state == expected_state) begin
          $display("Pass: state is correct:  state=%d", actual_state);
       end else begin
          $display("Fail: state is wrong.  state=%d but expected %d", actual_state, expected_state);
          numfail = numfail + 1;
       end
      // See if we have the right value for the valid signal
       if (valid === expected_valid) begin
          $display("Pass: valid is correct:  valid=%b", valid);
       end else begin
          $display("Fail: valid is wrong.  valid=%b but expected %b", valid, expected_valid);
          numfail = numfail + 1;
       end 
       // // See if we have the right value for the load signal
       // if (load === expected_load) begin
       //    $display("Pass: load is correct:  load=%b", load);
       // end else begin
       //    $display("Fail: load is wrong.  load=%b but expected %b", load, expected_load);
       //    numfail = numfail + 1;
       // end 
       // // See if we have the right value for the sel signal
       // if (sel === expected_sel) begin
       //    $display("Pass: sel is correct:  sel=%b", sel);
       // end else begin
       //    $display("Fail: sel is wrong.  sel=%b but expected %b", sel, expected_sel);
       //    numfail = numfail + 1;
       // end
       // // See if we have the right value for the shift signal
       // if (shift === expected_shift) begin
       //    $display("Pass: shift is correct:  shift=%b", shift);
       // end else begin
       //    $display("Fail: shift is wrong.  shift=%b but expected %b", shift, expected_shift);
       //    numfail = numfail + 1;
       // end
       // // See if we have the right value for the inbit signal
       // if (inbit === expected_inbit) begin
       //    $display("Pass: inbit is correct:  inbit=%b", inbit);
       // end else begin
       //    $display("Fail: inbit is wrong.  inbit=%b but expected %b", inbit, expected_inbit);
       //    numfail = numfail + 1;
       // end
       // // See if we have the right value for the add signal
       // if (add === expected_add) begin
       //    $display("Pass: add is correct:  add=%b", add);
       // end else begin
       //    $display("Fail: add is wrong.  add=%b but expected %b", add, expected_add);
       //    numfail = numfail + 1;
       // end
    end

  
  $display("Number test cases that fail: %d",numfail);
    if (numfail == 0) 
       $display("Good work!\n");
    $display(" ");
 end
endtask
endmodule

