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
// File: presence_checker.sv
// Author: Marco Andorno
// Date: 03/10/2019

import mmm_pkg::*;

module presence_checker
(
  input   logic [XLEN-1:0]  pc_i,
  input   logic [XLEN-1:0]  prev_pc_i,
  input   logic [XLEN-1:0]  line_pc_i,

  output  logic             here_o,
  output  logic             will_be_here_o
);

  logic here_int;

  assign here_int = (pc_i[XLEN-1:ICACHE_OFFSET] === line_pc_i[XLEN-1:ICACHE_OFFSET]);
  assign here_o = here_int;
  assign will_be_here_o = (pc_i[XLEN-1:ICACHE_OFFSET] === prev_pc_i[XLEN-1:ICACHE_OFFSET]) & (!here_int);

endmodule