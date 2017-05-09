module dataPath(clk,size,dataIn,addr,write,brst);

input write,clk;
input [31:0] dataIn;
input [3:0] addr;
//output [31:0] size;
output [31:0] brst,size;
wire inSize,inBurst;

controlReg  burst(brst,inBurst,dataIn,clk);
controlReg datasize(size,inSize,dataIn,clk);
deMux demux(inBurst,inSize,addr,write);

endmodule


//module controlReg(dataOut,write,dataIn,clk);