module issue_EX1(
    input clk,
	input rstn,
    input flush_signal1,
    input flush_signal2,
    input nop1,
    input nop2,
	input [31:0] issue_EX1_in_instr1,
	input [31:0] issue_EX1_in_instr2,
    input [31:0] issue_EX1_in_instr1_imm,
    input [31:0] issue_EX1_in_instr2_imm,
    input [4:0] issue_EX1_in_instr1_rs1_address,
    input [4:0] issue_EX1_in_instr2_rs1_address,
    input [4:0] issue_EX1_in_instr1_rs2_address,
    input [4:0] issue_EX1_in_instr2_rs2_address,
	input [4:0] issue_EX1_in_instr1_rd_address,
	input [4:0] issue_EX1_in_instr2_rd_address,
    input [31:0] issue_EX1_in_instr1_pc,
    input [31:0] issue_EX1_in_instr2_pc,
    input issue_EX1_in_instr1_branch_predict_state,
	input issue_EX1_in_instr2_branch_predict_state,

	output reg [31:0] issue_EX1_out_instr1,
	output reg [31:0] issue_EX1_out_instr2,
    output reg [31:0] issue_EX1_out_instr1_imm,
    output reg [31:0] issue_EX1_out_instr2_imm,
    output reg [4:0] issue_EX1_out_instr1_rs1_address,
    output reg [4:0] issue_EX1_out_instr2_rs1_address,
    output reg [4:0] issue_EX1_out_instr1_rs2_address,
    output reg [4:0] issue_EX1_out_instr2_rs2_address,
	output reg [4:0] issue_EX1_out_instr1_rd_address,
	output reg [4:0] issue_EX1_out_instr2_rd_address,
    output reg [31:0] issue_EX1_out_instr1_pc,
    output reg [31:0] issue_EX1_out_instr2_pc,
    output reg issue_EX1_out_instr1_branch_predict_state,
	output reg issue_EX1_out_instr2_branch_predict_state,

    input stall
);

always @(posedge clk ,negedge rstn)
begin
    if(!rstn)
    begin
        issue_EX1_out_instr1<=32'b0;
        issue_EX1_out_instr2<=32'b0;
        issue_EX1_out_instr1_rs1_address<=5'b0;
        issue_EX1_out_instr2_rs1_address<=5'b0;
        issue_EX1_out_instr1_rs2_address<=5'b0;
        issue_EX1_out_instr2_rs2_address<=5'b0;
        issue_EX1_out_instr1_rd_address<=5'b0;
        issue_EX1_out_instr2_rd_address<=5'b0;
        issue_EX1_out_instr1_imm<=32'b0;
        issue_EX1_out_instr2_imm<=32'b0;
        issue_EX1_out_instr1_pc<=32'b0;
        issue_EX1_out_instr2_pc<=32'b0;
        issue_EX1_out_instr1_branch_predict_state<=0;
    	issue_EX1_out_instr2_branch_predict_state<=0;
    end
    else
    begin
        casez({(flush_signal1||flush_signal2),nop1,nop2, stall})
        4'b1???:
        begin
            issue_EX1_out_instr1<=32'b0;
            issue_EX1_out_instr2<=32'b0;
            issue_EX1_out_instr1_rs1_address<=5'b0;
            issue_EX1_out_instr2_rs1_address<=5'b0;
            issue_EX1_out_instr1_rs2_address<=5'b0;
            issue_EX1_out_instr2_rs2_address<=5'b0;
            issue_EX1_out_instr1_rd_address<=5'b0;
            issue_EX1_out_instr2_rd_address<=5'b0;
            issue_EX1_out_instr1_imm<=32'b0;
            issue_EX1_out_instr2_imm<=32'b0;
            issue_EX1_out_instr1_pc<=32'b0;
            issue_EX1_out_instr2_pc<=32'b0;
            issue_EX1_out_instr1_branch_predict_state<=0;
            issue_EX1_out_instr2_branch_predict_state<=0;
        end
        4'b01??:
        begin
            issue_EX1_out_instr1<=32'b0;
            issue_EX1_out_instr2<=issue_EX1_in_instr2;
            issue_EX1_out_instr1_rs1_address<=5'b0;
            issue_EX1_out_instr2_rs1_address<=issue_EX1_in_instr2_rs1_address;
            issue_EX1_out_instr1_rs2_address<=5'b0;
            issue_EX1_out_instr2_rs2_address<=issue_EX1_in_instr2_rs2_address;
            issue_EX1_out_instr1_rd_address<=5'b0;
            issue_EX1_out_instr2_rd_address<=issue_EX1_in_instr2_rd_address;
            issue_EX1_out_instr1_imm<=32'b0;
            issue_EX1_out_instr2_imm<=issue_EX1_in_instr2_imm;
            issue_EX1_out_instr1_pc<=32'b0;
            issue_EX1_out_instr2_pc<=issue_EX1_in_instr2_pc;
            issue_EX1_out_instr1_branch_predict_state<=0;
            issue_EX1_out_instr2_branch_predict_state<=issue_EX1_in_instr2_branch_predict_state;
        end
        4'b001?:
        begin
            issue_EX1_out_instr1<=issue_EX1_in_instr1;
            issue_EX1_out_instr2<=32'b0;
            issue_EX1_out_instr1_rs1_address<=issue_EX1_in_instr1_rs1_address;
            issue_EX1_out_instr2_rs1_address<=5'b0;
            issue_EX1_out_instr1_rs2_address<=issue_EX1_in_instr1_rs2_address;
            issue_EX1_out_instr2_rs2_address<=5'b0;
            issue_EX1_out_instr1_rd_address<=issue_EX1_in_instr1_rd_address;
            issue_EX1_out_instr2_rd_address<=5'b0;
            issue_EX1_out_instr1_imm<=issue_EX1_in_instr1_imm;
            issue_EX1_out_instr2_imm<=32'b0;
            issue_EX1_out_instr1_pc<=issue_EX1_in_instr1_pc;
            issue_EX1_out_instr2_pc<=32'b0;
            issue_EX1_out_instr1_branch_predict_state<=issue_EX1_in_instr1_branch_predict_state;
            issue_EX1_out_instr2_branch_predict_state<=0;
            
        end 
        4'b0001: //stall
        begin
            issue_EX1_out_instr1<=issue_EX1_out_instr1;
            issue_EX1_out_instr2<=issue_EX1_out_instr2;
            issue_EX1_out_instr1_rs1_address<=issue_EX1_out_instr1_rs1_address;
            issue_EX1_out_instr2_rs1_address<=issue_EX1_out_instr2_rs1_address;
            issue_EX1_out_instr1_rs2_address<=issue_EX1_out_instr1_rs2_address;
            issue_EX1_out_instr2_rs2_address<=issue_EX1_out_instr2_rs2_address;
            issue_EX1_out_instr1_rd_address<=issue_EX1_out_instr1_rd_address;
            issue_EX1_out_instr2_rd_address<=issue_EX1_out_instr2_rd_address;
            issue_EX1_out_instr1_imm<=issue_EX1_out_instr1_imm;
            issue_EX1_out_instr2_imm<=issue_EX1_out_instr2_imm;
            issue_EX1_out_instr1_pc<=issue_EX1_out_instr1_pc;
            issue_EX1_out_instr2_pc<=issue_EX1_out_instr2_pc;
            issue_EX1_out_instr1_branch_predict_state<=issue_EX1_out_instr1_branch_predict_state;
            issue_EX1_out_instr2_branch_predict_state<=issue_EX1_out_instr2_branch_predict_state;
        end
        default:
        begin
            issue_EX1_out_instr1<=issue_EX1_in_instr1;
            issue_EX1_out_instr2<=issue_EX1_in_instr2;
            issue_EX1_out_instr1_rs1_address<=issue_EX1_in_instr1_rs1_address;
            issue_EX1_out_instr2_rs1_address<=issue_EX1_in_instr2_rs1_address;
            issue_EX1_out_instr1_rs2_address<=issue_EX1_in_instr1_rs2_address;
            issue_EX1_out_instr2_rs2_address<=issue_EX1_in_instr2_rs2_address;
            issue_EX1_out_instr1_rd_address<=issue_EX1_in_instr1_rd_address;
            issue_EX1_out_instr2_rd_address<=issue_EX1_in_instr2_rd_address;
            issue_EX1_out_instr1_imm<=issue_EX1_in_instr1_imm;
            issue_EX1_out_instr2_imm<=issue_EX1_in_instr2_imm;
            issue_EX1_out_instr1_pc<=issue_EX1_in_instr1_pc;
            issue_EX1_out_instr2_pc<=issue_EX1_in_instr2_pc;
            issue_EX1_out_instr1_branch_predict_state<=issue_EX1_in_instr1_branch_predict_state;
            issue_EX1_out_instr2_branch_predict_state<=issue_EX1_in_instr2_branch_predict_state;
        end
        endcase
    end

    /*
    else if(flush_signal1||flush_signal2)
    begin
        issue_EX1_out_instr1<=32'b0;
        issue_EX1_out_instr2<=32'b0;
        issue_EX1_out_instr1_rs1_address<=5'b0;
        issue_EX1_out_instr2_rs1_address<=5'b0;
        issue_EX1_out_instr1_rs2_address<=5'b0;
        issue_EX1_out_instr2_rs2_address<=5'b0;
        issue_EX1_out_instr1_rd_address<=5'b0;
        issue_EX1_out_instr2_rd_address<=5'b0;
        issue_EX1_out_instr1_imm<=32'b0;
        issue_EX1_out_instr2_imm<=32'b0;
        issue_EX1_out_instr1_pc<=32'b0;
        issue_EX1_out_instr2_pc<=32'b0;
        issue_EX1_out_instr1_branch_predict_state<=0;
    	issue_EX1_out_instr2_branch_predict_state<=0;
    end
    else if(nop1)
    begin
        issue_EX1_out_instr1<=32'b0;
        issue_EX1_out_instr2<=issue_EX1_in_instr2;
        issue_EX1_out_instr1_rs1_address<=5'b0;
        issue_EX1_out_instr2_rs1_address<=issue_EX1_in_instr2_rs1_address;
        issue_EX1_out_instr1_rs2_address<=5'b0;
        issue_EX1_out_instr2_rs2_address<=issue_EX1_in_instr2_rs2_address;
        issue_EX1_out_instr1_rd_address<=5'b0;
        issue_EX1_out_instr2_rd_address<=issue_EX1_in_instr2_rd_address;
        issue_EX1_out_instr1_imm<=32'b0;
        issue_EX1_out_instr2_imm<=issue_EX1_in_instr2_imm;
        issue_EX1_out_instr1_pc<=32'b0;
        issue_EX1_out_instr2_pc<=issue_EX1_in_instr2_pc;
        issue_EX1_out_instr1_branch_predict_state<=0;
    	issue_EX1_out_instr2_branch_predict_state<=issue_EX1_in_instr2_branch_predict_state;
    end
    else if(nop2)
    begin
        issue_EX1_out_instr1<=issue_EX1_in_instr1;
        issue_EX1_out_instr2<=32'b0;
        issue_EX1_out_instr1_rs1_address<=issue_EX1_in_instr1_rs1_address;
        issue_EX1_out_instr2_rs1_address<=5'b0;
        issue_EX1_out_instr1_rs2_address<=issue_EX1_in_instr1_rs2_address;
        issue_EX1_out_instr2_rs2_address<=5'b0;
        issue_EX1_out_instr1_rd_address<=issue_EX1_in_instr1_rd_address;
        issue_EX1_out_instr2_rd_address<=5'b0;
        issue_EX1_out_instr1_imm<=issue_EX1_in_instr1_imm;
        issue_EX1_out_instr2_imm<=32'b0;
        issue_EX1_out_instr1_pc<=issue_EX1_in_instr1_pc;
        issue_EX1_out_instr2_pc<=32'b0;
        issue_EX1_out_instr1_branch_predict_state<=issue_EX1_in_instr1_branch_predict_state;
    	issue_EX1_out_instr2_branch_predict_state<=0;
        
    end   
    else
    begin
        issue_EX1_out_instr1<=issue_EX1_in_instr1;
        issue_EX1_out_instr2<=issue_EX1_in_instr2;
        issue_EX1_out_instr1_rs1_address<=issue_EX1_in_instr1_rs1_address;
        issue_EX1_out_instr2_rs1_address<=issue_EX1_in_instr2_rs1_address;
        issue_EX1_out_instr1_rs2_address<=issue_EX1_in_instr1_rs2_address;
        issue_EX1_out_instr2_rs2_address<=issue_EX1_in_instr2_rs2_address;
        issue_EX1_out_instr1_rd_address<=issue_EX1_in_instr1_rd_address;
        issue_EX1_out_instr2_rd_address<=issue_EX1_in_instr2_rd_address;
        issue_EX1_out_instr1_imm<=issue_EX1_in_instr1_imm;
        issue_EX1_out_instr2_imm<=issue_EX1_in_instr2_imm;
        issue_EX1_out_instr1_pc<=issue_EX1_in_instr1_pc;
        issue_EX1_out_instr2_pc<=issue_EX1_in_instr2_pc;
        issue_EX1_out_instr1_branch_predict_state<=issue_EX1_in_instr1_branch_predict_state;
        issue_EX1_out_instr2_branch_predict_state<=issue_EX1_in_instr2_branch_predict_state;
    end
        */
end

endmodule