module decoder(
    input  logic [31:0] instruction,  // Instruction from instruction memory

    output logic [4:0]  rs1,          // First source register
    output logic [4:0]  rs2,          // Second source register
    output logic [4:0]  rd,           // Destination register
    output logic [6:0]  opcode,       // Opcode field of instruction
    output logic [6:0]  imm11_5,      // Instruction bits [31:25]
    output logic [2:0]  fn3,          // Function field
    output logic [11:0] imm,          // 12-bit immediate
    output logic [19:0] imm_uj,       // 20-bit U/J immediate
    output logic        fn7_5         // Instruction bit [30]
);

    always_comb begin

        // Default values
        rs1     = 5'b0;
        rs2     = 5'b0;
        rd      = 5'b0;
        opcode  = instruction[6:0];
        imm11_5 = 7'b0;
        fn3     = 3'b0;
        imm     = 12'b0;
        imm_uj  = 20'b0;
        fn7_5   = 1'b0;

        case (instruction[6:0])

            // R-type instructions
            7'b0110011: begin
                rd      = instruction[11:7];
                fn3     = instruction[14:12];
                rs1     = instruction[19:15];
                rs2     = instruction[24:20];
                fn7_5   = instruction[30];
            end

            // I-type arithmetic and logical instructions
            7'b0010011: begin
                rd      = instruction[11:7];
                fn3     = instruction[14:12];
                rs1     = instruction[19:15];
                imm     = instruction[31:20];
                imm11_5 = instruction[31:25];
            end

            // Load instructions
            7'b0000011: begin
                rd  = instruction[11:7];
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                imm = instruction[31:20];
            end

            // Store instructions
            7'b0100011: begin
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                imm = {instruction[31:25], instruction[11:7]};
            end

            // Branch instructions
            7'b1100011: begin
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                imm = {
                    instruction[31],
                    instruction[7],
                    instruction[30:25],
                    instruction[11:8]
                };
            end

            // JAL instruction
            7'b1101111: begin
                rd = instruction[11:7];
                imm_uj = {
                    instruction[31],
                    instruction[19:12],
                    instruction[20],
                    instruction[30:21]
                };
            end

            // JALR instruction
            7'b1100111: begin
                rd  = instruction[11:7];
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                imm = instruction[31:20];
            end

            // LUI and AUIPC instructions
            7'b0110111,
            7'b0010111: begin
                rd     = instruction[11:7];
                imm_uj = instruction[31:12];
            end

            // Unsupported instruction
            default: begin
                rs1     = 5'b0;
                rs2     = 5'b0;
                rd      = 5'b0;
                imm     = 12'b0;
                imm_uj  = 20'b0;
                imm11_5 = 7'b0;
                fn3     = 3'b0;
                fn7_5   = 1'b0;
            end

        endcase
    end

endmodule


