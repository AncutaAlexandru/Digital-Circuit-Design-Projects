`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2026 05:42:28 PM
// Design Name: 
// Module Name: SIMD_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "Defines.vh"

module SIMD_TOP(
    input [`INSTR_RANGE]        Instr_data, //Instruction data from memory
    input [`DATA_RANGE]         Data_in_mem,    //Data from ext memory
    input                       clk, reset, 
    output                      load_use_hazard,
    output  [`DATA_RANGE]       Data_out_mem    //Data sent to memory       
    );
    
    wire [`ADDR_RANGE]      addr_src, addr_dest;
    wire [`ALU_OP_RANGE]    ALU_op;
    wire [`DATA_RANGE]      Dout_reg_rs, Dout_reg_rd, ALU_in_rs, ALU_in_rd;
    wire                    mod_reg, mod_mem, w_en ,r_en, flag_hazard_forward_rs, flag_hazard_forward_rd;
    wire [`DATA_RANGE]      Data_out_ALU_combined;
    wire [`DATA_RANGE]      Data_in_register;
    
    reg [`DATA_RANGE]       EX_WB_Dout_reg_rs;
    reg [`DATA_RANGE]       EX_WB_Data_out_ALU_combined;
    reg [`ADDR_RANGE]       EX_WB_addr_dest;
    reg                     EX_WB_w_en, EX_WB_mod_mem;
    reg [`ADDR_RANGE]       InDec_Ex_addr_src, InDec_Ex_addr_dest;
    reg [`ALU_OP_RANGE]     InDec_Ex_ALU_op;
    reg                     InDec_Ex_mod_reg, InDec_Ex_mod_mem, InDec_Ex_w_en ,InDec_Ex_r_en;
    Decoder Inst_Decoder (
        .Instr_data(Instr_data),
        .addr_src(addr_src),
        .addr_dest(addr_dest),
        .ALU_op(ALU_op),
        .mod_reg(mod_reg),
        .mod_mem(mod_mem),
        .w_en(w_en),
        .r_en(r_en)
    );
    
    RegFile Inst_RegFile (
        .clk(clk),
        .reset(reset),
        .w_en(EX_WB_w_en), 
        .r_en(InDec_Ex_r_en),                 
        .data_in(Data_in_register),
        .addr_rs(InDec_Ex_addr_src),
        .addr_rd(InDec_Ex_addr_dest),
        .addr_wr(EX_WB_addr_dest),       
        .dout_rs(Dout_reg_rs),
        .dout_rd(Dout_reg_rd)
    );
    
    LANE_ALU Inst_Lane [3:0] (
        .data_rs(ALU_in_rs), 
        .data_rd(ALU_in_rd), 
        .ALU_op(InDec_Ex_ALU_op), 
        .data_out(Data_out_ALU_combined)
    );
    
    
    always @(posedge clk) begin
        if(reset) begin
            InDec_Ex_addr_src                       <=      3'd0;
            InDec_Ex_addr_dest                      <=      3'd0;
            InDec_Ex_ALU_op                         <=      2'd0;
            InDec_Ex_mod_reg                        <=      1'd0;
            InDec_Ex_mod_mem                        <=      1'd0;
            InDec_Ex_w_en                           <=      1'd0;
            InDec_Ex_r_en                           <=      1'd0;
            EX_WB_Dout_reg_rs                       <=      128'd0;
            EX_WB_Data_out_ALU_combined             <=      128'd0;
            EX_WB_addr_dest                         <=      3'd0;
            EX_WB_mod_mem                           <=      1'd0;
            EX_WB_w_en                              <=      1'd0;
        end
      
        else if(load_use_hazard) begin
                InDec_Ex_mod_reg                    <=      1'd0;
                InDec_Ex_mod_mem                    <=      1'd0;
                InDec_Ex_w_en                       <=      1'd0;
                InDec_Ex_ALU_op                     <=      2'b11;
                EX_WB_Dout_reg_rs                   <=      Dout_reg_rs;
                EX_WB_addr_dest                     <=      InDec_Ex_addr_dest;
                EX_WB_mod_mem                       <=      InDec_Ex_mod_mem;
                EX_WB_w_en                          <=      InDec_Ex_w_en;
                EX_WB_Data_out_ALU_combined         <=      Data_out_ALU_combined;
            end
        
        else begin
        
            InDec_Ex_addr_src                       <=      addr_src;
            InDec_Ex_addr_dest                      <=      addr_dest;
            InDec_Ex_ALU_op                         <=      ALU_op;
            InDec_Ex_mod_reg                        <=      mod_reg;
            InDec_Ex_mod_mem                        <=      mod_mem;
            InDec_Ex_w_en                           <=      w_en;
            InDec_Ex_r_en                           <=      r_en;
            EX_WB_Dout_reg_rs                       <=      Dout_reg_rs;
            EX_WB_addr_dest                         <=      InDec_Ex_addr_dest;
            EX_WB_mod_mem                           <=      InDec_Ex_mod_mem;
            EX_WB_w_en                              <=      InDec_Ex_w_en;
            EX_WB_Data_out_ALU_combined             <=      Data_out_ALU_combined;
            
        end
    
    end
    

    assign flag_hazard_forward_rs = (EX_WB_w_en && (EX_WB_addr_dest == InDec_Ex_addr_src )) ? 1'b1 : 1'b0;
    assign flag_hazard_forward_rd = (EX_WB_w_en && (EX_WB_addr_dest == InDec_Ex_addr_dest )) ? 1'b1 : 1'b0; 
    
    assign load_use_hazard = (InDec_Ex_mod_mem && InDec_Ex_w_en) &&  ((InDec_Ex_addr_dest == addr_src) || (InDec_Ex_addr_dest == addr_dest));
   
    assign ALU_in_rs = (flag_hazard_forward_rs)? Data_in_register  : Dout_reg_rs; 
    assign ALU_in_rd = (flag_hazard_forward_rd)? Data_in_register  : Dout_reg_rd; 
    
    
    
    assign Data_in_register = (EX_WB_Data_out_ALU_combined & ~{128{EX_WB_mod_mem}}) | (Data_in_mem & {128{EX_WB_mod_mem}});
    
    assign Data_out_mem = (EX_WB_mod_mem && !EX_WB_w_en) ? EX_WB_Dout_reg_rs : 128'd0;

endmodule
