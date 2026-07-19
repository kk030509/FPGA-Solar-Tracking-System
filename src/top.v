module top(
    input clk,
    input reset,

    input vauxp6,
    input vauxn6,
    input vauxp7,
    input vauxn7,

    output servo_pwm,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an
);

wire tick_10ms;
wire tick_100ms;
tick_generator #(
    .CLK_FREQ(100_000_000),
    .TICK_MS(10)
    )tick0(
    .clk(clk),
    .reset(reset),
    .tick(tick_10ms)
);
tick_generator #(
    .CLK_FREQ(100_000_000),
    .TICK_MS(100)
    )tick1(
    .clk(clk),
    .reset(reset),
    .tick(tick_100ms)
);

wire [6:0] daddr;
wire den;
wire dwe;
wire [15:0] di;
wire [15:0] do;
wire drdy;
xadc_core xadc(
    .clk(clk),
    .reset(reset),
    .vauxp6(vauxp6),
    .vauxn6(vauxn6),
    .vauxp7(vauxp7),
    .vauxn7(vauxn7),
//controller에서 가져옴
    .daddr(daddr),
    .den(den),
    .dwe(dwe),
    .di(di),
    
    .do(do),
    .drdy(drdy)
);

wire [11:0] raw_cds_left;
wire [11:0] raw_cds_right;
wire        cds_left_en;
wire        cds_right_en;
xadc_controller ctrl(
    .clk(clk),
    .reset(reset),
    .do(do),
    .drdy(drdy),
    .tick(tick_100ms),
    .daddr(daddr),
    .den(den),
    .dwe(dwe),
    .di(di),
    .raw_cds_left(raw_cds_left),
    .raw_cds_right(raw_cds_right),
    .cds_left_en(cds_left_en),
    .cds_right_en(cds_right_en)
);

// 좌우 CdS 개체차 보정 (필요시 OFFSET 값 재보정)
wire [11:0] offset_cds_left;
wire [11:0] offset_cds_right;
offset_corrector #(
    .OFFSET(13'sd123)
)u_offset_left(
    .raw_value(raw_cds_left),
    .corrected_value(offset_cds_left)
);
offset_corrector #(
    .OFFSET(13'sd0)
)u_offset_right(
    .raw_value(raw_cds_right),
    .corrected_value(offset_cds_right)
);
 
// 8샘플 이동평균 필터
wire [11:0] cds_left;
wire [11:0] cds_right;
cds_filter u_filter_left(
    .clk(clk),
    .sample_en(cds_left_en),
    .raw_value(offset_cds_left),
    .filtered_value(cds_left)
);
cds_filter u_filter_right(
    .clk(clk),
    .sample_en(cds_right_en),
    .raw_value(offset_cds_right),
    .filtered_value(cds_right)
);


wire [7:0] angle;
wire [20:0] pulse_width;
angle_to_pwm angle_pwm(
    .angle(angle),
    .pulse_width(pulse_width)
);
pwm_generator pwm(
    .clk(clk),
    .reset(reset),
    .pulse_width(pulse_width),

    .pwm(servo_pwm)
);
wire is_day;
sun_tracker_fsm fsm(
    .clk(clk),
    .reset(reset),
    .cds_left(cds_left),
    .cds_right(cds_right),
    .tick(tick_100ms),

    .angle(angle),
    .is_day(is_day)
);
brightness_led u_led(
    .cds_left(cds_left),
    .cds_right(cds_right),
    .led(led)
);
 
fnd_display u_fnd(
    .clk(clk),
    .is_day(is_day),
    .seg(seg),
    .an(an)
);
endmodule
