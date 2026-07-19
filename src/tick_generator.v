//CLK_FREQ는 보드 클럭수 여기서는 100Mhz
//TICK_MS는 몇ms마다 tick을 발생시킬지. 소수점 계산 피하기 위해 ms단위로

module tick_generator #(
    parameter CLK_FREQ = 100_000_000,
    parameter TICK_MS  = 100
)(
    input  clk,
    input  reset,

    output reg tick
);
//ms단위로 받은거라 1000으로 나눠주기
//0.1초동안 몇개의 클럭 발생시킬건가
localparam COUNT_MAX = CLK_FREQ*TICK_MS/1000;
reg [$clog2(COUNT_MAX)-1:0]counter;

always @(posedge clk)begin
    if(reset)begin
        counter <= 0;
        tick <=0;
    end
    else begin
        tick <= 0;
        if(counter == COUNT_MAX -1)begin
            tick <= 1;
            counter <= 0;
        end
        else
            counter <= counter + 1;
    end
        
end
endmodule