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
  localparam PERIOD = 10;
  logic clk = '1;
  logic rst_n = '0;
  logic [XLEN-1:0] pc, res_pc, res_target;
  logic res_valid, res_taken, res_mispredict;
  logic [HLEN-1:0] res_index;
  int fd_res, scan;

  // Clock generator
  always #(PERIOD/2) clk = ~clk;

  // Reset
  initial begin
    #11 rst_n = '1;
  end

  // DUT instantiation
  bpu dut
  (
    .clk_i            (clk),
    .rst_n_i          (rst_n),
    .flush_i          ('0),
    .pc_i             (pc),
    .res_valid_i      (res_valid),
    .res_pc_i         (res_pc),
    .res_index_i      (res_index),
    .res_target_i     (res_target),
    .res_taken_i      (res_taken),
    .res_mispredict_i (res_mispredict),

    .pred_pc_o        (),
    .pred_index_o     (),
    .pred_target_o    (),
    .pred_taken_o     ()
  );
  
  initial begin
    // Initialize inputs
    pc = '0;
    res_valid = '0;
    res_pc = '0;
    res_index = '0;
    res_target = '0;
    res_taken = '0;
    res_mispredict = '0;

    // Let reset settle
    #(3*PERIOD);

    // PC under exam
    pc = 'd12;

    // Read resolutions file
    fd_res = $fopen("bpu_resolutions.txt", "r");
    while (!$feof(fd_res)) begin
      scan = $fscanf(fd_res, "%h %h %h %h %h %h\n",
          res_valid, res_pc, res_index, res_target, res_taken, res_mispredict);
      $display("Branch resolution: %h %h %h %h %h %h",
          res_valid, res_pc, res_index, res_target, res_taken, res_mispredict);
      @(posedge clk);
    end
    $fclose(fd_res);
    $stop;
  end

endmodule