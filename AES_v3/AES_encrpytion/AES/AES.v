`timescale 1ns/100ps
/*
`include "def.v"
`include "pc.v"
`include "controller.v"
`include "addroundkey.v"
`include "algorithm_reg.v"
`include "key_expansion.v"
`include "mixcolumns.v"
`include "MUX2_128.v"
`include "shiftrows.v"
*/
module AES(clk_i, rst_ni, plaintext_i, key_i, subbytes_rowshift_i, W3_i, addroundkey_reg_o, finish_o, pc_o, reg_subbytes_o, W3_o);

  input clk_i;
  input rst_ni;
  input [`TEXT_WIDTH - 1:0] plaintext_i;
  input [`KEY_WIDTH - 1:0] key_i;
  input [`TEXT_WIDTH - 1:0] subbytes_rowshift_i;
  input [`FOUR_BYTE_WIDTH - 1:0] W3_i;
  
  output [`TEXT_WIDTH - 1:0] addroundkey_reg_o;
  output finish_o;
  output [`ADDR_WIDTH - 1:0] pc_o;
  output [`TEXT_WIDTH - 1:0] reg_subbytes_o;
  output [`FOUR_BYTE_WIDTH - 1:0] W3_o;
  
  wire enable;
  wire [`TEXT_WIDTH - 1:0] xor_m1;
  wire [`TEXT_WIDTH - 1:0] m1_reg;
  wire [`TEXT_WIDTH - 1:0] rowshift_mixcolumns;
  wire [`TEXT_WIDTH - 1:0] mixcolumns_m2;
  wire [`TEXT_WIDTH - 1:0] m2_addroundkey;
  wire controller_m1;
  wire controller_m2;
  wire [`TEXT_WIDTH - 1:0] key0;
  wire [`FOUR_BYTE_WIDTH - 1:0] W0;
  wire [`FOUR_BYTE_WIDTH - 1:0] W1;
  wire [`FOUR_BYTE_WIDTH - 1:0] W2;
  
  pc pc(.clk_i   (clk_i),
        .rst_ni  (rst_ni),
		.enable_i(enable),
		.pc_o    (pc_o));
  
  addroundkey addroundkey0(.cyphertext_temp_i(plaintext_i),
                           .key_i            (key_i),
						   .cyphertext_temp_o(xor_m1));
  
  MUX2_128 m1(.a(xor_m1),
              .b(addroundkey_reg_o),
			  .s(controller_m1),
			  .o(m1_reg));
  
  algorithm_reg algorithm_reg(.clk_i       (clk_i),
                              .cyphertext_d(m1_reg),
							  .cyphertext_q(reg_subbytes_o));
  
  shiftrows shiftrows(.cyphertext_temp_i(subbytes_rowshift_i),
                      .cyphertext_temp_o(rowshift_mixcolumns));
  
  mixcolumns mixcolumns(.cyphertext_temp_i(rowshift_mixcolumns),
                        .cyphertext_temp_o(mixcolumns_m2));
  
  MUX2_128 m2(.a(rowshift_mixcolumns),
              .b(mixcolumns_m2),
			  .s(controller_m2),
			  .o(m2_addroundkey));
  
  addroundkey addroundkey1(.cyphertext_temp_i(m2_addroundkey),
                           .key_i            (key0),
						   .cyphertext_temp_o(addroundkey_reg_o));
  
  key_expansion key_expansion(.clk_i (clk_i),
                              .rst_ni(rst_ni),
                              .key_i (key_i),
							  .W_S_box(W3_i),
							  .W3_o  (W3_o),
							  .key_o(key0));
  
  controller controller(.clk_i    (clk_i),
                        .rst_ni   (rst_ni),
						.enable_o (enable),
						.select1_o(controller_m1),
						.select2_o(controller_m2),
						.finish_o (finish_o));

endmodule
