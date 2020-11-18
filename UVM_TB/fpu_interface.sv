//-------------------------------------------------------------------------
//						fpu_interface - www.verificationguide.com
//-------------------------------------------------------------------------

interface fpu_if(input logic clk,reset);
  
  //---------------------------------------
  //declaring the signals
  //---------------------------------------

  logic [1:0] rmode;
  logic [2:0] fpu_op;
  logic [31:0] opa;
  logic [31:0] opb;
  logic [31:0] out;
  logic inf;
  logic snan;
  logic qnan;
  logic ine; 
  logic overflow; 
  logic underflow; 
  logic zero; 
  logic div_by_zero; 
  
  
  //---------------------------------------
  //driver clocking block
  //---------------------------------------
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output Address;
    output CS;
    output WE;
    output OE;
    output wdata;
    input  rdata;
  endclocking
  
  //---------------------------------------
  //monitor clocking block
  //---------------------------------------
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input Address;
    input CS;
    input WE;
    input OE;
    input wdata;
    input rdata;
  endclocking
  
  //---------------------------------------
  //driver modport
  //---------------------------------------
  modport DRIVER  (clocking driver_cb,input clk,reset);
  
  //---------------------------------------
  //monitor modport  
  //---------------------------------------
  modport MONITOR (clocking monitor_cb,input clk,reset);
    
     
  //---------------------------------------
  //Functional Coverage Collection
  //---------------------------------------
    
    covergroup fpu_coverage @(posedge WE or posedge OE or posedge CS);
      Address_cov : coverpoint Address{
      }
      Data_cov : coverpoint wdata{
        bins data[256] = {[0:65535]};
      }
      CS_cov : coverpoint CS {
        bins no_CS = {0};
        bins set_CS = {1};
      }
      WE_cov : coverpoint WE {
        bins no_WE = {0};
        bins set_WE = {1};
      }
      OE_cov : coverpoint OE {
        bins no_OE = {0};
        bins set_OE = {1};
      }
      cross_CS_WE_cov : cross CS_cov, WE_cov;
      cross_CS_OE_cov : cross CS_cov, OE_cov;
      cross_CS_Address_cov : cross CS_cov, Address_cov;
      cross_WE_Address_cov : cross WE_cov, Address_cov;
      cross_OE_Address_cov : cross OE_cov, Address_cov;
      cross_Address_Data_cov : cross Data_cov, Address_cov;
    endgroup
    
    fpu_coverage coverage_collection = new();
  
  
endinterface