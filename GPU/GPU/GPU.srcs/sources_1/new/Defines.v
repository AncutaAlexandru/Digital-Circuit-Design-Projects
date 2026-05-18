//----------------------------------------------------------------------
//                   Defines used on all files
//----------------------------------------------------------------------

`define ADDR_WIDTH          32
`define ADDR_IDX             5
`define INSTR_WIDTH         32
`define DATA_WIDTH          32
`define PC_WIDTH            32
`define CU_WIDTH             5
`define BYTES_NR             4
`define HWA_WIDTH           32

//----------------------------------------------------------------------
//                   Defines used Fetch stage
//----------------------------------------------------------------------
`define PC_INCR             4
`define INSTR_DEPTH        200
`define IMEM_IDX           $clog2(`INSTR_DEPTH)
`define BYTES_ALLIGN_RANGE 2+`IMEM_IDX-1:2
//----------------------------------------------------------------------
//                   Defines used Decode stage
//----------------------------------------------------------------------
// Instruction Encoding
`define FUNCT7_RANGE     31:25       // FUNCT7
`define RS2_RANGE        24:20       // Source register 2 range in R-type
`define RS1_RANGE        19:15       // Source register 1 range in R-type
`define FUNCT3_RANGE     14:12       // FUNCT3
`define FUNCT3_MSB          14
`define FUNCT3_LSB          12
`define RD_RANGE          11:7       // Destination register range in R-type
`define OPCODE_RANGE       6:0       // Opcode range
// IMM subfields
`define IMM_RANGE        31:20       // Imm
`define IMM_LSB             20       // Imm
`define IMM_MSB             31       // Imm
`define IMM_WIDTH           12       // Imm
