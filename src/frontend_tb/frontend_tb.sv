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
  logic clk;
  logic rst_n;
  logic flush;
  logic except;
  logic [XLEN-1:0] except_pc;
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

  // Initial values 
  initial begin
    flush = '0;
  end

  // DUTs instantiations
  pc_gen_stage dut_pc_gen_stage
  (
    .clk_i          (clk),
    .rst_n_i        (rst_n),
    .except_i       (except),
    .except_pc_i    (except_pc),
    .res_i          ('0),
    .pred_i         ('0),
    .fetch_ready_i  (fetch_ready),

    .pc_o           (pc)
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
    //.pred_o           (pred),

    // From branch unit (ex stage)
    .res_i            ('0)
  );

  // Testbench module instantiations
  clk_gen u_clk_gen
  (
    .clk_o    (clk),
    .rst_n_o  (rst_n)
  );

  dummy_icache u_dummy_icache
  (
    .clk_i        (clk),
    .addr_i       (addr),
    .addr_valid_i (addr_valid),
    .data_ready_i (data_ready),

    .data_o       (data),
    .data_valid_o (data_valid),
    .addr_ready_o (addr_ready)
  );

  dummy_queue u_dummy_queue
  (
    .issue_valid_i  (issue_valid),
    .issue_ready_o  (issue_ready)
  );

  // PC jumps
  initial begin
    repeat(3) @(posedge clk);
    except = '1;
    except_pc = 'd100;
    @(posedge clk);
    except_pc = 'd200;
    @(posedge clk);
    except_pc = 'd300;
    @(posedge clk);
    except_pc = 'd400;
  end

endmodule