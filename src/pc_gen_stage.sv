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
// File: pc_gen_stage.sv
// Author: Marco Andorno
// Date: 03/10/2019

import mmm_pkg::*;

module pc_gen_stage
(
  input   logic             clk_i,
  input   logic             rst_n_i,
  input   logic             except_i,
  input   logic [XLEN-1:0]  except_pc_i,
  input   logic             res_valid_i,
  input   logic [XLEN-1:0]  res_pc_i,
  input   logic             res_taken_i,
  input   logic [XLEN-1:0]  res_target_i,
  input   logic             res_mispredict_i, 
  input   logic             pred_taken_i,
  input   logic [XLEN-1:0]  pred_target_i,
  input   logic             fetch_ready_i,

  output  logic [XLEN-1:0]  pc_o
);
  
  // Logic declarations
  logic [XLEN-1:0] next_pc, add_pc, adder_out;

  // Mux + adder
  add_pc = (res_valid_i && res_mispredict_i) ? res_pc_i : pc_o;
  adder_out = add_pc + ILEN/8;

  // Priority list for choosing next PC:
  // 1) Exception
  // 2) Misprediction
  // 3) Branch prediction
  // 4) Default PC+4
  always_comb begin: pc_priority_enc
    if (except_i) begin
      next_pc = except_pc_i;
    end else if (res_valid_i && res_mispredict_i) begin
      if (res_taken_i) begin
        next_pc = res_target_i;
      end else begin
        next_pc = adder_out;
      end
    end else if (pred_taken_i) begin
      next_pc = pred_target_i;
    end else begin
      next_pc = adder_out;
    end
  end: pc_priority_enc

  // PC update
  always_ff @ (posedge clk_i or negedge rst_n_i) begin: pc_reg  
    if (!rst_n_i) begin
      pc_o <= BOOT_PC;
    end else begin
      if (fetch_ready_i) begin
        pc_o <= next_pc;
      end
    end
  end: pc_reg
endmodule