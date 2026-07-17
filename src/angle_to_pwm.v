`timescale 1ns / 1ps

// module angle_to_pwm (
//     input  wire [7:0]  angle,    // 0 ~ 180
//     output reg  [20:0] value
// );

    // localparam integer CLK_PER_MS = 100000; // 100MHz 기준 1ms

    // always @(*) begin
    //     if (angle < 8'd26)
    //         value = (CLK_PER_MS * 6)  / 10;  // 0.6ms  → 0도 부근
    //     else if (angle < 8'd52)
    //         value = (CLK_PER_MS * 9)  / 10;  // 0.9ms
    //     else if (angle < 8'd77)
    //         value = (CLK_PER_MS * 12) / 10;  // 1.2ms
    //     else if (angle < 8'd103)
    //         value = (CLK_PER_MS * 15) / 10;  // 1.5ms → 중간
    //     else if (angle < 8'd128)
    //         value = (CLK_PER_MS * 17) / 10;  // 1.7ms
    //     else if (angle < 8'd154)
    //         value = (CLK_PER_MS * 20) / 10;  // 2.0ms
    //     else
    //         value = (CLK_PER_MS * 23) / 10;  // 2.3ms → 180도 부근
    // end

module angle_to_pwm(
    input  [7:0] angle,
    output reg [20:0] value
);

always @(*) begin
    value = 21'd60000 + angle * 21'd944;
end

endmodule