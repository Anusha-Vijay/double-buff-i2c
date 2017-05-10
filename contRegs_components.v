module controlReg(dataOut,write,dataIn,clk);
output reg[31:0] dataOut;
input write,clk;
input[31:0] dataIn;
reg [31:0] ctrlReg;


always@(posedge clk) begin
if(write==1) begin
ctrlReg = dataIn;
dataOut = ctrlReg;
end
else begin
ctrlReg = ctrlReg;
dataOut = ctrlReg;
end
end
endmodule


module deMux(inBurst,inSize,addr,write);
output reg inBurst;
output reg inSize;
input write;
input [3:0] addr;

always @ (write,addr)
begin
    if(addr[0]==0) begin
        assign inBurst = write;
        assign inSize = 0;
        end
    else if(addr[0]) begin
        assign inSize = write;
        assign inBurst = 0;
        end
end  
endmodule



