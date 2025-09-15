module decode_issue(
    input clk,
	input rstn,
    input nop1,
    input nop2,
    input flush_signal1,
    input flush_signal2,
	input [31:0] decode_issue_in_instr1,
	input [31:0] decode_issue_in_instr2,
    input [31:0] decode_issue_in_instr1_pc,
    input [31:0] decode_issue_in_instr2_pc,
    input decode_issue_in_instr1_branch_predict_state,
	input decode_issue_in_instr2_branch_predict_state,
    
	output reg [31:0] decode_issue_out_instr1,
	output reg [31:0] decode_issue_out_instr2,
    output reg [31:0] decode_issue_out_instr1_pc,
    output reg [31:0] decode_issue_out_instr2_pc,
    output reg decode_issue_out_instr1_branch_predict_state,
	output reg decode_issue_out_instr2_branch_predict_state,

    input stall
);

always @(posedge clk ,negedge rstn) 
begin
    if(!rstn)
    begin
        decode_issue_out_instr1<=32'b0;
        decode_issue_out_instr2<=32'b0;
        decode_issue_out_instr1_pc<=32'b0;
        decode_issue_out_instr2_pc<=32'b0;
        decode_issue_out_instr1_branch_predict_state<=0;
	    decode_issue_out_instr2_branch_predict_state<=0;
    end 
    else
    begin
        casez({(flush_signal1||flush_signal2),stall,nop1,nop2})
        4'b1???:
        begin
            decode_issue_out_instr1<=32'b0;
            decode_issue_out_instr2<=32'b0;
            decode_issue_out_instr1_pc<=32'b0;
            decode_issue_out_instr2_pc<=32'b0;
            decode_issue_out_instr1_branch_predict_state<=0;
            decode_issue_out_instr2_branch_predict_state<=0;
        end
        4'b01??: //stall
        begin
            decode_issue_out_instr1<=decode_issue_out_instr1;
            decode_issue_out_instr2<=decode_issue_out_instr2;
            decode_issue_out_instr1_pc<=decode_issue_out_instr1_pc;
            decode_issue_out_instr2_pc<=decode_issue_out_instr2_pc;
            decode_issue_out_instr1_branch_predict_state<=decode_issue_out_instr1_branch_predict_state;
            decode_issue_out_instr2_branch_predict_state<=decode_issue_out_instr2_branch_predict_state;
        end
        4'b001?:
        begin //keep
            decode_issue_out_instr1<=32'b0;
            decode_issue_out_instr2<=decode_issue_in_instr2;
            decode_issue_out_instr1_pc<=32'b0;
            decode_issue_out_instr2_pc<=decode_issue_in_instr2_pc;
            decode_issue_out_instr1_branch_predict_state<=0;
            decode_issue_out_instr2_branch_predict_state<=decode_issue_in_instr2_branch_predict_state;
        end
        4'b0001:
        begin //keep
            decode_issue_out_instr1<=decode_issue_in_instr1;
            decode_issue_out_instr2<=32'b0;
            decode_issue_out_instr1_pc<=decode_issue_in_instr1_pc;
            decode_issue_out_instr2_pc<=32'b0;
            decode_issue_out_instr1_branch_predict_state<=decode_issue_in_instr1_branch_predict_state;
            decode_issue_out_instr2_branch_predict_state<=0;
        end
        default:
        begin
            decode_issue_out_instr1<=decode_issue_in_instr1;
            decode_issue_out_instr2<=decode_issue_in_instr2;
            decode_issue_out_instr1_pc<=decode_issue_in_instr1_pc;
            decode_issue_out_instr2_pc<=decode_issue_in_instr2_pc;
            decode_issue_out_instr1_branch_predict_state<=decode_issue_in_instr1_branch_predict_state;
            decode_issue_out_instr2_branch_predict_state<=decode_issue_in_instr2_branch_predict_state;
        end
        endcase
    end

    /*
    else if(flush_signal1||flush_signal2)
    begin
        decode_issue_out_instr1<=32'b0;
        decode_issue_out_instr2<=32'b0;
        decode_issue_out_instr1_pc<=32'b0;
        decode_issue_out_instr2_pc<=32'b0;
        decode_issue_out_instr1_branch_predict_state<=0;
	    decode_issue_out_instr2_branch_predict_state<=0;
    end
    else if(nop1)
    begin //keep
        decode_issue_out_instr1<=32'b0;
        decode_issue_out_instr2<=decode_issue_in_instr2;
        decode_issue_out_instr1_pc<=32'b0;
        decode_issue_out_instr2_pc<=decode_issue_in_instr2_pc;
        decode_issue_out_instr1_branch_predict_state<=0;
        decode_issue_out_instr2_branch_predict_state<=decode_issue_in_instr2_branch_predict_state;
    end
    else if(nop2)
    begin //keep
        decode_issue_out_instr1<=decode_issue_in_instr1;
        decode_issue_out_instr2<=32'b0;
        decode_issue_out_instr1_pc<=decode_issue_in_instr1_pc;
        decode_issue_out_instr2_pc<=32'b0;
        decode_issue_out_instr1_branch_predict_state<=decode_issue_in_instr1_branch_predict_state;
        decode_issue_out_instr2_branch_predict_state<=0;
    end
    
    else
    begin
        decode_issue_out_instr1<=decode_issue_in_instr1;
        decode_issue_out_instr2<=decode_issue_in_instr2;
        decode_issue_out_instr1_pc<=decode_issue_in_instr1_pc;
        decode_issue_out_instr2_pc<=decode_issue_in_instr2_pc;
        decode_issue_out_instr1_branch_predict_state<=decode_issue_in_instr1_branch_predict_state;
	    decode_issue_out_instr2_branch_predict_state<=decode_issue_in_instr2_branch_predict_state;
    end   
        */
end

endmodule