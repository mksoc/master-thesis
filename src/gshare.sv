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
  input   logic             valid_i,
  input   logic [HLEN-1:0]  index_i,
  input   logic             taken_i,

  output  logic             pred_taken_o,
  output  logic [HLEN-1:0]  pred_index_o
);

  // Definitions
  typedef enum logic [1:0] {SNT, WNT, WT, ST} c2b_t; // 2-bit counter enum
  localparam c2b_t INIT_C2B = SNT;
  localparam PHT_ROWS = 1 << HLEN;
  c2b_t pht_d[PHT_ROWS], pht_q[PHT_ROWS];
  
  logic [HLEN-1:0] ghr;

  // --------------------------
  // Branch History Table (BHT)
  // --------------------------
  always_ff @(posedge clk_i or negedge rst_n_i) begin: bht
    if (!rst_n_i) begin: bht_async_rst
      ghr <= '0;
    end else begin
      if (flush_i) begin: bht_sync_flush
        ghr <= '0;
      end else if (valid_i) begin: bht_shift
        ghr <= {ghr[HLEN-1:1], taken_i};
      end
    end
  end: bht

  // ---------------------------
  // Pattern History Table (PHT)
  // ---------------------------
  always_comb begin: pht_update
    // By default, store previous values
    pht_d = pht_q;

    // If a valid branch resolution arrives, update counters
    if (valid_i) begin: c2b_fsm
      case (pht_q[index_i])
        SNT: begin
          if (taken_i)
            pht_d[index_i] = WNT;
          else pht_d[index_i] = SNT;
        end

        WNT: begin
          if (taken_i)
            pht_d[index_i] = WT;
          else pht_d[index_i] = SNT;
        end

        WT: begin
          if (taken_i)
            pht_d[index_i] = ST;
          else pht_d[index_i] = WNT;
        end

        ST: begin
          if (taken_i)
            pht_d[index_i] = ST;
          else pht_d[index_i] = WT;
        end

        default: pht_d[index_i] = WNT;
      endcase
    end: c2b_fsm
  end: pht_update

  always_ff @(posedge clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin: pht_async_rst
      for (int i = 0; i < PHT_ROWS; i++) begin
        pht_q[i] <= INIT_C2B;
      end
    end
    else if (flush_i) begin: pht_sync_flush
      for (int i = 0; i < PHT_ROWS; i++) begin
        pht_q[i] <= INIT_C2B;
      end
    end
    else pht_q <= pht_d;
  end
    
  // Assignments
  assign pred_index_o = ghr ^ pc_i[HLEN + OFFSET - 1:OFFSET]; // XOR hashing
  assign pred_taken_o = pht_q[pred_index_o][1];

endmodule
