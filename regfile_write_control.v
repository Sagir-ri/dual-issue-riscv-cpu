module regfile_write_control(
    input [31:0] instr,
    input [31:0] alu_result,
    input [31:0] data_read_from_dram,
    input [31:0] pc,
    output regwrite,
    output reg [31:0] write_data
);

reg [31:0] instr_reg;
reg [6:0] opcode;
reg regwrite_reg;

always @(*)
begin
opcode= instr[6:0];
instr_reg=instr;
	case(opcode)
	7'b0110011:begin //R
			case(instr_reg[14:12])
			3'b000:begin
					case(instr_reg[31:25])
					7'b0000000: begin regwrite_reg=1;write_data=alu_result; end//add
					7'b0100000: begin regwrite_reg=1;write_data=alu_result; end//sub
					7'b0000001: begin regwrite_reg=1;write_data=alu_result; end//mul
					default: begin regwrite_reg=1;write_data=alu_result; end
					endcase
				end
			3'b111: begin
					case(instr_reg[31:25]) 
					7'b0000000:begin regwrite_reg=1;write_data=alu_result; end//and
					7'b0000001:begin regwrite_reg=1;write_data=alu_result; end//remu
					default:begin regwrite_reg=1;write_data=alu_result; end
					endcase
					end
			3'b110: begin
					case(instr_reg[31:25]) 
					7'b0000000:begin regwrite_reg=1;write_data=alu_result; end//or
					7'b0000001:begin regwrite_reg=1;write_data=alu_result; end//rem
					default:begin regwrite_reg=1;write_data=alu_result; end
					endcase
					end
			3'b100: begin
					case(instr_reg[31:25]) 
					7'b0000000: begin regwrite_reg=1;write_data=alu_result; end//xor
					7'b0000001: begin regwrite_reg=1;write_data=alu_result; end//div
					default: begin regwrite_reg=1;write_data=alu_result; end
					endcase
				end
			3'b001: begin
					case(instr_reg[31:25])	
					7'b0000000: begin regwrite_reg=1;write_data=alu_result; end//sll
					7'b0000001:begin regwrite_reg=1;write_data=alu_result; end//mulh
					default: begin regwrite_reg=1;write_data=alu_result; end
					endcase
					end
			3'b101:begin
					case(instr_reg[31:25])
					7'b0000000: begin regwrite_reg=1;write_data=alu_result; end //srl
					7'b0100000: begin regwrite_reg=1;write_data=alu_result; end //sra
					7'b0000001: begin regwrite_reg=1;write_data=alu_result; end //divu
					default: begin regwrite_reg=1;write_data=alu_result; end 
					endcase
			       end
			3'b010: begin
					case(instr_reg[31:25])
					7'b0000001: begin regwrite_reg=1;write_data=alu_result; end //mulhsu
					7'b0000000: begin regwrite_reg=1;write_data=alu_result; end //slt
					default: begin regwrite_reg=1;write_data=alu_result; end
					endcase
					end
			3'b011: begin
					case(instr_reg[31:25])
					7'b0000000:begin regwrite_reg=1;write_data=alu_result; end //sltu
					7'b0000001:begin regwrite_reg=1;write_data=alu_result; end //mulhu
					default:begin regwrite_reg=1;write_data=alu_result; end 
					endcase
					end
			default: begin regwrite_reg=1;write_data=alu_result; end
			endcase
		   end
	7'b0000011: begin
			case(instr_reg[14:12])
			3'b010:begin regwrite_reg=1;write_data=data_read_from_dram; end//lw
			3'b000:begin regwrite_reg=1;write_data=data_read_from_dram;  end//lb
			3'b100:begin regwrite_reg=1;write_data=data_read_from_dram;  end//lbu
			3'b001:begin regwrite_reg=1;write_data=data_read_from_dram;  end//lh
			3'b101:begin regwrite_reg=1;write_data=data_read_from_dram;  end//lhu
			default:begin regwrite_reg=1;write_data=data_read_from_dram;  end
			endcase
		   end	
	7'b0010011: begin  //I
			case(instr_reg[14:12])
			3'b000: begin regwrite_reg=1;write_data=alu_result;  end//addi
			3'b111: begin regwrite_reg=1;write_data=alu_result;  end//andi
			3'b110: begin regwrite_reg=1;write_data=alu_result;  end//ori
			3'b100: begin regwrite_reg=1;write_data=alu_result;  end//xori
			3'b001: begin regwrite_reg=1;write_data=alu_result;  end//slli
			3'b101: begin
				case(instr_reg[31:25])
				7'b0000000: begin regwrite_reg=1;write_data=alu_result;  end//srli
				7'b0100000: begin regwrite_reg=1;write_data=alu_result;  end//srai
				default:begin regwrite_reg=1;write_data=alu_result;  end
				endcase
			        end
			3'b010: begin regwrite_reg=1;write_data=alu_result;  end //slti
			3'b011: begin regwrite_reg=1;write_data=alu_result;  end //sltiu
			default: begin regwrite_reg=1;write_data=alu_result;  end
			endcase
		    end
	//7'b0001111:begin regwrite_reg=1; end //fence_i
	7'b0100011: begin
			case(instr_reg[14:12])
			3'b010:begin regwrite_reg=0;write_data=32'b0; end//sw
			3'b000:begin regwrite_reg=0;write_data=32'b0; end//sb
			3'b001:begin regwrite_reg=0;write_data=32'b0; end//sh
			default:begin regwrite_reg=0;write_data=32'b0; end
			endcase
		    end
	7'b1100011: begin  //B
			case(instr_reg[14:12])
			3'b000:begin regwrite_reg=0;write_data=32'b0; end//beq
			3'b001:begin regwrite_reg=0;write_data=32'b0; end//bne
			3'b100:begin regwrite_reg=0;write_data=32'b0; end//blt
			3'b110:begin regwrite_reg=0;write_data=32'b0; end//bltu
			3'b101:begin regwrite_reg=0;write_data=32'b0; end//bge
			3'b111:begin regwrite_reg=0;write_data=32'b0; end//bgeu
			default:begin regwrite_reg=0;write_data=32'b0; end
			endcase
		     end
	7'b0110111: begin regwrite_reg=1;write_data=alu_result; end//lui //found out that 12bits-shift and sign-extension all done before
	7'b0010111: begin regwrite_reg=1;write_data=alu_result; end//auipc
	7'b1101111: begin regwrite_reg=1;write_data=alu_result; end//jal
	7'b1100111: begin regwrite_reg=1;write_data=pc+32'd4; end//jalr
	default: begin regwrite_reg=0;write_data=32'b0; end 
	endcase
end

assign regwrite=regwrite_reg;


endmodule