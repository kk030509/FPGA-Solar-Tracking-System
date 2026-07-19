//각도를 받아서 high시간이 몇 us인지 변환하는 모듈
module angle_to_pwm(
    input [7:0] angle,

    output reg [20:0] pulse_width
);
localparam MIN_PULSE = 100_000;
localparam STEP = 944;
//일반적으로 0도 -> 100_000
//         90도-> 150_000
//        180도-> 200_000
always @(*)begin
    if(angle > 180)
        pulse_width = 180 * STEP + MIN_PULSE;
    else 
        pulse_width = angle * STEP + MIN_PULSE;
end
endmodule