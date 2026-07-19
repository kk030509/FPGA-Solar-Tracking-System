`timescale 1ns / 1ps
module fnd_display (
    input  wire       clk,
    input  wire       is_day,
    output reg  [6:0] seg,   // {CA,CB,CC,CD,CE,CF,CG} active low
    output reg  [3:0] an
);

localparam SEG_D   = 7'b0100001; // d
localparam SEG_A   = 7'b0001000; // A
localparam SEG_Y   = 7'b0010001; // Y
localparam SEG_N   = 7'b0101011; // n
localparam SEG_I   = 7'b1111001; // I
localparam SEG_G   = 7'b0010000; // G
localparam SEG_H   = 7'b0001011; // H
localparam SEG_OFF = 7'b1111111; // 꺼짐

localparam MUX_TICKS = 17'd100000;
reg [16:0] mux_cnt;
reg [1:0]  digit;

always @(posedge clk) begin
    if (mux_cnt >= MUX_TICKS) begin
        mux_cnt <= 0;
        digit   <= digit + 1;
    end
    else
        mux_cnt <= mux_cnt + 1;
end

always @(*) begin
    if (is_day) begin
        case (digit)
            2'd0: begin an = 4'b0111; seg = SEG_D;   end
            2'd1: begin an = 4'b1011; seg = SEG_A;   end
            2'd2: begin an = 4'b1101; seg = SEG_Y;   end
            2'd3: begin an = 4'b1111; seg = SEG_OFF; end
        endcase
    end
    else begin
        case (digit)
            2'd0: begin an = 4'b0111; seg = SEG_N; end
            2'd1: begin an = 4'b1011; seg = SEG_I; end
            2'd2: begin an = 4'b1101; seg = SEG_G; end
            2'd3: begin an = 4'b1110; seg = SEG_H; end
        endcase
    end
end
endmodule
