module xadc_controller(
    input clk,
    input reset,
    input [15:0] do,
    input drdy,
    input tick,
    output reg [6:0] daddr,
    output reg den,
    output wire dwe,
    output wire [15:0] di,
    output reg [11:0] raw_cds_left,
    output reg [11:0] raw_cds_right,
    output reg cds_left_en,
    output reg cds_right_en
);
assign dwe = 1'b0;
assign di = 16'd0;
reg [2:0] state;

localparam IDLE = 3'd0;
localparam READ_CH6 = 3'd1;
localparam WAIT_CH6 = 3'd2;
localparam READ_CH7 = 3'd3;
localparam WAIT_CH7 = 3'd4;

always @(posedge clk ) begin
    if(reset)begin
        daddr <= 0;
        den <= 0;
        raw_cds_left <= 0;
        raw_cds_right <= 0;
        cds_left_en <= 0;
        cds_right_en <= 0;
        state <= IDLE;
    end
    else begin
        cds_left_en <= 0;
        cds_right_en <= 0;
        case(state)
        IDLE : begin
            den <= 0;
            if(tick)
                state <= READ_CH6;
        end
        READ_CH6 : begin
            daddr <= 7'h16;
            den <= 1;
            state <= WAIT_CH6;
        end
        WAIT_CH6 : begin
            den <= 0;
            if(drdy)begin
                raw_cds_left <= do[15:4];
                cds_left_en <= 1;
                state <= READ_CH7;
            end            
        end
        READ_CH7 : begin
            daddr <= 7'h17;
            den <= 1;
            state <= WAIT_CH7;
        end
        WAIT_CH7 : begin
            den <= 0;
            if(drdy)begin
                raw_cds_right <= do[15:4];
                cds_right_en <= 1;
                state <= IDLE;
            end
        end
        default : begin
            state <= IDLE;
            den <=0;
        end
        endcase
    end
end
endmodule