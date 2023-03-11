`timescale 1ns/100ps
/*
`include "def.v"
`include "pc.v"
`include "controller.v"
`include "addroundkey.v"
`include "algorithm_reg.v"
`include "key_expansion.v"
`include "inv_mixcolumns.v"
`include "MUX2_128.v"
`include "inv_shiftrows.v"
*/
module AES(clk_i, rst_ni, cyphertext_i, key_i, subbyte_addround_i, W3_i, m3_reg_o, finish_o, pc_o, shift_subbyte_o, W3_o);

  input clk_i;
  input rst_ni;
  input [`TEXT_WIDTH - 1:0] cyphertext_i;
  input [`KEY_WIDTH - 1:0] key_i;
  input [`TEXT_WIDTH - 1:0] subbyte_addround_i;
  input [`FOUR_BYTE_WIDTH - 1:0] W3_i;
  
  output [`TEXT_WIDTH - 1:0] m3_reg_o;
  output finish_o;
  output [`ADDR_WIDTH - 1:0] pc_o;
  output [`TEXT_WIDTH - 1:0] shift_subbyte_o;
  output [`FOUR_BYTE_WIDTH - 1:0] W3_o;
  
  wire enable;
  wire ready;
  wire [3:0] counter;
  wire [`TEXT_WIDTH - 1:0] addround_m1;
  wire [`KEY_WIDTH - 1:0] expansion_addround;
  wire [`TEXT_WIDTH - 1:0] m1_reg;
  wire [`TEXT_WIDTH - 1:0] reg_shift;
  wire [`TEXT_WIDTH - 1:0] addround_mixcolumns;
  wire [`TEXT_WIDTH - 1:0] mixcolumns_m3;
  wire controller_m1;
  wire controller_m3;
  wire [`TEXT_WIDTH - 1:0] m2_addroundkey;
  wire [`FOUR_BYTE_WIDTH - 1:0] W0;
  wire [`FOUR_BYTE_WIDTH - 1:0] W1;
  wire [`FOUR_BYTE_WIDTH - 1:0] W2;
  wire [`KEY_WIDTH - 1:0] key;
  wire [`TEXT_WIDTH - 1:0] inside_mix;
  
  pc pc(.clk_i   (clk_i),
        .rst_ni  (rst_ni),
		.enable_i(enable),
		.pc_o    (pc_o));
  
  addroundkey addroundkey0(.cyphertext_temp_i(cyphertext_i),
                           .key_i            (expansion_addround),
						   .cyphertext_temp_o(addround_m1));
  
  MUX2_128 m1(.a(addround_m1),
              .b(m3_reg_o),
			  .s(controller_m1),
			  .o(m1_reg));
  
  algorithm_reg algorithm_reg(.clk_i       (clk_i),
                              .cyphertext_d(m1_reg),
							  .cyphertext_q(reg_shift));
  
  inv_shiftrows inv_shiftrows(.cyphertext_temp_i(reg_shift),
                              .cyphertext_temp_o(shift_subbyte_o));
  
  addroundkey addroundkey1(.cyphertext_temp_i(subbyte_addround_i),
                           .key_i            (m2_addroundkey),
						   .cyphertext_temp_o(addround_mixcolumns));
  
  pre_process pre_process(.cyphertext_temp_i(addround_mixcolumns),
                          .cyphertext_temp_o(inside_mix));
  
  inv_mixcolumns inv_mixcolumns(.cyphertext_temp_i(inside_mix),
                                .cyphertext_temp_o(mixcolumns_m3));
  
  MUX2_128 m3(.a(addround_mixcolumns),
              .b(mixcolumns_m3),
			  .s(controller_m3),
			  .o(m3_reg_o));
  
  key_expansion key_expansion(.clk_i      (clk_i),
                              .rst_ni     (rst_ni),
							  .number_i   (counter),
                              .key_i      (key_i),
							  .W_S_box    (W3_i),
							  .key_o      (m2_addroundkey),
							  .key_first_o(expansion_addround),
							  .key_ready_o(ready),
							  .W3_o       (W3_o));
  
  controller controller(.clk_i      (clk_i),
                        .rst_ni     (rst_ni),
						.key_ready_i(ready),
						.enable_o   (enable),
						.select1_o  (controller_m1),
						.select3_o  (controller_m3),
						.finish_o   (finish_o),
						.counter_o  (counter));

endmodule
