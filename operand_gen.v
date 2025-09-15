module operand_gen(
    input [31:0] instr,
    input [31:0] read_data1,
    input [31:0] read_data2,
    input [31:0] pc,
    input [31:0] imm,

    output reg [31:0] operand1,
    output reg [31:0] operand2
);

reg [6:0] opcode;

always @(*)
begin
opcode= instr[6:0];
	case(opcode)
	7'b0110011:begin //R
                operand1=read_data1;
                operand2=read_data2;
		    end
	7'b0000011: begin
                operand1=read_data1;
                operand2=imm;
		   end	
	7'b0010011: begin  //I
                operand1=read_data1;
                operand2=imm;
		    end
	//7'b0001111:begin  end //fence_i
	7'b0100011: begin
                operand1=read_data1;
                operand2=imm;
		    end
	7'b1100011: begin  //B
                operand1=read_data1;
                operand2=read_data2;
		     end
	7'b0110111: begin 
                operand1=imm;
                operand2=32'b0;
            end//lui
	7'b0010111: begin 
                operand1=pc;
                operand2=imm;
                end//auipc
	7'b1101111: begin 
                operand1=pc;
                operand2=32'd4;
                 end//jal
	7'b1100111: begin 
                operand1=read_data1;
                operand2=imm;
                end//jalr
	default: begin 
                operand1=read_data1;
                operand2=read_data2;
                 end 
	endcase
end


endmodule