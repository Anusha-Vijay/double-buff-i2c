module i2cTXinterface(SendStartSig, SendWriteSig, SendStopSig,WaitAck,RecvdAck,ShiftTXBuf0,ShiftTXBuf1, SDA, SCL, clk, data);

input SendStartSig, SendWriteSig, SendStopSig,WaitAck,clk,ShiftTXBuf0,ShiftTXBuf1;
input data;
inout SDA, SCL;
output reg RecvdAck;
reg SDA_in, SDA_out, SCL_in, SCL_out;
reg Wait;

initial begin
Wait <= 1'b0;
end

always @ (SendStartSig or SendWriteSig or SendStopSig or WaitAck or clk or ShiftTXBuf0 or ShiftTXBuf1) begin 
assign SDA_in = SDA;
if(SendStartSig) begin
   SCL_out <= 1'b1;
   SDA_out <= 1'b1;
   #5 SDA_out <= 1'b0;
end
if(SendWriteSig) begin
  SCL_out <= clk;
  SDA_out <= 1'b0;
end
if(SendStopSig) begin
  SCL_out <= 1'b1;
   SDA_out <= 1'b0;
  #5 SDA_out <= 1'b1;
end
if(WaitAck && ~Wait) begin
  RecvdAck <= 1'b0;
  SCL_out <= clk;
  SDA_out <= 1'bz;
  Wait <= 1'b1;
end
if(WaitAck && Wait) begin
if(SDA_in == 1'b0) begin
   RecvdAck <= 1'b1;
   Wait <= 1'b0;
 end 
end
if(ShiftTXBuf0 || ShiftTXBuf1)begin
  SCL_out <= clk;
  SDA_out <= data;
end

end

assign SDA = SDA_out;
assign SCL = SCL_out;

endmodule

