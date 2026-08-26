module alu(

 input  [7:0] a,b,
   input  [2:0] sel,

     output reg [7:0] alu_out,
 output reg carry,overflow,zero
);

always @(*) begin

    carry    = 1'b0;
    overflow = 1'b0;
    alu_out  = 8'd0;

    case(sel)

        // ADD
        3'b000:
        begin
            {carry, alu_out} = a + b;
            overflow = (a[7]==b[7]) && (alu_out[7]!=a[7]);
        end

        // SUB
        3'b001:
        begin
            {carry, alu_out} = a - b;
            overflow = (a[7]!=b[7]) && (alu_out[7]!=a[7]);
        end

        3'b010:alu_out = a | b;//or
        3'b011:alu_out = a & b;//and
        3'b100:alu_out = a ^ b;//xor
        3'b101:alu_out = a << 1;//shl
        3'b110:alu_out = a >> 1;//shr
      3'b111:alu_out = a;//hold a
        default:alu_out = 8'd0;

    endcase

    zero = (alu_out == 8'd0);

end

endmodule
