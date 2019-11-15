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
// File: dummy_cache.sv
// Author: Marco Andorno
// Date: 15/11/2019

import mmm_pkg::*;

module dummy_icache
(
  input   logic             clk_i,
  input   logic [XLEN-1:0]  addr_i,
  input   logic             addr_valid_i,
  input   logic             data_ready_i,

  output  icache_out_t      data_o,
  output  logic             data_valid_o,
  output  logic             addr_ready_o
);

  localparam ADDR_DELAY = 0;
  localparam DATA_DELAY = 0;
  logic [XLEN-1:0] saved_address;
  logic data_flag;

  initial begin
    data_o = '0;
    data_valid_o = '0;
    addr_ready_o = '0;
    data_flag = '0;
  end

  always begin
    wait(addr_valid_i)

    // Address handshake
    $display("[%0t ns] Dummy icache simulating address busy cycles", $time);
    repeat(ADDR_DELAY) @(posedge clk_i);
    addr_ready_o = '1;
    saved_address = addr_i;
    data_flag = '1;

    @(posedge clk_i);
    addr_ready_o = '0;
  end

  always begin
    wait(data_flag)

    // Data handshake
    $display("[%0t ns] Dummy icache simulating miss cycles", $time);
    repeat(DATA_DELAY) @(posedge clk_i);
    data_valid_o = '1;
    data_o.pc = saved_address;
    for (int i = 0; i < ICACHE_INSTR; i += 1) begin
      data_o.line[i] = i + 1;
    end
    data_flag = '0;

    @(posedge clk_i);
    data_valid_o = '0;
  end
  
endmodule