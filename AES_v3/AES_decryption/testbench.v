`include "AES/def.v"
`include "RAM/plaintext_memory.v"
`include "ROM/cyphertext_key_memory.v"
`include "ROM/inv_S_box_memory.v"
`include "ROM/S_box_memory.v"
`include "AES/pc.v"
`include "AES/controller.v"
`include "AES/addroundkey.v"
`include "AES/algorithm_reg.v"
`include "AES/key_expansion.v"
`include "AES/inv_mixcolumns.v"
`include "AES/MUX2_128.v"
`include "AES/inv_shiftrows.v"

`ifdef syn
`include "AES/tsmc13.v"
`include "AES/AES_syn_12.v"
`else
`include "AES/AES.v"
`endif

`timescale 1ns/100ps
module testbench;

  reg clk_i;
  reg rst_ni;
  
  wire [`TEXT_WIDTH - 1:0] cyphertext;
  wire [`ADDR_WIDTH - 1:0] pc;
  wire [`TEXT_WIDTH - 1:0] plaintext_o;
  wire finish_o;
  wire [`TEXT_WIDTH - 1:0] addroundkey_reg_o;
  wire [`KEY_WIDTH - 1:0] key;
  wire [`TEXT_WIDTH - 1:0] inv_S_box_AES;
  wire [`TEXT_WIDTH - 1:0] AES_inv_S_box;
  wire [`FOUR_BYTE_WIDTH - 1:0] S_box_AES;
  wire [`FOUR_BYTE_WIDTH - 1:0] AES_S_box;
  
  integer fp_w, i;
  
  AES AES(.clk_i             (clk_i),
          .rst_ni            (rst_ni),
		  .cyphertext_i      (cyphertext),
		  .key_i             (key),
		  .W3_i              (S_box_AES),
		  .subbyte_addround_i(inv_S_box_AES),
		  .m3_reg_o          (addroundkey_reg_o),
		  .finish_o          (finish_o),
		  .pc_o              (pc),
		  .shift_subbyte_o   (AES_inv_S_box),
		  .W3_o              (AES_S_box));
		  
  cyphertext_key_memory cyphertext_key_memory(.clk_i       (clk_i),
                                              .pc_i        (pc),
								        	  .cyphertext_q(cyphertext),
									          .key_q       (key));
  
  plaintext_memory plaintext_memory(.clk_i      (clk_i),
                                    .pc_i       (pc),
                                    .finish_d   (finish_o),
								    .plaintext_d(addroundkey_reg_o),
								    .plaintext_q(plaintext_o));
  
  inv_S_box_memory inv_S_box_memory(.clk_i            (clk_i),
                                    .cyphertext_temp_i(AES_inv_S_box),
									.cyphertext_temp_o(inv_S_box_AES));
  
  S_box_memory S_box_memory(.clk_i(clk_i),
                            .W_i  (AES_S_box),
							.W_o  (S_box_AES));
  
  `ifdef syn
  initial $sdf_annotate ("AES/AES_syn_12.sdf", AES);
  `endif

  always #(`CYCLE/2) clk_i = ~clk_i;

  initial begin
    fp_w = $fopen("text/plaintext_ascii.txt", "w");
	$readmemh("text/cyphertext_ascii.txt",cyphertext_key_memory.MEMORY);
	$readmemh("text/key.txt",cyphertext_key_memory.KEY_MEMORY);
	$readmemh("text/inv_S_box.txt",inv_S_box_memory.inv_S_box);
	$readmemh("text/S_box.txt",S_box_memory.S_box);
	//$monitor("%h", AES.expansion_addround);
	/*
	$fsdbDumpfile("AES.fsdb");
	$fsdbDumpMDA;
	$fsdbDumpvars;
	*/
	
                    clk_i = 1'b0;
	                rst_ni = 1'b1;
    #(`CYCLE/5)     rst_ni = 1'b0;
	#`CYCLE         rst_ni = 1'b1;
	#(`CYCLE*540)
	for(i=0;i<`MEMORY_SIZE;i=i+1)begin
	  if(plaintext_memory.MEMORY[i]!==`TEXT_WIDTH'bx)
	    $fwrite(fp_w, "%h", plaintext_memory.MEMORY[i]);
    end
	#(`CYCLE)  $finish;
	
  end
  
endmodule
