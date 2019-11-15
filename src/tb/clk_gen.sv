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
// File: clk_gen.sv
// Author: Marco Andorno
// Date: 15/11/2019

`timescale 1ns/1ns
// `define BOUNDED

module clk_gen
(
  output logic clk_o,
  output logic rst_n_o
);

  localparam PERIOD = 10;
  localparam SIM_CYCLES = 100;
  
  // Clock generator
  initial begin
    clk_o = '1;
    `ifdef BOUNDED
      repeat(2*SIM_CYCLES) #(PERIOD/2) clk_o = ~clk_o;
    `endif
  end

  `ifndef BOUNDED
  always #(PERIOD/2) clk_o = ~clk_o;
  `endif

  // Reset generator
  initial begin
    rst_n_o = '0;
    #11 rst_n_o = '1;
  end

endmodule