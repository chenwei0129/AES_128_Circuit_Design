`timescale 1ns/100ps
module pc(clk_i, rst_ni, enable_i, pc_o);

  input clk_i;
  input rst_ni;
  input enable_i;
  
  output [`ADDR_WIDTH - 1:0] pc_o;
  
  reg [`ADDR_WIDTH - 1:0] pc_o_reg;
  
  assign pc_o = pc_o_reg - `ADDR_WIDTH'd1;

  always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni)
	  pc_o_reg <= `ADDR_WIDTH'b0;
	else if(enable_i)
      pc_o_reg <= pc_o_reg + `ADDR_WIDTH'b1;
	else 
	  pc_o_reg <= pc_o_reg;
  end

endmodule
