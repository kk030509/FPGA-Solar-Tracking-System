`timescale 1ns / 1ps

module pwm_gen (
    input  wire        clk,
    input reset,
    input  wire [20:0] value,
    output wire        PWM
);

    reg [20:0] count;

    always @(posedge clk) begin
        if (reset)
            count <= 21'd0;
        else if(count == 2_000_000-1)
            count <= 21'd0;
        else
            count <= count + 1'b1;
    end

    assign PWM = (count < value);

endmodule