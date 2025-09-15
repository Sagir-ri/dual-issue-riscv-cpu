module branch_judge(
    input [31:0] instr,
    input [31:0] alu_result,
    input [31:0] pc,
    input zero,
    input less_than,
    output reg is_jump, //J-type
    output reg is_branch, //show that if an instr is branch type, branch_predict needs this sig. B-type
    output reg taken,
    output reg [31:0] target_pc
);

reg signed [31:0] offset;

always @(*)
begin
    case(instr[6:0])
    7'b1101111: //jal
    begin
        //target_pc=instr_pc+{{19{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
		  offset={{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
        target_pc=pc+offset;
        taken=1;
        is_branch=0;
        is_jump=1;
    end
    7'b1100111: //jalr
    begin
        //target_pc=x[rs1]+sext(offset)
		  offset='b0;
        target_pc=alu_result;
        taken=1;
        is_branch=0;
        is_jump=1;
    end
    7'b1100011: //B
    begin
        case(instr[14:12])
        3'b000: //beq
        begin
            if(zero)
            begin
                offset={{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
                target_pc=pc+offset;
                taken=1;
                is_branch=1;
                is_jump=0;
            end
            else
            begin
					 offset='b0;
                target_pc='b0; 
                taken=0;
                is_branch=1;
                is_jump=0;
            end
        end
        3'b001: //bne
        begin
            if(!zero)
            begin
                offset={{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
                target_pc=pc+offset;
                taken=1;
                is_branch=1;
                is_jump=0;
            end
            else
            begin
					 offset='b0;
                target_pc='b0; 
                taken=0;
                is_branch=1;
                is_jump=0;
            end
        end
        3'b100: //blt
        begin
            if(less_than)
            begin
                offset={{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
                target_pc=pc+offset;
                taken=1;
                is_branch=1;
                is_jump=0;
            end
            else
            begin
					 offset='b0;
                target_pc='b0; 
                taken=0;
                is_branch=1;
                is_jump=0;
            end
        end
        3'b101: //bge
        begin
            if(!less_than)
            begin
                offset={{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
                target_pc=pc+offset;
                taken=1;
                is_branch=1;
                is_jump=0;
            end
            else
            begin
					 offset='b0;
                target_pc='b0;
                taken=0;
                is_branch=1;
                is_jump=0;
            end
        end
        3'b110: //bltu
        begin
            if(less_than)
            begin
                offset={{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
                target_pc=pc+offset;
                taken=1;
                is_branch=1;
                is_jump=0;
            end
            else
            begin
					 offset='b0;
                target_pc='b0;
                taken=0;
                is_branch=1;
                is_jump=0;
            end
        end
        3'b111: //bgeu
        begin
            if(!less_than)
            begin
                offset={{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
                target_pc=pc+offset;
                taken=1;
                is_branch=1;
                is_jump=0;
            end
            else
            begin
					 offset='b0;
                target_pc='b0;
                taken=0;
                is_branch=1;
                is_jump=0;
            end
        end
        default:
        begin
			   offset='b0;
            target_pc=32'b0;
            taken=0;
            is_branch=0;
            is_jump=0;
        end
        endcase
    end
    default:
    begin
			offset='b0;
        target_pc=32'b0;
        taken=0;
        is_branch=0;
        is_jump=0;
    end
    endcase
end

endmodule