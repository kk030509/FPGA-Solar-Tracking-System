//카운터 한 클럭 늦게 pwm에 반영됨 -> 큰 영향 없음
// counter : 20ms period
// pulse_width : High duration
// pwm : Servo PWM output

module pwm_generator(
    input clk,
    input reset,
    input [20:0] pulse_width,

    output wire pwm
);

reg [20:0] counter;
localparam [20:0] CNT_MAX = 2_000_000; //20ms
always @(posedge clk) begin
    if(reset)begin
        counter <= 0;
    end
    else begin 
        if(counter == CNT_MAX-1)
            counter <= 0;
        else 
            counter <= counter + 1;
    end
end

//pulse width만큼 pwm을 1줌. 
assign pwm = (counter < pulse_width);

endmodule