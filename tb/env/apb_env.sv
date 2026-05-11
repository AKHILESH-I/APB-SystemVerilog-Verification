import apb_pkg::*;
class environment;
//HANDLES
generator gen;
driver drv;
monitor mon;
scoreboard scb;
//MAILBOX
mailbox #(apb_txn) gen2drv;
mailbox #(apb_txn) mon2scb;
//VIRTUAL INTERFACE
virtual apb_if vif;
//CONSTRUCTOR
function new(virtual apb_if vif);
this.vif  = vif;
//MAILBOX CONSTRUCTOR
gen2drv = new();
mon2scb = new(); 
// COMPONRNT CONSTRUCTOR
gen = new(gen2drv, 10);
drv = new(gen2drv, vif);
mon = new(mon2scb, vif);
scb = new(mon2scb);
endfunction
//RUN TASK
task run();
fork
gen.run();
drv.run();
mon.run();
scb.run();
join_none
$display("ENVIRONMENT STARTED");
endtask
endclass
