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
// File: fetch_unit.sv
// Author: Marco Andorno
// Date: 03/10/2019

import mmm_pkg::*;

module fetch_unit
(
  input   logic             clk_i,
  input   logic             rst_n_i,
  input   logic             flush_i,

  // From/to PC gen
  input   logic [XLEN-1:0]  pc_i,
  output  logic             fetch_ready_o,

  // From/to i-cache interface
  input   icache_out_t      cache_out_i,
  input   logic             read_done_i,
  output  logic             read_req_o,

  // From/to instruction decode
  input   logic             issue_ready_i,
  output  logic             issue_valid_o,
  output  logic [ILEN-1:0]  instruction_o
);

  // Signal declarations
  logic read_req, read_done;
  icache_out_t line_reg_d, line_reg_q;
  icache_out_t line_bak_d, line_bak_q;
  logic fetch_ready;
  logic here, will_be_here;
  pc_src_t selector_pc;
  line_src_t selector_line;
  logic [XLEN-1:0] prev_pc_d, prev_pc_q;

  // --------
  // Line reg
  // --------
  assign line_reg_d = read_done ? cache_out_i : line_reg_q;

  always_ff @ (posedge clk_i or negedge rst_n_i) begin: line_reg
    if (!rst_n_i)     line_reg_q <= '0;
    else if (flush_i) line_reg_q <= '0;
    else              line_reg_q <= line_reg_d;
  end: line_reg

  // --------
  // Line reg
  // --------
  assign line_bak_d = fetch_ready ? line_reg_q : line_bak_q;

  always_ff @ (posedge clk_i or negedge rst_n_i) begin: line_bak
    if (!rst_n_i)     line_bak_q <= '0;
    else if (flush_i) line_bak_q <= '0;
    else              line_bak_q <= line_bak_d;
  end: line_bak

  // ----------------
  // Fetch controller
  // ----------------
  fetch_cu u_fetch_cu
  (
    .clk_i            (clk_i),
    .rst_n_i          (rst_n_i),
    .flush_i          (flush_i),
    .here_i           (here),
    .will_be_here_i   (will_be_here),
    .issue_ready_i    (issue_ready_i),
    .read_done_i      (read_done_i),

    .fetch_ready_o    (fetch_ready),
    .read_req_o       (read_req_o),
    .issue_valid_o    (issue_valid_o),
    .selector_pc_o    (selector_pc),
    .selector_line_o  (selector_line)
  );

  // -------
  // Prev PC
  // -------
  assign prev_pc_d = fetch_ready ? pc_i : prev_pc_q;

  always_ff @ (posedge clk_i or negedge rst_n_i) begin: prev_pc
    if (!rst_n_i)     prev_pc_q <= '0;
    else if (flush_i) prev_pc_q <= '0;
    else              prev_pc_q <= prev_pc_d;
  end: prev_pc

  // ----------------
  // Presence checker
  // ----------------
  presence_checker u_presence_checker
  (
    .pc_i           (pc_i),
    .prev_pc_i      (prev_pc_q),
    .line_pc_i      (line_reg_q.pc),

    .here_o         (here),
    .will_be_here_o (will_be_here)
  );

  // --------------------
  // Instruction selector
  // --------------------
  instruction_selector u_instruction_selector
  (
    .cache_out_i    (cache_out_i.line),
    .line_reg_i     (line_reg_q.line),
    .line_bak_i     (line_bak_q.line),
    .pc_i           (pc_i[ICACHE_OFFSET-1:0]),
    .prev_pc_i      (prev_pc_q[ICACHE_OFFSET-1:0]),
    .line_pc_i      (line_reg_q.pc[ICACHE_OFFSET-1:0]),
    .pc_sel_i       (selector_pc),
    .line_sel_i     (selector_line),

    .instruction_o  (instruction_o)
  );

  // In case of flush, be ready to fetch next PC
  // at the following cycle
  assign fetch_ready_o = fetch_ready | flush_i;

endmodule