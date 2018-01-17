`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:35:21 10/12/2015
// Design Name:   fx2_slaveFIFO_loopback
// Module Name:   D:/work/LCSDR/src/xilinx/main1/main/fx2_tb.v
// Project Name:  main
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fx2_slaveFIFO_loopback
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fx2_tb;

	// Inputs
	reg clk_locked;
	reg flag_ff;
	reg flag_ef;
	reg clk;

	// Outputs
	wire [1:0] faddr;
	wire slrd;
	wire slwr;
	wire sloe;
	wire done;
	wire clk_out;

	// Bidirs
	wire [15:0] fdata;
    reg [15:0] fdata_in= 0;
    wire [15:0] fdata_out;

    parameter dcount = 0;
    integer j;

    assign fdata = (sloe)? 16'bz : fdata_in;
    assign fdata_out = fdata;

	// Instantiate the Unit Under Test (UUT)
	fx2_slaveFIFO_loopback uut (
		.clk_locked(clk_locked), 
		.fdata(fdata), 
		.faddr(faddr), 
		.slrd(slrd), 
		.slwr(slwr), 
		.sloe(sloe), 
		.flag_ff(flag_ff), 
		.flag_ef(flag_ef), 
		.done(done), 
		.clk(clk), 
		.clk_out(clk_out)
	);

	initial begin
		// Initialize Inputs
		clk_locked = 0;
		flag_ff = 0;
		flag_ef = 0;
		clk = 0;
		flag_ff = 1; 

		// Wait 100 ns for global reset to finish
        
        #100
        #10
        clk_locked = 1;
        #10
        wait (done == 1);

        #90
        flag_ef = 1;
        wait (sloe == 0);
        #10 fdata_in = 16'h0001;
        wait (slrd == 0);
        wait (clk_out == 0);
        wait (clk_out == 1);
        #10 fdata_in = 16'h0002;
        #10 flag_ef = 0; 
        //wait (clk_out == 1);
        //wait (clk_out == 0);
        //wait (clk_out == 1);
        //wait (clk_out == 0);

        //flag_ff = 1; 

        wait (slwr == 0);
        wait (slwr == 1);

        //#1 flag_ff = 0; 
        
        #100;

        flag_ef = 1;
        wait (sloe == 0);
        #1 fdata_in = 16'h0001;
        wait (slrd == 0);
        wait (clk_out == 1);
        wait (clk_out == 0);
        #1 fdata_in = 16'h0002;
        wait (clk_out == 1);
        wait (clk_out == 0);
        #1 fdata_in = 16'h0003;
        wait (clk_out == 1);
        wait (clk_out == 0);
        #1 fdata_in = 16'h0004;
        wait (clk_out == 1);
        #10 flag_ef = 0; 

        wait (slwr == 0);
        wait (slwr == 1);

        #100;
        flag_ef = 1;
        wait (sloe == 0);
        #1 fdata_in = 16'h0000;
        wait (slrd == 0);
        wait (clk_out == 1);
        wait (clk_out == 0);
        for (j=1;j<=254;j=j+1)
        begin
            fdata_in = j;
            wait (clk_out == 1);
            wait (clk_out == 0);
        end
        fdata_in = 255;
        wait (clk_out == 1);
        #10 flag_ef = 0; 

        wait (slwr == 0);
        wait (slwr == 1);

	end
    
    parameter PERIOD = 1000/10;

    always begin
        clk = 1'b0;
        #(PERIOD/2) clk = 1'b1;
        #(PERIOD/2);
    end       

    reg [2:0]ep;
    always @ (*) begin
       case (faddr) 
           2'b00: ep <= 2;
           2'b01: ep <= 4;
           2'b10: ep <= 6;
           2'b11: ep <= 8;
       endcase
    end
      
endmodule

