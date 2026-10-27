`timescale 1ns / 1ps

module id_stage(
    input  logic        clk,         // Clock
    input  logic [31:0] Instr,       // Instruction from IF stage

    // Decoded instruction fields
    output logic [6:0]  op,          // Opcode field
    output logic [4:0]  rd,          // Destination register
    output logic [2:0]  funct3,      // funct3 field
    output logic [4:0]  rs1,         // First source register
    output logic [4:0]  rs2,         // Second source register
    output logic        funct7b5,    // Bit 5 of funct7 field

    // Register file outputs
    output logic [31:0] RD1,         // Data read from rs1
    output logic [31:0] RD2,         // Data read from rs2

    // Immediate generator output
    output logic [31:0] ImmExt,      // Sign-extended immediate

    // Control signals
    output logic [1:0]  ResultSrc,   // Selects ALU, memory, or PC+4 for writeback
    output logic        MemRead,     // Enable for reading from data memory
    output logic        MemWrite,    // Enable for writing to data memory
    output logic        PCSrc,       // Controls PC update
    output logic        ALUSrc,      // ALU source select
    output logic        RegWrite,    // Enable writing to register file
    output logic        Jump,        // Jump signal
    output logic [2:0]  ALUControl,  // ALU operation code
    output logic [1:0]  ImmSrc       // Immediate type selector
);

    // Temporary zero flag until the execution stage is implemented
    logic Zero;

    // Internal signal for the main decoder's branch output
    logic [31:0] imm_instr;

    // Zero is not available until the ALU is implemented
    // Keep it low during initial instruction-decode testing
    assign Zero = 1'b0;

    // Decode the instruction into its individual fields
    id_decoder decoder(
        .Instr(Instr),
        .op(op),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7b5(funct7b5)
    );

    // Generate processor control signals
    controller ctrl(
        .op(op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .Zero(Zero),
        .ResultSrc(ResultSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );

    // Read the source registers
    // Register writes will be connected when the execution stage is implemented
    regfile rf(
        .clk(clk),
        .we3(1'b0),
        .a1(rs1),
        .a2(rs2),
        .a3(5'b0),
        .wd3(32'b0),
        .rd1(RD1),
        .rd2(RD2)
    );

    // Generate the immediate value from the instruction
    assign imm_instr = Instr;

    extend ext(
        .instr(imm_instr[31:7]),
        .immsrc(ImmSrc),
        .immext(ImmExt)
    );

endmodule


