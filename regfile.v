module regfile (
    input  wire         clk,

    input  wire         instr1_WE,
    input  wire[5-1:0]  instr1_read_rs1_address,
    input  wire[5-1:0]  instr1_read_rs2_address,
    input  wire[5-1:0]  instr1_write_rd_address,
	input  wire[32-1:0] instr1_write_data,

	input  wire         instr2_WE,
	input  wire[5-1:0]  instr2_read_rs1_address,
    input  wire[5-1:0]  instr2_read_rs2_address,
    input  wire[5-1:0]  instr2_write_rd_address,
    input  wire[32-1:0] instr2_write_data,


    output wire[32-1:0] instr1_read_data1,
    output wire[32-1:0] instr1_read_data2,
	output wire[32-1:0] instr2_read_data1,
    output wire[32-1:0] instr2_read_data2
);
reg signed [31:0] rf [31:0];

//integer a;

/*initial 
begin
	rf[0]=32'b0;
end*/

reg [31:0] instr1_read_data1_reg;
reg [31:0] instr1_read_data2_reg;
reg [31:0] instr2_read_data1_reg;
reg [31:0] instr2_read_data2_reg;


always@(posedge clk)
begin
	begin//instr1 part-------------------------------------------------------------------------------------------------------------
	rf[0]=32'b0;
    if(instr1_WE==1&&instr1_write_rd_address!=5'b0)
    begin

		rf[instr1_write_rd_address]=instr1_write_data;
    end
	end

	begin//instr2 part-------------------------------------------------------------------------------------------------------------
    if(instr2_WE==1&&instr2_write_rd_address!=5'b0)
    begin

		rf[instr2_write_rd_address]=instr2_write_data;
    end
	end
end

always@(*)
begin
	begin//instr1 part-------------------------------------------------------------------------------------------------------------
	if(instr1_read_rs2_address==5'b0)
	begin
		instr1_read_data2_reg=32'b0;
	end
	else 
	begin
		instr1_read_data2_reg=rf[instr1_read_rs2_address];
	end
	if(instr1_read_rs1_address==5'b0)
	begin
		instr1_read_data1_reg=32'b0;
	end
	else 
	begin
		instr1_read_data1_reg=rf[instr1_read_rs1_address];
	end
	end

	begin//instr2 part-------------------------------------------------------------------------------------------------------------
	if(instr2_read_rs2_address==5'b0)
	begin
		instr2_read_data2_reg=32'b0;
	end
	else 
	begin
		instr2_read_data2_reg=rf[instr2_read_rs2_address];
	end
	if(instr2_read_rs1_address==5'b0)
	begin
		instr2_read_data1_reg=32'b0;
	end
	else 
	begin
		instr2_read_data1_reg=rf[instr2_read_rs1_address];
	end
	end
end





assign instr1_read_data1=instr1_read_data1_reg;
assign instr1_read_data2=instr1_read_data2_reg;
assign instr2_read_data1=instr2_read_data1_reg;
assign instr2_read_data2=instr2_read_data2_reg;

endmodule
