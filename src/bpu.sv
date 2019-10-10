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
// File: bpu.sv
// Author: Marco Andorno
// Date: 7/8/2019

import mmm_pkg::*;

module bpu
(
  input   logic             clk_i,
  input   logic             rst_n_i,
  input   logic             flush_i,
  input   logic [XLEN-1:0]  pc_i,
  input   logic             res_valid_i,
  input   logic [XLEN-1:0]  res_pc_i,
  input   logic [HLEN-1:0]  res_index_i,
  input   logic [XLEN-1:0]  res_target_i,
  input   logic             res_taken_i,
  input   logic             res_mispredict_i,

  output  logic [XLEN-1:0]  pred_pc_o,
  output  logic [HLEN-1:0]  pred_index_o,
  output  logic [XLEN-1:0]  pred_target_o,
  output  logic             pred_taken_o
);

  // Signal definitions
  logic btb_res_valid, btb_hit;
  logic gshare_taken;

  // Module instantiations
  gshare u_gshare
  (
    .clk_i          (clk_i),
    .rst_n_i        (rst_n_i),
    .flush_i        (flush_i),
    .pc_i           (pc_i),
    .res_valid_i    (res_valid_i),
    .res_index_i    (res_index_i),
    .res_taken_i    (res_taken_i),

    .taken_o        (gshare_taken),
    .pred_index_o   (pred_index_o)
  );

  btb u_btb
  (
    .clk_i            (clk_i),
    .rst_n_i          (rst_n_i),
    .flush_i          (flush_i),
    .pc_i             (pc_i),
    .update_valid_i   (btb_update),
    .del_entry_i      (btb_del_entry),
    .res_pc_i         (res_pc_i),
    .res_target_i     (res_target_i),

    .hit_o            (btb_hit),
    .pred_target_o    (pred_target_o)
    );
  
  // Assignments
  assign btb_update = res_valid_i & res_mispredict_i;
  assign btb_del_entry = res_mispredict_i & ~res_taken_i;
  assign pred_pc_o = pc_i;
  assign pred_taken_o = gshare_taken & btb_hit;
  
endmodule