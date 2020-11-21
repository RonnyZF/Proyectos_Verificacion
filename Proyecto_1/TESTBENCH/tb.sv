// Code your testbench here
// or browse Examples

`timescale 1ns / 100ps
`include "/mnt/vol_NFS_Zener/WD_ESPEC/dleon/Veri/P1/RTL/fpu.v"

module test;

logic clk;
logic [1:0]rmode;
logic [2:0] fpu_op;
logic [31:0] opa, opb;
logic [31:0] out;
logic inf, snan, qnan;
logic ine;
logic overflow, underflow;
logic zero;
logic div_by_zero;


fpu u0(
  	.clk(clk), 
	.rmode(rmode), 
	.fpu_op(fpu_op), 
	.opa(opa), 
	.opb(opb), 
	.out(out), 
  	.inf(inf), 
	.snan(snan), 
	.qnan(qnan), 
	.ine(ine), 
	.overflow(overflow), 
	.underflow(underflow), 
	.zero(zero), 
	.div_by_zero(div_by_zero)
);

  
always // clock generator
#0.5 clk = ~clk;
  
initial begin
$display("INICIA TEST");
clk = 0;
#10
rmode = 2'b10;
fpu_op = 3'b000; //suma
//fpu_op = 3'b001; //resta
//fpu_op = 3'b010; //mul
//fpu_op = 3'b011; //div
opa = 32'h40490FDB; //pi
opb = 32'h402DF854; //euler
  
#10
rmode = 2'b10;
//fpu_op = 3'b000; //suma
fpu_op = 3'b001; //resta
//fpu_op = 3'b010; //mul
//fpu_op = 3'b011; //div
opa = 32'h40490FDB; //pi
opb = 32'h402DF854; //euler


#10
rmode = 2'b10;
//fpu_op = 3'b000; //suma
//fpu_op = 3'b001; //resta
fpu_op = 3'b010; //mul
//fpu_op = 3'b011; //div
opa = 32'h40490FDB; //pi
opb = 32'h402DF854; //euler


#10
rmode = 2'b10;
//fpu_op = 3'b000; //suma
//fpu_op = 3'b001; //resta
//fpu_op = 3'b010; //mul
fpu_op = 3'b011; //div
opa = 32'h40490FDB; //pi
opb = 32'h402DF854; //euler
#50
$stop;

end


endmodule


























