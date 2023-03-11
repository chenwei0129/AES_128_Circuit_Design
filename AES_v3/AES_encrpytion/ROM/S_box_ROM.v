`timescale 1ns/100ps
module S_box_ROM(clk_i, cyphertext_temp_i, W_i, cyphertext_temp_o, W_o);

  input clk_i;
  input [`TEXT_WIDTH - 1:0] cyphertext_temp_i;
  input [`FOUR_BYTE_WIDTH - 1:0] W_i;
  
  output reg [`TEXT_WIDTH - 1:0] cyphertext_temp_o;
  output reg [`FOUR_BYTE_WIDTH - 1:0] W_o;
  
  reg [`BYTE_WIDTH - 1:0] S_box [0:`S_BOX_SIZE - 1];
  
  always@(negedge clk_i)begin
    cyphertext_temp_o <= {S_box[cyphertext_temp_i[127:120]],
                          S_box[cyphertext_temp_i[119:112]],
			 	 		  S_box[cyphertext_temp_i[111:104]],
						  S_box[cyphertext_temp_i[103:96]],
						  S_box[cyphertext_temp_i[95:88]],
						  S_box[cyphertext_temp_i[87:80]],
						  S_box[cyphertext_temp_i[79:72]],
						  S_box[cyphertext_temp_i[71:64]],
						  S_box[cyphertext_temp_i[63:56]],
						  S_box[cyphertext_temp_i[55:48]],
						  S_box[cyphertext_temp_i[47:40]],
						  S_box[cyphertext_temp_i[39:32]],
						  S_box[cyphertext_temp_i[31:24]],
						  S_box[cyphertext_temp_i[23:16]],
						  S_box[cyphertext_temp_i[15:8]],
						  S_box[cyphertext_temp_i[7:0]]};
  
    W_o <= {S_box[W_i[31:24]],
		    S_box[W_i[23:16]],
		    S_box[W_i[15:8]],
		    S_box[W_i[7:0]]};
  
  end
  
endmodule
