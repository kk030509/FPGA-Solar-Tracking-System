module fake_xadc(

    input wire clk,

    input wire [6:0] daddr,
    input wire den,

    output reg [15:0] do,
    output reg drdy

);

// 테스트용 센서값
reg [11:0] left_value  = 12'd2500;
reg [11:0] right_value = 12'd2500;

always @(posedge clk) begin

    drdy <= 1'b0;

    if(den) begin

        case(daddr)

            // VAUX6
            7'h16: begin
                do   <= {left_value,4'b0000};
                drdy <= 1'b1;
            end

            // VAUX7
            7'h17: begin
                do   <= {right_value,4'b0000};
                drdy <= 1'b1;
            end

            default: begin
                do   <= 16'd0;
                drdy <= 1'b1;
            end

        endcase

    end

end

endmodule
