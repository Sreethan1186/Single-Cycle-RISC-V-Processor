module regfile(
    input  logic        clk,       // Clock signal
    input  logic        reset,     // Asynchronous active-high reset
    input  logic        we3,       // Register write enable
    input  logic [4:0]  a1,        // First source register address
    input  logic [4:0]  a2,        // Second source register address
    input  logic [4:0]  a3,        // Destination register address
    input  logic [31:0] wd3,       // Write data

    output logic [31:0] rd1,       // First register read data
    output logic [31:0] rd2        // Second register read data
);

    logic [31:0] rf [31:0];
    integer i;

    // Asynchronous reset of all registers
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                rf[i] <= 32'b0;
        end
        else begin
            if (we3 && (a3 != 5'd0))
                rf[a3] <= wd3;
        end
    end

    // Combinational read ports
    always_comb begin
        if (a1 == 5'd0)
            rd1 = 32'b0;
        else
            rd1 = rf[a1];

        if (a2 == 5'd0)
            rd2 = 32'b0;
        else
            rd2 = rf[a2];
    end

endmodule


