`timescale 1ns / 1ps

module id_decoder(
    input  logic [31:0] Instr,      // Instruction from instruction memory

    output logic [6:0]  op,         // Opcode field of instruction
    output logic [4:0]  rd,         // Destination register
    output logic [2:0]  funct3,     // funct3 field
    output logic [4:0]  rs1,        // First source register
    output logic [4:0]  rs2,        // Second source register
    output logic        funct7b5    // Bit 5 of funct7 field
);

    // Extract instruction fields from their standard RISC-V positions
    always_comb begin
        op       = Instr[6:0];
        rd       = Instr[11:7];
        funct3   = Instr[14:12];
        rs1      = Instr[19:15];
        rs2      = Instr[24:20];
        funct7b5 = Instr[30];
    end

endmodule


