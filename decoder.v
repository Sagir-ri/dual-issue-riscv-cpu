module decoder(
    input [31:0] instr,
	output reg [4:0] rs1_address,
	output reg [4:0] rs2_address,
	output reg [4:0] rd_address
);
//------------reg_address_gen part----------------------------------------------------------------------------------------

//zero reg cant be modified, thus use the address of zero reg as null

always @(*)
begin
	case(instr[6:0])
	7'b0110111: begin rs1_address=5'b0; rs2_address=5'b0; rd_address=instr[11:7]; end//lui
	7'b0010111: begin rs1_address=5'b0; rs2_address=5'b0; rd_address=instr[11:7]; end//auipc
	7'b1101111: begin rs1_address=5'b0; rs2_address=5'b0; rd_address=instr[11:7]; end//jal
	7'b1100111: begin rs1_address=instr[19:15]; rs2_address=5'b0; rd_address=instr[11:7]; end//jalr
	7'b1100011: begin rs1_address=instr[19:15]; rs2_address=instr[24:20]; rd_address=5'b0; end//B
	7'b0000011: begin rs1_address=instr[19:15]; rs2_address=5'b0; rd_address=instr[11:7]; end//I load
	7'b0100011: begin rs1_address=instr[19:15]; rs2_address=instr[24:20]; rd_address=5'b0; end//S
	7'b0010011: begin rs1_address=instr[19:15]; rs2_address=5'b0; rd_address=instr[11:7]; end//I imm
	7'b0110011: begin rs1_address=instr[19:15]; rs2_address=instr[24:20]; rd_address=instr[11:7]; end//R
	default: begin rs1_address=5'b0; rs2_address=5'b0; rd_address=5'b0; end
	endcase
end

endmodule