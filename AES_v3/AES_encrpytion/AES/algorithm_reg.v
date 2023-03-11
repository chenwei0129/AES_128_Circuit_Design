`timescale 1ns/100ps
module algorithm_reg(clk_i, cyphertext_d, cyphertext_q);

  input clk_i;
  input [`TEXT_WIDTH - 1:0] cyphertext_d;
  
  output reg [`TEXT_WIDTH - 1:0] cyphertext_q;
  
  always@(posedge clk_i)begin
    cyphertext_q <= cyphertext_d;  
  end

endmodule
