`timescale 1ns / 1ps
// CdS 좌우 센서 개체차 보정용
// raw_value + OFFSET 계산 후 0~4095 범위로 클램핑
module offset_corrector #(
    parameter signed [12:0] OFFSET = 13'sd0
)(
    input  wire [11:0] raw_value,
    output wire [11:0] corrected_value
);

wire signed [12:0] sum;
assign sum = $signed({1'b0, raw_value}) + OFFSET;

assign corrected_value = (sum < 13'sd0)    ? 12'd0   :
                          (sum > 13'sd4095) ? 12'hFFF :
                          sum[11:0];

endmodule
