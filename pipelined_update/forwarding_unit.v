module forwarding_unit(
    input [7:0] reg_A,
    input [7:0] reg_B,
    input [7:0] reg_RES,
    
    input [3:0] mem_opcode,
    input [3:0] mem_operand,
    input [7:0] mem_alu_out,
    input [7:0] ram_data,
    input [7:0] ext_data,
    
    output reg [7:0] fwd_A,
    output reg [7:0] fwd_B
);

always @(*) begin
    fwd_A = reg_A;
    fwd_B = reg_B;
    
    // Check if Stage 3 is updating 'A'
    if (mem_opcode == 4'b1001) begin 
        fwd_A = ram_data; 
    end else if (mem_opcode == 4'b1101) begin 
        fwd_A = ext_data; 
    end else if (mem_opcode == 4'b0000 && mem_operand[3:2] == 2'b00) begin
        case(mem_operand[1:0])
            2'b01: fwd_A = reg_B;       
            2'b10: fwd_A = reg_RES;     
            2'b11: fwd_A = mem_alu_out; 
        endcase
    end
    
    // Check if Stage 3 is updating 'B'
    if (mem_opcode == 4'b0000 && mem_operand[3:2] == 2'b01) begin
        case(mem_operand[1:0])
            2'b00: fwd_B = reg_A;       
            2'b10: fwd_B = reg_RES;     
            2'b11: fwd_B = mem_alu_out; 
        endcase
    end
end

endmodule 
