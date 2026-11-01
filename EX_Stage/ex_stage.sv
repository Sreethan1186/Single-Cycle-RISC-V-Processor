
module ex_stage #(
    parameter DATA_WIDTH = 32
)(
    // Inputs from the decode stage
    input  logic [DATA_WIDTH-1:0] RD1,
    input  logic [DATA_WIDTH-1:0] RD2,
    input  logic [DATA_WIDTH-1:0] ImmExt,

    // Control signals from the decode stage
    input  logic                  ALUSrc,
    input  logic [2:0]            ALUControl,

    // Outputs
    output logic [DATA_WIDTH-1:0] ALUResult,
    output logic                  Zero
);

    logic [DATA_WIDTH-1:0] ALUOperand2;

    // Select the second ALU operand
    // 0: Register data (RD2)
    // 1: Immediate value (ImmExt)
    always_comb begin
        if (ALUSrc)
            ALUOperand2 = ImmExt;
        else
            ALUOperand2 = RD2;
    end

    // Instantiate the ALU
    alu #(
        .DATA_WIDTH(DATA_WIDTH)
    ) alu_unit (
        .alu_control(ALUControl),
        .rs1_data(RD1),
        .rs2_data(ALUOperand2),
        .alu_out(ALUResult),
        .zero(Zero)
    );

endmodule


