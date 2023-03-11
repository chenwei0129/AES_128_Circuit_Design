`timescale 1ns/100ps
module addroundkey(cyphertext_temp_i, key_i, cyphertext_temp_o);

  input [`TEXT_WIDTH - 1:0] cyphertext_temp_i;
  input [`KEY_WIDTH - 1:0] key_i;
  
  output [`TEXT_WIDTH - 1:0] cyphertext_temp_o;
  
  reg [`TEXT_WIDTH - 1:0] cyphertext_temp_o;
  
  always@(*)begin
    cyphertext_temp_o = cyphertext_temp_i ^ key_i;
  end

endmodule