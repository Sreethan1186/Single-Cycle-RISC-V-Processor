module aludec(
    input  logic        opb5,       // Opcode bit 5
    input  logic [2:0]  funct3,     // Function field from instruction
    input  logic        funct7b5,   // Bit 5 of funct7 field
    input  logic [1:0]  ALUOp,      // ALU operation from main decoder
    output logic [2:0] ALUControl  // ALU operation code
);

    always_comb begin

        // Default operation: ADD
        ALUControl = 3'b000;

        case (ALUOp)

            // Load/store address calculation
            2'b00: begin
                ALUControl = 3'b000;  // ADD
            end

            // Branch comparison
            2'b01: begin
                ALUControl = 3'b001;  // SUB
            end

            // R-type and I-type arithmetic/logical operations
            2'b10: begin
                case (funct3)

                    // ADD / ADDI or SUB
                    3'b000: begin
                        if (opb5 && funct7b5)
                            ALUControl = 3'b001; // SUB
                        else
                            ALUControl = 3'b000; // ADD
                    end

                    // SLT / SLTI
                    3'b010: begin
                        ALUControl = 3'b101;
                    end

                    // AND / ANDI
                    3'b111: begin
                        ALUControl = 3'b010;
                    end

                    // OR / ORI
                    3'b110: begin
                        ALUControl = 3'b011;
                    end

                    // Unsupported funct3
                    default: begin
                        ALUControl = 3'b000;
                    end

                endcase
            end

            default: begin
                ALUControl = 3'b000;
            end

        endcase
    end

endmodule


