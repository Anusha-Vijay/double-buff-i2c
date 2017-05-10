module burstcounter(reset,inc,cnt);
input reset, inc;
output reg [5:0] cnt;

always @ (inc or reset) begin

if(reset) 
cnt = 1'd0;
else begin
if(inc) begin
cnt <= cnt+1'd1;
end
end
end
endmodule
