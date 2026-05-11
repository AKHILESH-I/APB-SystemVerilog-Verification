import apb_pkg::*;
class driver;
//HANDLE
apb_txn txn;
//VIRTUAL INTERFACE
virtual apb_if vif;
//MAILBOX
mailbox #(apb_txn) gen2drv;
//CONSTRUCTOR
function new(mailbox #(apb_txn) gen2drv, virtual apb_if vif);
  this.gen2drv = gen2drv;
  this.vif = vif;
endfunction
//RUN TASK
task run();
//WAIT
wait(vif.PRESETn == 1);
//ALIGN TO PCLK
@(vif.drv_cb);
//IDLE STATE
  vif.drv_cb.PSEL <= 0;
  vif.drv_cb.PENABLE <= 0;
  vif.drv_cb.PADDR <= 0;
  vif.drv_cb.PWRITE <= 0;
  vif.drv_cb.PWDATA <= 0;
  forever begin
    //GET TXN
    gen2drv.get(txn);
    //DELAY
    repeat(txn.delay) @(vif.drv_cb);
    //SETUP_PHASE
    vif.drv_cb.PSEL <= 1;
    vif.drv_cb.PENABLE <= 0;
    vif.drv_cb.PADDR <= txn.addr;
    vif.drv_cb.PWRITE <= txn.write;
    vif.drv_cb.PWDATA <= txn.wdata;
    @(vif.drv_cb);
    //ACCESS PHASE
    vif .drv_cb.PENABLE <= 1;
    do begin @(vif.drv_cb);
    end while(vif.drv_cb.PREADY == 0);
    //CAPTURE PHASE 
    if(!txn.write) 
      begin
        txn.rdata = vif.drv_cb.PRDATA;
      end

      txn.slverr = vif.drv_cb.PSLVERR;
    //IDLE PHASE
    vif.drv_cb.PSEL <= 0;
    vif.drv_cb.PENABLE <= 0;
    vif.drv_cb.PADDR <= 0;
    vif.drv_cb.PWRITE <= 0;
    vif.drv_cb.PWDATA <= 0;
    @(vif.drv_cb);
    //DEBUG
    txn.display();
  end
endtask
endclass
