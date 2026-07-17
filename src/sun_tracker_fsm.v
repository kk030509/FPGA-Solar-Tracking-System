`timescale 1ns / 1ps
module sun_tracker_fsm(
    input  wire        clk,
    input  wire        rst,
    input  wire [11:0] cds_left,
    input  wire [11:0] cds_right,
    output wire [11:0] diff,
    output reg  [7:0]  angle,
    output wire [2:0] state_out
);
    localparam ANGLE_MIN   = 8'd0;
    localparam ANGLE_MAX   = 8'd120;
    localparam NIGHT_LEVEL = 12'd285;  // 0.07V
    localparam START_DIFF  = 12'd200;  // 0.06V
    localparam MOVE_WAIT   = 32'd10000000;  // 100ms
    localparam CHECK_WAIT  = 32'd10000000; // 1초
    localparam HOME_WAIT   = 32'd5000000;   // 50ms
    localparam HOME_STEP   = 8'd5;          // 5도씩

    localparam DAY_CHECK      = 3'd0;
    localparam READ           = 3'd1;
    localparam MOVE           = 3'd2;
    localparam WAIT           = 3'd3;
    localparam TRACKED        = 3'd4;
    localparam GO_HOME        = 3'd5;
    localparam GO_HOME_WAIT   = 3'd6; // GO_HOME 전용 대기

    reg [2:0]  state;
    reg [31:0] counter;
    reg [3:0] night_cnt;
    assign state_out = state;

    assign diff = (cds_left > cds_right) ?
                  (cds_left - cds_right) :
                  (cds_right - cds_left);

    wire is_day;
    assign is_day = (cds_left > NIGHT_LEVEL) || (cds_right > NIGHT_LEVEL);

    always @(posedge clk) begin
        if (rst) begin
            angle   <= ANGLE_MIN;
            state   <= DAY_CHECK;
            counter <= 0;
            night_cnt <= 0;
        end
        else begin
            case (state)

                DAY_CHECK: begin
                    if (!is_day)begin
                        if(night_cnt < 20)
                        night_cnt <= night_cnt + 1;
                        else
                            state <= GO_HOME;
                end
                else begin 
                    night_cnt <= 0;
                    state <= READ;
                end
                end

                READ: begin
                    if (diff > START_DIFF)
                        state <= MOVE;
                    else begin
                        counter <= 0;
                        state   <= TRACKED;
                    end
                end

                MOVE: begin
                    if (angle < ANGLE_MAX) begin
                        angle   <= angle + 1;
                        counter <= 0;
                        state   <= WAIT;
                    end
                    else begin
                        counter <= 0;
                        state   <= TRACKED;
                    end
                end

                WAIT: begin
                    if (counter >= MOVE_WAIT) begin
                        counter <= 0;
                        state   <= READ;
                    end
                    else
                        counter <= counter + 1;
                end

                TRACKED: begin
                    if (counter >= CHECK_WAIT) begin
                        counter <= 0;
                        state   <= DAY_CHECK;
                    end
                    else
                        counter <= counter + 1;
                end

                GO_HOME: begin
                    if (angle > ANGLE_MIN) begin
                        angle   <= (angle > HOME_STEP) ?
                                   (angle - HOME_STEP) : ANGLE_MIN;
                        counter <= 0;
                        state   <= GO_HOME_WAIT;
                    end
                    else begin
                        counter <= 0;
                        state   <= DAY_CHECK;
                    end
                end

                GO_HOME_WAIT: begin
                    if (counter >= HOME_WAIT) begin
                        counter <= 0;
                        state   <= GO_HOME;
                    end
                    else
                        counter <= counter + 1;
                end

                default: state <= DAY_CHECK;

            endcase
        end
    end
endmodule