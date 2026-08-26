module data_ram(
    input clk,
    input we,
    input [7:0] addr,
    input [7:0] data_in,
    output [7:0] data_out
);

reg [7:0] memory [0:255];

always @(posedge clk) begin
    if(we)
        memory[addr] <= data_in;
end

// Changed from always @(*) to continuous assignment
assign data_out = memory[addr];

endmodule
