module txDataPath(StartTX,TXIn,ShiftTXBuff0,ShiftTXBuff1,LoadTXBuff0,LoadTXBuff1,dataIn,TXBuff0,TXBuff1,clk,TXOut,passTXbuff);

input [31:0] TXIn;
input StartTX,ShiftTXBuff0,ShiftTXBuff1,LoadTXBuff0,LoadTXBuff1,passTXbuff,clk;
output [31:0] dataIn;
output TXBuff0,TXBuff1,TXOut;
assign dataIn=TXIn;




output loadbuffer0,loadbuffer1,shiftbuffer0,shiftbuffer1;

and(loadbuffer0,StartTX ,LoadTXBuff0);
and(loadbuffer1,StartTX,LoadTXBuff1);
and(shiftbuffer0,StartTX,ShiftTXBuff0);
and(shiftbuffer1,StartTX,ShiftTXBuff1);

txData buff0(.clk(clk),.load(loadbuffer0),.shift(shiftbuffer0),.dataIn(dataIn),.dataOut(TXBuff0));
txData buff1(.clk(clk),.load(loadbuffer1),.shift(shiftbuffer1),.dataIn(dataIn),.dataOut(TXBuff1));
mux_2_1 mux(.TXOut(TXOut),.TXbuff0(TXBuff0), .TXbuff1(TXBuff1),.passTXbuff(passTXbuff));

endmodule

