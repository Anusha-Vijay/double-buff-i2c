module test;
reg clk,ShiftTXBuff0,ShiftTXBuff1,LoadTXBuff0,LoadTXBuff1,StartTX,passTXbuff;
reg [31:0] TXIn;
reg [31:0] buffer;
output[31:0] dataIn;
output TXBuff0,TXBuff1;
output TXOut;


txDataPath datapath(.clk(clk),.StartTX(StartTX),.TXIn(TXIn),.ShiftTXBuff0(ShiftTXBuff0),.ShiftTXBuff1(ShiftTXBuff1),.LoadTXBuff0(LoadTXBuff0),.LoadTXBuff1(LoadTXBuff1),.dataIn(dataIn),.TXBuff0(TXBuff0),.TXBuff1(TXBuff1),.TXOut(TXOut),.passTXbuff(passTXbuff));

initial begin
$dumpfile("dump.vcd");
$dumpvars(1);
clk=1'b1;
StartTX=1;
end

always #10 clk=~clk;
initial begin
passTXbuff=0;
LoadTXBuff0=1'b1;
LoadTXBuff1=1'b0;
ShiftTXBuff0=1'b0;
ShiftTXBuff1=1'b0;
TXIn=32'd67;



#100 ShiftTXBuff0=1'b1; LoadTXBuff0=1'b0;


#200 ShiftTXBuff0=1'b0; LoadTXBuff0=1'b0;
#100 LoadTXBuff1=1'b1; passTXbuff=1;
#300 ShiftTXBuff1=1'b1; LoadTXBuff1=1'b0;



end
initial
#1000 $stop;
endmodule