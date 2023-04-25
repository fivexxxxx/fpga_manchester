module Mqst_Module(
    input   		clk					,   //32M  
			
    input   		Bit_out				,
    input   		Bit_out_valid		,
    output  		Bit_out_tready		,
    
    output reg 		Mqst_BitOut  //2M  
);

//reg             Mqst_BitOut=0;
reg     [1:0]   send_tmp  = 0			; 
reg     [7:0]   clk_cnt = 0				;
reg     [2:0]   state_reg = 0			;
reg             Bit_out_valid_r1 = 0	;
reg             Bit_out_valid_r2 = 0	;
wire            Bit_out_valid_posedge = Bit_out_valid_r1 && (~Bit_out_valid_r2);

always @(posedge clk) begin
    Bit_out_valid_r1<=Bit_out_valid;
    Bit_out_valid_r2<=Bit_out_valid_r1;
end
    
always @ (posedge clk) begin  
    case (state_reg)    
    0:begin                 //数据有效后，开始编码
        if(Bit_out_valid_posedge)
            state_reg<=1;
    end
    
    1:begin
        if(clk_cnt==32/2-1)   begin//输入时钟32M、曼切斯特速率2M
            clk_cnt<=0;
            if(Bit_out_valid==0)
                state_reg<=0;
        end                                    
        else
            clk_cnt<=clk_cnt+1;
    end
   endcase 
end

always @ (posedge clk) begin   //编码 0：编码为2'b10  1:编码为2’b01
    if(Bit_out_valid==1)
    begin
        if(Bit_out==0)
            send_tmp<=2'b10;
        else
            send_tmp<=2'b01;
     end
     else
        send_tmp<=2'b00; 
end

always @ (posedge clk) begin  //曼切斯特编码输出
    if(state_reg==1)
    begin
        if(clk_cnt==0)
            Mqst_BitOut<=send_tmp[1];
        else if(clk_cnt==8)
            Mqst_BitOut<=send_tmp[0];
    end
    else
        Mqst_BitOut<=0;
end

assign   Bit_out_tready = (clk_cnt==13) ? 1'b1 :1'b0;  //提前2个时钟置高

endmodule