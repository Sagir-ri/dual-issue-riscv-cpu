module myCPU(             
    input cpu_rst,
    input cpu_clk,

    // Interface to IROM
    output [31:0] irom_addr1,       
    input [31:0] irom_data1,
    output [31:0] irom_addr2,       
    input [31:0] irom_data2,

    // Interface to DRAM & periphera
    output [31:0] perip_addr,   
    output perip_wen,    
    output [2:0] perip_mask, 
    output [31:0] perip_wdata,    
    input [31:0] perip_rdata     
);


  
data_path u_data_path(
	.rst_n(!cpu_rst),
    .clk(cpu_clk),

    //IROM
	.instr1(irom_data1),
	.instr2(irom_data2),
	.instr1_pc(irom_addr1),
	.instr2_pc(irom_addr2),

	//DRAM
	.DRAM_addr(perip_addr),
	.DRAM_wdata(perip_wdata),
	.DRAM_mask(perip_mask),
	.DRAM_wen(perip_wen),
	.DRAM_rdata(perip_rdata)
    );

endmodule


