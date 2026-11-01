module id_stage(
    input  logic        clk,          // Clock signal
    input  logic        reset,        // Asynchronous active-high reset
    input  logic        stall,        // Stall signal
    input  logic [31:0] instruction,  // Instruction from instruction memory
    input  logic [31:0] wb_data,      // Writeback data

    // Register file outputs
    output logic [31:0] rs1_data,     // Data read from rs1
    output logic [31:0] rs2_data,     // Data read from rs2

    // Immediate generator output
    output logic [31:0] imm_out,      // Generated immediate

    // Decoded instruction fields
    output logic [6:0]  opcode_out_d, // Opcode field
    output logic [6:0]  imm11_5,      // Instruction bits [31:25]
    output logic [2:0]  fn3_out_d,    // Function field
    output logic        fn7_5,        // Instruction bit [30]

    // Control signals
    output logic [2:0]  aluop,        // ALU operation selector
    output logic [1:0]  memtoreg,     // Writeback data source selector
    output logic        branch,       // Conditional branch flag
    output logic        mem_write,    // Data memory write enable
    output logic        mem_read,     // Data memory read enable
    output logic        alu_src,      // ALU source select
    output logic        mux_inp       // JALR target selection
);

    // Internal decoder signals
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;
    logic [11:0] imm;
    logic [19:0] imm_uj;

    // Internal main control signals
    logic reg_write;

    // Decode the instruction into its individual fields
    decoder instruction_decoder(
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode_out_d),
        .imm11_5(imm11_5),
        .fn3(fn3_out_d),
        .imm(imm),
        .imm_uj(imm_uj),
        .fn7_5(fn7_5)
    );

    // Generate the immediate value
    imm_generator immediate_generator(
        .imm_input(imm),
        .fn3(fn3_out_d),
        .opcode(opcode_out_d),
        .imm_input_uj(imm_uj),
        .imm_output(imm_out)
    );

    // Generate control signals
    maindec main_control(
        .opcode(opcode_out_d),
        .fn3(fn3_out_d),
        .memtoreg(memtoreg),
        .branch(branch),
        .mux_inp(mux_inp),
        .memread(mem_read),
        .memwrite(mem_write),
        .alusrc(alu_src),
        .reg_write(reg_write),
        .aluop(aluop)
    );

    // Register file
    regfile register_file(
        .clk(clk),
        .reset(reset),
        .we3(reg_write && !stall),
        .a1(rs1),
        .a2(rs2),
        .a3(rd),
        .wd3(wb_data),
        .rd1(rs1_data),
        .rd2(rs2_data)
    );

endmodule


