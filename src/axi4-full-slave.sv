`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2026 22:42:24
// Design Name: 
// Module Name: axi4-full-slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axi4_full_slave#(
parameter ADDR_WIDTH=32,
parameter DATA_WIDTH=32,
parameter DEPTH=1024
)(
input logic ACLK,
input logic ARESETn,

input logic [ADDR_WIDTH-1:0] AWADDR,
input logic [7:0] AWLEN,
input logic [2:0] AWSIZE,
input logic AWVALID,
output logic AWREADY,

input logic [DATA_WIDTH-1:0] WDATA,
input logic WVALID,
input logic WLAST,
output logic WREADY,

output logic[1:0] BRESP,
output logic BVALID,
input logic BREADY,

input logic[ADDR_WIDTH-1:0] ARADDR,
input logic[7:0] ARLEN,
input logic[2:0] ARSIZE,
input logic ARVALID,
output logic ARREADY,

output logic[DATA_WIDTH-1:0] RDATA,
output logic RVALID,
output logic RLAST,
input logic RREADY
);

//internal memory
logic[DATA_WIDTH-1:0] mem[0:DEPTH-1];

// internal registers 
logic[ADDR_WIDTH-1:0] wr_addr,rd_addr;
logic[7:0] wr_len,rd_len;
logic[7:0] wr_cnt,rd_cnt;
logic[2:0] wr_size,rd_size;

//fsm logics

typedef enum logic[1:0]{
WR_IDLE,
WR_DATA,
WR_RESP} wr_state_t;

wr_state_t wr_state;

//read fsm
typedef enum logic [1:0]{
RD_IDLE,
RD_DATA
} rd_state_t;
rd_state_t rd_state;

//write channel logic
always_ff@(posedge ACLK or negedge ARESETn)
begin
if(!ARESETn)
begin
wr_state <= WR_IDLE;
AWREADY <=1'b0;
WREADY <= 1'b0;
BVALID <= 1'b0;
BRESP <= 2'b00;
wr_cnt<=8'd0;
end

else begin 
case(wr_state)
WR_IDLE : begin
AWREADY<=1'b1;
WREADY<=1'b0;
BVALID<=1'b0;

if(AWVALID && AWREADY) begin
wr_addr <= AWADDR;
wr_len <= AWLEN;
wr_size<= AWSIZE;
wr_cnt<=8'd0;
AWREADY<=1'b0;
WREADY<=1'b1;
wr_state<=WR_DATA;
end
end

WR_DATA : begin
if(WVALID && WREADY) 
begin
mem[wr_addr>>2] <= WDATA;
wr_addr<= wr_addr+(1<<wr_size);
wr_cnt <= wr_cnt+1'b1;

if(WLAST)
begin
WREADY <=1'b0;
BVALID <=1'b1;
BRESP<=2'b00;
wr_state<=WR_RESP;
end
end 
end

WR_RESP : begin
if(BREADY) begin
BVALID<=1'b0;
wr_state<=WR_IDLE;
end
end
endcase
end
end

//read channel logic
always_ff@(posedge ACLK or negedge ARESETn)
begin
if(!ARESETn) 
begin
rd_state<=RD_IDLE;
ARREADY<=1'b0;
RVALID<=1'b0;
RLAST<=1'b0;
rd_cnt<=8'd0;
end

else 
begin
case(rd_state)
RD_IDLE : begin
ARREADY <= 1'b1;
RVALID <=1'b0;
RLAST<=1'b0;

if(ARVALID && ARREADY) begin
rd_addr<=ARADDR;
rd_len<=ARLEN;
rd_size<=ARSIZE;
rd_cnt<=8'd0;
ARREADY<=1'b0;
rd_state<= RD_DATA;
end
end

RD_DATA : begin
if(!RVALID || RREADY) begin 
RDATA<= mem[rd_addr>>2];
RVALID<=1'b1;
rd_addr<=rd_addr+(1<< rd_size);
rd_cnt<= rd_cnt+1'b1;

if(rd_cnt== rd_len)
RLAST<=1'b1;

if(RVALID && RREADY && RLAST) begin
RVALID<=1'b0;
RLAST<=1'b0;
rd_state<=RD_IDLE;
end
end
end
endcase
end
end
endmodule





































