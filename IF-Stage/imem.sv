module imem(
    input  logic [31:0] a,   // Address
    output logic [31:0] rd   // Instruction
);

    logic [31:0] mem [0:31]; // 32 words

    // Load instructions from file
    initial begin
        $readmemh("instructions.mem", mem);
    end

    assign rd = mem[a[6:2]];

endmodule


