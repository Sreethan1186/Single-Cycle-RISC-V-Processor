module controller(
    input  logic [6:0]  op,         // opcode field of instruction
    input  logic [2:0]  funct3,     // funct3 field
    input  logic        funct7b5,   // bit 5 of funct7 field
    input  logic        Zero,       // Zero flag from ALU
    output logic [1:0]  ResultSrc,  // selects data to write to register
    output logic        MemRead,    // memory read enable
    output logic        MemWrite,   // memory write enable
    output logic        PCSrc,      // controls PC update
    output logic        ALUSrc,     // ALU input select
    output logic        RegWrite,   // register write enable
    output logic        Jump,       // jump signal
    output logic [1:0]  ImmSrc,     // immediate generator select
    output logic [2:0]  ALUControl  // ALU operation code
);

    logic Branch;
    logic [1:0] ALUOp;

    // Main decoder generates high-level control signals
    maindec md(
        .op(op),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp)
    );

    // ALU decoder generates the specific ALU operation
    aludec ad(
        .opb5(op[5]),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    // Select the next PC for jumps and taken BEQ branches
    always_comb begin
        PCSrc = Jump | (Branch & Zero);
    end

endmodule


