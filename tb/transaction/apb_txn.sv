class apb_txn;
//REQUEST
logic [7:0] addr;	//rand
logic write;	//rand
logic [31:0]wdata;	//rand
//RESPONSE
logic [31:0] rdata;
logic slverr;
int delay;
//CONSTRUCTOR
function new();
addr = '0;
write = 1'b0;
wdata = '0;
rdata = '0;
slverr = 1'b0;
delay = 0;
endfunction
//DISPLAY TRANSACTION
function void display();
if(write)
$display("W -> addr = %0h, wdata = %0h, delay=%0d, slverr = %0b",addr, wdata, delay, slverr);
else
$display("R -> addr = %0h, rdata = %0h, delay=%0d, slverr = %0b",addr, rdata, delay, slverr);
endfunction
endclass
