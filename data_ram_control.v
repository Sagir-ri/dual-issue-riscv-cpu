module data_ram_control(
       input[31:0] instr,
       
       output      memread,
       output      memwrite,
	   output [2:0] mask,
	   output is_ls //judge if an instr is l or s type
);

reg [31:0] instr_reg;
reg [6:0] opcode;

reg memread_reg;
reg memwrite_reg;
reg [2:0] mask_reg;
reg is_ls_reg;

always @(*)
begin
opcode= instr[6:0];
instr_reg=instr;
	case(opcode)
	7'b0110011:begin //R
			case(instr_reg[14:12])
			3'b000:begin
					case(instr_reg[31:25])
					7'b0000000: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//add
					7'b0100000: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//sub
					7'b0000001: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//mul
					default: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
					endcase
				end
			3'b111: begin
					case(instr_reg[31:25]) 
					7'b0000000:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//and
					7'b0000001:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//remu
					default:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
					endcase
					end
			3'b110: begin
					case(instr_reg[31:25]) 
					7'b0000000:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//or
					7'b0000001:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//rem
					default:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
					endcase
					end
			3'b100: begin
					case(instr_reg[31:25]) 
					7'b0000000: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//xor
					7'b0000001: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//div
					default: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
					endcase
				end
			3'b001: begin
					case(instr_reg[31:25])	
					7'b0000000: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//sll
					7'b0000001:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//mulh
					default: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
					endcase
					end
			3'b101:begin
					case(instr_reg[31:25])
					7'b0000000: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end //srl
					7'b0100000: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end //sra
					7'b0000001: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end //divu
					default: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end 
					endcase
			       end
			3'b010: begin
					case(instr_reg[31:25])
					7'b0000001: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end //mulhsu
					7'b0000000: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end //slt
					default: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
					endcase
					end
			3'b011: begin
					case(instr_reg[31:25])
					7'b0000000:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end //sltu
					7'b0000001:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end //mulhu
					default:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end 
					endcase
					end
			default: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
			endcase
		   end
	7'b0000011: begin
			case(instr_reg[14:12])
			3'b010:begin memread_reg=1;memwrite_reg=0;mask_reg=3'b110;is_ls_reg=1; end//lw
			3'b000:begin memread_reg=1;memwrite_reg=0;mask_reg=3'b100;is_ls_reg=1; end//lb //maybe need to change later as the official dram driver sv is full of mistakes
			3'b100:begin memread_reg=1;memwrite_reg=0;mask_reg=3'b000;is_ls_reg=1; end//lbu
			3'b001:begin memread_reg=1;memwrite_reg=0;mask_reg=3'b101;is_ls_reg=1; end//lh
			3'b101:begin memread_reg=1;memwrite_reg=0;mask_reg=3'b001;is_ls_reg=1; end//lhu
			default:begin memread_reg=1;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
			endcase
		   end	
	7'b0010011: begin  //I
			case(instr_reg[14:12])
			3'b000: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//addi
			3'b111: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//andi
			3'b110: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//ori
			3'b100: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//xori
			3'b001: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//slli
			3'b101: begin
				case(instr_reg[31:25])
				7'b0000000: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//srli
				7'b0100000: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end//srai
				default:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
				endcase
			        end
			3'b010: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end //slti
			3'b011: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end //sltiu
			default: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
			endcase
		    end
	7'b0001111:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0; end
	7'b0100011: begin
			case(instr_reg[14:12])
			3'b010:begin memread_reg=0;memwrite_reg=1;mask_reg=3'b110;is_ls_reg=1; end//sw
			3'b000:begin memread_reg=0;memwrite_reg=1;mask_reg=3'b100;is_ls_reg=1; end//sb
			3'b001:begin memread_reg=0;memwrite_reg=1;mask_reg=3'b101;is_ls_reg=1; end//sh
			default:begin memread_reg=0;memwrite_reg=1;mask_reg=3'b111;is_ls_reg=0; end
			endcase
		    end
	7'b1100011: begin  //B
			case(instr_reg[14:12])
			3'b000:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end//beq
			3'b001:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end//bne
			3'b100:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end//blt
			3'b110:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end//bltu
			3'b101:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end//bge
			3'b111:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end//bgeu
			default:begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end
			endcase
		     end
	7'b0110111: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end//lui
	7'b0010111: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end//auipc
	7'b1101111: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end//jal
	7'b1100111: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end//jalr
	default: begin memread_reg=0;memwrite_reg=0;mask_reg=3'b111;is_ls_reg=0;  end 
	endcase
end


assign memread=memread_reg;
assign memwrite=memwrite_reg;
assign mask=mask_reg;
assign is_ls=is_ls_reg;

endmodule

