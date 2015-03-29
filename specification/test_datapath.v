//
// EECE 479: Project Verilog File: test_datapath.v
//

module  test_datapath;

wire [6:0] remainder;
wire [7:0] quotient;
wire sign;
reg [6:0] divisorin;
reg [7:0] dividendin;
reg load;
reg add;
reg shift;
reg inbit;
reg [1:0] sel;
reg clk;
reg reset;

//////////////////////////////////////////////////////////////////////////
// Instantiate the module
//////////////////////////////////////////////////////////////////////////

datapath u0(
         .remainder(remainder),
         .quotient(quotient),
         .sign(sign),
         .divisorin(divisorin),
         .dividendin(dividendin),
         .load(load),
         .add(add),
         .shift(shift),
         .inbit(inbit),
         .sel(sel),
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
   test_datapath("test_datapath.vec");
   $finish;
end


//////////////////////////////////////////////////////////////////////////
// The code that actually runs the test
//////////////////////////////////////////////////////////////////////////


task test_datapath;

 
  input [255:0] file;
  reg[1:38] test_vector_input[5999:0];  // we can have up to 6000 test vectors
  reg[1:37] line;

  reg [6:0] expected_remainder;
  reg [7:0] expected_quotient;
  reg expected_sign;

  // reg actual_remainder;
  // reg actual_quotient;
  // reg actual_sign;

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
          divisorin = line[2:8];
          add = line[9];
          sel = line[10:11];
          dividendin = line[12:19];
          shift = line[20];
          inbit = line[21];
          expected_remainder = line[22:28];
          expected_quotient = line[29:36];
          expected_sign = line[37];

     @(posedge clk)
     #10
       $display("**** Clock Cycle: %d ****", cnt);
       // See if we have the right value for the remainder signal
       if (remainder === expected_remainder) begin
          $display("Pass: remainder is correct:  remainder=%b", remainder);
       end else begin
          $display("Fail: remainder is wrong.  remainder=%b but expected %b", remainder, expected_remainder);
          numfail = numfail + 1;
       end 
       // See if we have the right value for the quotient signal
       if (quotient === expected_quotient) begin
          $display("Pass: quotient is correct:  quotient=%b", quotient);
       end else begin
          $display("Fail: quotient is wrong.  quotient=%b but expected %b", quotient, expected_quotient);
          numfail = numfail + 1;
       end
       // See if we have the right value for the sign signal
       if (sign === expected_sign) begin
          $display("Pass: sign is correct:  sign=%b", sign);
       end else begin
          $display("Fail: sign is wrong.  sign=%b but expected %b", sign, expected_sign);
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

