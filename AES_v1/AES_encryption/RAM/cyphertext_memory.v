`timescale 1ns/100ps
module cyphertext_memory(clk_i, pc_i, finish_d, cyphertext_d, cyphertext_q);

  input clk_i;
  input [`ADDR_WIDTH - 1:0] pc_i;
  input finish_d;
  input [`TEXT_WIDTH - 1:0] cyphertext_d;
  
  output [`TEXT_WIDTH - 1:0] cyphertext_q;
  
  reg [`TEXT_WIDTH - 1:0] cyphertext_q;
  reg [`TEXT_WIDTH - 1:0] MEMORY [0:`MEMORY_SIZE - 1];
  
  always@(posedge clk_i)begin
    if(finish_d)begin
	  cyphertext_q <= cyphertext_d;
	  MEMORY[pc_i] <= cyphertext_d;
	end
	else
	  cyphertext_q <= `TEXT_WIDTH'bx;
  end

endmodule
