`timescale 1ns/100ps
module mixcolumns(clk_i, rst_ni, cyphertext_temp_i, cyphertext_temp_o);

  input clk_i;
  input rst_ni;
  input [`TEXT_WIDTH - 1:0] cyphertext_temp_i;
  
  output [`TEXT_WIDTH - 1:0] cyphertext_temp_o;
  
  reg [`BYTE_WIDTH - 1:0] output_component [0:`MATRIX_SIZE - 1];
  
  reg [1:0] mix_matrix [0:`MATRIX_SIZE - 1];
  
  wire [`BYTE_WIDTH - 1:0] cypher_matrix [0:`MATRIX_SIZE - 1];
  
  integer i;
  integer j;
  integer k;
  
  assign cypher_matrix[0] = cyphertext_temp_i[127:120];
  assign cypher_matrix[1] = cyphertext_temp_i[95:88];
  assign cypher_matrix[2] = cyphertext_temp_i[63:56];
  assign cypher_matrix[3] = cyphertext_temp_i[31:24];
  assign cypher_matrix[4] = cyphertext_temp_i[119:112];
  assign cypher_matrix[5] = cyphertext_temp_i[87:80];
  assign cypher_matrix[6] = cyphertext_temp_i[55:48];
  assign cypher_matrix[7] = cyphertext_temp_i[23:16];
  assign cypher_matrix[8] = cyphertext_temp_i[111:104];
  assign cypher_matrix[9] = cyphertext_temp_i[79:72];
  assign cypher_matrix[10] = cyphertext_temp_i[47:40];
  assign cypher_matrix[11] = cyphertext_temp_i[15:8];
  assign cypher_matrix[12] = cyphertext_temp_i[103:96];
  assign cypher_matrix[13] = cyphertext_temp_i[71:64];
  assign cypher_matrix[14] = cyphertext_temp_i[39:32];
  assign cypher_matrix[15] = cyphertext_temp_i[7:0];
  
  assign cyphertext_temp_o = {output_component[0],
                              output_component[4],
                              output_component[8],
                              output_component[12],
                              output_component[1],
                              output_component[5],
                              output_component[9],
                              output_component[13],
                              output_component[2],
                              output_component[6],
                              output_component[10],
                              output_component[14],
                              output_component[3],
                              output_component[7],
                              output_component[11],
                              output_component[15]};
  
  always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni)begin
	  mix_matrix[0] <= 2'd2;
      mix_matrix[1] <= 2'd3;
      mix_matrix[2] <= 2'd1;
      mix_matrix[3] <= 2'd1;
      mix_matrix[4] <= 2'd1;
      mix_matrix[5] <= 2'd2;
      mix_matrix[6] <= 2'd3;
      mix_matrix[7] <= 2'd1;
      mix_matrix[8] <= 2'd1;
      mix_matrix[9] <= 2'd1;
      mix_matrix[10] <= 2'd2;
      mix_matrix[11] <= 2'd3;
      mix_matrix[12] <= 2'd3;
      mix_matrix[13] <= 2'd1;
      mix_matrix[14] <= 2'd1;
      mix_matrix[15] <= 2'd2;
	end
	else begin
	  mix_matrix[0] <= mix_matrix[0];
      mix_matrix[1] <= mix_matrix[1];
      mix_matrix[2] <= mix_matrix[2];
      mix_matrix[3] <= mix_matrix[3];
      mix_matrix[4] <= mix_matrix[4];
      mix_matrix[5] <= mix_matrix[5];
      mix_matrix[6] <= mix_matrix[6];
      mix_matrix[7] <= mix_matrix[7];
      mix_matrix[8] <= mix_matrix[8];
      mix_matrix[9] <= mix_matrix[9];
      mix_matrix[10] <= mix_matrix[10];
      mix_matrix[11] <= mix_matrix[11];
      mix_matrix[12] <= mix_matrix[12];
      mix_matrix[13] <= mix_matrix[13];
      mix_matrix[14] <= mix_matrix[14];
      mix_matrix[15] <= mix_matrix[15];
	end
  end
  
  always@(*)begin
    for(i=0;i<4;i=i+1)
	  for(j=0;j<4;j=j+1)begin
	    output_component[4*i+j] = `BYTE_WIDTH'd0;
	    for(k=0;k<4;k=k+1)
	      output_component[4*i+j] = output_component[4*i+j] ^ calculate(cypher_matrix[4*k+j], mix_matrix[4*i+k]);
	  end
  end

  function [`BYTE_WIDTH - 1:0] calculate;
    input [`BYTE_WIDTH - 1:0] cyphertext;
	input [1:0] matrix;
	if(matrix==2'b01)
	  calculate = cyphertext;
	else if(matrix==2'b10)begin
	  if(cyphertext[`BYTE_WIDTH - 1])
	    calculate = (cyphertext<<1) ^ 8'b0001_1011;
	  else
	    calculate = cyphertext<<1;
	end
	else begin
	  if(cyphertext[`BYTE_WIDTH - 1])
	    calculate = cyphertext ^ ((cyphertext<<1) ^ 8'b0001_1011);
	  else
	    calculate = cyphertext ^ (cyphertext<<1);
	end
  endfunction

endmodule
