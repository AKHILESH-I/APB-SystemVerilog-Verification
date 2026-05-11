import apb_pkg::*;
class test;
//HANDLE
environment env;
//VIERTUAL
virtual apb_if vif;
//CONFIGURATION
int transaction_count;
//CONSTRUCTOR
function new(virtual apb_if vif);
this.vif = vif;
transaction_count = 10;
endfunction
//BUILD TASK/FUNCTION
function void build();
//CREATE
env = new(vif); 
//CONFIGURE GEN
env.gen.count = transaction_count;  
//env.connect();  //CONNECT
endfunction
//RUN TASK
task run();
$display(" TXN count = %0d", transaction_count);
//BIULD ENV
build();
//RUN ENV
env.run();
endtask
endclass
