`include "alu.v"
`include "pc.v"
`include "control_unit.v"
`include "data_ram.v"
`include "instruction_mem.v"
`include "register_file.v"
`include "if_id_reg.v"
`include "ex_mem_reg.v"
`include "forwarding_unit.v"

module cpu(
    input clk,rst,
    input [7:0] ext_data
);

    wire [7:0] if_pc,if_instruction;
    wire [7:0] id_pc,id_instruction;
    wire [3:0] id_opcode,id_operand;

    wire [7:0] A,B,RES,fwd_A,fwd_B,alu_out,data_in;
    wire [2:0] sel;
    wire current_zero, carry, overflow; 
    wire halt, jmp_e, ram_we;
    wire [7:0] addr, load_add;
    wire flush;

    wire [3:0] mem_opcode,mem_operand;
    wire [7:0] mem_alu_out,mem_addr,mem_data_in;
    wire  mem_ram_we;
    wire [7:0] ram_data;

    assign flush = jmp_e;

    // --- FIX: DEDICATED ZERO FLAG REGISTER ---
    reg zero_flag;
    always @(posedge clk) begin
        if (rst) zero_flag <= 1'b0;
        // Lock the flag only when an ALU operation executes
        else if (id_opcode >= 4'b0001 && id_opcode <= 4'b1000) begin
            zero_flag <= current_zero;
        end
    end

    pc PC(.clk(clk), .rst(rst), .halt(halt), .jmp_e(jmp_e), .load_add(load_add), .pc(if_pc));
    instruction_mem IM(.addr(if_pc), .instruction(if_instruction));

    if_id_reg IF_ID(
        .clk(clk), .rst(rst), .flush(flush),
        .if_pc(if_pc), .if_instruction(if_instruction),
        .id_pc(id_pc), .id_instruction(id_instruction)
    );

    assign id_opcode  = id_instruction[7:4];
    assign id_operand = id_instruction[3:0];

    forwarding_unit FU(
        .reg_A(A), .reg_B(B), .reg_RES(RES),
        .mem_opcode(mem_opcode), .mem_operand(mem_operand),
        .mem_alu_out(mem_alu_out), .ram_data(ram_data), .ext_data(ext_data),
        .fwd_A(fwd_A), .fwd_B(fwd_B)
    );

    alu ALU(
        .a(fwd_A), .b(fwd_B),
        .sel(sel), .alu_out(alu_out),
        .carry(carry), .overflow(overflow), .zero(current_zero)
    );

    control_unit CU(
        .zero(zero_flag), .opcode(id_opcode), .operand(id_operand), 
        .a(fwd_A), 
        .data_in(data_in), .sel(sel), .halt(halt),
        .jmp_e(jmp_e), .ram_we(ram_we), .addr(addr), .load_add(load_add)
    );

    ex_mem_reg EX_MEM(
        .clk(clk), .rst(rst),
        .ex_opcode(id_opcode), .ex_operand(id_operand),
        .ex_alu_out(alu_out), .ex_addr(addr), .ex_data_in(data_in), .ex_ram_we(ram_we),
        .mem_opcode(mem_opcode), .mem_operand(mem_operand),
        .mem_alu_out(mem_alu_out), .mem_addr(mem_addr), .mem_data_in(mem_data_in), .mem_ram_we(mem_ram_we)
    );

    data_ram DR(
        .clk(clk), .we(mem_ram_we), .addr(mem_addr),
        .data_in(mem_data_in), .data_out(ram_data)
    );

    register_file RF(
        .clk(clk), .rst(rst),
        .opcode(mem_opcode), .operand(mem_operand),
        .alu_out(mem_alu_out), .ram_data(ram_data), .ext_data(ext_data),
        .a(A), .b(B), .res(RES)
    );

    wire [7:0] pc = if_pc;
    wire [7:0] instruction = if_instruction;
    wire [3:0] opcode = id_opcode;

endmodule
