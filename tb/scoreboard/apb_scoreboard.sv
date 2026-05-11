import apb_pkg::*;
class scoreboard;
//HANDEL
apb_txn txn;
//MAILBOX
mailbox #(apb_txn) mon2scb;
//REFERENCE FEILDS
bit [31:0] reg0;
bit [31:0] reg1;
bit [31:0] status_reg;
bit [31:0] control_reg;
//CONSTRUCTOR
function new(mailbox #(apb_txn) mon2scb);
  this.mon2scb = mon2scb;
  reg0 = 0;
  reg1 = 0;
  status_reg = 0;
  control_reg = 0;
endfunction
//RUN TASK
task run();
  forever begin
//GET TXN
    mon2scb.get(txn);
//WRITE TRANSACTION
    if(txn.write) begin
      case(txn.addr)
        8'h00: begin
        if(txn.slverr == 0) begin
            reg0 = txn.wdata;
            $display("PASS W: addr = 00 data = %0h", txn.wdata);
          end 
        else begin
            $error("FAIL w: addr = 00 unexpected error");
          end
        end
        8'h04: begin
          if(txn.slverr == 0) begin
            reg1 = txn.wdata;
            $display("PASS W: addr = 04 data = %0h", txn.wdata);
          end 
        else begin
            $error("FAIL w: addr = 04 unexpected error");
          end
        end
        8'h08: begin
          if(txn.slverr == 0) begin
            status_reg = txn.wdata;
            $display("PASS W: addr = 08 data = %0h", txn.wdata);
          end 
        else begin
            $error("FAIL w: addr = 08 unexpected error");
          end
        end
        8'h0C: begin
          if(txn.slverr == 0) begin
            control_reg = txn.wdata;
            $display("PASS W: addr = 0C data = %0h", txn.wdata);
          end 
        else begin
            $error("FAIL w: addr = 0C unexpected error");
          end
        end

        default: begin
          if(txn.slverr == 1) 
            $display("PASS W: invalid addr %0h error OK", txn.addr);
        else
            $error("FAIL w: invalid addr %0h error NOT ASSERTED", txn.addr);
        end
      endcase
    end
//READ TRANSACTION
    else begin
      case (txn.addr)
        8'h00: begin
          if(txn.slverr == 0 && txn.rdata == reg0) begin
            $display("PASS R: addr = 00 data = %0h", txn.rdata);
          end
          else begin
            $error("FAIL R: addr = 00 expected %0h got = %0h", reg0, txn.rdata);
          end
        end
        8'h04: begin
          if(txn.slverr == 0 && txn.rdata == reg1) begin
            $display("PASS R: addr = 04 data = %0h", txn.rdata);
          end
          else begin
            $error("FAIL R: addr = 04 expected = %0h got =%0h", reg1, txn.rdata);
          end
        end
        8'h08: begin
          if(txn.slverr == 0 && txn.rdata == status_reg) begin
            $display("PASS R: addr = 08 data = %0h", txn.rdata);
          end
          else begin
            $error("FAIL R: addr = 08 expected = %0h got =%0h", status_reg, txn.rdata);
          end
        end
        8'h0C: begin
          if(txn.slverr == 0 && txn.rdata == control_reg) begin
            $display("PASS R: addr = 0C data = %0h", txn.rdata);
          end
          else begin
            $error("FAIL R: addr = 0C expected = %0h got =%0h", control_reg, txn.rdata);
          end
        end

        default: begin
          if(txn.slverr == 1)
            $display("PASS R: invalid addr %0h error OK", txn.addr);
          else
            $error("FAIL R: invalid addr %0h error NOT ASSERTED", txn.addr);
        end
      endcase
    end
  end
endtask
endclass
