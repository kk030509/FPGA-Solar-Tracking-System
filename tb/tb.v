`timescale 1ns/1ps

module top_tb;

reg clk;
reg reset;

wire [6:0] daddr;
wire den;
wire dwe;
wire [15:0] di;

wire [15:0] do;
wire drdy;

wire [11:0] cds_left;
wire [11:0] cds_right;

wire [7:0] angle;

wire [20:0] pulse_width;

wire servo_pwm;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
initial begin
    reset = 1;
    #100;
    reset = 0;
end
reg tick;

initial begin
    tick = 0;

    forever begin
        #1000;
        tick = 1;
        #10;
        tick = 0;
    end
end
fake_xadc fake(

    .clk(clk),

    .daddr(daddr),
    .den(den),

    .do(do),
    .drdy(drdy)

);
xadc_controller ctrl(

    .clk(clk),
    .reset(reset),

    .do(do),
    .drdy(drdy),

    .tick(tick),

    .daddr(daddr),
    .den(den),
    .dwe(dwe),
    .di(di),

    .cds_left(cds_left),
    .cds_right(cds_right)

);
sun_tracker_fsm fsm(

    .clk(clk),
    .reset(reset),

    .cds_left(cds_left),
    .cds_right(cds_right),

    .tick(tick),

    .angle(angle)

);
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
initial begin

    wait(reset == 0);

    #5000;

    fake.left_value = 3000;
    fake.right_value = 1200;

    #50000;

    fake.left_value = 1200;
    fake.right_value = 3000;

    #50000;

    fake.left_value = 2500;
    fake.right_value = 2500;
    #50000;

$finish;

end
endmodule
