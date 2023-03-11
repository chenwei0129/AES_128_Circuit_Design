`timescale 1ns/100ps
module pc(clk_i, rst_ni, enable_i, pc_o);

  input clk_i;
  input rst_ni;
  input enable_i;
  
  output [`ADDR_WIDTH - 1:0] pc_o;
  
  reg [`ADDR_WIDTH - 1:0] pc_o;

  always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni)
	  pc_o <= `ADDR_WIDTH'b0 - `ADDR_WIDTH'd1;
	else if(enable_i)
      pc_o <= pc_o + `ADDR_WIDTH'b1;
	else 
	  pc_o <= pc_o;
  end

endmodule
