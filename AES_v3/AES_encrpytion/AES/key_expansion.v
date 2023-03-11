`timescale 1ns/100ps
module key_expansion(clk_i, rst_ni, key_i, W_S_box, W3_o, key_o);

  input clk_i;
  input rst_ni;
  input [`KEY_WIDTH - 1:0] key_i;
  input [`FOUR_BYTE_WIDTH - 1:0] W_S_box;
  
  output reg [`FOUR_BYTE_WIDTH - 1:0] W3_o;
  output reg [`KEY_WIDTH - 1:0] key_o;
  
  reg [`FOUR_BYTE_WIDTH - 1:0] W0;
  reg [`FOUR_BYTE_WIDTH - 1:0] W1;
  reg [`FOUR_BYTE_WIDTH - 1:0] W2;
  reg [`BYTE_WIDTH - 1:0] RC;
  
  reg [3:0] counter;

  always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni || counter==4'd10)
	  counter <= 4'b0000;
	else
	  counter <= counter + 4'd1;
  end
  
  always@(posedge clk_i)begin
	if(counter!=4'd0)
	  RC <= (RC<<1) ^ (8'h1b & -(RC>>7));
	else 
	  RC <= 8'b1;
  end
  
  always@(posedge clk_i)begin
	if(counter==4'd0)begin//use the original key to generate the next key,W3 will go to subbytes
	  W0   <= key_i[127:96];
	  W1   <= key_i[95:64];
	  W2   <= key_i[63:32];
	  W3_o <= key_i[31:0];
	end
	else begin//use the last round key to generate the next key,W3 will go to subbytes
	  W0   <= key_o[127:96];
	  W1   <= key_o[95:64];
	  W2   <= key_o[63:32];
	  W3_o <= key_o[31:0];
	end
  end
  
  always@(*)begin
	key_o[127:96] = W0   ^ {W_S_box[23:16], W_S_box[15:8], W_S_box[7:0], W_S_box[31:24]} ^ {RC, 24'b0};
	key_o[95:64]  = W1   ^ key_o[127:96];
	key_o[63:32]  = W2   ^ key_o[95:64];
	key_o[31:0]   = W3_o ^ key_o[63:32];
  end
  
endmodule
