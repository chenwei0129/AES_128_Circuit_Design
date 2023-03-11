`timescale 1ns/100ps
module MUX10_128(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, s, o);

  input [`KEY_WIDTH - 1:0] a0;
  input [`KEY_WIDTH - 1:0] a1;
  input [`KEY_WIDTH - 1:0] a2;
  input [`KEY_WIDTH - 1:0] a3;
  input [`KEY_WIDTH - 1:0] a4;
  input [`KEY_WIDTH - 1:0] a5;
  input [`KEY_WIDTH - 1:0] a6;
  input [`KEY_WIDTH - 1:0] a7;
  input [`KEY_WIDTH - 1:0] a8;
  input [`KEY_WIDTH - 1:0] a9;
  input [3:0] s;
  
  output [`KEY_WIDTH - 1:0] o;
  
  reg [`KEY_WIDTH - 1:0] o;
  
  always@(*)begin
    case(s)
      4'd0:o = a0;
	  4'd1:o = a1;
	  4'd2:o = a2;
	  4'd3:o = a3;
	  4'd4:o = a4;
	  4'd5:o = a5;
	  4'd6:o = a6;
	  4'd7:o = a7;
	  4'd8:o = a8;
	  4'd9:o = a9;
	  default:o = `KEY_WIDTH'bx;
    endcase	
  end

endmodule
