`timescale 1ns/100ps
module S_box_memory(clk_i, W_i, W_o);

  input clk_i;
  input [`FOUR_BYTE_WIDTH - 1:0] W_i;
  
  output [`FOUR_BYTE_WIDTH - 1:0] W_o;
  
  reg [`FOUR_BYTE_WIDTH - 1:0] W_o;
  reg [`BYTE_WIDTH - 1:0] S_box [0:`S_BOX_SIZE - 1];
  
  always@(negedge clk_i)begin
    W_o <= {S_box[W_i[31:24]],
		    S_box[W_i[23:16]],
		    S_box[W_i[15:8]],
		    S_box[W_i[7:0]]};
  
  end
  
endmodule
