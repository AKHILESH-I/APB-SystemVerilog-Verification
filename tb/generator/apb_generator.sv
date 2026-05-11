import apb_pkg::*;
class generator;
//transactions count
int count;
//Mailbox
mailbox #(apb_txn) gen2drv;
//transaction handle
apb_txn txn;
//CONSTRUCTOR
function new(mailbox #(apb_txn) gen2drv, int count = 10);
  this.gen2drv = gen2drv;
  this.count = count;
endfunction
//RUN TASK
task run();
 for(int i = 0; i < count; i++) begin
//CREATE
  txn = new();
case(i % 3)
//WRITE
 0: begin
  txn.addr = 8'h00;
  txn.write = 1'b1;
  txn.wdata = 32'h1234AAAA;
  txn.delay = 0;
 end
//READ
 1:begin
  txn.addr = 8'h00;
  txn.write = 1'b0;
  txn.delay = 1;
 end
//WRITE
 2: begin
  txn.addr = 8'hF0;
  txn.write = 1'b1;
  txn.wdata = 32'hDEADDEEF;
  txn.delay = 2;
 end
endcase
//TRANSACTION DISPLAY
  txn.display();
//SEND TRANSACTION TO DRIVER
  gen2drv.put(txn);
  end
$display("GENERATOR COMPLETED");
endtask
endclass
