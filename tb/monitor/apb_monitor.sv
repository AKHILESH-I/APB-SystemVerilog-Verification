import apb_pkg::*;
class monitor;
//HANDLE
apb_txn txn;
//VIRTUAL INTERFACE
virtual apb_if vif;
//MAILBOX
mailbox #(apb_txn) mon2scb;
//CONSTRUCTOR
function new(mailbox #(apb_txn) mon2scb, virtual apb_if vif);
  this.mon2scb = mon2scb;
  this.vif = vif;
endfunction
//RUN TASK
task run();
  forever begin
    @(vif.mon_cb);
    if(vif.mon_cb.PSEL && vif.mon_cb.PENABLE && vif.mon_cb.PREADY) 
    begin
//CREATE NEW TRANSACTION
    txn = new();
//CAPTURE COMMON FIELDS
    txn.addr = vif.mon_cb.PADDR;
    txn.write = vif.mon_cb.PWRITE;
    txn.slverr = vif.mon_cb.PSLVERR;
//CAPTURE DATA
    if(txn.write)
      txn.wdata = vif.mon_cb.PWDATA;
    else
      txn.rdata = vif.mon_cb.PRDATA;
//DISPLAY 
    txn.display();
    mon2scb.put(txn);
    end
  end
endtask
endclass
