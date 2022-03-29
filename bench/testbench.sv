module tb;
  timeunit        1ns ;
  timeprecision 100ps ;
 parameter iWIDTH = 10;
 parameter oWIDTH = $clog2(iWIDTH);
reg clk;
reg rst;
reg [iWIDTH - 1:0] data_in;
wire err;
wire crd_bit;

crd dut(.err(err),.crd_bit(crd_bit),.clk(clk),.rst(rst),.data_in(data_in));
  
  //monitor results
 initial
    begin
     $timeformat ( -9, 0, "ns", 3 ) ;
      $monitor ( "%t data_in=%b err=%b cdt_bit=%b rst=%b",
	        $time,   data_in,   err,   crd_bit,   rst ) ;
     // $finish;
    end  
  //
  
  
  task expect_test (input expects, input expects2) ;
    if ( crd_bit !== expects )
      begin
        $display ( "crd=%b, should be %b", crd_bit, expects );
        $display ( " TEST FAILED" );
        $finish;
      end
    
    if ( err !== expects2 )
      begin
        $display ( "err=%b, should be %b", err, expects2 );
        $display ( " TEST FAILED" );
        $finish;
      end
    else $display("I'm here...............!");
  endtask
  
  
initial begin
clk=1'b0;
rst = 1'b1;

 
  @(posedge clk)
  {rst,data_in} = 11'b0_0110100100;
  @(posedge clk) expect_test (1'b0,1'b0);
  {rst,data_in} = 11'b0_1000101001;  
  @(posedge clk) expect_test (1'b0,1'b1);
  {rst,data_in} = 11'b0_0111011001;  
  @(posedge clk) expect_test (1'b1,1'b0);
  {rst,data_in} = 11'b0_0111011001;  
  @(posedge clk) expect_test (1'b1,1'b1);
  {rst,data_in} = 11'b0_1100010011;  
  @(posedge clk) expect_test (1'b1,1'b0);
  {rst,data_in} = 11'b0_1010000010; 
  @(posedge clk) expect_test (1'b0,1'b0);
  {rst,data_in} = 11'b0_0110101010;
  @(posedge clk) expect_test (1'b0,1'b0);
  {rst,data_in} = 11'b0_0110101010;
  @(posedge clk) expect_test (1'b0,1'b0);
  {rst,data_in} = 11'b0_1010000010;
  @(posedge clk) expect_test (1'b1,1'b0);

  $display ( "TEST PASSED" );
      $finish;

end
  
always #1 clk=~clk;

endmodule