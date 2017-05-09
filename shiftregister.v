module txData(dataOut,shift,load,dataIn,clk);

output reg dataOut;
output TXBuff0;
input shift,load,clk;
input [31:0] dIn;
reg [31:0] buffer;

output [31:0] dataIn;
assign dataIn=dIn;


initial begin
buffer=31'b0;
end

always @(posedge clk,dataIn)
	begin
		if(load)
		buffer <= dataIn;

		else if(shift)
			begin
				dataOut <= buffer[0];
				buffer <= buffer>>1;
			end
		else
			buffer <= buffer;
	end

assign TXBuff0 = dataOut;

endmodule