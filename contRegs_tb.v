module testbench;
reg clk;
reg[3:0] addr;
reg[31:0] dataIn;
reg write;
output [31:0] brst,size;


dataPath datapath(.clk(clk),.size(size),.dataIn(dataIn),.addr(addr),.write(write),.brst(brst));


initial begin
	$dumpfile("waveForm.vcd");
	$dumpvars;
	write = 0;
	clk=1'b1;

end

always 
#5 clk = ~ clk;
initial
begin
addr=4'b0000;
dataIn=32'd10;
#10 write=1;
#50 addr= 4'b0001; dataIn=32'd64; write = 0;
#50 addr= 4'b0001; dataIn=32'd64; write = 1;
end
initial
#1000 $stop;
endmodule



