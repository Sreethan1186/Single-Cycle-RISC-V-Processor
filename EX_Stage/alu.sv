module alu #(
    parameter DATA_WIDTH = 32
)(
    input  logic [2:0]          alu_control,
    input  logic [DATA_WIDTH-1:0] rs1_data,
    input  logic [DATA_WIDTH-1:0] rs2_data,

    output logic [DATA_WIDTH-1:0] alu_out,
    output logic                  zero
);

    always_comb begin

        // Default output
        alu_out = '0;

        case (alu_control)

            // ADD: rs1 + rs2
            3'b000: begin
                alu_out = rs1_data + rs2_data;
            end

            // SUB: rs1 - rs2
            3'b001: begin
                alu_out = rs1_data - rs2_data;
            end

            // AND
            3'b010: begin
                alu_out = rs1_data & rs2_data;
            end

            // OR
            3'b011: begin
                alu_out = rs1_data | rs2_data;
            end

            // SLT: signed comparison
            3'b101: begin
                alu_out = ($signed(rs1_data) < $signed(rs2_data))
                          ? {{(DATA_WIDTH-1){1'b0}}, 1'b1}
                          : '0;
            end

            // Unsupported operation
            default: begin
                alu_out = '0;
            end

        endcase
    end

    // Zero flag is used by the branch control logic
    assign zero = (alu_out == '0);

endmodule


