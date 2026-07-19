module sun_tracker_fsm(
    input clk,
    input reset,
    input [11:0] cds_left,
    input [11:0] cds_right,
    input tick,

    output reg [7:0] angle,
    output wire is_day
);

localparam IDLE = 3'd0;
localparam READ = 3'd1;
localparam MOVE = 3'd2;
localparam WAIT = 3'd3;
localparam DAY_CHECK = 3'd4;
localparam GO_HOME = 3'd5;
localparam HOME_WAIT = 3'd6;
localparam THRESHOLD = 12'd200;
localparam ANGLE_MIN = 0;
localparam ANGLE_MAX = 120;
localparam NIGHT_LEVEL = 285;
localparam NIGHT_DEBOUNCE = 5'd20;
reg [4:0] night_cnt;
wire [11:0] diff;
assign diff = (cds_left > cds_right) ?
              (cds_left - cds_right) :
              (cds_right - cds_left);
wire is_day;
reg [2:0] state;
assign is_day = (cds_left > NIGHT_LEVEL)||(cds_right> NIGHT_LEVEL);
always @(posedge clk ) begin
    if(reset)begin
        state <= IDLE;
        angle <= ANGLE_MIN;
        night_cnt <= 0;
    end
    else begin
        case (state)
            IDLE : begin
                state <= DAY_CHECK;
            end
            DAY_CHECK : begin
                if(is_day)begin
                    state <= READ;
                    night_cnt <= 0;
                end
                else begin
                    if(tick)begin
                        if(night_cnt < NIGHT_DEBOUNCE-1)
                            night_cnt<= night_cnt +1;
                            else begin
                                night_cnt <= 0;
                                state<= GO_HOME;
                            end
                    end
                end
            end
            GO_HOME : begin
                if(angle > ANGLE_MIN)begin
                    angle <= angle -1;
                    state <= HOME_WAIT;
                end
                else begin
                    state <= DAY_CHECK;
                end
            end
            HOME_WAIT : begin
                if(tick)
                    state <= GO_HOME;
            end
            READ : begin
                if(diff > THRESHOLD && cds_right > cds_left)begin
                    state <= MOVE;
                end
                else 
                    state <= WAIT;
            end
            MOVE : begin
                if(angle < ANGLE_MAX)begin
                    angle <= angle + 1;
                end
                state <= WAIT;
            end
            WAIT : begin
                if(tick)
                    state <= DAY_CHECK;
            end
        endcase
    end
    
end
endmodule