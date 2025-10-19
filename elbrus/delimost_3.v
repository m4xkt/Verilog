`timescale 10ns/100ps

module del_3 #(parameter DATA_W = 8)(
    input [DATA_W - 1:0]data,

    output wire divisibility
);

wire [DATA_W - 1:0]del;
assign del = data % 3;

assign divisibility = (del == 0) ? 1'b1 : 1'b0;

endmodule



module t_del_3();

localparam DATA_W = 2;

reg [DATA_W - 1:0]data_t;
wire div_t;

del_3 #(.DATA_W(DATA_W)) del_3(.data(data_t), .divisibility(div_t));



initial begin
    data_t = 0;

    #10 data_t = 1;
    #10 $display(data_t, " ", data_t%3, " ", div_t);

    #10 data_t = 2;
    #10 $display(data_t, " ", data_t%3, " ", div_t);

    #10 data_t = 3;
    #10 $display(data_t, " ", data_t%3, " ", div_t);

    #10 data_t = 4;
    #10 $display(data_t, " ", data_t%3, " ", div_t);

    #10 data_t = 5;
    #10 $display(data_t, " ", data_t%3, " ", div_t);


    #10 $finish;
end

endmodule