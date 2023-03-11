`timescale 1ns/100ps
module controller(clk_i, rst_ni, enable_o, select1_o, select2_o, finish_o);

  input clk_i;
  input rst_ni;
  
  output reg enable_o;
  output reg select1_o;
  output reg select2_o;
  output reg finish_o;
  
  reg [1:0] state, n_state;
  reg [3:0] counter;
  
  parameter RST      = 2'b00,
			ENCRYPT  = 2'b01,
			DONE     = 2'b10;
  
  always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni)begin
	  state <= RST;
	  counter <= 4'd0;
	end
	else begin
	  state <= n_state;
	  if(n_state==RST)
	    counter <= 4'd0;
	  else
	    counter <= counter + 4'd1;
	end
  end
  
  always@(*)begin
    case(state)
	  RST:begin//counetr=0
	    enable_o = 1'b1;
		select1_o = 1'b0;
		select2_o = 1'bx;
		finish_o = 1'b0;
		n_state = ENCRYPT;
	  end
	  ENCRYPT:begin//round1~round9(key0~key8), counter=1~9
	    enable_o = 1'b0;
		select1_o = 1'b1;
		select2_o = 1'b1;
		finish_o = 1'b0;
		n_state = (counter==4'd9)?DONE:ENCRYPT;
	  end
	  DONE:begin//last round(key9), do not need to oprate mixcolumns(select2_o), counetr=10
	    enable_o = 1'b0;
		select1_o = 1'bx;
		select2_o = 1'b0;
		finish_o = 1'b1;
		n_state = RST;
	  end
	  default:begin
	    enable_o = 1'bx;
		select1_o = 1'bx;
		select2_o = 1'bx;
		finish_o = 1'bx;
		n_state = 2'bx;
	  end
	endcase
  end

endmodule
