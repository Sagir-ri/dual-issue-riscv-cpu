module fetch_decode(
    input clk,
    input rstn,
    input nop,
    input flush_signal1,
    input flush_signal2,
    input [31:0] fetch_decode_in_instr1,
    input [31:0] fetch_decode_in_instr2,
    input [31:0] fetch_decode_in_instr1_pc,
    input [31:0] fetch_decode_in_instr2_pc,
    input fetch_decode_in_instr1_branch_predict_state,
    input fetch_decode_in_instr2_branch_predict_state,
    input fetch_decode_in_is_branch1_fetch,
    input fetch_decode_in_is_branch2_fetch,

    output reg [31:0] fetch_decode_out_instr1,
    output reg [31:0] fetch_decode_out_instr2,
    output reg [31:0] fetch_decode_out_instr1_pc,
    output reg [31:0] fetch_decode_out_instr2_pc,
    output reg fetch_decode_out_instr1_branch_predict_state,
	output reg fetch_decode_out_instr2_branch_predict_state,

    input stall
);

always @(posedge clk, negedge rstn)
begin
    if(!rstn)
    begin
        fetch_decode_out_instr1<=32'b0;
        fetch_decode_out_instr2<=32'b0;
        fetch_decode_out_instr1_pc<=32'b0;
        fetch_decode_out_instr2_pc<=32'b0;
        fetch_decode_out_instr1_branch_predict_state<=0;
	    fetch_decode_out_instr2_branch_predict_state<=0;
    end
    else
    begin
        casez({(flush_signal1||flush_signal2), (nop||stall), (fetch_decode_in_is_branch1_fetch==1 && fetch_decode_in_instr1_branch_predict_state==1)})
        //specialize //dual-issue cpu fetchs 2 instrs in a single clk period. but when we predict instr1 takes when instr1 is a branch-type instr, instr2 is on the 'wrong' path
                     //but we didnt notice this before, and we cant flush the whole instr-path from stage fetch to stage ex1 when we can judge if the prediction of instr1 is right or wrong 
                     //as the instrs before the 'judge' stage is on the right path since as soon as we have made the prediction, the pc changes
                     //so we can only flush this single instr2 just right after the branch-type instr1
        3'b1??:
        begin
            fetch_decode_out_instr1<=32'b0;
            fetch_decode_out_instr2<=32'b0;
            fetch_decode_out_instr1_pc<=32'b0;
            fetch_decode_out_instr2_pc<=32'b0;
            fetch_decode_out_instr1_branch_predict_state<=0;
            fetch_decode_out_instr2_branch_predict_state<=0;
        end
        3'b01?: //stall or nop keep
        begin
            fetch_decode_out_instr1<=fetch_decode_out_instr1;
            fetch_decode_out_instr2<=fetch_decode_out_instr2;
            fetch_decode_out_instr1_pc<=fetch_decode_out_instr1_pc;
            fetch_decode_out_instr2_pc<=fetch_decode_out_instr2_pc;
            fetch_decode_out_instr1_branch_predict_state<=fetch_decode_out_instr1_branch_predict_state;
            fetch_decode_out_instr2_branch_predict_state<=fetch_decode_out_instr2_branch_predict_state;
        end
        3'b001:
        begin
            fetch_decode_out_instr1<=fetch_decode_in_instr1;
            fetch_decode_out_instr2<='b0;
            fetch_decode_out_instr1_pc<=fetch_decode_in_instr1_pc;
            fetch_decode_out_instr2_pc<='b0;
            fetch_decode_out_instr1_branch_predict_state<=fetch_decode_in_instr1_branch_predict_state;
            fetch_decode_out_instr2_branch_predict_state<='b0;
        end
        default:
        begin
            fetch_decode_out_instr1<=fetch_decode_in_instr1;
            fetch_decode_out_instr2<=fetch_decode_in_instr2;
            fetch_decode_out_instr1_pc<=fetch_decode_in_instr1_pc;
            fetch_decode_out_instr2_pc<=fetch_decode_in_instr2_pc;
            fetch_decode_out_instr1_branch_predict_state<=fetch_decode_in_instr1_branch_predict_state;
            fetch_decode_out_instr2_branch_predict_state<=fetch_decode_in_instr2_branch_predict_state;
        end
        endcase
    end
    /*
    else if(flush_signal1||flush_signal2)
    begin
        fetch_decode_out_instr1<=32'b0;
        fetch_decode_out_instr2<=32'b0;
        fetch_decode_out_instr1_pc<=32'b0;
        fetch_decode_out_instr2_pc<=32'b0;
        fetch_decode_out_instr1_branch_predict_state<=0;
	    fetch_decode_out_instr2_branch_predict_state<=0;
    end
    else if(nop)
    begin
        fetch_decode_out_instr1<=fetch_decode_out_instr1;
        fetch_decode_out_instr2<=fetch_decode_out_instr2;
        fetch_decode_out_instr1_pc<=fetch_decode_out_instr1_pc;
        fetch_decode_out_instr2_pc<=fetch_decode_out_instr2_pc;
        fetch_decode_out_instr1_branch_predict_state<=fetch_decode_out_instr1_branch_predict_state;
	    fetch_decode_out_instr2_branch_predict_state<=fetch_decode_out_instr2_branch_predict_state;
    end
    
    else
    begin
        fetch_decode_out_instr1<=fetch_decode_in_instr1;
        fetch_decode_out_instr2<=fetch_decode_in_instr2;
        fetch_decode_out_instr1_pc<=fetch_decode_in_instr1_pc;
        fetch_decode_out_instr2_pc<=fetch_decode_in_instr2_pc;
        fetch_decode_out_instr1_branch_predict_state<=fetch_decode_in_instr1_branch_predict_state;
	    fetch_decode_out_instr2_branch_predict_state<=fetch_decode_in_instr2_branch_predict_state;
    end
        */
end

endmodule