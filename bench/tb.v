`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2022 12:14:51 AM
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb;
 parameter iWIDTH = 10;
 parameter oWIDTH = $clog2(iWIDTH);
reg clk;
reg rst;
reg [iWIDTH - 1:0] data_in;
wire err;
wire crd_bit;

crd dut(.err(err),.crd_bit(crd_bit),.clk(clk),.rst(rst),.data_in(data_in));
initial begin
clk=1'b0;
rst = 1'b1;

 
#2
rst = 1'b0;  
data_in =10'b0110100100;
#2
data_in =10'b1000101001;
#2
data_in =10'b0111011001;
#2
data_in =10'b0111011001;
#2
data_in =10'b1100010011;
#2
data_in =10'b1101011101;
#2
data_in =10'b1010000010;
#2
data_in =10'b0110101010;
#2
data_in =10'b0110101010;
#2
data_in =10'b1010000010;
 



end
always #1 clk=~clk;

endmodule
