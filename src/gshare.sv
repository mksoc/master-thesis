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
// File: gshare.sv
// Author: Marco Andorno
// Date: 26/07/2019

import mmm_pkg::*;

module gshare
(
  input   logic             clk_i,
  input   logic             rst_n_i,
  input   logic             flush_i,
  input   logic [XLEN-1:0]  pc_i,
  input   logic             res_valid_i,
  input   logic [HLEN-1:0]  res_index_i,
  input   logic             res_taken_i,

  output  logic             taken_o,
  output  logic [HLEN-1:0]  pred_index_o
);

  // Definitions
  typedef enum logic [1:0] {NT, WEAK_NT, WEAK_T, T} c2b_t; // 2-bit counter enum

  localparam PHT_ROWS = 2 << HLEN;

  struct packed { // 2-bit counter struct
    logic valid;
    c2b_t count;
  } pht_d[PHT_ROWS], pht_q[PHT_ROWS];
  
  logic [HLEN-1:0] history;

  // --------------------------
  // Branch History Table (BHT)
  // --------------------------
  always_ff @(posedge clk_i or negedge rst_n_i) begin: bht
    if (!rst_n_i) begin
      history <= '0; // Async reset
    end else begin
      if (flush_i) begin
        history <= '0; // Sync flush
      end else if (res_valid_i) begin
        history <= history >> 1;
        history[HLEN-1] <= res_taken_i;
      end
    end
  end

  // ---------------------------
  // Pattern History Table (PHT)
  // ---------------------------
  always_comb begin: pht_update
    // By default, store previous values
    pht_d = pht_q;

    // If a valid branch resolution arrives, update counters
    if (res_valid_i) begin
      pht_d[res_index_i].valid = 1'b1;

      case (pht_q[res_index_i].count)
        NT: begin
          if (res_taken_i)
            pht_d[res_index_i].count = WEAK_NT;
          else pht_d[res_index_i].count = NT;
        end

        WEAK_NT: begin
          if (res_taken_i)
            pht_d[res_index_i].count = WEAK_T;
          else pht_d[res_index_i].count = NT;
        end

        WEAK_T: begin
          if (res_taken_i)
            pht_d[res_index_i].count = T;
          else pht_d[res_index_i].count = WEAK_NT;
        end

        T: begin
          if (res_taken_i)
            pht_d[res_index_i].count = T;
          else pht_d[res_index_i].count = WEAK_T;
        end

        default: pht_d[res_index_i].count = WEAK_NT;
      endcase
    end
  end

  always_ff @(posedge clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin // Async reset
      for (int i = 0; i < PHT_ROWS; i++) begin
        pht_q[i].valid <= 1'b0;
        if (i % 2) pht_q[i].count <= WEAK_NT;
        else pht_q[i].count <= WEAK_T;
      end
    end
    else if (flush_i) begin // Sync flush
      for (int i = 0; i < PHT_ROWS; i++) begin
        pht_q[i].valid <= 1'b0;
        if (i % 2) pht_q[i].count <= WEAK_NT;
        else pht_q[i].count <= WEAK_T;
      end
    end
    else pht_q <= pht_d;
  end
    
  // Assignments
  assign pred_index_o = history ^ pc_i[HLEN + OFFSET - 1:OFFSET]; // XOR hashing
  assign taken_o = pht_q[pred_index_o].valid & pht_q[pred_index_o].count[1];

endmodule
