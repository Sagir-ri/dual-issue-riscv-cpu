module imm_gen(
    input [31:0] instr,
    output signed [31:0] imm
);

reg signed [31:0] reg_imm=32'sb0;


always @(*)
begin
	case(instr[6:0])
	7'b1101111: reg_imm={{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};//J
	7'b0010111: reg_imm={instr[31:12],12'b0};//auipc
	7'b0110111: reg_imm={instr[31:12],12'b0};//lui
	7'b0000011: reg_imm={{20{instr[31]}},instr[31:20]};
	7'b0010011: reg_imm={{20{instr[31]}},instr[31:20]};//I
	7'b1100111: reg_imm={{20{instr[31]}},instr[31:20]};
	7'b0100011: reg_imm={{20{instr[31]}},instr[31:25],instr[11:7]};//S
	7'b1100011:begin reg_imm={{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0}; end//B
	default: reg_imm=32'sb0;
	endcase

end

assign imm=reg_imm;

endmodule

