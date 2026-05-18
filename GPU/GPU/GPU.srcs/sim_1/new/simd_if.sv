`timescale 1ns / 1ps

`ifndef SIMD_IF_SV
`define SIMD_IF_SV
`include "Defines.vh"

interface simd_if(input logic clk,input logic reset);

    logic [`INSTR_RANGE] Instr_data;
    logic [`DATA_RANGE] Data_in_mem, Data_out_mem;

    //Blocul modport defineste pentru fiecare clasa directiile semnalelor
    modport driver_mp(clocking driver_block, input reset);
    modport monitor_mp(clocking monitor_block, input reset);
    //clocking block impune timpi de setp si hold pentru a scoate problemele de tip race condition
    clocking driver_block @(posedge clk);
        
        default input #1step output #0;
        
        output Instr_data, Data_in_mem;
        input Data_out_mem;
           
    endclocking

    clocking monitor_block @(posedge clk);
        
        default input #1step output #0;
        input Instr_data, Data_in_mem, Data_out_mem; 
             
    endclocking
endinterface

`endif