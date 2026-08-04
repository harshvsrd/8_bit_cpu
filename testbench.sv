module tb;

   reg clk;
    reg rst;
  reg [7:0] ext_data;

    // Instantiate your top module
    cpu dut (
        .clk(clk),
      .rst(rst),
      .ext_data(ext_data)
    );
  
    always #5 clk = ~clk;

    initial begin
        // This generates the waveform file for EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Monitor console output for key internal registers
      $monitor("Time=%0t | PC=%b | Inst=%b | Op=%b | A=%d | B=%d | ALU=%d |OV=%d |C=%d | Halt=%b", 
                 $time, dut.pc, dut.instruction, dut.opcode, dut.A, dut.B, dut.alu_out ,dut.overflow ,dut.carry, dut.halt);
      
      ext_data=8'd99;
       
      // Pre-load RAM with decimal values 10 and 20
  dut.DR.memory[0] = 8'd10;
  dut.DR.memory[1] = 8'd20;
        // Initialization & Reset Sequence
        clk = 0;
        rst = 1;

        #10 rst = 0; // Release reset

        // Auto-stop simulation after 200 time units to prevent infinite loops
        #200 $finish;
    end

    always @(posedge clk) begin
        if (dut.halt == 1'b1) begin
            $display("CPU Halted at Time=%0t", $time);
            #10 $finish;
        end
    end

endmodule