`timescale 1ns/100ps
module s(
    input clk,
    output clk1
);

assign clk1 = ~clk;

endmodule

module test();

reg clk = 1'b0;

always begin
    #1 clk = ~clk;
end

wire clk1;

s hi(.clk(clk), .clk1(clk1));

initial begin
    $dumpvars;
    $display("hell0");
    #30 $finish;
end

endmodule