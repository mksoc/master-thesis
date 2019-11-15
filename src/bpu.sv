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

`include "mmm_pkg.sv"
import mmm_pkg::*;

module bpu
(
  input   logic             clk_i,
  input   logic             rst_n_i,
  input   logic             flush_i,
  input   logic [XLEN-1:0]  pc_i,
  input   resolution_t      res_i,

  output  prediction_t      pred_o
);

  // Signal definitions
  logic btb_res_valid, btb_hit, btb_update, btb_del_entry;
  logic gshare_taken;
  logic [XLEN-OFFSET-1:0] btb_target;

  // Module instantiations
  gshare u_gshare
  (
    .clk_i          (clk_i),
    .rst_n_i        (rst_n_i),
    .flush_i        (flush_i),
    .pc_i           (pc_i),
    .res_i          (res_i),

    .taken_o        (gshare_taken)
  );

  btb u_btb
  (
    .clk_i            (clk_i),
    .rst_n_i          (rst_n_i),
    .flush_i          (flush_i),
    .pc_i             (pc_i),
    .valid_i          (btb_update),
    .del_entry_i      (btb_del_entry),
    .res_i            (res_i),

    .hit_o            (btb_hit),
    .target_o         (btb_target)
    );
  
  // Assignments
  assign btb_update     = res_i.valid & res_i.mispredict;
  assign btb_del_entry  = res_i.mispredict & ~res_i.taken;
  assign pred_o.pc      = pc_i;
  assign pred_o.taken   = gshare_taken & btb_hit;
  assign pred_o.target  = {btb_target, 2'b00};
  
endmodule