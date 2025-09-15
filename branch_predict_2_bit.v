module branch_predict_2_bit(
input clk,
input rstn,
input T,
input update,
output branch_en
);
parameter Strongly_taken = 'b00;
parameter Weakly_taken = 'b01;
parameter Weakly_not_taken = 'b11;
parameter Strongly_not_taken = 'b10;

reg [1:0] now_state,next_state;
reg branch_en_reg;

always@(posedge clk,negedge rstn)begin
    if(!rstn) begin
        now_state<=Weakly_not_taken;
    end
    else begin
        now_state<=next_state;
    end
end

always@(*)begin
    case(now_state)
    Strongly_taken:begin
        if(T&&update) next_state=Strongly_taken;
        else if(!T&&update) next_state=Weakly_taken;
        else next_state=Strongly_taken;
    end

    Weakly_taken:begin
        if(T&&update) next_state=Strongly_taken;
        else if(!T&&update) next_state=Strongly_not_taken;
        else next_state=Weakly_taken;
    end

    Weakly_not_taken:begin
        if(T&&update) next_state=Strongly_taken;
        else if(!T&&update)next_state=Strongly_not_taken;
        else next_state=Weakly_not_taken;
    end

    Strongly_not_taken:begin
        if(T&&update) next_state=Weakly_not_taken;
        else if(!T&&update) next_state=Strongly_not_taken;
        else next_state=Strongly_not_taken;
    end
    endcase
end

always@(posedge clk,negedge rstn)begin
    if(!rstn) branch_en_reg<=0;
    else begin
        case(now_state)
        Strongly_taken:branch_en_reg<=1;
        Weakly_taken:branch_en_reg<=1;
        Weakly_not_taken:branch_en_reg<=0;
        Strongly_not_taken:branch_en_reg<=0;
        endcase
    end
end

assign branch_en=branch_en_reg;

endmodule