`timescale 1ns/100ps
module cyphertext_key_memory(clk_i, pc_i, cyphertext_q, key_q);

  input clk_i;
  input [`ADDR_WIDTH - 1:0] pc_i;
  
  output [`TEXT_WIDTH - 1:0] cyphertext_q;
  output [`KEY_WIDTH - 1:0] key_q;
  
  reg [`TEXT_WIDTH - 1:0] cyphertext_q;
  reg [`KEY_WIDTH - 1:0] key_q;
  
  reg [`TEXT_WIDTH - 1:0] MEMORY [0:`MEMORY_SIZE - 1];
  reg [`KEY_WIDTH - 1:0] KEY_MEMORY [0:1];
  
  always@(negedge clk_i)begin
    cyphertext_q <= MEMORY[pc_i];
	key_q <= KEY_MEMORY[0];
  end

endmodule