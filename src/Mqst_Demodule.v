module Mqst_Demodule(
    input   			clk					,   //32M      
    output reg  		Bit_in				,
    output reg  		Bit_in_valid		,        
    input    			Mqst_BitIn       		//2M  
);

reg     [7:0]   		clk_cnt = 0			;
reg             		bit_cnt = 0			;
reg     [2:0]   		Mqst_BitIn_tmp = 0	;		
reg             		Bit_sync  = 0		;  //同步  当收到2'b00或2'b11  作为解码的同步标志		
reg     [2:0]   		state_reg = 0		;		
reg             		Mqst_BitIn_r1 = 0	;
wire            		Mqst_BitIn_posedge = Mqst_BitIn && (~Mqst_BitIn_r1);

always @(posedge clk) begin
    Mqst_BitIn_r1<=Mqst_BitIn;
end
    
always @ (posedge clk) begin
    case (state_reg)
    0:begin
        clk_cnt<=0;
        Bit_sync<=0;
        if(Mqst_BitIn_posedge)
            state_reg<=1;
    end
    
    1:begin 
        if(clk_cnt==7)  //输入时钟32M、曼切斯特速率2M
            clk_cnt<=0;                                                         
        else
            clk_cnt<=clk_cnt+1; 
                         
        if(clk_cnt==7)
        begin                
            if((Mqst_BitIn_tmp[1:0]==2'b00 || Mqst_BitIn_tmp[1:0]==2'b11) && Bit_sync==0)//寻找 同步头   
                Bit_sync<=1;                    
            else if((Mqst_BitIn_tmp[1:0]==2'b00 || Mqst_BitIn_tmp[1:0]==2'b11) && bit_cnt==1) //同步头 丢失后 重新寻找同步头
                Bit_sync<=0;
            else if(Mqst_BitIn_tmp[2:0] == 3'b000)  //当收到3个零时，数据错误，重新开始解码
                state_reg<=0;                 
        end                          
    end       
   endcase 
end


always @ (posedge clk) begin    //当 bit_cnt==1 时，才解码输出
    if(clk_cnt==4 && Bit_sync==1)
        bit_cnt<=bit_cnt+1;
end


always @ (posedge clk) begin  //数据缓存
    if(clk_cnt==4)
        Mqst_BitIn_tmp[2:0]<={Mqst_BitIn_tmp[1:0],Mqst_BitIn};
end

always @ (posedge clk) begin  //曼切斯特解码
    if(clk_cnt==7 && bit_cnt==1) begin
        case(Mqst_BitIn_tmp[1:0])
            2'b01:Bit_in<=1;
            2'b10:Bit_in<=0;
            default:Bit_in<=0;
     endcase
   end
end

always @ (posedge clk) begin  //曼切斯特 解码正确后Bit_in_valid有效
    if(bit_cnt==1 && clk_cnt==7) begin
        if(Mqst_BitIn_tmp[1:0]==2'b01 || Mqst_BitIn_tmp[1:0]==2'b10)  
            Bit_in_valid<=1;
         else
            Bit_in_valid<=0;               
    end
    else
        Bit_in_valid<=0; 
end
endmodule 