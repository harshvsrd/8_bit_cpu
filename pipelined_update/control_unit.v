module control_unit(
    input zero, 
    input [3:0] opcode, operand,
    input [7:0] a, 

    output reg [7:0] data_in,
    output reg [2:0] sel,
    output reg halt, jmp_e, ram_we,
    output reg [7:0] addr, load_add
);

always @(*) begin
    halt     = 1'b0;
    jmp_e    = 1'b0;
    ram_we   = 1'b0;
    sel      = 3'b111; 
    addr     = 8'd0;
    load_add = 8'd0;
    data_in  = a; 

    case(opcode)
        4'b0001: sel = 3'b000; // ADD
        4'b0010: sel = 3'b001; // SUB
        4'b0011: sel = 3'b010; // OR
        4'b0100: sel = 3'b011; // AND
        4'b0101: sel = 3'b100; // XOR
        4'b0110: sel = 3'b101; // SHL
        4'b0111: sel = 3'b110; // SHR
        4'b1000: sel = 3'b111; // PASS A
        4'b1001: addr = {4'b0000, operand}; // LOAD
        4'b1010: begin         // STORE
            addr = {4'b0000, operand};
            ram_we = 1'b1;
        end
        4'b1011: begin      // JMP
            jmp_e = 1'b1;
            load_add = {4'b0000, operand};
        end
        4'b1100: begin      // JMPE
            if(zero) begin 
                jmp_e = 1'b1;
                load_add = {4'b0000, operand};
            end
        end
        4'b1101: begin      // EXT_LOAD
            sel = 3'b111; // Prevent floating signals
        end
        4'b1110: begin      // IND_ACCESS (Use A as RAM pointer)
            addr = a; 
            if (operand[0] == 1'b1) begin 
                ram_we = 1'b1; // e.g., 1110_0001 -> Store A into RAM[A]
            end
        end
        4'b1111: halt = 1'b1; // HALT
        default: ;
    endcase
end

endmodule
