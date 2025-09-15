module bypass(
    input [4:0] EX1_stage_instr1_rs1_address,
    input [4:0] EX1_stage_instr1_rs2_address,
    input [4:0] EX1_stage_instr2_rs1_address,
    input [4:0] EX1_stage_instr2_rs2_address,

    input [4:0] EX2_stage_instr1_rd_address,
    input [4:0] EX2_stage_instr2_rd_address,

    input [4:0] commit_stage_instr1_rd_address,
    input [4:0] commit_stage_instr2_rd_address,


    output reg stall,

    input clk,
    input rstn
);

wire [4:0] bypass_sel_instr1_data1 = {
    !(EX1_stage_instr1_rs1_address ^ 'd0) ,
    !(EX1_stage_instr1_rs1_address^EX2_stage_instr2_rd_address) ,
    !(EX1_stage_instr1_rs1_address^EX2_stage_instr1_rd_address) ,
    !(EX1_stage_instr1_rs1_address^commit_stage_instr2_rd_address) ,
    !(EX1_stage_instr1_rs1_address^commit_stage_instr1_rd_address) 
};

wire [4:0] bypass_sel_instr1_data2 = {
    !(EX1_stage_instr1_rs2_address ^ 'd0) ,
    !(EX1_stage_instr1_rs2_address^EX2_stage_instr2_rd_address) ,
    !(EX1_stage_instr1_rs2_address^EX2_stage_instr1_rd_address) ,
    !(EX1_stage_instr1_rs2_address^commit_stage_instr2_rd_address) ,
    !(EX1_stage_instr1_rs2_address^commit_stage_instr1_rd_address) 
};

wire [4:0] bypass_sel_instr2_data1 = {
    !(EX1_stage_instr2_rs1_address ^ 'd0) ,
    !(EX1_stage_instr2_rs1_address^EX2_stage_instr2_rd_address) ,
    !(EX1_stage_instr2_rs1_address^EX2_stage_instr1_rd_address) ,
    !(EX1_stage_instr2_rs1_address^commit_stage_instr2_rd_address) ,
    !(EX1_stage_instr2_rs1_address^commit_stage_instr1_rd_address) 
};


wire [4:0] bypass_sel_instr2_data2 = {
    !(EX1_stage_instr2_rs2_address ^ 'd0) ,
    !(EX1_stage_instr2_rs2_address^EX2_stage_instr2_rd_address) ,
    !(EX1_stage_instr2_rs2_address^EX2_stage_instr1_rd_address) ,
    !(EX1_stage_instr2_rs2_address^commit_stage_instr2_rd_address) ,
    !(EX1_stage_instr2_rs2_address^commit_stage_instr1_rd_address) 
};

reg stall_for_1_clk_instr1_data1, stall_for_2_clk_instr1_data1;
reg stall_for_1_clk_instr1_data2, stall_for_2_clk_instr1_data2;
reg stall_for_1_clk_instr2_data1, stall_for_2_clk_instr2_data1;
reg stall_for_1_clk_instr2_data2, stall_for_2_clk_instr2_data2;
reg stall_for_1_clk, stall_for_2_clk;

    always @(*) 
    begin

        casez (bypass_sel_instr1_data1)
            5'b1????:
            begin
                stall_for_1_clk_instr1_data1=0;
                stall_for_2_clk_instr1_data1=0;
            end
            5'b01???:
            begin
                stall_for_1_clk_instr1_data1=1;
                stall_for_2_clk_instr1_data1=0;
            end
            5'b001??:
            begin
                stall_for_1_clk_instr1_data1=1;
                stall_for_2_clk_instr1_data1=0;
            end
            5'b0001?:
            begin
                stall_for_1_clk_instr1_data1=0;
                stall_for_2_clk_instr1_data1=1;
            end
            5'b00001:
            begin
                stall_for_1_clk_instr1_data1=0;
                stall_for_2_clk_instr1_data1=1;
            end
            default:
            begin
                stall_for_1_clk_instr1_data1=0;
                stall_for_2_clk_instr1_data1=0;
            end
        endcase

         casez (bypass_sel_instr1_data2)
            5'b1????:
            begin
                stall_for_1_clk_instr1_data2=0;
                stall_for_2_clk_instr1_data2=0;
            end
            5'b01???:
            begin
                stall_for_1_clk_instr1_data2=1;
                stall_for_2_clk_instr1_data2=0;
            end
            5'b001??:
            begin
                stall_for_1_clk_instr1_data2=1;
                stall_for_2_clk_instr1_data2=0;
            end
            5'b0001?:
            begin
                stall_for_1_clk_instr1_data2=0;
                stall_for_2_clk_instr1_data2=1;
            end
            5'b00001:
            begin
                stall_for_1_clk_instr1_data2=0;
                stall_for_2_clk_instr1_data2=1;
            end
            default:
            begin
                stall_for_1_clk_instr1_data2=0;
                stall_for_2_clk_instr1_data2=0;
            end
        endcase

         casez (bypass_sel_instr2_data1)
            5'b1????:
            begin
                stall_for_1_clk_instr2_data1=0;
                stall_for_2_clk_instr2_data1=0;
            end
            5'b01???:
            begin
                stall_for_1_clk_instr2_data1=1;
                stall_for_2_clk_instr2_data1=0;
            end
            5'b001??:
            begin
                stall_for_1_clk_instr2_data1=1;
                stall_for_2_clk_instr2_data1=0;
            end
            5'b0001?:
            begin
                stall_for_1_clk_instr2_data1=0;
                stall_for_2_clk_instr2_data1=1;
            end
            5'b00001:
            begin
                stall_for_1_clk_instr2_data1=0;
                stall_for_2_clk_instr2_data1=1;
            end
            default:
            begin
                stall_for_1_clk_instr2_data1=0;
                stall_for_2_clk_instr2_data1=0;
            end
        endcase


        casez (bypass_sel_instr2_data2)
            5'b1????:
            begin
                stall_for_1_clk_instr2_data2=0;
                stall_for_2_clk_instr2_data2=0;
            end
            5'b01???:
            begin
                stall_for_1_clk_instr2_data2=1;
                stall_for_2_clk_instr2_data2=0;
            end
            5'b001??:
            begin
                stall_for_1_clk_instr2_data2=1;
                stall_for_2_clk_instr2_data2=0;
            end
            5'b0001?:
            begin
                stall_for_1_clk_instr2_data2=0;
                stall_for_2_clk_instr2_data2=1;
            end
            5'b00001:
            begin
                stall_for_1_clk_instr2_data2=0;
                stall_for_2_clk_instr2_data2=1;
            end
            default:
            begin
                stall_for_1_clk_instr2_data2=0;
                stall_for_2_clk_instr2_data2=0;
            end
        endcase

        stall_for_1_clk = stall_for_1_clk_instr1_data1 || stall_for_1_clk_instr1_data2 || stall_for_1_clk_instr2_data1 || stall_for_1_clk_instr2_data2;
        stall_for_2_clk = stall_for_2_clk_instr1_data1 || stall_for_2_clk_instr1_data2 || stall_for_2_clk_instr2_data1 || stall_for_2_clk_instr2_data2;
    end


    reg [3:0] i;

    always @(posedge clk, negedge rstn)
    begin
        if(~rstn)
        begin
            i<=0;
        end
        else
        begin
             if(stall_for_2_clk)
            begin
                i<=2;
            end
            else if(stall_for_1_clk)
            begin
                i<=1;
            end
            else if(i!=0)
            begin
                i<=i-1;
            end
            else
            begin
                i<=0;
            end
        end
    end

    always @(*)
    begin
        if(stall_for_2_clk)
        begin
            stall=1;
        end
        else if(stall_for_1_clk)
        begin
            stall=1;
        end
        else if(i!=0)
        begin
            stall=1;
        end
        else
        begin
            stall=0;
        end
    end
endmodule