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
        // Generate the waveform file for EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Monitor console output for key internal registers
        $monitor("Time=%0t | PC=%b | Inst=%b | Op=%b | A=%d | B=%d | ALU=%d |OV=%d |C=%d | Halt=%b", 
                 $time, dut.pc, dut.instruction, dut.opcode, dut.A, dut.B, dut.alu_out, dut.overflow, dut.carry, dut.halt);
      
        ext_data = 8'd99;
        clk = 0;
        rst = 1;

        #10 rst = 0; // Release reset

        // PRE-LOAD DATA HERE
      dut.DR.memory[0] = 8'd7; // Multiplier
        dut.DR.memory[1] = 8'd20; // Multiplicand
        dut.DR.memory[2] = 8'd0;  // Initial Sum = 0
        dut.DR.memory[3] = 8'd1;  // Constant 1

        // Auto-stop simulation as a fallback to prevent infinite loops
        #2000;
        $display("TIMEOUT: CPU never reached HALT state.");
        $finish;
    end

    // Dynamically print the result exactly when the CPU halts
    always @(posedge clk) begin
        if (dut.halt == 1'b1) begin
            $display("========================================");
            $display(" CPU Halted at Time=%0t", $time);
            $display(" MULTIPLICATION RESULT (RAM[2]) = %d", dut.DR.memory[2]);
            $display("========================================");
            #10 $finish;
        end
    end

endmodule
