//
// EECE 479: Project Verilog File: test_divisor_reg.v
//

module  test_divisor_reg;

wire [7:0] reg_output;
reg [7:0] reg_input;
reg load;
reg clk;
reg reset;

//////////////////////////////////////////////////////////////////////////
// Instantiate the module
//////////////////////////////////////////////////////////////////////////

divisor_reg u0(
         .reg_output(reg_output),
         .reg_input(reg_input),
         .load(load),
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
   test_divisor_reg("test_divisor_register.vec");
   $finish;
end


//////////////////////////////////////////////////////////////////////////
// The code that actually runs the test
//////////////////////////////////////////////////////////////////////////


task test_divisor_reg;

 
  input [255:0] file;
  reg[1:18] test_vector_input[5999:0];  // we can have up to 6000 test vectors
  reg[1:17] line;

  reg [7:0] expected_regoutput;

  integer cnt, num, numfail;
  
  begin

    // Read in the input file into an array
    $readmemb(file, test_vector_input);

    // The first line of the file should specify the 
    // number of entries in the file
    num = test_vector_input[0];
    $display("Number of test vectors: %d\n",num);

    // A clock cycle just to get things going
    @(negedge clk);
    numfail = 0;
    reset = 1;

    // Negate reset
    @(negedge clk)
    reset = 0;

    // Step through each test vector 
    for(cnt=0; cnt<num; cnt=cnt+1) begin
        line = test_vector_input[1+cnt];
        
        @(negedge clk);
        // Set inputs
          load = line[1];
          reg_input = line[2:9];
          expected_regoutput = line[10:17];

     @(posedge clk)
     #10
       $display("**** Clock Cycle: %d ****", cnt);
       // See if we have the right value for the regout signal
       if (reg_output === expected_regoutput) begin
          $display("Pass: reg_output is correct:  reg_output=%b", reg_output);
       end else begin
          $display("Fail: reg_output is wrong.  reg_output=%b but expected %b", reg_output, expected_regoutput);
          numfail = numfail + 1;
       end 
    end
  
  $display("Number test cases that fail: %d",numfail);
    if (numfail == 0) 
       $display("Good work!\n");
    $display(" ");
 end
endtask
endmodule

