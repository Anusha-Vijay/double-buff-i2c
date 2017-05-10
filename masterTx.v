module master (clk, StartTX,TXIn,TXout,write,addr,TXBuff0,TXBuff1);

// Declaring inputs and outputs of the whole master transmission block, these are driven by the testbench

input wire clk,StartTX,write;
input wire [31:0] TXIn;
wire [31:0] dataIn;
input [3:0] addr;
output TXout;
output TXBuff0,TXBuff1;

/*Declaring wire's the interconnect the components of the transmission block
TX controlregister unit output to the inputs of the controller brst --> burst upcounter's cnt */

wire [31:0] burst, size;


initial begin
$dumpfile("dump1.vcd");
$dumpvars(1);
end

// Declaring inputs and outputs of the state machine block

input wire[5:0] TXCount,BurstCnt; //wire that goes from the counter outputs  to the finite State Machine inputs

wire ResetTXCount, IncTXCount, LoadTXBuff0, LoadTXBuff1, ShiftTXBuff0, ShiftTXBuff1,
passTXbuff,SendStartSig, SendWriteSig, SendStopSig,WaitAck,LoadAddr,SDA,SCL,ResetBurstCnt, IncBurstCnt,Ackrecvd;



// Declaring inputs and outputs of the double buffered transmitter
//output reg[31:0] dataIn;


/***************************************************************************************
--------------- TRANSMITTER CONTROL REGISTER FOR SIZE AND BURST----------------

To write to the registers, the test-bench needs to address them and write data to
them by asserting the Write signal and putting the data on the dedicated data bus
provided to program them. There is a 4 bit address space available and you can choose
 to assign any address to these two registers.
*******************************************************************************/

dataPath cRegsdp(.clk(clk),.size(size),.dataIn(dataIn),.addr(addr),.write(write),.brst(burst));




/***********************************************************************************************************
--------------- TRANSMITTER CONTROLLER FOR DOUBLE BUFFERED TRANSMISSION AND I2C INTERFACE----------------

Once the registers are programmed, the test-bench will assert the StartTx control signal which
starts the control state machine and the transmission operation
************************************************************************************************************/

txcontroller controllerUnit(.clk(clk),.StartTX(StartTX),.Ackrecvd(Ackrecvd),.TXCount(TXCount),.BurstCnt(BurstCnt), .ResetTXCount(ResetTXCount), .IncTXCount(IncTXCount),
.LoadTXBuf0(LoadTXBuff0), .LoadTXBuf1(LoadTXBuff1),.ShiftTXBuf0(ShiftTXBuff0), .ShiftTXBuf1(ShiftTXBuff1), .PassTXBuf(passTXbuff) ,.SendStartSig(SendStartSig),
.SendWriteSig(SendWriteSig),.SendStopSig(SendStopSig),.WaitAck(WaitAck),.LoadAddr(LoadAddr), .SDA(SDA), .SCL(SCL), .ResetBurstCnt(ResetBurstCnt), .IncBurstCnt(IncBurstCnt));


/***********************************************************************************************************
---------------DOUBLE BUFFERED TRANSMISSION----------------
Each time the Tx unit needs the next set of data, it will assert the ReadyData signal to the testbench.
The test-bench should respond to this signal by providing the next data chunk to transmit
(based on the size programmed in the control register) to the Tx unit on the dedicated TxData
bus.
************************************************************************************************************/

txDataPath datapath(.clk(clk),.StartTX(StartTX),.TXIn(TXIn),.ShiftTXBuff0(ShiftTXBuff0),.ShiftTXBuff1(ShiftTXBuff1),.LoadTXBuff0(LoadTXBuff0),
.LoadTXBuff1(LoadTXBuff1),.dataIn(dataIn),.TXBuff0(TXBuff0),.TXBuff1(TXBuff1),.TXOut(TXout),.passTXbuff(passTXbuff));


endmodule