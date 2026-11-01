module alu_control(
    input  logic [2:0] alu_op,       // ALU operation class from main control
    input  logic [2:0] fn3,          // Function field from instruction
    input  logic [6:0] imm11_5,      // Instruction bits [31:25]
    input  logic       fn7_5,        // Instruction bit [30]

    output logic [4:0] control_out  // ALU operation control
);

    always_comb begin

        // Default operation: ADD
        control_out = 5'b00000;

        case (alu_op)

            // R-type instructions
            3'b000: begin
                case (fn3)

                    // ADD / SUB
                    3'b000: begin
                        if (fn7_5)
                            control_out = 5'b00001;
                        else
                            control_out = 5'b00000;
                    end

                    // SLL
                    3'b001: control_out = 5'b00101;

                    // SLT
                    3'b010: control_out = 5'b01000;

                    // SLTU
                    3'b011: control_out = 5'b01001;

                    // XOR
                    3'b100: control_out = 5'b00010;

                    // SRL / SRA
                    3'b101: begin
                        if (fn7_5)
                            control_out = 5'b00111;
                        else
                            control_out = 5'b00110;
                    end

                    // OR
                    3'b110: control_out = 5'b00011;

                    // AND
                    3'b111: control_out = 5'b00100;

                    default: control_out = 5'b00000;

                endcase
            end

            // I-type arithmetic and logical instructions
            3'b001: begin
                case (fn3)

                    // ADDI
                    3'b000: control_out = 5'b00000;

                    // SLLI
                    3'b001: control_out = 5'b00101;

                    // SLTI
                    3'b010: control_out = 5'b01000;

                    // SLTIU
                    3'b011: control_out = 5'b01001;

                    // XORI
                    3'b100: control_out = 5'b00010;

                    // SRLI / SRAI
                    3'b101: begin
                        if (imm11_5 == 7'b0100000)
                            control_out = 5'b00111;
                        else
                            control_out = 5'b00110;
                    end

                    // ORI
                    3'b110: control_out = 5'b00011;

                    // ANDI
                    3'b111: control_out = 5'b00100;

                    default: control_out = 5'b00000;

                endcase
            end

            // Load instructions: address calculation
            3'b010: begin
                control_out = 5'b00000;
            end

            // Store instructions: address calculation
            3'b011: begin
                control_out = 5'b00000;
            end

            // Branch instructions
            3'b100: begin
                case (fn3)

                    // BEQ
                    3'b000: control_out = 5'b01010;

                    // BNE
                    3'b001: control_out = 5'b01011;

                    // BLT
                    3'b100: control_out = 5'b01100;

                    // BGE
                    3'b101: control_out = 5'b01101;

                    // BLTU
                    3'b110: control_out = 5'b01110;

                    // BGEU
                    3'b111: control_out = 5'b01111;

                    default: control_out = 5'b00000;

                endcase
            end

            // JAL and LUI
            3'b110: begin
                control_out = 5'b00000;
            end

            // Default operation
            default: begin
                control_out = 5'b00000;
            end

        endcase
    end

endmodule


