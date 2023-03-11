`timescale 1ns/100ps
module mixcolumns(cyphertext_temp_i, cyphertext_temp_o);
  
  input [`TEXT_WIDTH - 1:0] cyphertext_temp_i;
  
  output reg [`TEXT_WIDTH - 1:0] cyphertext_temp_o;
  
  always@(*)begin
    cyphertext_temp_o[127:120] = X2(cyphertext_temp_i[127:120] ^cyphertext_temp_i[119:112]) ^ (cyphertext_temp_i[111:104] ^cyphertext_temp_i[103:96]  ^cyphertext_temp_i[119:112]);
	cyphertext_temp_o[95:88]   = X2(cyphertext_temp_i[95:88]   ^cyphertext_temp_i[87:80])   ^ (cyphertext_temp_i[79:72]   ^cyphertext_temp_i[71:64]   ^cyphertext_temp_i[87:80]);
	cyphertext_temp_o[63:56]   = X2(cyphertext_temp_i[63:56]   ^cyphertext_temp_i[55:48])   ^ (cyphertext_temp_i[47:40]   ^cyphertext_temp_i[39:32]   ^cyphertext_temp_i[55:48]);
	cyphertext_temp_o[31:24]   = X2(cyphertext_temp_i[31:24]   ^cyphertext_temp_i[23:16])   ^ (cyphertext_temp_i[15:8]    ^cyphertext_temp_i[7:0]     ^cyphertext_temp_i[23:16]);
	cyphertext_temp_o[119:112] = X2(cyphertext_temp_i[119:112] ^cyphertext_temp_i[111:104]) ^ (cyphertext_temp_i[127:120] ^cyphertext_temp_i[111:104] ^cyphertext_temp_i[103:96]);
	cyphertext_temp_o[87:80]   = X2(cyphertext_temp_i[87:80]   ^cyphertext_temp_i[79:72])   ^ (cyphertext_temp_i[95:88]   ^cyphertext_temp_i[79:72]   ^cyphertext_temp_i[71:64]);
	cyphertext_temp_o[55:48]   = X2(cyphertext_temp_i[55:48]   ^cyphertext_temp_i[47:40])   ^ (cyphertext_temp_i[63:56]   ^cyphertext_temp_i[47:40]   ^cyphertext_temp_i[39:32]);
	cyphertext_temp_o[23:16]   = X2(cyphertext_temp_i[23:16]   ^cyphertext_temp_i[15:8])    ^ (cyphertext_temp_i[31:24]   ^cyphertext_temp_i[15:8]    ^cyphertext_temp_i[7:0]);
	cyphertext_temp_o[111:104] = X2(cyphertext_temp_i[111:104] ^cyphertext_temp_i[103:96])  ^ (cyphertext_temp_i[127:120] ^cyphertext_temp_i[119:112] ^cyphertext_temp_i[103:96]);
	cyphertext_temp_o[79:72]   = X2(cyphertext_temp_i[79:72]   ^cyphertext_temp_i[71:64])   ^ (cyphertext_temp_i[95:88]   ^cyphertext_temp_i[87:80]   ^cyphertext_temp_i[71:64]);
	cyphertext_temp_o[47:40]   = X2(cyphertext_temp_i[47:40]   ^cyphertext_temp_i[39:32])   ^ (cyphertext_temp_i[63:56]   ^cyphertext_temp_i[55:48]   ^cyphertext_temp_i[39:32]);
	cyphertext_temp_o[15:8]    = X2(cyphertext_temp_i[15:8]    ^cyphertext_temp_i[7:0])     ^ (cyphertext_temp_i[31:24]   ^cyphertext_temp_i[23:16]   ^cyphertext_temp_i[7:0]);
	cyphertext_temp_o[103:96]  = X2(cyphertext_temp_i[127:120] ^cyphertext_temp_i[103:96])  ^ (cyphertext_temp_i[127:120] ^cyphertext_temp_i[119:112] ^cyphertext_temp_i[111:104]);
	cyphertext_temp_o[71:64]   = X2(cyphertext_temp_i[95:88]   ^cyphertext_temp_i[71:64])   ^ (cyphertext_temp_i[95:88]   ^cyphertext_temp_i[87:80]   ^cyphertext_temp_i[79:72]);
	cyphertext_temp_o[39:32]   = X2(cyphertext_temp_i[63:56]   ^cyphertext_temp_i[39:32])   ^ (cyphertext_temp_i[63:56]   ^cyphertext_temp_i[55:48]   ^cyphertext_temp_i[47:40]);
	cyphertext_temp_o[7:0]     = X2(cyphertext_temp_i[31:24]   ^cyphertext_temp_i[7:0])     ^ (cyphertext_temp_i[31:24]   ^cyphertext_temp_i[23:16]   ^cyphertext_temp_i[15:8]);
  end

  function [`BYTE_WIDTH - 1:0] X2;
    input [`BYTE_WIDTH - 1:0] cyphertext;
	reg [`BYTE_WIDTH - 1:0] temp;
	begin
	  temp = cyphertext<<1;
	  if(cyphertext[`BYTE_WIDTH - 1])
	    X2 = temp ^ 8'b0001_1011;
	  else
	    X2 = temp;
    end
  endfunction

endmodule
