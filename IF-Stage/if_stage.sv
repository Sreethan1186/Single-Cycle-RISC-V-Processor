module if_stage(
    input  logic        clk,
    input  logic        reset,

    // Next-PC selection
    input  logic        PCSrc,
    input  logic [31:0] PC_target,

    // IF stage outputs
    output logic [31:0] PC,
    output logic [31:0] PCPlus4,
    output logic [31:0] Instr
);

    logic [31:0] PCNext;

    // Calculate PC + 4 for the next sequential instruction
    adder pc_adder(
        .a(PC),
        .b(32'd4),
        .y(PCPlus4)
    );

    // Select sequential PC or branch/jump target
    always_comb begin
        if (PCSrc)
            PCNext = PC_target;
        else
            PCNext = PCPlus4;
    end

    // Program counter register
    flopr #(.WIDTH(32)) pc_reg(
        .clk(clk),
        .reset(reset),
        .d(PCNext),
        .q(PC)
    );

    // Instruction memory reads the instruction at the current PC
    imem instruction_memory(
        .a(PC),
        .rd(Instr)
    );

endmodule


