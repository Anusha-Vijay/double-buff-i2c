module testbench;

output TXout;
output TXBuff0,TXBuff1;

reg clk,StartTX,write,Ackrecvd;
//output [31:0] dataIn;
reg [3:0] addr;
reg [31:0] TXIn;

master m1 (.clk(clk),.StartTX(StartTX),.TXIn(TXIn),.TXout(TXout),.write(write),.addr(addr),.TXBuff0(TXBuff0),.TXBuff1(TXBuff1),.Ackrecvd(Ackrecvd));

initial begin
$dumpfile("dump.vcd");
$dumpvars(1);
clk=1'b1;
StartTX=0;
write = 0;
Ackrecvd=0;
end

always #10 clk=~clk;
initial begin
StartTX=0;
addr=4'b0000;
TXIn=32'd2;

#10 write=1;

// *************** #50 addr = 4'b0001; TXIn=32'd64; write = 0; *************** //

#50 addr = 4'b0001; TXIn=32'd8; write = 1;

#50 StartTX=1; TXIn=32'd67;
#50 Ackrecvd=1;

end
initial
#1000 $stop;
endmodule