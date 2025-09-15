module EX2_commit(
    input clk,
    input rstn,

    input [31:0] EX2_commit_in_instr1,
	input [31:0] EX2_commit_in_instr2,
	input [4:0] EX2_commit_in_instr1_rd_address,
	input [4:0] EX2_commit_in_instr2_rd_address,
	input [31:0] EX2_commit_in_instr1_pc,
	input [31:0] EX2_commit_in_instr2_pc,
	input [31:0] EX2_commit_in_instr1_write_data,
	input [31:0] EX2_commit_in_instr2_write_data,
    input EX2_commit_in_instr1_regwrite,
    input EX2_commit_in_instr2_regwrite,

	output reg [31:0] EX2_commit_out_instr1,
	output reg [31:0] EX2_commit_out_instr2,
	output reg [4:0] EX2_commit_out_instr1_rd_address,
	output reg [4:0] EX2_commit_out_instr2_rd_address,
	output reg [31:0] EX2_commit_out_instr1_pc,
	output reg [31:0] EX2_commit_out_instr2_pc,
	output reg [31:0] EX2_commit_out_instr1_write_data,
	output reg [31:0] EX2_commit_out_instr2_write_data,
    output reg EX2_commit_out_instr1_regwrite,
    output reg EX2_commit_out_instr2_regwrite
);

always @(posedge clk ,negedge rstn)
begin
    if(!rstn)
    begin
        EX2_commit_out_instr1<=32'b0;
        EX2_commit_out_instr2<=32'b0;
        EX2_commit_out_instr1_rd_address<=5'b0;
        EX2_commit_out_instr2_rd_address<=5'b0;
        EX2_commit_out_instr1_pc<=32'b0;
        EX2_commit_out_instr2_pc<=32'b0;
        EX2_commit_out_instr1_write_data<=32'b0;
        EX2_commit_out_instr2_write_data<=32'b0;
        EX2_commit_out_instr1_regwrite<=1'b0;
        EX2_commit_out_instr2_regwrite<=1'b0;
    end
    else
    begin
        EX2_commit_out_instr1<=EX2_commit_in_instr1;
        EX2_commit_out_instr2<=EX2_commit_in_instr2;
        EX2_commit_out_instr1_rd_address<=EX2_commit_in_instr1_rd_address;
        EX2_commit_out_instr2_rd_address<=EX2_commit_in_instr2_rd_address;
        EX2_commit_out_instr1_pc<=EX2_commit_in_instr1_pc;
        EX2_commit_out_instr2_pc<=EX2_commit_in_instr2_pc;
        EX2_commit_out_instr1_write_data<=EX2_commit_in_instr1_write_data;
        EX2_commit_out_instr2_write_data<=EX2_commit_in_instr2_write_data;
        EX2_commit_out_instr1_regwrite<=EX2_commit_in_instr1_regwrite;
        EX2_commit_out_instr2_regwrite<=EX2_commit_in_instr2_regwrite;
    end
end


endmodule