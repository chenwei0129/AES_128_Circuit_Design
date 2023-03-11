`timescale 1ns/100ps
/*
`include "def.v"
`include "pc.v"
`include "controller.v"
`include "subbytes.v"
`include "addroundkey.v"
`include "algorithm_reg.v"
`include "key_expansion.v"
`include "mixcolumns.v"
`include "MUX2_128.v"
`include "MUX10_128.v"
`include "shiftrows.v"
*/
module AES(clk_i, rst_ni, cyphertext_i, key_i, m3_reg_o, finish_o, pc_o);

  input clk_i;
  input rst_ni;
  input [`TEXT_WIDTH - 1:0] cyphertext_i;
  input [`KEY_WIDTH - 1:0] key_i;
  
  output [`TEXT_WIDTH - 1:0] m3_reg_o;
  output finish_o;
  output [`ADDR_WIDTH - 1:0] pc_o;
  
  wire enable;
  wire [`TEXT_WIDTH - 1:0] addround_m1;
  wire [`KEY_WIDTH - 1:0] expansion_addround;
  wire [`TEXT_WIDTH - 1:0] m1_reg;
  wire [`TEXT_WIDTH - 1:0] reg_shift;
  wire [`TEXT_WIDTH - 1:0] shift_subbyte;
  wire [`TEXT_WIDTH - 1:0] subbyte_addround;
  wire [`TEXT_WIDTH - 1:0] addround_mixcolumns;
  wire [`TEXT_WIDTH - 1:0] mixcolumns_m3;
  wire controller_m1;
  wire controller_m3;
  wire [`TEXT_WIDTH - 1:0] m2_addroundkey;
  wire [`KEY_WIDTH - 1:0] key0;
  wire [`KEY_WIDTH - 1:0] key1;
  wire [`KEY_WIDTH - 1:0] key2;
  wire [`KEY_WIDTH - 1:0] key3;
  wire [`KEY_WIDTH - 1:0] key4;
  wire [`KEY_WIDTH - 1:0] key5;
  wire [`KEY_WIDTH - 1:0] key6;
  wire [`KEY_WIDTH - 1:0] key7;
  wire [`KEY_WIDTH - 1:0] key8;
  wire [`KEY_WIDTH - 1:0] key9;
  wire [3:0] controller_m2;
  
  pc pc(.clk_i(clk_i),
        .rst_ni(rst_ni),
		.enable_i(enable),
		.pc_o(pc_o));
  
  addroundkey addroundkey0(.cyphertext_temp_i(cyphertext_i),
                           .key_i(expansion_addround),
						   .cyphertext_temp_o(addround_m1));
  
  MUX2_128 m1(.a(addround_m1),
              .b(m3_reg_o),
			  .s(controller_m1),
			  .o(m1_reg));
  
  algorithm_reg algorithm_reg(.clk_i(clk_i),
                              .cyphertext_d(m1_reg),
							  .cyphertext_q(reg_shift));
  
  inv_shiftrows inv_shiftrows(.cyphertext_temp_i(reg_shift),
                              .cyphertext_temp_o(shift_subbyte));
  
  inv_subbytes inv_subbytes(.clk_i(clk_i),
                            .rst_ni(rst_ni),
                            .cyphertext_temp_i(shift_subbyte),
                            .cyphertext_temp_o(subbyte_addround));
  
  addroundkey addroundkey1(.cyphertext_temp_i(subbyte_addround),
                           .key_i(m2_addroundkey),
						   .cyphertext_temp_o(addround_mixcolumns));
  
  inv_mixcolumns inv_mixcolumns(.clk_i(clk_i),
                                .rst_ni(rst_ni),
                                .cyphertext_temp_i(addround_mixcolumns),
                                .cyphertext_temp_o(mixcolumns_m3));
  
  MUX2_128 m3(.a(addround_mixcolumns),
              .b(mixcolumns_m3),
			  .s(controller_m3),
			  .o(m3_reg_o));
  
  key_expansion key_expansion(.clk_i(clk_i),
                              .rst_ni(rst_ni),
                              .key_i(key_i),
                              .key0_o(key0),
							  .key1_o(key1),
							  .key2_o(key2),
							  .key3_o(key3), 
							  .key4_o(key4),
							  .key5_o(key5),
							  .key6_o(key6),
							  .key7_o(key7),
							  .key8_o(key8),
							  .key9_o(key9),
							  .key_o(expansion_addround));
  
  MUX10_128 m2(.a0(key0),
               .a1(key1),
			   .a2(key2),
			   .a3(key3),
			   .a4(key4),
			   .a5(key5),
			   .a6(key6),
			   .a7(key7),
			   .a8(key8),
			   .a9(key9),
			   .s(controller_m2),
			   .o(m2_addroundkey));
  
  controller controller(.clk_i(clk_i),
                        .rst_ni(rst_ni),
						.enable_o(enable),
						.select1_o(controller_m1),
						.select2_o(controller_m2),
						.select3_o(controller_m3),
						.finish_o(finish_o));

endmodule
