module instruction_mem(
    input [7:0] addr,
    output [7:0] instruction
);

reg [7:0] rom [0:255];

initial begin
    $readmemb("program.mem", rom);
end

// Changed from always @(*) to continuous assignment
assign instruction = rom[addr];

endmodule