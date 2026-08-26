module if_id_reg(
    input clk,
    input rst,
    input flush, 
    
    input [7:0] if_pc,
    input [7:0] if_instruction,
    
    output reg [7:0] id_pc,
    output reg [7:0] id_instruction
);

always @(posedge clk) begin
    if (rst || flush) begin
        id_pc          <= 8'd0;
        id_instruction <= 8'd0;
    end else begin
        id_pc          <= if_pc;
        id_instruction <= if_instruction;
    end
end

endmodule
