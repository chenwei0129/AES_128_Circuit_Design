`include "AES/def.v"
`include "RAM/cyphertext_memory.v"
`include "ROM/plaintext_key_memory.v"
`include "AES/pc.v"
`include "AES/controller.v"
`include "AES/subbytes.v"
`include "AES/addroundkey.v"
`include "AES/algorithm_reg.v"
`include "AES/key_expansion.v"
`include "AES/mixcolumns.v"
`include "AES/MUX2_128.v"
`include "AES/MUX10_128.v"
`include "AES/shiftrows.v"

`ifdef syn
`include "AES/tsmc18.v"
`include "AES/AES_syn.v"
`else
`include "AES/AES.v"
`endif

`timescale 1ns/100ps
module testbench;

  reg clk_i;
  reg rst_ni;
  
  wire [`TEXT_WIDTH - 1:0] plaintext;
  wire [`ADDR_WIDTH - 1:0] pc;
  wire [`TEXT_WIDTH - 1:0] cyphertext_o;
  wire finish_o;
  wire [`TEXT_WIDTH - 1:0] addroundkey_reg_o;
  wire [`KEY_WIDTH - 1:0] key;
  
  integer fp_w, i;
  
  AES AES(.clk_i(clk_i),
          .rst_ni(rst_ni),
		  .plaintext_i(plaintext),
		  .key_i(key),
		  .addroundkey_reg_o(addroundkey_reg_o),
		  .finish_o(finish_o),
		  .pc_o(pc));
		  
  plaintext_key_memory plaintext_key_memory(.pc_i(pc),
								        	.plaintext_q(plaintext),
									        .key_q(key));
  
  cyphertext_memory cyphertext_memory(.clk_i(clk_i),
                                      .pc_i(pc),
                                      .finish_d(finish_o),
								      .cyphertext_d(addroundkey_reg_o),
								      .cyphertext_q(cyphertext_o));

`ifdef syn
initial $sdf_annotate ("AES/AES_syn.sdf", AES);
`endif

  always #(`CYCLE/2) clk_i = ~clk_i;

  initial begin
    fp_w = $fopen("text/cyphertext_ascii.txt", "w");
	$readmemh("text/plaintext_ascii.txt",plaintext_key_memory.MEMORY);
	$readmemh("text/key.txt",plaintext_key_memory.KEY_MEMORY);
	/*
	$fsdbDumpfile("AES.fsdb");
	$fsdbDumpMDA;
	$fsdbDumpvars;
	*/
	
                    clk_i = 1'b0;
	                rst_ni = 1'b1;
    #(`CYCLE/5)     rst_ni = 1'b0;
	#`CYCLE         rst_ni = 1'b1;
	#(`CYCLE*400)
	for(i=0;i<`MEMORY_SIZE;i=i+1)begin
	  if(cyphertext_memory.MEMORY[i]!==`TEXT_WIDTH'bx)
	    $fwrite(fp_w, "%h", cyphertext_memory.MEMORY[i]);
    end
	#(`CYCLE)  $stop;
	
  end

endmodule
