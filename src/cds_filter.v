`timescale 1ns / 1ps

module cds_filter (
    input  wire        clk,
    input  wire        sample_en,
    input  wire [11:0] raw_value,
    output wire [11:0] filtered_value
);

    // 8샘플 버퍼 (12bit × 8 = 최대 15bit 합산)
    reg [11:0] buf0, buf1, buf2, buf3;
    reg [11:0] buf4, buf5, buf6, buf7;

    always @(posedge clk) begin
        if (sample_en) begin
            buf7 <= buf6;
            buf6 <= buf5;
            buf5 <= buf4;
            buf4 <= buf3;
            buf3 <= buf2;
            buf2 <= buf1;
            buf1 <= buf0;
            buf0 <= raw_value;
        end
    end

    // 합산 후 >> 3 (÷8)
    assign filtered_value =
        (buf0 + buf1 + buf2 + buf3 +
         buf4 + buf5 + buf6 + buf7) >> 3;

endmodule