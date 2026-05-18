`ifndef DEFINES_VH
`define DEFINES_VH
`timescale 1ns / 1ps
// --- REGFILE ---
`define REG_RANGE           7:0
`define REG_WIDTH_RANGE     127:0
`define ADDR_RANGE          2:0
`define DATA_RANGE          127:0
`define LANE_RANGE          31:0
`define INSTR_RANGE         31:0
`define ALU_OP_RANGE        1:0
// --- SSE PREFIX ---
    `define PREFIX_SSE      8'h0F

// --- OPCODES ---
`define OP_ADDPS            8'h58
`define OP_SUBPS            8'h5C
`define OP_MULPS            8'h59
`define OP_MOVAPS_LOAD      8'h28
`define OP_MOVAPS_STORE     8'h29

// --- ALU CONTROL ---

`define ALU_ADD             2'b00
`define ALU_SUB             2'b01
`define ALU_MUL             2'b10
`define ALU_NOP             2'b11

// --- MODES ---
`define MOD_REG             2'b11
`define MOD_MEM             2'b00

`endif