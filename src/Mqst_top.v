module Mqst_top(
input   		clk							,
input   		rst_p						,
			
input [7:0]   	data_in						,
input         	data_in_valid				,
output        	data_tready					,
			
output  [7:0] 	data_out					,
output        	data_out_valid				,  
			
input         	Mqst_BitIn					,
output        	Mqst_BitOut    			
);		
		
reg         	Bit_out =0 					;      //1bit发送数据
reg         	Bit_out_valid =0 			;//1bit发送数据有效信号
wire        	Bit_out_tready				;  //发送1bit结束	
wire        	Bit_in  					;        //1bit解码数据
wire        	Bit_in_valid				;    //1bit解码数据有效信号
reg     [7:0]   data_in_reg					;
reg     [7:0]   bit_cnt = 0					;
reg     [2:0]   state_reg = 0				;
reg             data_in_valid_r1 = 0		;
reg             data_in_valid_r2 = 0		;
wire            data_in_valid_posedge = data_in_valid_r1 && (~data_in_valid_r2);

  
always @(posedge clk) begin
    data_in_valid_r1<=data_in_valid;
    data_in_valid_r2<=data_in_valid_r1;
end

always @ (posedge clk) begin  //编码8bit，
    case (state_reg)
    0:begin
        if(data_in_valid_posedge)
        begin
            Bit_out_valid<=1;
            state_reg<=1;
        end
    end
    
    1:begin
        if(Bit_out_tready)  begin              
            if(bit_cnt==7)   begin
                bit_cnt<=0;
                if(data_in_valid==0) begin
                    Bit_out_valid<=0;
                    state_reg<=0;
                end
            end                                    
            else
                bit_cnt<=bit_cnt+1;
        end
    end
   endcase 
end

always @ (posedge clk) begin  //字节数据输入
    if(bit_cnt==0)
        data_in_reg<=data_in;
 end
 
always @ (posedge clk) begin  //bit数据  进入曼切斯特编码模块
    case(bit_cnt)
        0:Bit_out<=data_in_reg[7];
        1:Bit_out<=data_in_reg[6];
        2:Bit_out<=data_in_reg[5];
        3:Bit_out<=data_in_reg[4];
        4:Bit_out<=data_in_reg[3];
        5:Bit_out<=data_in_reg[2];
        6:Bit_out<=data_in_reg[1];
        7:Bit_out<=data_in_reg[0];
    endcase
end

assign    data_tready  = (bit_cnt==7)   ?  1: 0;

///曼切斯特 编码//
Mqst_Module Mqst_tx(
    .clk(clk),
    .Bit_out(Bit_out),
    .Bit_out_valid(Bit_out_valid),
    .Bit_out_tready(Bit_out_tready),
    .Mqst_BitOut(Mqst_BitOut)    
);
   
///曼切斯特 解码 //   仿真时，将 Mqst_BitOut 与 Mqst_BitIn 直接相连 
Mqst_Demodule Mqst_rx(
     .clk(clk),
     .Bit_in(Bit_in),
     .Bit_in_valid(Bit_in_valid),

     .Mqst_BitIn(Mqst_BitOut)//Mqst_BitIn    
);
endmodule