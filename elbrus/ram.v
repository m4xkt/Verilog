`timescale 1ns/100ps
module joke #(
    parameter MEM_SIZE = 6, 
    parameter DATA_W = 10, 
    parameter ADDR_SIZE = MEM_SIZE
)(
    input write,
    input [DATA_W - 1:0]datain,
    input [ADDR_SIZE - 1:0]addr_w,
    input read,
    input [ADDR_SIZE - 1:0]addr_r,

    input clk,

    output reg [DATA_W - 1:0]dataout
);

reg [DATA_W - 1:0]mem[0:MEM_SIZE - 1];

always @(posedge clk) begin
    if (write && !read) begin
        mem[addr_w] <= datain;
        dataout <= mem[addr_w];
    end
    if (read && !write) begin
        dataout <= mem[addr_r];
    end
    if (read && write) begin
        dataout <= mem[addr_r];
        mem[addr_w] <= datain;
    end
    else begin
        dataout <= mem[addr_w];
    end
end

endmodule



module test();

localparam MEM_SIZE = 6;
localparam ADDR_SIZE = MEM_SIZE;
localparam DATA_W = 7;
reg clk = 1'b1;

always begin
    #1 clk = ~clk;
end

reg w, r;
reg [ADDR_SIZE - 1:0]addr_r;
reg [ADDR_SIZE - 1:0]addr_w;
reg [DATA_W - 1:0]d_in;
wire [DATA_W - 1:0]d_out;

joke #(.MEM_SIZE(MEM_SIZE), .ADDR_SIZE(ADDR_SIZE), .DATA_W(DATA_W)) joke (
    .write(w),
    .datain(d_in),
    .dataout(d_out),
    .clk(clk),
    .addr_r(addr_r),
    .addr_w(addr_w),
    .read(r)
);

initial begin
    $dumpvars;

    {d_in, w, r, addr_w, addr_r} = 0;

    #2
    d_in = 7'b0000001;
    w = 1;
    r = 1;
    addr_w = 0;
    addr_r = 0;
    #2 $display(d_out);

    #2
    d_in = 7'b0000010;
    w = 1;
    r = 1;
    addr_w = 1;
    addr_r = 0;
    #2 $display(d_out);

    #2
    d_in = 7'b0000011;
    w = 1;
    r = 1;
    addr_w = 5;
    addr_r = 1;
    #2 $display(d_out);

    #2
    d_in = 7'b0000100;
    w = 1;
    r = 1;
    addr_w = 2;
    addr_r = 5;
    #2 $display(d_out);

    #2
    d_in = 7'b000101;
    w = 1;
    r = 1;
    addr_w = 4;
    addr_r = 2;
    #2 $display(d_out);

    #2
    d_in = 7'b100111;
    w = 1;
    r = 1;
    addr_w = 3;
    addr_r = 4;
    #2 $display(d_out);

    #2
    d_in = 7'b000000;
    w = 0;
    r = 1;
    addr_r = 3;
    #2 $display(d_out);

    #50 $finish;
end

endmodule