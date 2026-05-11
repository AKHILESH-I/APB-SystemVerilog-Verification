`timescale 1ns/1ps
module tb_top;
import apb_pkg::*;
//INTERFACE INSTANCE
apb_if intf();
//DUT INSTANCE
dut d0(.PCLK(intf.PCLK),.PRESETn(intf.PRESETn),.PADDR(intf.PADDR),.PSEL(intf.PSEL),.PENABLE(intf.PENABLE),.PWRITE(intf.PWRITE),.PWDATA(intf.PWDATA),.PRDATA(intf.PRDATA),.PREADY(intf.PREADY),.PSLVERR(intf.PSLVERR));
//TEST HANDLE
test t0;
//environment env;
//CLK GENERATION
initial intf.PCLK = 0;
always #5 intf.PCLK = ~intf.PCLK;
//RESET GENERATION
initial begin
intf.PRESETn = 0;
#5;
repeat(2) @(posedge intf.PCLK);
intf.PRESETn = 1;
end
//TEST FLOW
initial begin
t0 = new(intf);
//env = new(intf);
//OPTIONAL CONFIGURATION
t0.transaction_count = 10;
//WAIT FOR RESET RELEASE
wait(intf.PRESETn == 1);
//RUN TEST
t0.run();
//env.run();
#1000;
$display("D O N E");
$finish;
end
endmodule
