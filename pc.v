module pc(
    input clk,rst,halt,jmp_e,
   input [7:0] load_add,
    output reg [7:0] pc
);

always @(posedge clk) begin
    if(halt)
        pc <= pc;
    else if(rst)
        pc <= 0;
  else if(jmp_e)
        pc <= load_add;
    else
        pc <= pc + 1;
end

endmodule