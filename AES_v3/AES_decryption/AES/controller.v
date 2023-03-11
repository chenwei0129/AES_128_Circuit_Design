`timescale 1ns/100ps
module controller(clk_i, rst_ni, key_ready_i, enable_o, select1_o, select3_o, finish_o, counter_o);

  input clk_i;
  input rst_ni;
  input key_ready_i;
  
  output enable_o;
  output select1_o;
  output select3_o;
  output finish_o;
  output [3:0] counter_o;
  
  reg enable_o;
  reg select1_o;
  reg select3_o;
  reg finish_o;
  
  reg [1:0] state, n_state;
  reg [3:0] counter_o;
  
  parameter RST      = 2'b00,
			ENCRYPT  = 2'b01,
			DONE     = 2'b10;
  
  always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni)begin
	  state <= RST;
	  counter_o <= 4'd0;
	end
	else begin
	  state <= n_state;
	  if(n_state==RST)
	    counter_o <= 4'd0;
	  else
	    counter_o <= counter_o + 4'd1;
	end
  end
  
  always@(*)begin
    case(state)
	  RST:begin
	    enable_o = (key_ready_i)?1'b1:1'b0;
		select1_o = 1'b0;
		select3_o = 1'b0;//x
		finish_o = 1'b0;
		n_state = (key_ready_i)?ENCRYPT:RST;
	  end
	  ENCRYPT:begin
	    enable_o = 1'b0;
		select1_o = 1'b1;
		select3_o = 1'b1;
		finish_o = 1'b0;
		n_state = (counter_o==4'd9)?DONE:ENCRYPT;
	  end
	  DONE:begin
	    enable_o = 1'b0;
		select1_o = 1'b0;//x
		select3_o = 1'b0;
		finish_o = 1'b1;
		n_state = RST;
	  end
	  default:begin
	    enable_o = 1'bx;
		select1_o = 1'bx;
		select3_o = 1'bx;
		finish_o = 1'bx;
		n_state = 2'bx;
	  end
	endcase
  end

endmodule
