module reg_file(        
    input clk,          
    input [4:0]raddr0,   // Адрес чтения №0
    input [4:0]raddr1,   // Адрес чтения №1
    input [4:0]waddr,    // Адрес записи
    input [31:0]wdata,   // Данные для записи
    input we,            // Вход разрешения записи
                        
    output [31:0]rdata0, // Прочитанные данные №0
    output [31:0]rdata1  // Прочитанные данные №1
);

reg [31:0]regs[0:31];

assign rdata0 = (raddr0 == 0) ? 0 : regs[raddr0];
assign rdata1 = (raddr1 == 0) ? 0 : regs[raddr1];

always @(posedge clk) begin
    if (we && waddr != 0) begin
        regs[waddr] <= wdata;
        $display("x%0d = %h", waddr, wdata);
    end
end

endmodule