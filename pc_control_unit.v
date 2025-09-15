module pc_control_unit(
	input clk,
	input rst_n,
    input nop1,
	input nop2,
	input PC_hold,
	input [31:0] instr1,
	input [31:0] instr2,
	input branch_predict_result,

    input recover_en,
	input [31:0] recover_pc,
    

	output [31:0] pc,
   // output reg answer_to_recover_unit

    output reg is_branch1,
    output reg is_branch2 ,

    input stall
);

reg [31:0] instr1_target_pc ,instr2_target_pc;
//reg is_branch1 ,is_branch2;
reg signed [31:0] offset1 ,offset2;
reg [31:0] pc_cur_state=32'b0;
reg [31:0] pc_next_state;
wire [31:0] pc_add_8;

assign pc=pc_cur_state;
assign pc_add_8=pc+'d8;

reg next_state_condition;
always @(*)
begin
    next_state_condition=(((!stall)&&(!nop2))||recover_en);//hope this could reduce the delay brought by recover_en which arrives very late…�??
end

always @(posedge clk,negedge rst_n) 
begin
	if (!rst_n)
	begin
		 pc_cur_state<=32'h80000000;
        // keep<=0;
	end
	else
	begin
        casez(next_state_condition)
        1'b1:pc_cur_state<=pc_next_state;
        default:pc_cur_state<=pc_cur_state;
        endcase
        /*
		if(((~PC_hold)&&(!nop2))||recover_en)
		begin
			pc_cur_state<=pc_next_state;
          //  keep<=0;
		end
		else 
		begin
			pc_cur_state<=pc_cur_state;
          //  keep<=1;
		en*/
	end
end


reg branch_condition1 ,branch_condition2;
always @(*)
begin
    branch_condition1=branch_predict_result&&is_branch1;
    branch_condition2=branch_predict_result&&is_branch2&&(!is_branch1);
end

always @(*)
begin
    casez({stall, recover_en ,branch_condition1 ,branch_condition2})
    4'b1???:
    begin
        pc_next_state=pc_next_state;
    end
    4'b01??:
    begin
        pc_next_state=recover_pc;
    end
    4'b001?:
    begin
        pc_next_state=instr1_target_pc;
    end
    4'b0001:
    begin
        pc_next_state=instr2_target_pc;
    end
    default:
    begin
        pc_next_state=pc_add_8;
    end
    endcase

    /*
        if(recover_en)
        begin
            pc_next_state=recover_pc;
        end
        else
        begin
            if(branch_predict_result&&is_branch1)
            begin
                pc_next_state=instr1_target_pc;
            end
            else if(branch_predict_result&&is_branch2&&(!is_branch1))
            begin
                pc_next_state=instr2_target_pc;
            end
            else
            begin
                pc_next_state=pc_add_8;
            end
        end
            */
end


always @(*)
begin
    case(instr1[6:0])
    7'b1101111: //jal
    begin
        //offset1={{19{instr1[31]}},instr1[31],instr1[19:12],instr1[20],instr1[30:21],1'b0};
		//instr1_target_pc=pc_cur_state+offset1;
		offset1='b0;
        instr1_target_pc=32'b0;
        is_branch1=0; 
        
    end
    7'b1100111: //jalr
    begin
        //target_pc=x[rs1]+sext(offset)
		//offset1={{20{instr1[31]}},instr1[31:20]};
        //instr1_target_pc=offset1+instr1_jalr_read_data;
		  offset1='b0;
        instr1_target_pc=32'b0;
        is_branch1=0; //address_predict...
    end
    7'b1100011: //B
    begin
        case(instr1[14:12])
        3'b000: //beq
        begin
            offset1={{19{instr1[31]}},instr1[31],instr1[7],instr1[30:25],instr1[11:8],1'b0};
            instr1_target_pc=pc_cur_state+offset1;
            is_branch1=1;
        end
        3'b001: //bne
        begin

                offset1={{19{instr1[31]}},instr1[31],instr1[7],instr1[30:25],instr1[11:8],1'b0};
                instr1_target_pc=pc_cur_state+offset1;
                is_branch1=1;
        end
        3'b100: //blt
        begin
            offset1={{19{instr1[31]}},instr1[31],instr1[7],instr1[30:25],instr1[11:8],1'b0};
            instr1_target_pc=pc_cur_state+offset1;
            is_branch1=1;
        end
        3'b101: //bge
        begin
            offset1={{19{instr1[31]}},instr1[31],instr1[7],instr1[30:25],instr1[11:8],1'b0};
            instr1_target_pc=pc_cur_state+offset1;
            is_branch1=1;
        end
        3'b110: //bltu
        begin
            offset1={{19{instr1[31]}},instr1[31],instr1[7],instr1[30:25],instr1[11:8],1'b0};
            instr1_target_pc=pc_cur_state+offset1;
            is_branch1=1;
        end
        3'b111: //bgeu
        begin
            offset1={{19{instr1[31]}},instr1[31],instr1[7],instr1[30:25],instr1[11:8],1'b0};
            instr1_target_pc=pc_cur_state+offset1;
            is_branch1=1;
        end
        default:
        begin
				offset1='b0;
            instr1_target_pc=32'b0;
            is_branch1=0;
        end
        endcase
    end
    default:
    begin
		  offset1='b0;	
        instr1_target_pc=32'b0;
        is_branch1=0;
    end
    endcase
end




always @(*)
begin
    case(instr2[6:0])
    7'b1101111: //jal
    begin
        //offset2={{19{instr2[31]}},instr2[31],instr2[19:12],instr2[20],instr2[30:21],1'b0};
		//instr2_target_pc=pc_cur_state+offset2;
		  offset2='b0;
        instr2_target_pc=32'b0;
        is_branch2=0; 
    end
    7'b1100111: //jalr
    begin
        //target_pc=x[rs1]+sext(offset)
        //offset2={{20{instr2[31]}},instr2[31:20]};
        //instr2_target_pc=offset2+instr2_jalr_read_data;
		  offset2='b0;
        instr2_target_pc=32'b0;
        is_branch2=0;
    end
    7'b1100011: //B
    begin
        case(instr2[14:12])
        3'b000: //beq
        begin
            offset2={{19{instr2[31]}},instr2[31],instr2[7],instr2[30:25],instr2[11:8],1'b0};
            instr2_target_pc=pc_cur_state+4+offset2;
            is_branch2=1;
        end
        3'b001: //bne
        begin

                offset2={{19{instr2[31]}},instr2[31],instr2[7],instr2[30:25],instr2[11:8],1'b0};
                instr2_target_pc=pc_cur_state+4+offset2;
                is_branch2=1;
        end
        3'b100: //blt
        begin
            offset2={{19{instr2[31]}},instr2[31],instr2[7],instr2[30:25],instr2[11:8],1'b0};
            instr2_target_pc=pc_cur_state+4+offset2;
            is_branch2=1;
        end
        3'b101: //bge
        begin
            offset2={{19{instr2[31]}},instr2[31],instr2[7],instr2[30:25],instr2[11:8],1'b0};
            instr2_target_pc=pc_cur_state+4+offset2;
            is_branch2=1;
        end
        3'b110: //bltu
        begin
            offset2={{19{instr2[31]}},instr2[31],instr2[7],instr2[30:25],instr2[11:8],1'b0};
            instr2_target_pc=pc_cur_state+4+offset2;
            is_branch2=1;
        end
        3'b111: //bgeu
        begin
            offset2={{19{instr2[31]}},instr2[31],instr2[7],instr2[30:25],instr2[11:8],1'b0};
            instr2_target_pc=pc_cur_state+4+offset2;
            is_branch2=1;
        end
        default:
        begin
				offset2='b0;
            instr2_target_pc=32'b0;
            is_branch2=0;
        end
        endcase
    end
    default:
    begin
			offset2='b0;
        instr2_target_pc=32'b0;
        is_branch2=0;
    end
    endcase
end



endmodule