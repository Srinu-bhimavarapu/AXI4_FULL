`timescale 1ns/1ps

module tb_axi4_full_slave;

parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;

logic ACLK;
logic ARESETn;

// Write address channel
logic [ADDR_WIDTH-1:0] AWADDR;
logic [7:0]  AWLEN;
logic [2:0]  AWSIZE;
logic        AWVALID;
logic        AWREADY;

// Write data channel
logic [DATA_WIDTH-1:0] WDATA;
logic        WVALID;
logic        WLAST;
logic        WREADY;

// Write response channel
logic [1:0]  BRESP;
logic        BVALID;
logic        BREADY;

// Read address channel
logic [ADDR_WIDTH-1:0] ARADDR;
logic [7:0]  ARLEN;
logic [2:0]  ARSIZE;
logic        ARVALID;
logic        ARREADY;

// Read data channel
logic [DATA_WIDTH-1:0] RDATA;
logic        RVALID;
logic        RLAST;
logic        RREADY;

//////////////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////////////
axi4_full_slave dut (
    .ACLK(ACLK),
    .ARESETn(ARESETn),

    .AWADDR(AWADDR),
    .AWLEN(AWLEN),
    .AWSIZE(AWSIZE),
    .AWVALID(AWVALID),
    .AWREADY(AWREADY),

    .WDATA(WDATA),
    .WVALID(WVALID),
    .WLAST(WLAST),
    .WREADY(WREADY),

    .BRESP(BRESP),
    .BVALID(BVALID),
    .BREADY(BREADY),

    .ARADDR(ARADDR),
    .ARLEN(ARLEN),
    .ARSIZE(ARSIZE),
    .ARVALID(ARVALID),
    .ARREADY(ARREADY),

    .RDATA(RDATA),
    .RVALID(RVALID),
    .RLAST(RLAST),
    .RREADY(RREADY)
);

//////////////////////////////////////////////////////////
// Clock generation
//////////////////////////////////////////////////////////
always #5 ACLK = ~ACLK;   // 100 MHz

//////////////////////////////////////////////////////////
// Test sequence
//////////////////////////////////////////////////////////
initial begin
    // init
    ACLK = 0;
    ARESETn = 0;

    AWVALID = 0;
    WVALID  = 0;
    WLAST   = 0;
    BREADY  = 0;

    ARVALID = 0;
    RREADY  = 0;

    #20;
    ARESETn = 1;

    // ============================
    // WRITE BURST (4 beats)
    // ============================
    @(posedge ACLK);
    AWADDR  = 32'h0000_0000;
    AWLEN   = 3;          // 4 beats
    AWSIZE  = 3'b010;     // 4 bytes
    AWVALID = 1;

    wait (AWREADY && AWVALID);
    @(posedge ACLK);
    AWVALID = 0;

    repeat(4) begin
        @(posedge ACLK);
        WDATA  = $random;
        WVALID = 1;
        WLAST  = (dut.wr_cnt == 3);
        wait (WREADY);
    end

    @(posedge ACLK);
    WVALID = 0;
    WLAST  = 0;

    // write response
    BREADY = 1;
    wait (BVALID);
    @(posedge ACLK);
    BREADY = 0;

    // ============================
    // READ BURST (4 beats)
    // ============================
    @(posedge ACLK);
    ARADDR  = 32'h0000_0000;
    ARLEN   = 3;
    ARSIZE  = 3'b010;
    ARVALID = 1;

    wait (ARREADY && ARVALID);
    @(posedge ACLK);
    ARVALID = 0;

    RREADY = 1;
    while (1) begin
        @(posedge ACLK);
        if (RVALID) begin
            $display("READ DATA = %h  RLAST=%b", RDATA, RLAST);
            if (RLAST)
                break; 
        end
    end
    RREADY = 0;

    #50;
    $finish;
end

endmodule
