module alu(
    input [31:0]src_a,
    input [31:0]src_b,
    input op,
    output reg [31:0]out
);

always @(*) begin
    case(op)
        1'b0: out = src_a;
        1'b1: out = src_a + src_b;
    endcase
end

endmodule