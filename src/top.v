`timescale 1ns / 1ps

module SunTracker (
    input  wire CLK100MHZ,
    input  wire vauxp6, vauxn6,   // CdS left
    input  wire vauxp7, vauxn7,   // CdS right
    input  wire vp_in,  vn_in,
    output wire PWM,
    output wire [6:0] seg,   // 추가
    output wire [3:0] an,
    output wire [15:0] led
);

    wire [11:0] cds_left, cds_right;
    wire [7:0]  angle;
    wire [20:0] value;
    wire is_day;
    assign is_day = (cds_left > 12'd204) || (cds_right > 12'd204);


    brightness_led u_led (
        .cds_left  (cds_left),
        .cds_right (cds_right),
        .led       (led)
    );
    fnd_display u_fnd (
        .clk    (CLK100MHZ),
        .is_day (is_day),
        .seg    (seg),
        .an     (an)
    );
    xadc_ctrl u_xadc (
        .clk       (CLK100MHZ),
        .vauxp6    (vauxp6), .vauxn6 (vauxn6),
        .vauxp7    (vauxp7), .vauxn7 (vauxn7),
        .vp_in     (vp_in),  .vn_in  (vn_in),
        .cds_left  (cds_left),
        .cds_right (cds_right)
    );

    sun_tracker_fsm u_fsm (
        .clk       (CLK100MHZ),
        .rst       (rst),
        .cds_left  (cds_left),
        .cds_right (cds_right),
        .angle     (angle),
        .diff      (diff),
        .state_out(state)
    );

    angle_to_pwm u_map (
        .angle (angle),
        .value (value)
    );

    pwm_gen u_pwm (
        .clk   (CLK100MHZ),
        .value (value),
        .PWM   (PWM)
    );
    ila_0 ila_inst (
    .clk(CLK100MHZ),
    .probe0(cds_left),
    .probe1(cds_right),
    .probe2(diff),
    .probe3(angle),
    .probe4(state)
);

endmodule
