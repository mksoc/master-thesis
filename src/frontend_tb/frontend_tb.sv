// Copyright 2019 Politecnico di Torino.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 2.0 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-2.0. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// File: frontend_tb.sv
// Author: Marco Andorno
// Date: 14/10/2019

`timescale 1ns/1ns

import mmm_pkg::*;

module frontend_tb;

  // Declarations
  localparam PERIOD = 10;
  logic clk = '1;
  logic rst_n = '0;
  logic flush = '0;
  logic pred_taken;
  logic [XLEN-1:0] pred_pc, pred_target;
  logic [HLEN-1:0] pred_index;
  logic res_valid, res_taken, res_mispredict;
  logic [XLEN-1:0] res_pc, res_target;
  logic [HLEN-1:0] res_index;
  logic fetch_ready;
  logic [XLEN-1:0] pc;
  logic [XLEN-1:0] addr;
  logic addr_valid;
  logic addr_ready;
  icache_out_t data;
  logic data_valid;
  logic data_ready;
  logic issue_ready;
  logic issue_valid;
  logic [ILEN-1:0] instruction;

  // Clock generator
  always #(PERIOD/2) clk = ~clk;

  // Reset
  initial begin
    #11 rst_n = '1;
  end

  // DUTs instantiations
  pc_gen_stage dut_pc_gen_stage
  (
    .clk_i            (clk),
    .rst_n_i          (rst_n),
    .pred_taken_i     (pred_taken),
    .pred_target_i    (pred_target),
    .res_valid_i      (res_valid),
    .res_taken_i      (res_taken),
    .res_target_i     (res_target),
    .res_mispredict_i (res_mispredict),
    .fetch_ready_i    (fetch_ready),

    .pc_o             (pc)
  );

  fetch_stage dut_fetch_stage
  (
    .clk_i            (clk),
    .rst_n_i          (rst_n),
    .flush_i          (flush),
    
    // From/to PC gen stage
    .pc_i             (pc),
    .fetch_ready_o    (fetch_ready),

    // From/to i-cache
    .addr_o           (addr),
    .addr_valid_o     (addr_valid),
    .addr_ready_i     (addr_ready),
    .data_i           (data),
    .data_valid_i     (data_valid),
    .data_ready_o     (data_ready),

    // From/to instruction decode
    .issue_ready_i    (issue_ready),
    .issue_valid_o    (issue_valid),
    .instruction_o    (instruction),
    .pred_pc_o        (pred_pc),
    .pred_index_o     (pred_index),
    .pred_target_o    (pred_target),
    .pred_taken_o     (pred_taken),

    // From branch unit (ex stage)
    .res_valid_i      (res_valid),
    .res_pc_i         (res_pc),
    .res_index_i      (res_index),
    .res_target_i     (res_target),
    .res_taken_i      (res_taken),
    .res_mispredict_i (res_mispredict)
  );

  // Dummy icache
  always_comb begin
    addr_ready = '1;
    data.pc = pc;
    data.line = {ICACHE_INSTR{NOP}};
    data_valid = '1;
  end

  // Dummy issue queue
  assign issue_ready = '1;

  // Dummy branch unit
  always_comb begin
    res_valid = '0;
    res_pc = '0;
    res_index = '0;
    res_target = '0;
    res_taken = '0;
    res_mispredict = '0;
  end

endmodule