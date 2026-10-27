module extend(
    input  logic [31:7] instr,     // Instruction bits
    input  logic [1:0]  immsrc,    // Immediate type selector
    output logic [31:0] immext     // Sign-extended immediate
);

always_comb
begin

    case(immsrc)

        2'b00 : immext = {{20{instr[31]}}, instr[31:20]}; // I - Type

        2'b01 : immext = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S - Type

        2'b10 : immext = {{19{instr[31]}}, instr[31], instr[7], instr[30:25],
                           instr[11:8], 1'b0};  // B - Type

        2'b11 : immext = {{11{instr[31]}}, instr[31], instr[19:12], instr[20],
                           instr[30:21], 1'b0}; // J - Type

        default: immext = 32'b0;

    endcase

end

endmodule


