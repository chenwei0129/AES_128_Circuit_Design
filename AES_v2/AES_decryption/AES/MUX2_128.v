`timescale 1ns/100ps
module MUX2_128(a, b, s, o);

  input [`TEXT_WIDTH - 1:0] a;
  input [`TEXT_WIDTH - 1:0] b;
  input s;
  
  output [`TEXT_WIDTH - 1:0] o;
  
  assign o = (s)?b:a;

endmodule
