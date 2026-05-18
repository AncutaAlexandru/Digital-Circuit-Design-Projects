


`ifndef SIMD_OBJ_SV
`define SIMD_OBJ_SV
`include "Defines.vh"
class transaction;

    rand logic [`INSTR_RANGE] Instr_data;
    rand logic [`DATA_RANGE] Data_in_mem;
    logic [`DATA_RANGE] Data_out_mem;
    
    bit use_small_values = 1;
    bit use_corner_cases = 0;
    constraint con_prefix
    {
        Instr_data[7:0] == `PREFIX_SSE;
    }
    constraint con_opcode
    {
        Instr_data[15:8] inside {`OP_ADDPS, `OP_SUBPS, `OP_MULPS, `OP_MOVAPS_LOAD, `OP_MOVAPS_STORE};
    }
    
    constraint con_instr
    {
        Instr_data[31:24] == 8'h0;
        Instr_data[23:22] inside {`MOD_REG, `MOD_MEM};
    }
    
    
    constraint con_small_data {
        if (use_small_values) {
            Data_in_mem[31:0]   < 10;
            Data_in_mem[63:32]  < 10;
            Data_in_mem[95:64]  < 10;
            Data_in_mem[127:96] < 10;
        }
    }
    
    
    constraint con_corner_cases {
        if (use_corner_cases) {
        }
    }
endclass

`endif