`include "AES/def.v"
`include "RAM/cyphertext_RAM.v"
`include "ROM/plaintext_key_ROM.v"
`include "ROM/S_box_ROM.v"
`include "AES/pc.v"
`include "AES/controller.v"
`include "AES/addroundkey.v"
`include "AES/algorithm_reg.v"
`include "AES/key_expansion.v"
`include "AES/mixcolumns.v"
`include "AES/MUX2_128.v"
`include "AES/shiftrows.v"

`ifdef syn
`include "AES/tsmc13.v"
`include "AES/AES_syn_8.v"
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
  wire [`TEXT_WIDTH - 1:0] AES_S_box;
  wire [`TEXT_WIDTH - 1:0] S_box_AES;
  wire [`FOUR_BYTE_WIDTH - 1:0] W3_S_box;
  wire [`FOUR_BYTE_WIDTH - 1:0] S_box_W3;
  
  integer fp_w, i;
  
  AES AES(.clk_i              (clk_i),
          .rst_ni             (rst_ni),
		  .plaintext_i        (plaintext),
		  .key_i              (key),
		  .subbytes_rowshift_i(S_box_AES),
		  .W3_i               (S_box_W3),
		  .addroundkey_reg_o  (addroundkey_reg_o),
		  .finish_o           (finish_o),
		  .pc_o               (pc),
		  .reg_subbytes_o     (AES_S_box),
		  .W3_o               (W3_S_box));
		  
  plaintext_key_ROM plaintext_key_ROM(.clk_i      (clk_i),
                                      .pc_i       (pc),
								      .plaintext_q(plaintext),
									  .key_q      (key));
  
  cyphertext_RAM cyphertext_RAM(.clk_i       (clk_i),
                                .pc_i        (pc),
                                .finish_d    (finish_o),
								.cyphertext_d(addroundkey_reg_o),
								.cyphertext_q(cyphertext_o));
  
  S_box_ROM S_box_ROM(.clk_i            (clk_i),
                      .cyphertext_temp_i(AES_S_box),
                      .W_i              (W3_S_box),
                      .cyphertext_temp_o(S_box_AES),
					  .W_o              (S_box_W3));

  `ifdef syn
  initial $sdf_annotate ("AES/AES_syn_8.sdf", AES);
  `endif

  always #(`CYCLE/2) clk_i = ~clk_i;

  initial begin
    fp_w = $fopen("text/cyphertext_ascii.txt", "w");
	$monitor("%d %h",$time, cyphertext_o);
	$readmemh("text/plaintext_ascii.txt",plaintext_key_ROM.ROM);
	$readmemh("text/key.txt",plaintext_key_ROM.KEY_ROM);
	$readmemh("text/S_box.txt",S_box_ROM.S_box);
	/*
	$fsdbDumpfile("AES.fsdb");
	$fsdbDumpMDA;
	$fsdbDumpvars;
	*/
	
                    clk_i = 1'b0;
	                rst_ni = 1'b1;
    #(`CYCLE/5)     rst_ni = 1'b0;
	#`CYCLE         rst_ni = 1'b1;
	#(`CYCLE*530)
	for(i=0;i<`MEMORY_SIZE;i=i+1)begin
	  if(cyphertext_RAM.RAM[i]!==`TEXT_WIDTH'bx)
	    $fwrite(fp_w, "%h", cyphertext_RAM.RAM[i]);
    end
	#(`CYCLE)  $finish;
	
  end

endmodule
