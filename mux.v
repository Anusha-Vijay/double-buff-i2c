module mux_2_1(TXOut,TXbuff0, TXbuff1, passTXbuff);

input TXbuff0,TXbuff1;
input passTXbuff;


output reg TXOut;

always @(passTXbuff) begin
if(~passTXbuff)
assign TXOut=TXbuff0;

if (passTXbuff)
   assign TXOut=TXbuff1;
end
endmodule