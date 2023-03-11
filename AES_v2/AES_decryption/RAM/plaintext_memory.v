`timescale 1ns/100ps
module plaintext_memory(clk_i, pc_i, finish_d, plaintext_d, plaintext_q);

  input clk_i;
  input [`ADDR_WIDTH - 1:0] pc_i;
  input finish_d;
  input [`TEXT_WIDTH - 1:0] plaintext_d;
  
  output [`TEXT_WIDTH - 1:0] plaintext_q;
  
  reg [`TEXT_WIDTH - 1:0] plaintext_q;
  reg [`TEXT_WIDTH - 1:0] MEMORY [0:`MEMORY_SIZE - 1];
  
  always@(posedge clk_i)begin
    if(finish_d)begin
	  plaintext_q <= plaintext_d;
	  MEMORY[pc_i] <= plaintext_d;
	end
	else
	  plaintext_q <= `TEXT_WIDTH'bx;
  end

endmodule
