module alu_control(
       input[31:0] instr,
       output[4:0] aluctrl
);

reg [31:0] instr_reg;
reg [6:0] opcode;

reg [4:0] aluctrl_reg;


always @(*)
begin
opcode= instr[6:0];
instr_reg=instr;
	case(opcode)
	7'b0110011:begin //R
			case(instr_reg[14:12])
			3'b000:begin
					case(instr_reg[31:25])
					7'b0000000: begin aluctrl_reg=5'b00010; end//add
					7'b0100000: begin aluctrl_reg=5'b00110; end//sub
					7'b0000001: begin aluctrl_reg=5'b01111; end//mul
					default: begin aluctrl_reg=5'b00110; end
					endcase
				end
			3'b111: begin
					case(instr_reg[31:25]) 
					7'b0000000:begin aluctrl_reg=5'b00000; end//and
					7'b0000001:begin aluctrl_reg=5'b10100; end//remu
					default:begin aluctrl_reg=5'b00000; end
					endcase
					end
			3'b110: begin
					case(instr_reg[31:25]) 
					7'b0000000:begin aluctrl_reg=5'b00001; end//or
					7'b0000001:begin aluctrl_reg=5'b10011; end//rem
					default:begin aluctrl_reg=5'b00001; end
					endcase
					end
			3'b100: begin
					case(instr_reg[31:25]) 
					7'b0000000: begin aluctrl_reg=5'b00111; end//xor
					7'b0000001: begin aluctrl_reg=5'b01101; end//div
					default: begin aluctrl_reg=5'b00111; end
					endcase
				end
			3'b001: begin
					case(instr_reg[31:25])	
					7'b0000000: begin aluctrl_reg=5'b01000; end//sll
					7'b0000001:begin aluctrl_reg=5'b10000; end//mulh
					default: begin aluctrl_reg=5'b01000; end
					endcase
					end
			3'b101:begin
					case(instr_reg[31:25])
					7'b0000000: begin aluctrl_reg=5'b01001; end //srl
					7'b0100000: begin aluctrl_reg=5'b01010; end //sra
					7'b0000001: begin aluctrl_reg=5'b01110; end //divu
					default: begin aluctrl_reg=5'b01010; end 
					endcase
			       end
			3'b010: begin
					case(instr_reg[31:25])
					7'b0000001: begin aluctrl_reg=5'b10001; end //mulhsu
					7'b0000000: begin aluctrl_reg=5'b01100; end //slt
					default: begin aluctrl_reg=5'b01100; end
					endcase
					end
			3'b011: begin
					case(instr_reg[31:25])
					7'b0000000:begin aluctrl_reg=5'b01011; end //sltu
					7'b0000001:begin aluctrl_reg=5'b10010; end //mulhu
					default:begin aluctrl_reg=5'b01011; end 
					endcase
					end
			default: begin aluctrl_reg=5'b00001; end
			endcase
		   end
	7'b0000011: begin
			case(instr_reg[14:12])
			3'b010:begin aluctrl_reg=5'b00010; end//lw
			3'b000:begin aluctrl_reg=5'b00010; end//lb
			3'b100:begin aluctrl_reg=5'b00010; end//lbu
			3'b001:begin aluctrl_reg=5'b00010; end//lh
			3'b101:begin aluctrl_reg=5'b00010; end//lhu
			default:begin aluctrl_reg=5'b00010; end
			endcase
		   end	
	7'b0010011: begin  //I
			case(instr_reg[14:12])
			3'b000: begin aluctrl_reg=5'b00010; end//addi
			3'b111: begin aluctrl_reg=5'b00000; end//andi
			3'b110: begin aluctrl_reg=5'b00001; end//ori
			3'b100: begin aluctrl_reg=5'b00111; end//xori
			3'b001: begin aluctrl_reg=5'b01000; end//slli
			3'b101: begin
				case(instr_reg[31:25])
				7'b0000000: begin aluctrl_reg=5'b01001; end//srli
				7'b0100000: begin aluctrl_reg=5'b01010; end//srai
				default:begin aluctrl_reg=5'b00010; end
				endcase
			        end
			3'b010: begin aluctrl_reg=5'b01100; end //slti
			3'b011: begin aluctrl_reg=5'b01011; end //sltiu
			default: begin aluctrl_reg=5'b00111; end
			endcase
		    end
	7'b0001111:begin aluctrl_reg=5'b00000; end
	7'b0100011: begin
			case(instr_reg[14:12])
			3'b010:begin aluctrl_reg=5'b00010; end//sw
			3'b000:begin aluctrl_reg=5'b00010; end//sb
			3'b001:begin aluctrl_reg=5'b00010; end//sh
			default:begin aluctrl_reg=5'b00010; end
			endcase
		    end
	7'b1100011: begin  //B
			case(instr_reg[14:12])
			3'b000:begin aluctrl_reg=5'b00110; end//beq
			3'b001:begin aluctrl_reg=5'b00110; end//bne
			3'b100:begin aluctrl_reg=5'b01100; end//blt
			3'b110:begin aluctrl_reg=5'b01011; end//bltu
			3'b101:begin aluctrl_reg=5'b01100; end//bge
			3'b111:begin aluctrl_reg=5'b01011; end//bgeu
			default:begin aluctrl_reg=5'b00110; end
			endcase
		     end
	7'b0110111: begin aluctrl_reg=5'b00010; end//lui
	7'b0010111: begin aluctrl_reg=5'b00010; end//auipc
	7'b1101111: begin aluctrl_reg=5'b00010; end//jal
	7'b1100111: begin aluctrl_reg=5'b00010; end//jalr
	default: begin aluctrl_reg=5'b00010; end 
	endcase
end


assign aluctrl=aluctrl_reg;

endmodule

