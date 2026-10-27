module maindec(
    input  logic [6:0] op,        // Opcode of the instruction
    output logic [1:0] ResultSrc, // Selects ALU, memory, or PC+4 for writeback
    output logic       MemWrite,   // Enable for writing to data memory
    output logic       MemRead,    // Enable for reading from data memory
    output logic       Branch,     // Conditional branch instruction flag
    output logic       ALUSrc,     // ALU source select (register vs immediate)
    output logic       RegWrite,   // Enable writing to register file
    output logic       Jump,       // Jump instruction flag
    output logic [1:0] ImmSrc,     // Immediate type selector
    output logic [1:0] ALUOp      // ALU operation selector
);

    always_comb begin

        // Default control signals
        ResultSrc = 2'b00;
        MemWrite  = 1'b0;
        MemRead   = 1'b0;
        Branch    = 1'b0;
        ALUSrc    = 1'b0;
        RegWrite  = 1'b0;
        Jump      = 1'b0;
        ImmSrc    = 2'b00;
        ALUOp     = 2'b00;

        case (op)

            // R-type: ADD, SUB, AND, OR, etc.
            7'b0110011: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b0;
                ResultSrc = 2'b00;
                ALUOp     = 2'b10;
            end

            // I-type arithmetic: ADDI, ANDI, ORI, etc.
            7'b0010011: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ImmSrc    = 2'b00;
                ResultSrc = 2'b00;
                ALUOp     = 2'b10;
            end

            // Load: LW
            7'b0000011: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ImmSrc    = 2'b00;
                MemRead   = 1'b1;
                ResultSrc = 2'b01;
                ALUOp     = 2'b00;
            end

            // Store: SW
            7'b0100011: begin
                ALUSrc   = 1'b1;
                ImmSrc   = 2'b01;
                MemWrite = 1'b1;
                ALUOp    = 2'b00;
            end

            // Branch: BEQ, BNE, etc.
            7'b1100011: begin
                Branch = 1'b1;
                ImmSrc = 2'b10;
                ALUOp  = 2'b01;
            end

            // JAL
            7'b1101111: begin
                RegWrite  = 1'b1;
                Jump      = 1'b1;
                ImmSrc    = 2'b11;
                ResultSrc = 2'b10;
            end

            // JALR
            7'b1100111: begin
                RegWrite  = 1'b1;
                Jump      = 1'b1;
                ALUSrc    = 1'b1;
                ImmSrc    = 2'b00;
                ResultSrc = 2'b10;
                ALUOp     = 2'b00;
            end

            // LUI
            7'b0110111: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ResultSrc = 2'b11;
            end

            // AUIPC
            7'b0010111: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ResultSrc = 2'b10;
            end

            default: begin
                // Keep all default control signals inactive
            end

        endcase
    end

endmodule


