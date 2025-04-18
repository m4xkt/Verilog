`timescale 1ns/100ps
module control(
    input [31:0]instr,

    output reg [11:0]imm12,
    output reg rf_w,
    output reg alu_op
);

//Поля из инструкций, отвечающие за то, какая инструкция должна исполняться
wire [6:0]opcode = instr[6:0];
wire [2:0]funct3 = instr[14:12];

 
always @(*) begin
    rf_w = 1'b0;
    alu_op = 1'b0;
    imm12 = 12'b0;

    casez({funct3, opcode}) 
        10'b000_0010011: begin
            rf_w = 1'b1;
            alu_op  = 1'b1;
            imm12 = instr[31:20];
        end
        default: ;
    endcase
end

endmodule

module core(
    input clk,
    input [31:0]instr,
    input [31:0]last_pc,

    output [31:0]instr_addr
);

reg [31:0]pc = 0;
assign instr_addr = pc;
always @(posedge clk) begin
    pc <= (pc == last_pc) ? pc : pc + 16;
    $display("[%h] %h", pc, instr);
end

wire [4:0]rd = instr[11:7];
wire [4:0]rs1 = instr[19:15];
wire [4:0]rs2 = instr[24:20];

wire [31:0]alu_res;
wire [31:0]alu_b_src = imm32;

alu alu(.src_a(rf_rdata0), .src_b(alu_b_src), .op(alu_op), .out(alu_res));

wire [31:0]rf_rdata0;
wire [31:0]rf_rdata1;
wire [4:0]rf_raddr0 = rs1;
wire [4:0]rf_raddr1 = rs2;
wire [31:0]rf_wdata = alu_res;
wire [4:0]rf_waddr = rd;
wire rf_w;

reg_file rf(
    .clk(clk),
    .raddr0(rf_raddr0), .rdata0(rf_rdata0),
    .raddr1(rf_raddr1), .rdata1(rf_rdata1),
    .waddr(rf_waddr), .wdata(rf_wdata), .we(rf_w)
);

wire [11:0]imm12;
wire [31:0]imm32 = { {20{imm12[11]} }, imm12 };


control control(
    .instr(instr),
    .imm12(imm12),
    .rf_w(rf_w),
    .alu_op(alu_op)
);

endmodule



module cpu_top(
    input wire clk
);

wire [31:0]instr_addr;
wire [31:0]instr_data;
rom rom(.addr(instr_addr[31:2]), .q(instr_data));

core core(
    .clk(clk),
    .instr(instr_data), .last_pc(32'h70),
    .instr_addr(instr_addr)
);

endmodule


module testbench();

reg clk = 1'b0;

always begin
    #1 clk = ~clk;
end

cpu_top cpu_top(.clk(clk));

initial begin
    $dumpvars;
    #16 $finish;
end

endmodule
