`timescale 1ns / 1ps

module xadc_ctrl (input wire clk,
                  input wire vauxp6,vauxn6,                       // CdS left
                  input wire vauxp7,vauxn7,                       // CdS right
                  input wire vp_in, vn_in,
                  output  [11:0] cds_left,
                  output  [11:0] cds_right);
    localparam signed [12:0] OFFSET_LEFT  = 13'sd123;  // 0.03V 보정
    localparam signed [12:0] OFFSET_RIGHT = 13'sd0;
    
    wire        enable;
    wire        ready;
    wire [15:0] data;
    reg  [6:0]  Address_in;
    reg         channel; // 0: left, 1: right
    
    xadc_wiz_0 XLXI_7 (
    .daddr_in   (Address_in),
    .dclk_in    (clk),
    .den_in     (enable),
    .di_in      (16'd0),
    .dwe_in     (1'b0),
    .busy_out   (),
    .vauxp6     (vauxp6), .vauxn6 (vauxn6),
    .vauxp7     (vauxp7), .vauxn7 (vauxn7),
    .vn_in      (vn_in),  .vp_in  (vp_in),
    .do_out     (data),
    .eoc_out    (enable),
    .channel_out(),
    .drdy_out   (ready)
    );
    always @(posedge clk) begin
        case (channel)
            1'b0: Address_in <= 7'h16; // vaux6
            1'b1: Address_in <= 7'h17; // vaux7
        endcase
    end
    reg [11:0] raw_left,  raw_right;
    reg        left_en,   right_en;
    
    always @(posedge clk) begin
        left_en  <= 1'b0;
        right_en <= 1'b0;
        
        if (ready) begin
            case (channel)
            1'b0: begin raw_left <= data[15:4]; left_en <= 1'b1; end
        1'b1: begin raw_right <= data[15:4]; right_en <= 1'b1; end
            endcase
            channel <= ~channel;
        end
    end
    
    wire [11:0] offset_left, offset_right;
    
    function [11:0] apply_offset;
        input [11:0] raw;
        input signed [12:0] offset;
        reg signed [12:0] result;
        begin
            result = $signed({1'b0, raw}) + offset;
            // 언더플로/오버플로 클램핑
            if (result < 0)          apply_offset   = 12'd0;
            else if (result > 12'hFFF) apply_offset = 12'hFFF;
            else                     apply_offset   = result[11:0];
        end
    endfunction
    
    assign offset_left  = apply_offset(raw_left,  OFFSET_LEFT);
    assign offset_right = apply_offset(raw_right, OFFSET_RIGHT);
    
    cds_filter u_filter_left (
    .clk            (clk),
    .sample_en      (left_en),
    .raw_value      (offset_left),
    .filtered_value (cds_left)
    );
    
    cds_filter u_filter_right (
    .clk            (clk),
    .sample_en      (right_en),
    .raw_value      (offset_right),
    .filtered_value (cds_right)
    );
    
    
    
    
    initial channel = 1'b0;
    
endmodule
