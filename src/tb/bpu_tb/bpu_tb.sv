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
// File: bpu_tb.sv
// Author: Marco Andorno
// Date: 10/10/2019

`timescale 1ns/1ns

import mmm_pkg::*;

module bpu_tb;

  // Declarations
  logic clk;
  logic rst_n;
  logic [XLEN-1:0] pc;
  prediction_t pred, saved_pred;
  resolution_t res;
  int addr_fd, res_fd, scan;

  // DUT instantiation
  bpu dut
  (
    .clk_i    (clk),
    .rst_n_i  (rst_n),
    .flush_i  ('0),
    .pc_i     (pc),
    .res_i    (res),

    .pred_o   (pred)
  );
  
  // Testbench module instantiations
  clk_gen u_clk_gen
  (
    .clk_o    (clk),
    .rst_n_o  (rst_n)
  );

  initial begin
    // Initialize inputs
    pc = '0;
    res = '0;

    // Let reset settle
    repeat(3) @(posedge clk);

    // Open files
    addr_fd = $fopen("addresses.txt", "r");
    res_fd = $fopen("resolutions.txt", "r");

    // Read addresses and resolutions
    while (!$feof(addr_fd) && !$feof(res_fd)) begin
      // Read address
      scan = $fscanf(addr_fd, "%d\n", pc);
      if (scan != 1) begin
        $display("Error while reading address file");
        $stop;
      end
    
      // Simulate PC changing
      @(posedge clk);
      saved_pred = pred;
      pc = pc + 4;

      // Read resolution
      res.valid = 'b1;
      scan = $fscanf(res_fd, "%d %d %d\n", res.pc, res.target, res.taken);
      if (scan != 3) begin
        $display("Error while reading resolution file");
        $stop;
      end
      if ((res.taken != saved_pred.taken) ||
          (res.taken && (res.target != saved_pred.target))) begin
        res.mispredict = 'b1;
        if (res.pc == 10) begin
          $display("Time %0t ns - Misprediction on outer loop (address %0d)", $time, res.pc);
        end else begin
          $display("Time %0t ns - Misprediction on inner loop (address %0d)", $time, res.pc);
        end
      end else begin
        res.mispredict = 'b0;
      end
      @(posedge clk);
      res.valid = 'b0;
    end

    $fclose(addr_fd);
    $fclose(res_fd);
    $finish;
  end

endmodule