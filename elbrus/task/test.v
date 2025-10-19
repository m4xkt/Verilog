`timescale 1ns/100ps

// дв. признак делимости на 2 (пример - b111010 = d123) 1 - 1 + 1 - 0  + 1 - 0 = 2, 2 на 3 не делится => всё 111010 не делится на 3
// рекурсивная функция, реализовать не получится

// b111010 = 100000 + 010000 + 001000 + 000000 + 000010 + 000000
//    d123 =   32   +   16   +    8   +    0   +    2   +    0    если сумма остатков от деления на 3 данных слагаемых кратна трём, то 123%3 = 0

/*       
у нечётных степеней двойки остаток от деления равен 2, у чётных - 1
тогда в остаток запишем b10, если бит чётный и b01, если нечётный
*/

module del_3 #(parameter DATA_W = 8)(
    input [DATA_W - 1:0]data,

    output divisibility
);

reg [2:0]ost; // трёхбитный остаток от деления yf 3
integer i;


always @(*) begin
    ost = 0;

    for (i = DATA_W-1; i >= 0; i = i - 1) begin
        ost = ((i & 1'b1) == 0) ? ost + data[i] : ost + (data[i] << 1); //чётность определяем по нулевому биту биту i
        
        if (ost > 3'b010) begin
            ost = ost - 3'b011;
            //$display("minus 3 ost: %b", ost);
        end
        //$display("ost:%b", ost, " i:%d", i, "; (i&1 == 0):%d", i&1'b1, "; data[i]: %b", data[i]);
    end
end

assign divisibility = (ost == 0) ? 1'b1 : 1'b0;

endmodule


module test();

localparam DATA_W = 8;
reg [DATA_W - 1:0]data;
wire div;

del_3 #(.DATA_W(DATA_W)) del_3 (.data(data), .divisibility(div));

initial begin
    $dumpvars;
    data = 0;

    #2 data = 6;
    #1 $display("da: ", div);

    #2 data = 32;
    #1 $display("net: ", div);

    #2 data = 255;
    #1 $display("da: ", div);

    #2 data = 1024;
    #1 $display("da: ", div);

    #2 data = 1;
    #1 $display("net: ", div);

    #2 data = 2;
    #1 $display("net: ", div);


    #20 $finish;
end

endmodule