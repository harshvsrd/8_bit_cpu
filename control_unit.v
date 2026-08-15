module control_unit(
    input clk,
    input zero,
    input [3:0] opcode,
    input [3:0] operand,
  input [7:0] ram_data,ext_data,
    input [7:0] alu_out,

    output reg [7:0] a,
    output reg [7:0] b,
    output reg [7:0] res,
    output reg [7:0] data_in,
    output reg [2:0] sel,
output reg halt,
   output reg jmp_e,
    output reg ram_we,
    output reg [7:0] addr,
    output reg [7:0] load_add
);

// 1. COMBINATIONAL: Instantly decode signals (Use '=' instead of '<=')
always @(*) begin
    // Default values prevent latches
    halt     = 1'b0;
    jmp_e    = 1'b0;
    ram_we   = 1'b0;
    sel      = 3'b111; 
    addr     = 8'd0;
    load_add = 8'd0;
    data_in  = a; // Ready to write A to RAM at any time

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
        4'b1100: begin  // JMPE
            if(zero) begin
                jmp_e = 1'b1;
                load_add = {4'b0000, operand};
            end
        end
        4'b1111: halt = 1'b1;// HALT
    endcase
end

// 2. SEQUENTIAL: Update physical registers on clock edge (Use '<=')
always @(posedge clk) begin
    case(opcode)
      4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110: begin
            res <= alu_out;
        end

        4'b0000: begin // Register Operations
            case(operand[3:2])
                2'b00: begin // Destination = A
                    case(operand[1:0])
                        2'b01: a <= b;
                        2'b10: a <= res;
                        2'b11: a <= alu_out;
                    endcase
                end
                2'b01: begin // Destination = B
                    case(operand[1:0])
                        2'b00: b <= a;
                        2'b10: b <= res;
                        2'b11: b <= alu_out;
                    endcase
                end
                2'b10: begin // Destination = RES
                    case(operand[1:0])
                        2'b00: res <= a;
                        2'b01: res <= b;
                        2'b11: res <= alu_out;
                    endcase
                end
            endcase
        end
        4'b1001: a <= ram_data; // LOAD into A
      4'b1101:a<=ext_data;
    endcase
end

endmodule
