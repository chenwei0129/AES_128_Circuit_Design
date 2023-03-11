`timescale 1ns/100ps
module shiftrows(cyphertext_temp_i, cyphertext_temp_o);

  input [`TEXT_WIDTH - 1:0] cyphertext_temp_i;
  
  output [`TEXT_WIDTH - 1:0] cyphertext_temp_o;
  
  reg [`TEXT_WIDTH - 1:0] cyphertext_temp_o;
  
  always@(*)begin
    cyphertext_temp_o = {cyphertext_temp_i[127:120],
                         cyphertext_temp_i[87:80],
					     cyphertext_temp_i[47:40],
						 cyphertext_temp_i[7:0],
						 cyphertext_temp_i[95:88],
						 cyphertext_temp_i[55:48],
						 cyphertext_temp_i[15:8],
						 cyphertext_temp_i[103:96],
						 cyphertext_temp_i[63:56],
						 cyphertext_temp_i[23:16],
						 cyphertext_temp_i[111:104],
						 cyphertext_temp_i[71:64],
						 cyphertext_temp_i[31:24],
						 cyphertext_temp_i[119:112],
						 cyphertext_temp_i[79:72],
						 cyphertext_temp_i[39:32]};
  end

endmodule
