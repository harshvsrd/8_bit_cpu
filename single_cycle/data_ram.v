module data_ram(
    input clk, we, rst,
    input [7:0] addr,
    input [7:0] data_in,
    output reg [7:0] data_out
);

reg [7:0] memory [0:255];
integer i;

always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] <= 8'd0;
        end
    end else if(we) begin
        memory[addr] <= data_in;
    end
end

always @(*) begin
    data_out = memory[addr];
end

endmodule
