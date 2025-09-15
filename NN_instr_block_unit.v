module NN_instr_block_unit(
    input clk,
    input rstn,


    input [31:0] instr1_in,
	input [31:0] instr2_in,



    output reg nop1,
    output reg nop2
);

wire [4:0] instr1_rs1_address ,instr1_rs2_address ,instr1_rd_address;
wire [4:0] instr2_rs1_address ,instr2_rs2_address ,instr2_rd_address;

decoder u_decoder1( //find the address of rs and rd (5'b00000 for null)
	.instr(instr1_in),
	.rs1_address(instr1_rs1_address),
	.rs2_address(instr1_rs2_address),
	.rd_address(instr1_rd_address)
);

decoder u_decoder2(
	.instr(instr2_in),
	.rs1_address(instr2_rs1_address),
	.rs2_address(instr2_rs2_address),
	.rd_address(instr2_rd_address)
);

reg instr1_ls_sig ,instr2_ls_sig; //ls for load and store

always @(*)
begin
    if((instr1_in[6:0]==7'b0000011)||(instr1_in[6:0]==7'b0100011))
    begin
        instr1_ls_sig=1;
    end
    else
    begin
        instr1_ls_sig=0;
    end

    if((instr2_in[6:0]==7'b0000011)||(instr2_in[6:0]==7'b0100011))
    begin
        instr2_ls_sig=1;
    end
    else
    begin
        instr2_ls_sig=0;
    end
end //judge if an instr is l or s type


parameter IDLE=2'b00;
parameter s0=2'b01;
parameter s1=2'b10;

reg [1:0] cur_state ,next_state;

always @(posedge clk ,negedge rstn)
begin
    if(!rstn)
    begin
        cur_state<=2'b0;
    end
    else
    begin
        cur_state<=next_state;
    end
end


always @(*)
begin
    case (cur_state)
        IDLE: 
        begin
            if((((!(instr2_rs1_address^instr1_rd_address))||(!(instr2_rs2_address^instr1_rd_address)))&&(instr1_rd_address^5'b0))||((instr1_ls_sig==1)&&(instr2_ls_sig==1)))
            begin
                next_state=s0;
            end
            else
            begin
                next_state=IDLE;
            end
        end
        s0:
        begin
            next_state=s1;
        end
        s1:
        begin
            if((((!(instr2_rs1_address^instr1_rd_address))||(!(instr2_rs2_address^instr1_rd_address)))&&(instr1_rd_address^5'b0))||((instr1_ls_sig==1)&&(instr2_ls_sig==1)))
            begin
                next_state=s0;
            end
            else
            begin
                next_state=IDLE;
            end
        end
        default: 
        begin
            next_state=IDLE;
        end
    endcase
end

always @(*)
begin
    case (cur_state)
        IDLE: 
        begin
            nop1=0;
            nop2=0;
        end
        s0:
        begin
            nop1=0;
            nop2=1;
        end
        s1:
        begin
            nop1=1;
            nop2=0;
        end
        default: 
        begin
            nop1=0;
            nop2=0;
        end
    endcase
end





endmodule