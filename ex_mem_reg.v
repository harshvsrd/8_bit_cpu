module ex_mem_reg(
    input clk,
    input rst,
    
    input [3:0] ex_opcode,
    input [3:0] ex_operand,
    input [7:0] ex_alu_out,
    input [7:0] ex_addr,
    input [7:0] ex_data_in,
    input       ex_ram_we,
    
    output reg [3:0] mem_opcode,
    output reg [3:0] mem_operand,
    output reg [7:0] mem_alu_out,
    output reg [7:0] mem_addr,
    output reg [7:0] mem_data_in,
    output reg       mem_ram_we
);

always @(posedge clk) begin
    if (rst) begin
        mem_opcode  <= 4'd0;
        mem_operand <= 4'd0;
        mem_alu_out <= 8'd0;
        mem_addr    <= 8'd0;
        mem_data_in <= 8'd0;
        mem_ram_we  <= 1'b0;
    end else begin
        mem_opcode  <= ex_opcode;
        mem_operand <= ex_operand;
        mem_alu_out <= ex_alu_out;
        mem_addr    <= ex_addr;
        mem_data_in <= ex_data_in;
        mem_ram_we  <= ex_ram_we;
    end
end

endmodule