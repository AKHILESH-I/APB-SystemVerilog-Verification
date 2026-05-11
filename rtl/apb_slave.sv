`timescale 1ns/1ps
module dut(
//PORT DECLARATION
//Inputs to slave
  input logic PCLK,
  input logic PRESETn,
  input logic [7:0] PADDR,
  input logic PSEL,
  input logic PENABLE,
  input logic PWRITE,
  input logic [31:0] PWDATA,
//Outputs from slave
  output logic [31:0] PRDATA,
  output logic PREADY,
  output logic PSLVERR);
// Internal Registers
  logic [31:0] reg0;
  logic [31:0] reg1;
  logic [31:0] status_reg;    
  logic [31:0] control_reg;
// READY LOGIC
assign PREADY = 1'b1;
//SEQUENTIAL LOGIC BLOCK (always_ff)
//Write Logic
always_ff @(posedge PCLK or negedge PRESETn) begin
  if(!PRESETn) begin
      reg0 <= 32'd0;
      reg1 <= 32'd0;
      status_reg <= 32'd0;
      control_reg <= 32'd0;
  end
  else begin
  if(PSEL && PENABLE && PREADY) begin
    if(PWRITE) begin
      case(PADDR)
        8'h00: reg0 <= PWDATA;
        8'h04: reg1 <= PWDATA;
        8'h08: status_reg <= PWDATA;
        8'h0C: control_reg <= PWDATA;
      endcase
    end
   end
  end
 end
// READ LOGIC
always_comb begin
PRDATA = 32'd0;
if(PSEL && PENABLE && PREADY && !PWRITE) begin
case(PADDR)
8'h00: PRDATA = reg0;
8'h04: PRDATA = reg1;
8'h08: PRDATA = status_reg;
8'h0C: PRDATA = control_reg;
default: PRDATA = 32'd0;
endcase
end
end
//ERROR LOGIC
always_comb begin
PSLVERR = 1'b0;
if(PSEL && PENABLE && PREADY) begin
case(PADDR)
8'h00,
8'h04,
8'h08,
8'h0C:
PSLVERR = 1'b0;
default:
PSLVERR = 1'b1; // UPDATED: invalid address generates error
endcase
end
end
endmodule
