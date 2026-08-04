module data_ram(

    input clk,we,
  input [7:0] addr,
     input [7:0] data_in,

    output reg [7:0] data_out

);

reg [7:0] memory [0:255];

always @(posedge clk)
begin

    if(we)
        memory[addr] <= data_in;

end

always @(*)
begin

    data_out = memory[addr];

end

endmodule