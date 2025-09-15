module data_path (
	input rst_n,
	input clk,

	//IROM
	input [31:0] instr1,
	input [31:0] instr2,
	output [31:0] instr1_pc,
	output [31:0] instr2_pc,

	//DRAM
	output [31:0] DRAM_addr,
	output [31:0] DRAM_wdata,
	output [2:0] DRAM_mask,
	output DRAM_wen,
	input [31:0] DRAM_rdata
);
//fetch------------------------------------------------------------------------------------------------------------------

//wire [31:0] instr1,instr2;
//wire [31:0] instr1_pc ,instr2_pc;

wire [31:0] pc;
assign instr1_pc=pc;
assign instr2_pc=pc+4;

/*
instr_rom u_instr_rom( //read instrs from rom
	.A1(instr1_pc),
	.A2(instr2_pc),
	.RD1(instr1),
	.RD2(instr2)
);
*/


wire instr1_taken ,instr2_taken;
wire [31:0] instr1_target_pc ,instr2_target_pc;
wire nop1 ,nop2;

wire branch_predict_result;
wire is_jump1 ,is_jump2;
wire [31:0] recover_pc;
wire branch_predict_miss;
wire recover_en;
wire EX1_EX2_out_recover_en ,EX1_EX2_out_flush_signal1 ,EX1_EX2_out_flush_signal2;
wire [31:0] EX1_EX2_out_recover_pc;

wire is_branch1_fetch, is_branch2_fetch;

wire stall;

pc_control_unit u_pc_control_unit( //control pc
	.clk(clk),
	.rst_n(rst_n),
	.nop1(nop1),
	.nop2(nop2),
	.PC_hold(1'b0),

	.instr1(instr1),
	.instr2(instr2),
	.branch_predict_result(branch_predict_result),

	.pc(pc),

	.recover_en(EX1_EX2_out_recover_en),
	.recover_pc(EX1_EX2_out_recover_pc),

	.is_branch1(is_branch1_fetch),
	.is_branch2(is_branch2_fetch),

	.stall(stall)
);


wire is_branch1 ,is_branch2;

branch_predict_2_bit u_branch_predict_2_bit(
//interact with pc_control_unit
	.clk(clk),
	.rstn(rst_n),
	.T(instr1_taken||instr2_taken),
	.update(is_branch1||is_branch2),
	.branch_en(branch_predict_result)
);

wire flush_signal1 ,flush_signal2;



wire [31:0] fetch_decode_out_instr1, fetch_decode_out_instr2; //pass on the instr
wire [31:0] fetch_decode_out_instr1_pc ,fetch_decode_out_instr2_pc; //pass on pc for branch_type instr to use later in the pipeline
wire fetch_decode_out_instr1_branch_predict_state ,fetch_decode_out_instr2_branch_predict_state;

fetch_decode u_fetch_decode(  //pipeline delay
	.clk(clk),
    .rstn(rst_n),
	.nop(nop2),
	.flush_signal1(flush_signal1||EX1_EX2_out_flush_signal1),
	.flush_signal2(flush_signal2||EX1_EX2_out_flush_signal2),
    .fetch_decode_in_instr1(instr1),
	.fetch_decode_in_instr2(instr2),
	.fetch_decode_in_instr1_pc(instr1_pc),
	.fetch_decode_in_instr2_pc(instr2_pc),
	.fetch_decode_in_instr1_branch_predict_state(branch_predict_result),
	.fetch_decode_in_instr2_branch_predict_state(branch_predict_result),
	.fetch_decode_in_is_branch1_fetch(is_branch1_fetch),
	.fetch_decode_in_is_branch2_fetch(is_branch2_fetch),

    .fetch_decode_out_instr1(fetch_decode_out_instr1),
	.fetch_decode_out_instr2(fetch_decode_out_instr2),
	.fetch_decode_out_instr1_pc(fetch_decode_out_instr1_pc),
	.fetch_decode_out_instr2_pc(fetch_decode_out_instr2_pc),
	.fetch_decode_out_instr1_branch_predict_state(fetch_decode_out_instr1_branch_predict_state),
	.fetch_decode_out_instr2_branch_predict_state(fetch_decode_out_instr2_branch_predict_state),

	.stall(stall)
);
//decode------------------------------------------------------------------------------------------------------------------


//avoid RAW in NN instr----------------------------


NN_instr_block_unit u_NN_instr_block_unit( //as the NN instrs are in the same stage , so unable to use the forward strategy
	.clk(clk),
    .rstn(rst_n),

	.instr1_in(instr1),
	.instr2_in(instr2),


    .nop1(nop1),
    .nop2(nop2)
);




wire [31:0] decode_issue_out_instr1 ,decode_issue_out_instr2;
wire [31:0] decode_issue_out_instr1_pc ,decode_issue_out_instr2_pc;
wire decode_issue_out_instr1_branch_predict_state ,decode_issue_out_instr2_branch_predict_state;

decode_issue u_decode_issue( //pipeline_delay
	.clk(clk),
	.rstn(rst_n),
	.nop1(nop1),
	.nop2(nop2),
	.flush_signal1(flush_signal1),
	.flush_signal2(flush_signal2),
	.decode_issue_in_instr1(fetch_decode_out_instr1),
	.decode_issue_in_instr2(fetch_decode_out_instr2),
	.decode_issue_in_instr1_pc(fetch_decode_out_instr1_pc),
	.decode_issue_in_instr2_pc(fetch_decode_out_instr2_pc),
	.decode_issue_in_instr1_branch_predict_state(fetch_decode_out_instr1_branch_predict_state),
	.decode_issue_in_instr2_branch_predict_state(fetch_decode_out_instr2_branch_predict_state),

	.decode_issue_out_instr1(decode_issue_out_instr1),
	.decode_issue_out_instr2(decode_issue_out_instr2),
	.decode_issue_out_instr1_pc(decode_issue_out_instr1_pc),
	.decode_issue_out_instr2_pc(decode_issue_out_instr2_pc),
	.decode_issue_out_instr1_branch_predict_state(decode_issue_out_instr1_branch_predict_state),
	.decode_issue_out_instr2_branch_predict_state(decode_issue_out_instr2_branch_predict_state),

	.stall(stall)
);
//issue------------------------------------------------------------------------------------------------------------------


wire [4:0] issue_instr1_rs1_address ,issue_instr1_rs2_address ,issue_instr1_rd_address;
wire [4:0] issue_instr2_rs1_address ,issue_instr2_rs2_address ,issue_instr2_rd_address;
/*
issue_queue u_issue_queue1( 
	.clk(clk),
    .rstn(rst_n),
    .issue_instr_in(decode_issue_out_instr1),//指令输入
    .issue_instr_pc_in(decode_issue_out_instr1_pc),//pc输入
    .stop(1'b0),//暂停信号
	.nop(1'b0),
    .clear(flush_signal1||flush_signal2),//清空信号


	.issue_instr(issue_instr1), //output ports here and below
	.issue_instr_rs1_address(issue_instr1_rs1_address),
	.issue_instr_rs2_address(issue_instr1_rs2_address),
	.issue_instr_rd_address(issue_instr1_rd_address),
	.issue_instr_pc(issue_instr1_pc),



	.branch_predict_state_in(decode_issue_out_instr1_branch_predict_state),
	.branch_predict_state_issue(instr1_branch_predict_state_issue)
);

issue_queue u_issue_queue2( 
	.clk(clk),
	.rstn(rst_n),
	.issue_instr_in(decode_issue_out_instr2),//指令输入
	.issue_instr_pc_in(decode_issue_out_instr2_pc),//pc输入
	.stop(1'b0),//暂停信号
	.nop(1'b0),
	.clear(flush_signal1||flush_signal2),//清空信号


	.issue_instr(issue_instr2), //output ports here and below
	.issue_instr_rs1_address(issue_instr2_rs1_address),
	.issue_instr_rs2_address(issue_instr2_rs2_address),
	.issue_instr_rd_address(issue_instr2_rd_address),
	.issue_instr_pc(issue_instr2_pc),



	.branch_predict_state_in(decode_issue_out_instr2_branch_predict_state),
	.branch_predict_state_issue(instr2_branch_predict_state_issue)
);
*/

decoder u_decoder_issue_queue_1( 
	.instr(decode_issue_out_instr1),
	.rs1_address(issue_instr1_rs1_address),
	.rs2_address(issue_instr1_rs2_address),
	.rd_address(issue_instr1_rd_address)
);

decoder u_decoder_issue_queue_2( 
	.instr(decode_issue_out_instr2),
	.rs1_address(issue_instr2_rs1_address),
	.rs2_address(issue_instr2_rs2_address),
	.rd_address(issue_instr2_rd_address)
);



wire [31:0] issue_instr1_imm ,issue_instr2_imm;

imm_gen u_imm_gen1(
	.instr(decode_issue_out_instr1),
	.imm(issue_instr1_imm)
);

imm_gen u_imm_gen2(
	.instr(decode_issue_out_instr2),
	.imm(issue_instr2_imm)
);




//-------------------------------------------

wire [31:0] issue_EX1_out_instr1 ,issue_EX1_out_instr2;
wire [31:0] issue_EX1_out_instr1_imm ,issue_EX1_out_instr2_imm;
wire [4:0] issue_EX1_out_instr1_rs1_address ,issue_EX1_out_instr2_rs1_address;
wire [4:0] issue_EX1_out_instr1_rs2_address ,issue_EX1_out_instr2_rs2_address;
wire [4:0] issue_EX1_out_instr1_rd_address ,issue_EX1_out_instr2_rd_address;
wire [31:0] issue_EX1_out_instr1_pc ,issue_EX1_out_instr2_pc;
wire [31:0] issue_EX1_out_instr1_read_data1 ,issue_EX1_out_instr1_read_data2;
wire [31:0] issue_EX1_out_instr2_read_data1 ,issue_EX1_out_instr2_read_data2;
wire issue_EX1_out_instr1_branch_predict_state ,issue_EX1_out_instr2_branch_predict_state;


issue_EX1 u_issue_EX1( //pipeline delay
	.clk(clk),
	.rstn(rst_n),
	.flush_signal1(flush_signal1),
	.flush_signal2(flush_signal2),
	.nop1(1'b0),
	.nop2(1'b0),
	.issue_EX1_in_instr1(decode_issue_out_instr1),
	.issue_EX1_in_instr2(decode_issue_out_instr2),
	.issue_EX1_in_instr1_imm(issue_instr1_imm),
	.issue_EX1_in_instr2_imm(issue_instr2_imm),
	.issue_EX1_in_instr1_rs1_address(issue_instr1_rs1_address),
	.issue_EX1_in_instr2_rs1_address(issue_instr2_rs1_address),
	.issue_EX1_in_instr1_rs2_address(issue_instr1_rs2_address),
	.issue_EX1_in_instr2_rs2_address(issue_instr2_rs2_address),
	.issue_EX1_in_instr1_rd_address(issue_instr1_rd_address),
	.issue_EX1_in_instr2_rd_address(issue_instr2_rd_address),
	.issue_EX1_in_instr1_pc(decode_issue_out_instr1_pc),
	.issue_EX1_in_instr2_pc(decode_issue_out_instr2_pc),
	.issue_EX1_in_instr1_branch_predict_state(decode_issue_out_instr1_branch_predict_state),
	.issue_EX1_in_instr2_branch_predict_state(decode_issue_out_instr2_branch_predict_state),


	.issue_EX1_out_instr1(issue_EX1_out_instr1),
	.issue_EX1_out_instr2(issue_EX1_out_instr2),
	.issue_EX1_out_instr1_imm(issue_EX1_out_instr1_imm),
	.issue_EX1_out_instr2_imm(issue_EX1_out_instr2_imm),
	.issue_EX1_out_instr1_rs1_address(issue_EX1_out_instr1_rs1_address),
	.issue_EX1_out_instr2_rs1_address(issue_EX1_out_instr2_rs1_address),
	.issue_EX1_out_instr1_rs2_address(issue_EX1_out_instr1_rs2_address),
	.issue_EX1_out_instr2_rs2_address(issue_EX1_out_instr2_rs2_address),
	.issue_EX1_out_instr1_rd_address(issue_EX1_out_instr1_rd_address),
	.issue_EX1_out_instr2_rd_address(issue_EX1_out_instr2_rd_address),
	.issue_EX1_out_instr1_pc(issue_EX1_out_instr1_pc),
	.issue_EX1_out_instr2_pc(issue_EX1_out_instr2_pc),
	.issue_EX1_out_instr1_branch_predict_state(issue_EX1_out_instr1_branch_predict_state),
	.issue_EX1_out_instr2_branch_predict_state(issue_EX1_out_instr2_branch_predict_state),

	.stall(stall)
);

//EX1------------------------------------------------------------------------------------------------------------------

//-------------------------------------------
wire [31:0] EX1_instr1_read_data1_from_regfile ,EX1_instr1_read_data2_from_regfile; //get from regfile
wire [31:0] EX1_instr2_read_data1_from_regfile ,EX1_instr2_read_data2_from_regfile;

//read data from regfile here!!!

//-------------------------------------------

wire [31:0] EX1_instr1_read_data1_valid ,EX1_instr1_read_data2_valid; //real valid data
wire [31:0] EX1_instr2_read_data1_valid ,EX1_instr2_read_data2_valid;

wire [4:0] EX1_EX2_out_instr1_rd_address ,EX1_EX2_out_instr2_rd_address;
wire [4:0] EX2_commit_out_instr1_rd_address ,EX2_commit_out_instr2_rd_address;
wire [31:0] instr1_write_data ,instr2_write_data;
wire [31:0] EX2_commit_out_instr1_write_data ,EX2_commit_out_instr2_write_data;



bypass u_bypass(
	.EX1_stage_instr1_rs1_address(issue_EX1_out_instr1_rs1_address),
    .EX1_stage_instr1_rs2_address(issue_EX1_out_instr1_rs2_address),
    .EX1_stage_instr2_rs1_address(issue_EX1_out_instr2_rs1_address),
    .EX1_stage_instr2_rs2_address(issue_EX1_out_instr2_rs2_address),

    .EX2_stage_instr1_rd_address(EX1_EX2_out_instr1_rd_address),
    .EX2_stage_instr2_rd_address(EX1_EX2_out_instr2_rd_address),

    .commit_stage_instr1_rd_address(EX2_commit_out_instr1_rd_address),
    .commit_stage_instr2_rd_address(EX2_commit_out_instr2_rd_address),

	/*
    .EX1_stage_instr1_read_data1_from_regfile(EX1_instr1_read_data1_from_regfile),
    .EX1_stage_instr1_read_data2_from_regfile(EX1_instr1_read_data2_from_regfile),
    .EX1_stage_instr2_read_data1_from_regfile(EX1_instr2_read_data1_from_regfile),
    .EX1_stage_instr2_read_data2_from_regfile(EX1_instr2_read_data2_from_regfile),

    .commit_stage_instr1_write_data(EX2_commit_out_instr1_write_data),
    .commit_stage_instr2_write_data(EX2_commit_out_instr2_write_data),

    .EX2_stage_instr1_write_data(instr1_write_data),
    .EX2_stage_instr2_write_data(instr2_write_data),

    .EX1_instr1_read_data1_valid(EX1_instr1_read_data1_valid),
    .EX1_instr1_read_data2_valid(EX1_instr1_read_data2_valid),                                                                                                                         
    .EX1_instr2_read_data1_valid(EX1_instr2_read_data1_valid),
    .EX1_instr2_read_data2_valid(EX1_instr2_read_data2_valid)
	*/

	.stall(stall),

	.clk(clk),
	.rstn(rst_n)
);


wire [4:0] instr1_aluctrl ,instr2_aluctrl; 
wire instr1_ZERO ,instr1_less_than;
wire instr2_ZERO ,instr2_less_than;
wire [31:0] instr1_alu_result ,instr2_alu_result;

wire [31:0] instr1_operand1 ,instr1_operand2;
wire [31:0] instr2_operand1 ,instr2_operand2;


operand_gen u_operand_gen1( //perform the duty of original muxes before alus
//select between rs1_data, rs2_data ,imm ,pc etc.
	.instr(issue_EX1_out_instr1),
	.read_data1(EX1_instr1_read_data1_from_regfile),
	.read_data2(EX1_instr1_read_data2_from_regfile),
	.pc(issue_EX1_out_instr1_pc),
	.imm(issue_EX1_out_instr1_imm),

	.operand1(instr1_operand1),
	.operand2(instr1_operand2)
);

operand_gen u_operand_gen2( //perform the duty of original muxes before alus
//select between rs1_data, rs2_data ,imm ,pc etc.
	.instr(issue_EX1_out_instr2),
	.read_data1(EX1_instr2_read_data1_from_regfile),
	.read_data2(EX1_instr2_read_data2_from_regfile),
	.pc(issue_EX1_out_instr2_pc),
	.imm(issue_EX1_out_instr2_imm),

	.operand1(instr2_operand1),
	.operand2(instr2_operand2)
);

alu_control u_alu_control1( //I partioned the control module so that the structure is quite more clear and signals we need to pass on between stages even lessen
	.instr(issue_EX1_out_instr1),
	.aluctrl(instr1_aluctrl)
);

alu_control u_alu_control2(
	.instr(issue_EX1_out_instr2),
	.aluctrl(instr2_aluctrl)
);


alu u_alu1( //alu for instr1
	.A(instr1_operand1),
    .B(instr1_operand2),
    .ALUCtrl(instr1_aluctrl),
    .ZERO(instr1_ZERO),
    .Y(instr1_alu_result),
    .less_than(instr1_less_than)
);

alu u_alu2( //alu for instr2
	.A(instr2_operand1),
    .B(instr2_operand2),
    .ALUCtrl(instr2_aluctrl),
    .ZERO(instr2_ZERO),
    .Y(instr2_alu_result),
    .less_than(instr2_less_than)
);


branch_judge u_branch_judge1( //we could use the zero/less_than sig here so that there'll be no need to pass them on
// and we'll pass output sigs here to pc_control_unit(modified v1.2)
	.instr(issue_EX1_out_instr1),
	.alu_result(instr1_alu_result),
	.pc(issue_EX1_out_instr1_pc),
	.zero(instr1_ZERO),
	.less_than(instr1_less_than),
	.taken(instr1_taken),
	.target_pc(instr1_target_pc),
	.is_branch(is_branch1),
	.is_jump(is_jump1)
);

branch_judge u_branch_judge2( 
	.instr(issue_EX1_out_instr2),
	.alu_result(instr2_alu_result),
	.pc(issue_EX1_out_instr2_pc),
	.zero(instr2_ZERO),
	.less_than(instr2_less_than),
	.taken(instr2_taken),
	.target_pc(instr2_target_pc),
	.is_branch(is_branch2),
	.is_jump(is_jump2)
);

recover_unit u_recover_unit(//handle branch_predict_miss and J-type instr(flush the pipeline and recover the pc)
	.taken1(instr1_taken),
	.taken2(instr2_taken),

	.instr1_branch_predict_state(issue_EX1_out_instr1_branch_predict_state),
	.instr2_branch_predict_state(issue_EX1_out_instr2_branch_predict_state),
	.is_branch1(is_branch1),
	.is_branch2(is_branch2),
	.is_jump1(is_jump1),
	.is_jump2(is_jump2),

	.target_pc1(instr1_target_pc),
	.target_pc2(instr2_target_pc),
	.original_pc1(issue_EX1_out_instr1_pc),
	.original_pc2(issue_EX1_out_instr2_pc),

	.recover_en(recover_en),
	.recover_pc(recover_pc),
	.branch_predict_miss(branch_predict_miss),

	.flush_signal1(flush_signal1),
	.flush_signal2(flush_signal2)
);

wire [31:0] EX1_EX2_out_instr1 ,EX1_EX2_out_instr2;
wire [31:0] EX1_EX2_out_instr1_pc ,EX1_EX2_out_instr2_pc;
wire [31:0] EX1_EX2_out_instr1_alu_result ,EX1_EX2_out_instr2_alu_result;
wire [31:0] EX1_EX2_out_instr1_read_data2 ,EX1_EX2_out_instr2_read_data2;

//still need to pass rs2_data on here
EX1_EX2 u_EX1_EX2(	
	.clk(clk),
	.rstn(rst_n),
	.flush_signal1(flush_signal1),
	.flush_signal2(flush_signal2),
	.EX1_EX2_in_instr1(issue_EX1_out_instr1),
	.EX1_EX2_in_instr2(issue_EX1_out_instr2),
	.EX1_EX2_in_instr1_rd_address(issue_EX1_out_instr1_rd_address),
	.EX1_EX2_in_instr2_rd_address(issue_EX1_out_instr2_rd_address),
	.EX1_EX2_in_instr1_pc(issue_EX1_out_instr1_pc),
	.EX1_EX2_in_instr2_pc(issue_EX1_out_instr2_pc),
	.EX1_EX2_in_instr1_alu_result(instr1_alu_result),
	.EX1_EX2_in_instr2_alu_result(instr2_alu_result),
	.EX1_EX2_in_instr1_read_data2(EX1_instr1_read_data2_from_regfile),
	.EX1_EX2_in_instr2_read_data2(EX1_instr2_read_data2_from_regfile),

	.EX1_EX2_out_instr1(EX1_EX2_out_instr1),
	.EX1_EX2_out_instr2(EX1_EX2_out_instr2),
	.EX1_EX2_out_instr1_rd_address(EX1_EX2_out_instr1_rd_address),
	.EX1_EX2_out_instr2_rd_address(EX1_EX2_out_instr2_rd_address),
	.EX1_EX2_out_instr1_pc(EX1_EX2_out_instr1_pc),
	.EX1_EX2_out_instr2_pc(EX1_EX2_out_instr2_pc),
	.EX1_EX2_out_instr1_alu_result(EX1_EX2_out_instr1_alu_result),
	.EX1_EX2_out_instr2_alu_result(EX1_EX2_out_instr2_alu_result),
	.EX1_EX2_out_instr1_read_data2(EX1_EX2_out_instr1_read_data2),
	.EX1_EX2_out_instr2_read_data2(EX1_EX2_out_instr2_read_data2),

	.EX1_EX2_in_recover_en(recover_en),
	.EX1_EX2_in_recover_pc(recover_pc),
	.EX1_EX2_in_flush_signal1(flush_signal1),
	.EX1_EX2_in_flush_signal2(flush_signal2),

	.EX1_EX2_out_recover_en(EX1_EX2_out_recover_en),
	.EX1_EX2_out_recover_pc(EX1_EX2_out_recover_pc),
	.EX1_EX2_out_flush_signal1(EX1_EX2_out_flush_signal1),
	.EX1_EX2_out_flush_signal2(EX1_EX2_out_flush_signal2),

	.stall(stall)
);

//EX2------------------------------------------------------------------------------------------------------------------
wire instr1_memread ,instr2_memread;
wire instr1_memwrite ,instr2_memwrite;
wire instr1_lb ,instr2_lb;
wire instr1_lbu ,instr2_lbu;
wire instr1_lh ,instr2_lh;
wire instr1_lhu ,instr2_lhu;
wire instr1_sb ,instr2_sb;
wire instr1_sh ,instr2_sh;

wire [2:0] mask1 ,mask2;
wire is_ls1 ,is_ls2;

data_ram_control u_data_ram_control1(
	.instr(EX1_EX2_out_instr1),
       
	.memread(instr1_memread), //in digital_twin DRAM ,the RE is never used
	.memwrite(instr1_memwrite),
	.mask(mask1),
	.is_ls(is_ls1)
);

data_ram_control u_data_ram_control2(
	.instr(EX1_EX2_out_instr2),
       
	.memread(instr2_memread),
	.memwrite(instr2_memwrite),
	.mask(mask2),
	.is_ls(is_ls2)
);

wire [31:0] instr1_data_read_from_dram ,instr2_data_read_from_dram;

assign DRAM_addr = (is_ls2) ? EX1_EX2_out_instr2_alu_result : EX1_EX2_out_instr1_alu_result;
assign DRAM_wdata = (is_ls2) ? EX1_EX2_out_instr2_read_data2 : EX1_EX2_out_instr1_read_data2;
assign DRAM_mask = (is_ls2) ? mask2 : mask1;
assign DRAM_wen = (is_ls2) ? instr2_memwrite : instr1_memwrite;

/*
data_ram u_data_ram(
	.clk(clk),

	//instr1
    .WE1(instr1_memwrite), //write enable
    .sb1(instr1_sb),
    .sh1(instr1_sh),
    .RE1(instr1_memread), //read enable
	.lb1(instr1_lb),
	.lbu1(instr1_lbu),
	.lh1(instr1_lh),
	.lhu1(instr1_lhu),

    .A1(EX1_EX2_out_instr1_alu_result), //write or read address
    .WD1(EX1_EX2_out_instr1_read_data2), //write data 32bits //read_data_from_regfile
    .WD_b1(EX1_EX2_out_instr1_read_data2[7:0]), //write data 8bits
    .WD_h1(EX1_EX2_out_instr1_read_data2[15:0]), //write data 16bits
    .RD1(instr1_data_read_from_dram), //already extension-done one

	//instr2
	.WE2(instr2_memwrite), //write enable
    .sb2(instr2_sb),
    .sh2(instr2_sh),
    .RE2(instr2_memread), //read enable
	.lb2(instr2_lb),
	.lbu2(instr2_lbu),
	.lh2(instr2_lh),
	.lhu2(instr2_lhu),

    .A2(EX1_EX2_out_instr2_alu_result), //write or read address
    .WD2(EX1_EX2_out_instr2_read_data2), //write data 32bits
    .WD_b2(EX1_EX2_out_instr2_read_data2[7:0]), //write data 8bits
    .WD_h2(EX1_EX2_out_instr2_read_data2[15:0]), //write data 16bits
    .RD2(instr2_data_read_from_dram)//already extension-done one


);
*/

wire instr1_WE ,instr2_WE;

assign instr1_data_read_from_dram = (is_ls1) ? DRAM_rdata : 32'b0; //from DRAM
assign instr2_data_read_from_dram = (is_ls2) ? DRAM_rdata : 32'b0;

regfile_write_control u_regfile_write_control1(
	.instr(EX1_EX2_out_instr1),
    .alu_result(EX1_EX2_out_instr1_alu_result),
    .data_read_from_dram(instr1_data_read_from_dram),
    .pc(EX1_EX2_out_instr1_pc),
    .regwrite(instr1_WE),
    .write_data(instr1_write_data)
);

regfile_write_control u_regfile_write_control2(
	.instr(EX1_EX2_out_instr2),
    .alu_result(EX1_EX2_out_instr2_alu_result),
    .data_read_from_dram(instr2_data_read_from_dram),
    .pc(EX1_EX2_out_instr2_pc),
    .regwrite(instr2_WE),
    .write_data(instr2_write_data)
);

wire [31:0] EX2_commit_out_instr1 ,EX2_commit_out_instr2;
wire [31:0] EX2_commit_out_instr1_pc ,EX2_commit_out_instr2_pc;
wire EX2_commit_out_instr1_regwrite ,EX2_commit_out_instr2_regwrite;

EX2_commit u_EX2_commit(
	.clk(clk),
	.rstn(rst_n),

	.EX2_commit_in_instr1(EX1_EX2_out_instr1),
	.EX2_commit_in_instr2(EX1_EX2_out_instr2),
	.EX2_commit_in_instr1_rd_address(EX1_EX2_out_instr1_rd_address),
	.EX2_commit_in_instr2_rd_address(EX1_EX2_out_instr2_rd_address),
	.EX2_commit_in_instr1_write_data(instr1_write_data),
	.EX2_commit_in_instr2_write_data(instr2_write_data),
	.EX2_commit_in_instr1_regwrite(instr1_WE),
	.EX2_commit_in_instr2_regwrite(instr2_WE),
	.EX2_commit_in_instr1_pc(EX1_EX2_out_instr1_pc),
	.EX2_commit_in_instr2_pc(EX1_EX2_out_instr2_pc),

	.EX2_commit_out_instr1(EX2_commit_out_instr1),
	.EX2_commit_out_instr2(EX2_commit_out_instr2),
	.EX2_commit_out_instr1_rd_address(EX2_commit_out_instr1_rd_address),
	.EX2_commit_out_instr2_rd_address(EX2_commit_out_instr2_rd_address),
	.EX2_commit_out_instr1_write_data(EX2_commit_out_instr1_write_data),
	.EX2_commit_out_instr2_write_data(EX2_commit_out_instr2_write_data),
	.EX2_commit_out_instr1_regwrite(EX2_commit_out_instr1_regwrite),
	.EX2_commit_out_instr2_regwrite(EX2_commit_out_instr2_regwrite),
	.EX2_commit_out_instr1_pc(EX2_commit_out_instr1_pc),
	.EX2_commit_out_instr2_pc(EX2_commit_out_instr2_pc)
);


//commit------------------------------------------------------------------------------------------------------------------


regfile u_regfile(
	.clk(clk),

    .instr1_WE(EX2_commit_out_instr1_regwrite),
    .instr1_read_rs1_address(issue_EX1_out_instr1_rs1_address), //from stage EX1
    .instr1_read_rs2_address(issue_EX1_out_instr1_rs2_address), //from stage EX1
    .instr1_write_rd_address(EX2_commit_out_instr1_rd_address),
	.instr1_write_data(EX2_commit_out_instr1_write_data),

	.instr2_WE(EX2_commit_out_instr2_regwrite),
	.instr2_read_rs1_address(issue_EX1_out_instr2_rs1_address), //from stage EX1
    .instr2_read_rs2_address(issue_EX1_out_instr2_rs2_address), //from stage EX1
    .instr2_write_rd_address(EX2_commit_out_instr2_rd_address),
    .instr2_write_data(EX2_commit_out_instr2_write_data),

    .instr1_read_data1(EX1_instr1_read_data1_from_regfile), //from stage EX1
    .instr1_read_data2(EX1_instr1_read_data2_from_regfile), //from stage EX1
	.instr2_read_data1(EX1_instr2_read_data1_from_regfile), //from stage EX1
    .instr2_read_data2(EX1_instr2_read_data2_from_regfile) //from stage EX1

	//.instr1_jalr_rs1_address(instr1[19:15]), //from stage fetch
	//.instr2_jalr_rs1_address(instr2[19:15]),
	//.instr1_jalr_read_data(instr1_jalr_read_data),
	//.instr2_jalr_read_data(instr2_jalr_read_data)  //prefectch data for jalr
);


assign instr_o=instr1;



endmodule
