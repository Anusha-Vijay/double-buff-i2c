module fsmtb;

reg clk, StartTX,Ackrecvd;
input [5:0] TXCount;
input [5:0] BurstCnt;
output ResetTXCount, IncTXCount, LoadTXBuff0, LoadTXBuff1, ShiftTXBuff0, ShiftTXBuff1, passTXbuff ,SendStartSig, SendWriteSig, SendStopSig,WaitAck,LoadAddr, ResetBurstCnt, IncBurstCnt;

txcontroller controllerUnit(.clk(clk),.StartTX(StartTX),.Ackrecvd(Ackrecvd),.TXCount(TXCount),.BurstCnt(BurstCnt), .ResetTXCount(ResetTXCount), .IncTXCount(IncTXCount),
.LoadTXBuf0(LoadTXBuff0), .LoadTXBuf1(LoadTXBuff1),.ShiftTXBuf0(ShiftTXBuff0), .ShiftTXBuf1(ShiftTXBuff1), .PassTXBuf(passTXbuff) ,.SendStartSig(SendStartSig),
.SendWriteSig(SendWriteSig),.SendStopSig(SendStopSig),.WaitAck(WaitAck),.LoadAddr(LoadAddr), .SDA(SDA), .SCL(SCL), .ResetBurstCnt(ResetBurstCnt), .IncBurstCnt(IncBurstCnt));






initial begin
$dumpfile("dump.vcd");
$dumpvars(1);
clk=1'b1;
StartTX=0;
Ackrecvd=0;
end

always #10 clk=~clk;
initial begin


#50 StartTX=1;
#50 Ackrecvd=1;

end
initial
#1000 $stop;
endmodule