`timescale 1ns / 1ps
// 더 밝은 쪽 CdS 값을 기준으로 16개 LED를 바그래프로 켬
module brightness_led (
    input  wire [11:0] cds_left,
    input  wire [11:0] cds_right,
    output reg  [15:0] led
);

wire [11:0] bright;
assign bright = (cds_left > cds_right) ? cds_left : cds_right;

// 4095 / 16 = 256 단위로 LED 하나씩 추가
always @(*) begin
    if      (bright < 12'd256)  led = 16'b0000000000000000;
    else if (bright < 12'd512)  led = 16'b0000000000000001;
    else if (bright < 12'd768)  led = 16'b0000000000000011;
    else if (bright < 12'd1024) led = 16'b0000000000000111;
    else if (bright < 12'd1280) led = 16'b0000000000001111;
    else if (bright < 12'd1536) led = 16'b0000000000011111;
    else if (bright < 12'd1792) led = 16'b0000000000111111;
    else if (bright < 12'd2048) led = 16'b0000000001111111;
    else if (bright < 12'd2304) led = 16'b0000000011111111;
    else if (bright < 12'd2560) led = 16'b0000000111111111;
    else if (bright < 12'd2816) led = 16'b0000001111111111;
    else if (bright < 12'd3072) led = 16'b0000011111111111;
    else if (bright < 12'd3328) led = 16'b0000111111111111;
    else if (bright < 12'd3584) led = 16'b0001111111111111;
    else if (bright < 12'd3840) led = 16'b0011111111111111;
    else                        led = 16'b1111111111111111;
end

endmodule
