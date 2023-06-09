`timescale 1ps / 1ps
module test_mqst();

reg   		clk						;
reg   		rst_p					;
reg [7:0]   data_in = 0				;
reg         data_in_valid			;
wire        data_tready				;
wire  [7:0] data_out				;
wire        data_out_valid			;  
reg         Mqst_BitIn				;
wire        Mqst_BitOut				; 

Mqst_top Mqst_top(
    .clk			(clk			),
    .rst_p			(rst_p			),
    .data_in		(data_in		),
    .data_in_valid	(data_in_valid	),
    .data_tready	(data_tready	),
    .data_out		(data_out		),
    .data_out_valid	(data_out_valid	),
    .Mqst_BitIn		(Mqst_BitIn		),
    .Mqst_BitOut	(Mqst_BitOut	)       
);

initial   begin
    #0
    clk = 0;
    rst_p =1;
    data_in_valid = 0;
    #100
    
    rst_p = 0;
    data_in_valid = 1;
  
end

always #15 clk =~clk;

always @ (posedge data_tready) begin
    if(data_in==11)
    begin
        data_in<=0;
        data_in_valid<=0;
    end
    else
        data_in<=data_in+1;
 end
endmodule