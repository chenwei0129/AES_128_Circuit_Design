`timescale 1ns/100ps
module plaintext_key_ROM(clk_i, pc_i,plaintext_q, key_q);

  input clk_i;
  input [`ADDR_WIDTH - 1:0] pc_i;
  
  output reg [`TEXT_WIDTH - 1:0] plaintext_q;
  output reg [`KEY_WIDTH - 1:0] key_q;
  
  reg [`TEXT_WIDTH - 1:0] ROM [0:`MEMORY_SIZE - 1];
  reg [`KEY_WIDTH - 1:0] KEY_ROM [0:1];
  
  always@(negedge clk_i)begin
    plaintext_q <= ROM[pc_i];
	key_q <= KEY_ROM[0];
  end

endmodule