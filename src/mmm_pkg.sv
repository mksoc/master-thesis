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
// File: mmm_pkg.sv
// Author: Marco Andorno
//         Matteo Perotti
//         Michele Caon
// Date: 26/07/2019

`ifndef MMM_PKG
`define MMM_PKG

package mmm_pkg;

  // Global constants
  localparam ILEN = 32; // instruction length
  localparam OFFSET = $clog2(ILEN/8); // 2 LSB of addresses are always 0, so no use in using them for indexing
  localparam XLEN = 64;
  localparam FLEN = 64;
  localparam logic [XLEN-1:0] BOOT_PC = 'h0; // starting PC (to be defined)
  localparam B_IMM = 12; // B-type immediate length
  localparam logic [ILEN-1:0] NOP = 'h13;

  // --------------
  // I-cache
  // --------------
  localparam ICACHE_OFFSET = 4; // for 16-instruction lines
  localparam ICACHE_INSTR = 2 << ICACHE_OFFSET;
  localparam ICACHE_LINE_LEN = ICACHE_INSTR * ILEN;

  // icache output struct
  typedef struct packed {
    logic [XLEN-1:0]            pc;
    logic [ICACHE_LINE_LEN-1:0] line;
  } icache_out_t;

  // --------------
  // Frontend
  // --------------
  localparam HLEN = 4 ;    // length of the history register
  localparam BTB_BITS = 4; // BTB has  2**BTB_BITS entries

  // instruction selector enums
  typedef enum logic [1:0] { current_pc = 'h0, prev_pc = 'h1, line_pc = 'h2 } pc_src_t;
  typedef enum logic [1:0] { cache_out = 'h0, line_reg = 'h1, line_bak = 'h2 } line_src_t;

  // -----------
  // Branch unit
  // -----------
  typedef enum logic [3:0] {
    beq   = 'h0,
    bne   = 'h1,
    blt   = 'h2,
    bge   = 'h3,
    bltu  = 'h4,
    bgeu  = 'h5
  } branch_type_t;

  //-----\\
  // CSR \\
  //-----\\

  typedef enum logic [1:0] {
    M, // machine mode
    S, // supervisor mode
    U  // user mode
  } priv_e;



  //------------------------------\\
  //----- EXECUTION PIPELINE -----\\
  //------------------------------\\
  
  // GLOBAL
  localparam XREG_NUM = 32; // number of gp integer registers
  localparam REG_IDX_LEN = $clog2(XREG_NUM); // Register file address width

  // ISSUE QUEUE
  localparam IQ_DEPTH = 8; // number of entries in the issue queue. This may or may not be a power of 2 (power of 2 recommended)

  // LOAD/STORE UNIT
  localparam LDBUFF_DEPTH = 8; // number of entries in the load buffer
  localparam STBUFF_DEPTH = 8; // number of entries in the store buffer

  // ROB
  localparam ROB_DEPTH = 16; // Number of entries in the ROB. This also tells the number of instruction that coexist in the execution pipeline at the same time

endpackage

`endif