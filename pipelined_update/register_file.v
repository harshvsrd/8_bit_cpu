module register_file(
    input clk,
    input rst,
    input [3:0] opcode,
    input [3:0] operand,
    input [7:0] alu_out,
    input [7:0] ram_data,
    input [7:0] ext_data,
    
    output reg [7:0] a,
    output reg [7:0] b,
    output reg [7:0] res
);

always @(posedge clk) begin
    if (rst) begin
        a   <= 8'd0;
        b   <= 8'd0;
        res <= 8'd0;
    end else begin
        case(opcode)
            4'b0000: begin // Register Operations
                case(operand[3:2])
                    2'b00: begin // Dest = A
                        case(operand[1:0])
                            2'b01: a <= b;
                            2'b10: a <= res;
                            2'b11: a <= alu_out;
                        endcase
                    end
                    2'b01: begin // Dest = B
                        case(operand[1:0])
                            2'b00: b <= a;
                            2'b10: b <= res;
                            2'b11: b <= alu_out;
                        endcase
                    end
                    2'b10: begin // Dest = RES
                        case(operand[1:0])
                            2'b00: res <= a;
                            2'b01: res <= b;
                            2'b11: res <= alu_out;
                        endcase
                    end
                endcase
            end
            
            // Catch all ALU operations and save the output to RES
            4'b0001, 4'b0010, 4'b0011, 4'b0100, 
            4'b0101, 4'b0110, 4'b0111, 4'b1000: begin
                res <= alu_out;
            end

            4'b1001: a <= ram_data; // LOAD into A
            4'b1101: a <= ext_data; // EXT LOAD
            
            // Catch the new Indirect Load
            4'b1110: begin          
                if (operand[0] == 1'b0) a <= ram_data;
            end
        endcase
    end
end

endmodule
