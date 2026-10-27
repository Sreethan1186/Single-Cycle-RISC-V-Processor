module adder(
    input  logic [31:0] a,  // Operand A
    input  logic [31:0] b,  // Operand B
    output logic [31:0] y   // Sum output
);

    // Add the two 32-bit operands
    always_comb begin
        y = a + b;
    end

endmodule

