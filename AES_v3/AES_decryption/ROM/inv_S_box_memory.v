`timescale 1ns/100ps
module inv_S_box_memory(clk_i, cyphertext_temp_i, cyphertext_temp_o);

  input clk_i;
  input [`TEXT_WIDTH - 1:0] cyphertext_temp_i;
  
  output [`TEXT_WIDTH - 1:0] cyphertext_temp_o;
  
  reg [`TEXT_WIDTH - 1:0] cyphertext_temp_o;
  reg [`BYTE_WIDTH - 1:0] inv_S_box [0:`S_BOX_SIZE - 1];
  
  always@(negedge clk_i)begin
    cyphertext_temp_o <= {inv_S_box[cyphertext_temp_i[127:120]],
                          inv_S_box[cyphertext_temp_i[119:112]],
			 	 		  inv_S_box[cyphertext_temp_i[111:104]],
						  inv_S_box[cyphertext_temp_i[103:96]],
						  inv_S_box[cyphertext_temp_i[95:88]],
						  inv_S_box[cyphertext_temp_i[87:80]],
						  inv_S_box[cyphertext_temp_i[79:72]],
						  inv_S_box[cyphertext_temp_i[71:64]],
						  inv_S_box[cyphertext_temp_i[63:56]],
						  inv_S_box[cyphertext_temp_i[55:48]],
						  inv_S_box[cyphertext_temp_i[47:40]],
						  inv_S_box[cyphertext_temp_i[39:32]],
						  inv_S_box[cyphertext_temp_i[31:24]],
						  inv_S_box[cyphertext_temp_i[23:16]],
						  inv_S_box[cyphertext_temp_i[15:8]],
						  inv_S_box[cyphertext_temp_i[7:0]]};
  end
  
endmodule
