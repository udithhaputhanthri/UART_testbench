`timescale 10ns/1ns
module tb;


reg Clk, Rst_n=1'b0, RxEn=1'b1,TxEn=1'b1;	
reg [3:0]NBits=4'b1000;	
reg [7:0]TxData=8'b11000101;		
reg [15:0] BaudRate=325;    

wire Tx;
wire TxDone;
wire RxDone;			
wire [7:0]RxData;	
wire Rx;
wire Tick;

assign Rx=Tx;

UART_BaudRate_generator baud(Clk,Rst_n,Tick,BaudRate);
UART_tx uart_tx(Clk,Rst_n,TxEn,TxData,TxDone,Tx,Tick,NBits);
UART_rx uart_rx(Clk,Rst_n,RxEn,RxData,RxDone,Rx,Tick,NBits);	

initial begin
  Clk = 1'b0;
  forever #10 Clk = ~Clk;
end

always @(negedge TxDone)
	begin
	   #5 Rst_n=0;
	   TxData=TxData+1;
	   #5 Rst_n=1;
end

always @(posedge RxDone)
	begin
	     if(TxData==RxData)
	     begin
	     $display("%d is transmitted",TxData); 
        end
	end


endmodule