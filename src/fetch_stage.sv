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
// File: fetch_stage.sv
// Author: Marco Andorno
// Date: 07/10/2019

import mmm_pkg::*;

module fetch_stage
(
  input   logic             clk_i,
  input   logic             rst_n_i,
  input   logic             flush_i,
  
  // From/to PC gen stage
  input   logic [XLEN-1:0]  pc_i,
  output  logic             fetch_ready_o,

  // From/to i-cache
  output  logic [XLEN-1:0]  addr_o,
  output  logic             addr_valid_o,
  input   logic             addr_ready_i,
  input   icache_out_t      data_i,
  input   logic             data_valid_i,
  output  logic             data_ready_o,

  // From/to instruction decode
  input   logic             issue_ready_i,
  output  logic             issue_valid_o,
  output  logic [ILEN-1:0]  instruction_o,
  output  logic [XLEN-1:0]  pred_pc_o,
  output  logic [HLEN-1:0]  pred_index_o,
  output  logic [XLEN-1:0]  pred_target_o,
  output  logic             pred_taken_o,

  // From branch unit (ex stage)
  input   logic             res_valid_i,
  input   logic [XLEN-1:0]  res_pc_i,
  input   logic [HLEN-1:0]  res_index_i,
  input   logic [XLEN-1:0]  res_target_i,
  input   logic             res_taken_i,
  input   logic             res_mispredict_i
);

  // Signal declarations
  logic read_req, read_done, bpu_flush;
  icache_out_t cache_out;
  
  // -----------------
  // I-cache interface
  // -----------------
  icache_interface u_icache_interface
  (
    .clk_i        (clk_i),
    .rst_n_i      (rst_n_i),
    .flush_i      (flush_i),

    // From/to IF
    .pc_i         (pc_i),
    .read_req_i   (read_req),
    .cache_out_o  (cache_out),
    .read_done_o  (read_done),

    // From/to icache
    .addr_o       (addr_o),
    .addr_valid_o (addr_valid_o),
    .addr_ready_i (addr_ready_i),
    .data_i       (data_i),
    .data_valid_i (data_valid_i),
    .data_ready_o (data_ready_o)
  );

  // ----------
  // Fetch unit
  // ----------
  fetch_unit u_fetch_unit
  (
    .clk_i          (clk_i),
    .rst_n_i        (rst_n_i),
    .flush_i        (flush_i),

    // From/to PC gen
    .pc_i           (pc_i),
    .fetch_ready_o  (fetch_ready_o),

    // From/to i-cache interface
    .cache_out_i    (cache_out),
    .read_done_i    (read_done),
    .read_req_o     (read_req),

    // From/to instruction decode
    .issue_ready_i  (issue_ready_i),
    .issue_valid_o  (issue_valid_o),
    .instruction_o  (instruction_o)
  );

  // ---------
  //    BPU
  // ---------
  bpu u_bpu
  (
    .clk_i            (clk_i),
    .rst_n_i          (rst_n_i),
    .flush_i          (bpu_flush),
    .pc_i             (pc_i),
    .res_valid_i      (res_valid_i),
    .res_pc_i         (res_pc_i),
    .res_index_i      (res_index_i),
    .res_target_i     (res_target_i),
    .res_taken_i      (res_taken_i),
    .res_mispredict_i (res_mispredict_i),

    .pred_pc_o        (pred_pc_o),
    .pred_index_o     (pred_index_o),
    .pred_target_o    (pred_target_o),
    .pred_taken_o     (pred_taken_o)
  );

  // If the flush is caused by a misprediction,
  // there no need to flush the BPU, just update it
  assign bpu_flush = flush_i & ~res_mispredict_i;

endmodule