// Code your design here
`include "alu.v"
`include "pc.v"
`include "control_unit.v"
`include "data_ram.v"
`include "instruction_mem.v"


module cpu(

    input clk,
    input rst,
  input [7:0] ext_data

);

    //----------------------------
    // Internal Wires
    //----------------------------

    wire [7:0] pc;

    wire [7:0] instruction;

    wire [3:0] opcode;
    wire [3:0] operand;

    wire [7:0] A;
    wire [7:0] B;
    wire [7:0] RES;

    wire [7:0] alu_out;

    wire [7:0] ram_data;
    wire [7:0] data_in;

    wire [2:0] sel;

    wire carry;
    wire overflow;
    wire zero;

    wire halt;
    wire jmp_e;
    wire ram_we;

    wire [7:0] addr;
    wire [7:0] load_add;

    //----------------------------
    // Instruction Decode
    //----------------------------

    assign opcode  = instruction[7:4];
    assign operand = instruction[3:0];

    //----------------------------
    // Program Counter
    //----------------------------

    pc PC(

        .clk(clk),
        .rst(rst),
        .halt(halt),
        .jmp_e(jmp_e),
        .load_add(load_add),
        .pc(pc)

    );

    //----------------------------
    // Instruction Memory
    //----------------------------

    instruction_mem IM(

        .addr(pc),
        .instruction(instruction)

    );

    //----------------------------
    // Data RAM
    //----------------------------

    data_ram DR(

        .clk(clk),
        .we(ram_we),
        .addr(addr),
        .data_in(data_in),
        .data_out(ram_data)

    );

    //----------------------------
    // ALU
    //----------------------------

    alu ALU(

        .a(A),
        .b(B),
        .sel(sel),

        .alu_out(alu_out),

        .carry(carry),
        .overflow(overflow),
        .zero(zero)

    );

    //----------------------------
    // Control Unit
    //----------------------------

    control_unit CU(

        .clk(clk),

        .zero(zero),

        .opcode(opcode),
        .operand(operand),

        .ram_data(ram_data),
      .ext_data(ext_data),

        .alu_out(alu_out),

        .a(A),
        .b(B),
        .res(RES),

        .data_in(data_in),

        .sel(sel),

        .halt(halt),
        .jmp_e(jmp_e),

        .ram_we(ram_we),

        .addr(addr),

        .load_add(load_add)

    );

endmodule