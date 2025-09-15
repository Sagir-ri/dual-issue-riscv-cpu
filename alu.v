module alu (
    input  wire signed [32-1:0] A,
    input  wire signed [32-1:0] B,
    input  wire [5-1 :0] ALUCtrl,
    output wire          ZERO,
    output wire signed [32-1:0] Y,
    output wire less_than
);

reg          reg_ZERO;
//reg signed [32-1:0] reg_Y;
reg signed [32-1:0] result;

// reg [31:0] A_temp; 
reg [31:0] result_temp;

reg [31:0] A_unsigned, B_unsigned;

reg reg_less_than;

//reg [63:0] mul_ss_temp,mul_su_temp,mul_uu_temp;

always @(*)
begin
	A_unsigned=A;
	B_unsigned=B;
	//mul_ss_temp=A*B;
	//mul_su_temp=A*B_unsigned;
	//mul_uu_temp=A_unsigned*B_unsigned;
	//$display("A=%d",A);
	//$display("B=%d",B);
	case(ALUCtrl)
		5'b00000: result=A&B;
		5'b00001: result=A|B;
		5'b00010: result=A+B;
		5'b00110: result=A-B;
		5'b00111: result=A^B;
		5'b01000: result=A<<B[4:0];//left logic
		5'b01001: result=A>>B[4:0];//right logic
		5'b01010: result = ( A>>> B [4:0] );//right arithmetic
		5'b01011: result = (A_unsigned<B_unsigned) ? 32'b1 : 32'b0 ;//unsigned comparison
		5'b01100: result = (A<B) ? 32'b1 : 32'b0 ;//signed comparision
		/*
		5'b01101: begin
			  if(B==0)
			  begin
				result=0-1;
			  end
			  else
			  begin
				result=A/B;//div signed
			  end
			  end
		5'b01110: begin
			  if(B==0)
			  begin
				result=0-1;
			  end
			  else
			  begin
				result=A_unsigned/B_unsigned;//div unsigned
			  end
			  end
		5'b01111: result=mul_ss_temp[31:0]; //mul
		5'b10000: result=mul_ss_temp[63:32]; //mulh
		5'b10001: result=mul_su_temp[63:32]; //mulhsu
		5'b10010: result=mul_uu_temp[63:32]; //mulhu
		5'b10011: 
				begin
					if(B==0)
					begin
						result=A;
					end
					else
					begin
						result=A%B; //rem
					end
				end
		5'b10100:
				begin
					if(B_unsigned==0)
					begin
						result=A_unsigned;
					end
					else
					begin
						result=A_unsigned%B_unsigned; //remu
					end
				end
				*/
		default: result=32'b0;
	endcase
	

	if(result==32'b0)
	begin
		reg_ZERO=1;
	end
	else
	begin
		reg_ZERO=0;
	end

	if((ALUCtrl==5'b01011||ALUCtrl==5'b01100)&&result==32'b1)
	begin
		reg_less_than=1;
	end
	else
	begin
		reg_less_than=0;
	end


	//reg_Y=result;
	//$displayb("result=",result);

end

assign Y=result;
assign ZERO=reg_ZERO;
assign less_than=reg_less_than;

endmodule