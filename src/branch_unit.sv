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
// File: branch_unit.sv
// Author: Marco Andorno
// Date: 05/10/2019

`include "mmm_pkg.sv"
import mmm_pkg::*;

/* verilator lint_off BLKANDNBLK */
module branch_unit
(
  input   logic             clk_i,
  input   logic             rst_n_i,
  input   logic [XLEN-1:0]  rs1_i,
  input   logic [XLEN-1:0]  rs2_i,
  input   logic [B_IMM-1:0] imm_i,
  input   logic             ops_valid_i,
  input   prediction_t      pred_i,
  input   branch_type_t     type_i,

  output  logic             ops_ready_o,
  output  resolution_t      res_o
);

  // Signal declarations
  logic taken, wrong_taken, wrong_target;
  logic [XLEN-1:0] target;

  // Logic unit
  always_comb begin
    case (type_i)
      beq:      taken = (rs1_i == rs2_i);
      bne:      taken = (rs1_i != rs2_i);
      blt:      taken = ($signed(rs1_i) < $signed(rs2_i));
      bge:      taken = ($signed(rs1_i) >= $signed(rs2_i));
      bltu:     taken = (rs1_i < rs2_i);
      bgeu:     taken = (rs1_i >= rs2_i);
      default:  taken = '0;
    endcase
  end

  // Control unit
  branch_unit_cu u_branch_unit_cu
  (
    .clk_i            (clk_i),
    .rst_n_i          (rst_n_i),
    .ops_valid_i      (ops_valid_i),
    .taken_i          (taken),
    .wrong_taken_i    (wrong_taken),
    .wrong_target_i   (wrong_target),

    .ops_ready_o      (ops_ready_o),
    .res_o            (res_o)
  );

  // Assignments
  assign wrong_taken  = pred_i.taken != taken;
  /* verilator lint_off WIDTH */
  assign target       = (imm_i << 1) + pred_i.pc;
  /* verilator lint_on WIDTH */
  assign wrong_target = pred_i.target != target;

  // Output register
  always_ff @ (posedge clk_i or negedge rst_n_i) begin: out_reg
    if (!rst_n_i) begin
      res_o.pc <= '0;
      res_o.target <= '0;
    end else if (ops_valid_i) begin
      res_o.pc <= pred_i.pc;
      res_o.target <= target;
    end
  end: out_reg
  
endmodule
/* verilator lint_on BLKANDNBLK */