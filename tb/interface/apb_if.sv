`timescale 1ns/1ps
// APB INTERFACE
interface apb_if #(parameter ADDR_WIDTH = 8, parameter DATA_WIDTH = 32);
logic PCLK;
logic PRESETn;
//M -> S signals
logic [ADDR_WIDTH-1:0] PADDR;
logic PSEL;
logic PENABLE;
logic PWRITE;
logic [DATA_WIDTH-1:0] PWDATA;
//S -> M signals
logic [DATA_WIDTH-1:0] PRDATA;
logic PREADY;
logic PSLVERR;
//DRIVER CLOCKING BLOCK
clocking drv_cb @(posedge PCLK);
  default input #1step output #1step;
//stimulus
  output PADDR, PSEL, PENABLE, PWRITE, PWDATA, PRESETn; 
//response
  input PRDATA, PREADY, PSLVERR;
endclocking
//MONITOR CLOCKING BLOCK
clocking mon_cb @(posedge PCLK);
  default input #1step;
//request signals
  input PADDR, PSEL, PENABLE, PWRITE, PWDATA;
//response signals
  input PRDATA, PREADY, PSLVERR, PRESETn;
endclocking
//MASTER MODPORT
modport master(clocking drv_cb, input PCLK);
//SLAVE MODPORT
modport slave(input PCLK, PRESETn, PADDR, PSEL, PENABLE, PWRITE, PWDATA, output PRDATA, PREADY, PSLVERR);
//MONITOR MODPORT
modport monitor(clocking mon_cb, input PCLK);
endinterface
