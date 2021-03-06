//`timescale 10ns/1ns
module txcontroller(clk, StartTX,Ackrecvd,TXCount,BurstCnt, ResetTXCount, IncTXCount, LoadTXBuf0, LoadTXBuf1, ShiftTXBuf0, ShiftTXBuf1, PassTXBuf ,SendStartSig, SendWriteSig, SendStopSig,WaitAck,LoadAddr, SDA, SCL, ResetBurstCnt, IncBurstCnt);

input StartTX, clk;
input [5:0] TXCount;
input [5:0] BurstCnt;
input  SDA, SCL;
output reg ResetTXCount, IncTXCount, LoadTXBuf0, LoadTXBuf1, ShiftTXBuf0, ShiftTXBuf1, PassTXBuf, LoadAddr ,SendStartSig, SendWriteSig, WaitAck, ResetBurstCnt, IncBurstCnt, SendStopSig;
input Ackrecvd;
reg [3:0] PS;
reg [3:0] NS;
reg [5:0] Count; //
parameter size = 6'b001111;
parameter burst = 6'b00010;
parameter IDLE  = 4'b0001, LOADADDRB0 = 4'b0010,PRELOADB1 = 4'b0011 , SENDADDR = 4'b0100, SENDWRITE = 4'b0101, 
         WAITACK = 4'b0110, LOADB0 = 4'b0111, EMPTYB1 = 4'b1000 , WAITACK1 = 4'b1001, LOADB1 = 4'b1010, EMPTYB0 = 4'b1011, WAITACK0= 4'b1100, SENDSTOP = 4'b1101 ; 
initial begin
PS <= IDLE;
NS <= LOADADDRB0;
LoadTXBuf0 <= 1'b0;
LoadTXBuf1 <= 1'b0;
ShiftTXBuf0 <= 1'b0;
ShiftTXBuf1 <= 1'b0;
ResetTXCount <= 1'b0;
IncTXCount <= 1'b0;
PassTXBuf <= 1'b0;
SendStartSig <= 1'b0;
SendWriteSig <= 1'b0;
WaitAck <= 1'b0;
ResetBurstCnt <= 1'b0;
IncBurstCnt <= 1'b0; 
SendStopSig <= 1'b0;
LoadAddr <= 1'b0;
end

always @ (posedge clk) begin
PS = NS;

if(StartTX==0) begin
NS <= IDLE;
end 
else begin

case(PS) 

IDLE    :    begin
             NS <= LOADADDRB0;
             end

LOADADDRB0: begin
           LoadTXBuf0 <= 1'b1;
           LoadAddr <= 1'b1;
           Count <= 6'b000111;
           ResetTXCount <= 1'b1;
	       SendStartSig <= 1'b1;
           NS <= PRELOADB1;
           end

PRELOADB1: begin
        LoadAddr <= 1'b0;
        ResetTXCount <= 1'b0;
        SendStartSig <= 1'b0;
        LoadTXBuf0 <= 1'b0;
     	LoadTXBuf1 <= 1'b1;
        ShiftTXBuf0 <= 1'b1;
        ShiftTXBuf1 <= 1'b0;
        IncTXCount <= 1'b1;
        PassTXBuf <= 1'b0;
        NS <= SENDADDR;
        end

SENDADDR: begin
         if(TXCount < Count-1) begin
         LoadTXBuf1 <= 1'b0;
         ShiftTXBuf0 <= 1'b1;
         IncTXCount <= 1'b1;
         end
         if(TXCount == Count-1) begin
         NS <= SENDWRITE;

         end
         end

SENDWRITE : begin
            ShiftTXBuf0 <= 1'b0;
            SendWriteSig <= 1'b1;
            IncTXCount <= 1'b0;
            NS <= WAITACK;
            end

WAITACK: begin 
         SendWriteSig <= 1'b0;
         WaitAck <= 1'b1;
         Count = 4'b1000;
         ResetTXCount <= 1'b1;
         ResetBurstCnt <= 1'b1;
         if(Ackrecvd)
         NS <= LOADB0;
         end
         
LOADB0: begin                       //load buffer 0 and shift buffer 1
        WaitAck <= 1'b0;
        ResetTXCount <= 1'b0;
        ResetBurstCnt <= 1'b0;
        LoadTXBuf0 <= 1'b1;
        ShiftTXBuf1 <= 1'b1;
        IncTXCount <= 1'b1;
        PassTXBuf <= 1'b1;
        NS <= EMPTYB1;
        end
EMPTYB1: begin
         if(TXCount <= Count) begin
         if((TXCount % 8) == 0) begin
         IncTXCount <= 1'b0;
         NS <= WAITACK1;
         end
         else begin
         LoadTXBuf1 <= 1'b0;
         ShiftTXBuf0 <= 1'b1;
         PassTXBuf <= 1'b1; //this is the change i have made
         IncTXCount <= 1'b1;
         end
         end else begin
         IncBurstCnt <= 1'b1;
         NS <= WAITACK1;
         end
         end
        
WAITACK1: begin
         WaitAck <= 1'b1;
         if(SDA == 1'b0) begin
         if((TXCount > Count)&&(BurstCnt < burst)) begin
         Count = size ;
         ResetTXCount <= 1'b1;
         NS <= LOADB1;
         end else if((TXCount <= Count)&&(BurstCnt < burst)) begin
         NS <= EMPTYB1;
         end else if(BurstCnt == burst)begin
         NS <= SENDSTOP; 
         end
         end
         end
LOADB1: begin
        IncBurstCnt <= 1'b0;
        IncBurstCnt <= 1'b0;
        ResetTXCount <= 1'b0;
        LoadTXBuf0 <= 1'b0;
     	LoadTXBuf1 <= 1'b1;
        ShiftTXBuf0 <= 1'b1;
        ShiftTXBuf1 <= 1'b0;
        IncTXCount <= 1'b1;
        PassTXBuf <= 1'b0;
        NS <= EMPTYB0;
        end
EMPTYB0: begin
         if(TXCount <= Count) begin
         if((TXCount % 6'b001000) == 0)begin
         IncTXCount <= 1'b0;
         NS <= WAITACK0;
         end else begin
         LoadTXBuf1 <= 1'b0;
         ShiftTXBuf0 <= 1'b1;
         PassTXBuf <= 1'b0;
         IncTXCount <= 1'b1;
         end
         end
         else begin
         IncBurstCnt <= 1'b1;
         NS <= WAITACK0;
         end
         end
        

WAITACK0: begin
         WaitAck <= 1'b1;
         if(SDA== 1'b0) begin
         if((TXCount > Count)&&(BurstCnt < burst)) begin
         Count = size ;
         ResetTXCount <= 1'b1;
         NS <= LOADB0;
         end else if((TXCount <= Count)&&(BurstCnt < burst)) begin
         NS <= EMPTYB0;
         end else if(BurstCnt == burst) begin
         NS <= SENDSTOP; 
         end
         end
         end
SENDSTOP: begin
          SendStopSig <= 1'b1;
          NS<= IDLE;
          end
        
         
default: NS <= IDLE;
      

endcase


end

end

TXcounter m1(ResetTXCount,IncTXCount,TXCount,clk);
burstcounter m2(ResetBurstCnt, IncBurstCnt, BurstCnt);
endmodule



