module recover_unit(

	input taken1,
	input taken2,
	input instr1_branch_predict_state,
	input instr2_branch_predict_state,
	input is_branch1,
	input is_branch2,
	input is_jump1,
	input is_jump2,

	input [31:0] target_pc1,
	input [31:0] target_pc2,
	input [31:0] original_pc1,
	input [31:0] original_pc2,
	//input answer_from_pc_control_unit,
	
	//output reg is_jump1_recover,
	//output reg is_jump2_recover,
	output reg [31:0] recover_pc,
	output reg branch_predict_miss,
	output reg flush_signal1,
	output reg flush_signal2,
	output reg recover_en
);

/*
// {flush_signal1 ,flush_signal2} can't be 2'b11
reg is_jump1_recover_d; //d for delayed
reg is_jump2_recover_d;
reg [31:0] recover_pc_d;
reg branch_predict_miss_d;
reg flush_signal1_d;
reg flush_signal2_d;

always @(posedge clk ,negedge rstn)
begin
	if(!rstn)
	begin
		is_jump1_recover_d<='b0;
		is_jump2_recover_d<='b0;
		recover_pc_d<='b0;
		branch_predict_miss_d<='b0;
		flush_signal1_d<='b0;
		flush_signal2_d<='b0;
	end
	else
	begin
		is_jump1_recover_d<=is_jump1_recover;
		is_jump2_recover_d<=is_jump2_recover;
		recover_pc_d<=recover_pc;
		branch_predict_miss_d<=branch_predict_miss;
		flush_signal1_d<=flush_signal1;
		flush_signal2_d<=flush_signal2;
	end
end
	*/

reg [7:0] level1_condition;

reg [1:0] level2_condition1;

reg [1:0] level2_condition2;

reg [1:0] level3_condition1;

reg [1:0] level2_condition3;

reg [1:0] level2_condition4;

always @(*)
begin
	level1_condition={((is_jump1)&&(is_jump2)),((is_jump1)&&(is_branch2)),((is_jump1)&&((!is_jump2)&&(!is_branch2)))
,((is_branch1)&&(is_jump2)),((is_branch1)&&(is_branch2)),((is_branch1)&&((!is_jump2)&&(!is_branch2))),(((!is_jump1)&&(!is_branch1))&&(is_jump2)),
(((!is_jump1)&&(!is_branch1))&&(is_branch2))};

	level2_condition1={(taken1==1&&instr1_branch_predict_state==0) ,(taken1==0&&instr1_branch_predict_state==1)};

	level2_condition2={(taken1==1&&instr1_branch_predict_state==0) ,(taken1==0&&instr1_branch_predict_state==1)};

	level3_condition1={(taken2==1&&instr2_branch_predict_state==0) ,(taken2==0&&instr2_branch_predict_state==1)};

	level2_condition3={(taken1==1&&instr1_branch_predict_state==0) ,(taken1==0&&instr1_branch_predict_state==1)};

	level2_condition4={(taken2==1&&instr2_branch_predict_state==0) ,(taken2==0&&instr2_branch_predict_state==1)};
end


always @(*)
begin
	casez(level1_condition)
		8'b1???????: //((is_jump1)&&(is_jump2))
		begin
			flush_signal1=1;
			flush_signal2=0;
			branch_predict_miss=0;
			recover_pc=target_pc1;
			recover_en=1;
		end
		8'b01??????: //((is_jump1)&&(is_branch2))
		begin
			flush_signal1=1;
			flush_signal2=0;
			branch_predict_miss=0;
			recover_pc=target_pc1;
			recover_en=1;
		end
		8'b001?????: //((is_jump1)&&((!is_jump2)&&(!is_branch2)))
		begin
			flush_signal1=1;
			flush_signal2=0;
			branch_predict_miss=0;
			recover_pc=target_pc1;
			recover_en=1;
		end
		8'b0001????: //((is_branch1)&&(is_jump2))
			casez(level2_condition1)
			2'b1?:
			begin
				flush_signal1=1;
				flush_signal2=0;
				branch_predict_miss=1;
				recover_pc=target_pc1;
				recover_en=1;
			end
			2'b01:
			begin
				flush_signal1=1;
				flush_signal2=0;
				branch_predict_miss=1;
				recover_pc=original_pc1+4;
				recover_en=1;
			end
			default:
			begin
				if(taken1==1)
				begin
					flush_signal1=0;
					flush_signal2=0;
					branch_predict_miss=0;
					recover_pc='b0;
					recover_en=0;
				end
				else
				begin
					flush_signal1=0;
					flush_signal2=1;
					branch_predict_miss=0;
					recover_pc=target_pc2;
					recover_en=1;
				end
			end
			endcase
		8'b00001???: //((is_branch1)&&(is_branch2))
		begin
			casez(level2_condition2)
			2'b1?:
			begin
				flush_signal1=1;
				flush_signal2=0;
				branch_predict_miss=1;
				recover_pc=target_pc1;
				recover_en=1;
			end
			2'b01:
			begin
				flush_signal1=1;
				flush_signal2=0;
				branch_predict_miss=1;
				recover_pc=original_pc1+4;
				recover_en=1;
			end
			default:
			begin
				if(taken1==1)
				begin
					flush_signal1=0;
					flush_signal2=0;
					branch_predict_miss=0;
					recover_pc='b0;
					recover_en=0;
				end
				else
				begin
					casez(level3_condition1)
					2'b1?:
					begin
						flush_signal1=0;
						flush_signal2=1;
						branch_predict_miss=1;
						recover_pc=target_pc2;
						recover_en=1;
					end
					2'b01:
					begin
						flush_signal1=0;
						flush_signal2=1;
						branch_predict_miss=1;
						recover_pc=original_pc2+4;
						recover_en=1;
					end
					default:
					begin
						flush_signal1=0;
						flush_signal2=0;
						branch_predict_miss=0;
						recover_pc='b0;
						recover_en=0;
					end
					endcase
				end
			end
			endcase
		end
		8'b000001??: //((is_branch1)&&((!is_jump2)&&(!is_branch2)))
		begin
			casez(level2_condition3)
			2'b1?:
			begin
				flush_signal1=1;
				flush_signal2=0;
				branch_predict_miss=1;
				recover_pc=target_pc1;
				recover_en=1;
			end
			2'b01:
			begin
				flush_signal1=1;
				flush_signal2=0;
				branch_predict_miss=1;
				recover_pc=original_pc1+4;
				recover_en=1;
			end
			default:
			begin
				flush_signal1=0;
				flush_signal2=0;
				branch_predict_miss=0;
				recover_pc='b0;
				recover_en=0;
			end
			endcase
		end
		8'b0000001?:
		begin
			flush_signal1=0;
			flush_signal2=1;
			branch_predict_miss=0;
			recover_pc=target_pc2;
			recover_en=1;
		end
		8'b00000001:
		begin
			casez(level2_condition4)
			2'b1?:
			begin
				flush_signal1=0;
				flush_signal2=1;
				branch_predict_miss=1;
				recover_pc=target_pc2;
				recover_en=1;
			end
			2'b01:
			begin
				flush_signal1=0;
				flush_signal2=1;
				branch_predict_miss=1;
				recover_pc=original_pc2+4;
				recover_en=1;
			end
			default:
			begin
				flush_signal1=0;
				flush_signal2=0;
				branch_predict_miss=0;
				recover_pc='b0;
				recover_en=0;
			end
			endcase
		end
		default: 
		begin
			flush_signal1=0;
			flush_signal2=0;
			branch_predict_miss=0;
			recover_pc='b0;
			recover_en=0;
		end
	endcase
	/*
	if((is_jump1)&&(is_jump2)) //branch ,jump ,normal 3x3 = 9 situations //1
	begin
		flush_signal1=1;
		flush_signal2=0;
		branch_predict_miss=0;
		recover_pc=target_pc1;
		recover_en=1;
	end
	else if((is_jump1)&&(is_branch2))//2
	begin
		flush_signal1=1;
		flush_signal2=0;
		branch_predict_miss=0;
		recover_pc=target_pc1;
		recover_en=1;
	end
	else if((is_jump1)&&((!is_jump2)&&(!is_branch2)))//3
	begin
		flush_signal1=1;
		flush_signal2=0;
		branch_predict_miss=0;
		recover_pc=target_pc1;
		recover_en=1;
	end
	else if((is_branch1)&&(is_jump2))//4
	begin
		if(taken1==1&&instr1_branch_predict_state==0)
		begin
			flush_signal1=1;
			flush_signal2=0;
			branch_predict_miss=1;
			recover_pc=target_pc1;
			recover_en=1;
		end
		else if(taken1==0&&instr1_branch_predict_state==1)
		begin
			flush_signal1=1;
			flush_signal2=0;
			branch_predict_miss=1;
			recover_pc=original_pc1+4;
			recover_en=1;
		end
		else
		begin
			if(taken1==1)
			begin
				flush_signal1=0;
				flush_signal2=0;
				branch_predict_miss=0;
				recover_pc='b0;
				recover_en=0;
			end
			else
			begin
				flush_signal1=0;
				flush_signal2=1;
				branch_predict_miss=0;
				recover_pc=target_pc2;
				recover_en=1;
			end
		end
	end
	else if((is_branch1)&&(is_branch2))//5
	begin
		if(taken1==1&&instr1_branch_predict_state==0)
		begin
			flush_signal1=1;
			flush_signal2=0;
			branch_predict_miss=1;
			recover_pc=target_pc1;
			recover_en=1;
		end
		else if(taken1==0&&instr1_branch_predict_state==1)
		begin
			flush_signal1=1;
			flush_signal2=0;
			branch_predict_miss=1;
			recover_pc=original_pc1+4;
			recover_en=1;
		end
		else
		begin
			if(taken1==1)
			begin
				flush_signal1=0;
				flush_signal2=0;
				branch_predict_miss=0;
				recover_pc='b0;
				recover_en=0;
			end
			else
			begin
				if(taken2==1&&instr2_branch_predict_state==0)
				begin
					flush_signal1=0;
					flush_signal2=1;
					branch_predict_miss=1;
					recover_pc=target_pc2;
					recover_en=1;
				end
				else if(taken2==0&&instr2_branch_predict_state==1)
				begin
					flush_signal1=0;
					flush_signal2=1;
					branch_predict_miss=1;
					recover_pc=original_pc2+4;
					recover_en=1;
				end
				else
				begin
					flush_signal1=0;
					flush_signal2=0;
					branch_predict_miss=0;
					recover_pc='b0;
					recover_en=0;
				end
			end
		end
	end
	else if((is_branch1)&&((!is_jump2)&&(!is_branch2)))//6
	begin
		if(taken1==1&&instr1_branch_predict_state==0)
		begin
			flush_signal1=1;
			flush_signal2=0;
			branch_predict_miss=1;
			recover_pc=target_pc1;
			recover_en=1;
		end
		else if(taken1==0&&instr1_branch_predict_state==1)
		begin
			flush_signal1=1;
			flush_signal2=0;
			branch_predict_miss=1;
			recover_pc=original_pc1+4;
			recover_en=1;
		end
		else
		begin
			flush_signal1=0;
			flush_signal2=0;
			branch_predict_miss=0;
			recover_pc='b0;
			recover_en=0;
		end
	end
	else if(((!is_jump1)&&(!is_branch1))&&(is_jump2))//7
	begin
		flush_signal1=0;
		flush_signal2=1;
		branch_predict_miss=0;
		recover_pc=target_pc2;
		recover_en=1;
	end
	else if(((!is_jump1)&&(!is_branch1))&&(is_branch2))//8
	begin
		if(taken2==1&&instr2_branch_predict_state==0)
		begin
			flush_signal1=0;
			flush_signal2=1;
			branch_predict_miss=1;
			recover_pc=target_pc2;
			recover_en=1;
		end
		else if(taken2==0&&instr2_branch_predict_state==1)
		begin
			flush_signal1=0;
			flush_signal2=1;
			branch_predict_miss=1;
			recover_pc=original_pc2+4;
			recover_en=1;
		end
		else
		begin
			flush_signal1=0;
			flush_signal2=0;
			branch_predict_miss=0;
			recover_pc='b0;
			recover_en=0;
		end
	end
	else //((!is_jump1)&&(!is_branch1))&&((!is_jump2)&&(!is_branch2)) //9
	begin
		flush_signal1=0;
		flush_signal2=0;
		branch_predict_miss=0;
		recover_pc='b0;
		recover_en=0;
	end
		*/
end

endmodule