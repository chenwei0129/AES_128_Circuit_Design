`timescale 1ns/100ps
module key_expansion(clk_i, rst_ni, number_i, key_i, W_S_box, key_o, key_first_o, key_ready_o, W3_o);

  input clk_i;
  input rst_ni;
  input [3:0] number_i;
  input [`KEY_WIDTH - 1:0] key_i;
  input [`FOUR_BYTE_WIDTH - 1:0] W_S_box;
  output [`KEY_WIDTH - 1:0] key_o;
  output [`KEY_WIDTH - 1:0] key_first_o;
  output reg key_ready_o;
  output reg [`FOUR_BYTE_WIDTH - 1:0] W3_o;

  reg [`FOUR_BYTE_WIDTH - 1:0] W0_o;
  reg [`FOUR_BYTE_WIDTH - 1:0] W1_o;
  reg [`FOUR_BYTE_WIDTH - 1:0] W2_o;

  reg [`BYTE_WIDTH - 1:0] RC;
  reg [`KEY_WIDTH - 1:0] key1_o;
  reg [`FOUR_BYTE_WIDTH - 1:0] W [0:3];
  reg [3:0] counter;
  reg [`TEXT_WIDTH - 1:0] KEY_MEM [0:9];

  assign key_o = ((4'd10 - number_i)==4'd0)?key_i:KEY_MEM[4'd9 - number_i];//number_i = 2~11
  assign key_first_o = KEY_MEM[9];//the last key generated, the first key used

  always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni)begin
	  W0_o <= key_i[127:96];
	  W1_o <= key_i[95:64];
	  W2_o <= key_i[63:32];
	  W3_o <= key_i[31:0];
      key_ready_o <= 1'b0;
	end
	else begin
      KEY_MEM[counter] <= key1_o;
	  if(counter==4'd10)begin
		key_ready_o <= 1'b1;
	    W0_o <= key_i[127:96];
	    W1_o <= key_i[95:64];
	    W2_o <= key_i[63:32];
	    W3_o <= key_i[31:0];
	  end
	  else begin
		key_ready_o <= 1'b0;
	    W0_o <= key1_o[127:96];
	    W1_o <= key1_o[95:64];
	    W2_o <= key1_o[63:32];
	    W3_o <= key1_o[31:0];
	  end
	end
  end
///////////
  always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni)begin
	  counter <= 4'b0000;
	end
	else begin
	  if(counter==4'd10)begin
	    counter <= 4'd10;
	  end
	  else begin
	    counter <= counter + 4'd1;
	  end
	end
  end
  
  always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni)
	  RC <= 8'b1;
	else
	  RC <= (RC<<1) ^ (8'h1b & -(RC>>7));
  end
  
  always@(*)begin
	W[0] = W0_o ^ {W_S_box[23:16], W_S_box[15:8], W_S_box[7:0], W_S_box[31:24]} ^ {RC, 24'b0};
	W[1] = W1_o ^ W[0];
	W[2] = W2_o ^ W[1];
	W[3] = W3_o ^ W[2];
	key1_o = {W[0], W[1], W[2], W[3]};
  end

endmodule
