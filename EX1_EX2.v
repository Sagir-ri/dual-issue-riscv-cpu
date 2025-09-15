module EX1_EX2(
    input clk,
    input rstn,
    input flush_signal1,
    input flush_signal2,
    input [31:0] EX1_EX2_in_instr1,
	input [31:0] EX1_EX2_in_instr2,
	input [4:0] EX1_EX2_in_instr1_rd_address,
	input [4:0] EX1_EX2_in_instr2_rd_address,
	input [31:0] EX1_EX2_in_instr1_pc,
	input [31:0] EX1_EX2_in_instr2_pc,
	input [31:0] EX1_EX2_in_instr1_alu_result,
	input [31:0] EX1_EX2_in_instr2_alu_result,
    input [31:0] EX1_EX2_in_instr1_read_data2,
    input [31:0] EX1_EX2_in_instr2_read_data2,

	output reg [31:0] EX1_EX2_out_instr1,
	output reg [31:0] EX1_EX2_out_instr2,
	output reg [4:0] EX1_EX2_out_instr1_rd_address,
	output reg [4:0] EX1_EX2_out_instr2_rd_address,
	output reg [31:0] EX1_EX2_out_instr1_pc,
	output reg [31:0] EX1_EX2_out_instr2_pc,
	output reg [31:0] EX1_EX2_out_instr1_alu_result,
	output reg [31:0] EX1_EX2_out_instr2_alu_result,
    output reg [31:0] EX1_EX2_out_instr1_read_data2,
    output reg [31:0] EX1_EX2_out_instr2_read_data2,

    input EX1_EX2_in_recover_en,
	input [31:0] EX1_EX2_in_recover_pc,
	input EX1_EX2_in_flush_signal1,
	input EX1_EX2_in_flush_signal2,

	output reg EX1_EX2_out_recover_en,
	output reg [31:0] EX1_EX2_out_recover_pc,
	output reg EX1_EX2_out_flush_signal1,
	output reg EX1_EX2_out_flush_signal2,

    input stall
);

always @(posedge clk ,negedge rstn)
begin
    if(!rstn)
    begin
        EX1_EX2_out_instr1<=32'b0;
        EX1_EX2_out_instr2<=32'b0;
        EX1_EX2_out_instr1_rd_address<=5'b0;
        EX1_EX2_out_instr2_rd_address<=5'b0;
        EX1_EX2_out_instr1_pc<=32'b0;
        EX1_EX2_out_instr2_pc<=32'b0;
        EX1_EX2_out_instr1_alu_result<=32'b0;
        EX1_EX2_out_instr2_alu_result<=32'b0;
        EX1_EX2_out_instr1_read_data2<=32'b0;
        EX1_EX2_out_instr2_read_data2<=32'b0;

        EX1_EX2_out_recover_en<=1'b0;
        EX1_EX2_out_recover_pc<=1'b0;
        EX1_EX2_out_flush_signal1<=1'b0;
        EX1_EX2_out_flush_signal2<=1'b0;
    end
    else
    begin
        casez({stall, flush_signal1})
        2'b1?:
        begin //insert nop
            EX1_EX2_out_instr1<=32'b0;
            EX1_EX2_out_instr2<=32'b0;
            EX1_EX2_out_instr1_rd_address<=5'b0;
            EX1_EX2_out_instr2_rd_address<=5'b0;
            EX1_EX2_out_instr1_pc<=32'b0;
            EX1_EX2_out_instr2_pc<=32'b0;
            EX1_EX2_out_instr1_alu_result<=32'b0;
            EX1_EX2_out_instr2_alu_result<=32'b0;
            EX1_EX2_out_instr1_read_data2<=32'b0;
            EX1_EX2_out_instr2_read_data2<=32'b0;

            EX1_EX2_out_recover_en<=1'b0;
            EX1_EX2_out_recover_pc<=1'b0;
            EX1_EX2_out_flush_signal1<=1'b0;
            EX1_EX2_out_flush_signal2<=1'b0;
        end
        2'b01:
        begin
            EX1_EX2_out_instr1<=EX1_EX2_in_instr1;
            EX1_EX2_out_instr1_rd_address<=EX1_EX2_in_instr1_rd_address;
            EX1_EX2_out_instr1_pc<=EX1_EX2_in_instr1_pc;
            EX1_EX2_out_instr1_alu_result<=EX1_EX2_in_instr1_alu_result;
            EX1_EX2_out_instr1_read_data2<=EX1_EX2_in_instr1_read_data2;
        
            EX1_EX2_out_instr2<=32'b0;
            EX1_EX2_out_instr2_rd_address<=5'b0;
            EX1_EX2_out_instr2_pc<=32'b0;
            EX1_EX2_out_instr2_alu_result<=32'b0;
            EX1_EX2_out_instr2_read_data2<=32'b0;

            EX1_EX2_out_recover_en<=EX1_EX2_in_recover_en;
            EX1_EX2_out_recover_pc<=EX1_EX2_in_recover_pc;
            EX1_EX2_out_flush_signal1<=EX1_EX2_in_flush_signal1;
            EX1_EX2_out_flush_signal2<=EX1_EX2_in_flush_signal2;
        end
        default:
        begin
            EX1_EX2_out_instr1<=EX1_EX2_in_instr1;
            EX1_EX2_out_instr2<=EX1_EX2_in_instr2;
            EX1_EX2_out_instr1_rd_address<=EX1_EX2_in_instr1_rd_address;
            EX1_EX2_out_instr2_rd_address<=EX1_EX2_in_instr2_rd_address;
            EX1_EX2_out_instr1_pc<=EX1_EX2_in_instr1_pc;
            EX1_EX2_out_instr2_pc<=EX1_EX2_in_instr2_pc;
            EX1_EX2_out_instr1_alu_result<=EX1_EX2_in_instr1_alu_result;
            EX1_EX2_out_instr2_alu_result<=EX1_EX2_in_instr2_alu_result;
            EX1_EX2_out_instr1_read_data2<=EX1_EX2_in_instr1_read_data2;
            EX1_EX2_out_instr2_read_data2<=EX1_EX2_in_instr2_read_data2;

            EX1_EX2_out_recover_en<=EX1_EX2_in_recover_en;
            EX1_EX2_out_recover_pc<=EX1_EX2_in_recover_pc;
            EX1_EX2_out_flush_signal1<=EX1_EX2_in_flush_signal1;
            EX1_EX2_out_flush_signal2<=EX1_EX2_in_flush_signal2;
        end
        endcase
    end
    /*
    else if(flush_signal1)
    begin
        EX1_EX2_out_instr1<=EX1_EX2_in_instr1;
        EX1_EX2_out_instr1_rd_address<=EX1_EX2_in_instr1_rd_address;
        EX1_EX2_out_instr1_pc<=EX1_EX2_in_instr1_pc;
        EX1_EX2_out_instr1_alu_result<=EX1_EX2_in_instr1_alu_result;
        EX1_EX2_out_instr1_read_data2<=EX1_EX2_in_instr1_read_data2;
    
        EX1_EX2_out_instr2<=32'b0;
        EX1_EX2_out_instr2_rd_address<=5'b0;
        EX1_EX2_out_instr2_pc<=32'b0;
        EX1_EX2_out_instr2_alu_result<=32'b0;
        EX1_EX2_out_instr2_read_data2<=32'b0;
    end
	 else
    begin
        EX1_EX2_out_instr1<=EX1_EX2_in_instr1;
        EX1_EX2_out_instr2<=EX1_EX2_in_instr2;
        EX1_EX2_out_instr1_rd_address<=EX1_EX2_in_instr1_rd_address;
        EX1_EX2_out_instr2_rd_address<=EX1_EX2_in_instr2_rd_address;
        EX1_EX2_out_instr1_pc<=EX1_EX2_in_instr1_pc;
        EX1_EX2_out_instr2_pc<=EX1_EX2_in_instr2_pc;
        EX1_EX2_out_instr1_alu_result<=EX1_EX2_in_instr1_alu_result;
        EX1_EX2_out_instr2_alu_result<=EX1_EX2_in_instr2_alu_result;
        EX1_EX2_out_instr1_read_data2<=EX1_EX2_in_instr1_read_data2;
        EX1_EX2_out_instr2_read_data2<=EX1_EX2_in_instr2_read_data2;
    end
*/
    /*
    else
    begin
        EX1_EX2_out_instr1 <= EX1_EX2_in_instr1;
        EX1_EX2_out_instr1_rd_address <= EX1_EX2_in_instr1_rd_address;
        EX1_EX2_out_instr1_pc <= EX1_EX2_in_instr1_pc;
        EX1_EX2_out_instr1_alu_result <= EX1_EX2_in_instr1_alu_result;
        EX1_EX2_out_instr1_read_data2 <= EX1_EX2_in_instr1_read_data2;

        
        EX1_EX2_out_instr2 <= EX1_EX2_in_instr2 & {32{~flush_signal1}};
        EX1_EX2_out_instr2_rd_address <= EX1_EX2_in_instr2_rd_address & {5{~flush_signal1}};
        EX1_EX2_out_instr2_pc <= EX1_EX2_in_instr2_pc & {32{~flush_signal1}};
        EX1_EX2_out_instr2_alu_result <= EX1_EX2_in_instr2_alu_result & {32{~flush_signal1}};
        EX1_EX2_out_instr2_read_data2 <= EX1_EX2_in_instr2_read_data2 & {32{~flush_signal1}};
    end
        */
end

endmodule