module xadc_core(
    input clk,
    input reset,
    input vauxp6,
    input vauxn6,
    input vauxp7,
    input vauxn7,
//controller에서 가져옴
    input [6:0] daddr,
    input den,
    input dwe,
    input [15:0] di,
    
    output [15:0] do,
    output drdy

);
//16비트의 버스 구조, 1비트가 하나 핀임
wire [15:0] vauxp_bus;
wire [15:0] vauxn_bus;
//16비트 버스중에 6,7번만 연결할거임
assign vauxp_bus = {8'b0, vauxp7, vauxp6, 6'b0};
assign vauxn_bus = {8'b0, vauxn7, vauxn6, 6'b0};
XADC #(
   // INIT_40 - INIT_42: XADC configuration registers
   .INIT_40(16'h0000),
   .INIT_41(16'h0000),
   .INIT_42(16'h0800),
   // INIT_48 - INIT_4F: Sequence Registers
   .INIT_48(16'h0000),
   .INIT_49(16'h0000),
   .INIT_4A(16'h0000),
   .INIT_4B(16'h0000),
   .INIT_4C(16'h0000),
   .INIT_4D(16'h0000),
   .INIT_4F(16'h0000),
   .INIT_4E(16'h0000),                // Sequence register 6
   // INIT_50 - INIT_58, INIT5C: Alarm Limit Registers
   .INIT_50(16'h0000),
   .INIT_51(16'h0000),
   .INIT_52(16'h0000),
   .INIT_53(16'h0000),
   .INIT_54(16'h0000),
   .INIT_55(16'h0000),
   .INIT_56(16'h0000),
   .INIT_57(16'h0000),
   .INIT_58(16'h0000),
   .INIT_5C(16'h0000),
   // Simulation attributes: Set for proper simulation behavior
   .SIM_DEVICE("7SERIES"),            // Select target device (values)
   .SIM_MONITOR_FILE("design.txt")  // Analog simulation data file name
)
XADC_inst (
   // ALARMS: 8-bit (each) output: ALM, OT
   .ALM(),                   // 8-bit output: Output alarm for temp, Vccint, Vccaux and Vccbram
   .OT(),                     // 1-bit output: Over-Temperature alarm
   // Dynamic Reconfiguration Port (DRP): 16-bit (each) output: Dynamic Reconfiguration Ports
   .DO(do),                     // 16-bit output: DRP output data bus
   .DRDY(drdy),                 // 1-bit output: DRP data ready
   // STATUS: 1-bit (each) output: XADC status ports
   .BUSY(),                 // 1-bit output: ADC busy output
   .CHANNEL(),           // 5-bit output: Channel selection outputs
   .EOC(),                   // 1-bit output: End of Conversion
   .EOS(),                   // 1-bit output: End of Sequence
   .JTAGBUSY(),         // 1-bit output: JTAG DRP transaction in progress output
   .JTAGLOCKED(),     // 1-bit output: JTAG requested DRP port lock
   .JTAGMODIFIED(), // 1-bit output: JTAG Write to the DRP has occurred
   .MUXADDR(),           // 5-bit output: External MUX channel decode
   // Auxiliary Analog-Input Pairs: 16-bit (each) input: VAUXP[15:0], VAUXN[15:0]
   .VAUXN(vauxn_bus),               // 16-bit input: N-side auxiliary analog input
   .VAUXP(vauxp_bus),               // 16-bit input: P-side auxiliary analog input
   // CONTROL and CLOCK: 1-bit (each) input: Reset, conversion start and clock inputs
   .CONVST(),             // 1-bit input: Convert start input
   .CONVSTCLK(),       // 1-bit input: Convert start input
   .RESET(reset),               // 1-bit input: Active-high reset
   // Dedicated Analog Input Pair: 1-bit (each) input: VP/VN
   .VN(),                     // 1-bit input: N-side analog input
   .VP(),                     // 1-bit input: P-side analog input
   // Dynamic Reconfiguration Port (DRP): 7-bit (each) input: Dynamic Reconfiguration Ports
   .DADDR(daddr),               // 7-bit input: DRP address bus
   .DCLK(clk),                 // 1-bit input: DRP clock
   .DEN(den),                   // 1-bit input: DRP enable signal
   .DI(di),                     // 16-bit input: DRP input data bus
   .DWE(dwe)                    // 1-bit input: DRP write enable
);
endmodule