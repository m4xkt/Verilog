module rom #(parameter LENGTH = 8, parameter WIDTH = 32)(
    input [31:0]addr,

    output [WIDTH - 1:0]q
);

reg [WIDTH - 1:0]mem[0:LENGTH - 1];

assign q = mem[addr[31:2]]; //Адресация по старшим битам

initial begin
    $readmemh("addi.txt", mem);
end

endmodule

module rom_fetcher(
    input clk,
    output [15:0]q
);

reg [7:0]pc = 0;
wire [7:0]pc_next = pc + 1;

rom #(.WIDTH(16)) rom(.addr(pc), .q(q));

always @(posedge clk) begin
  pc <= pc_next;
end

endmodule