module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    always@(posedge clk)begin
        if(reset)
            pm = 0;
        else
            pm = ((hh[7:0]==8'h11)&&(ss[7:0]==8'h59)&&(mm[7:0]==8'h59))?~pm:pm;
    end
        
    wire inter1, inter2;
    assign inter1 = (ss[7:0]==8'h59);
    assign inter2 = (ss[7:0]==8'h59)&&(mm[7:0]==8'h59);
    BCD60 s(clk, reset, ena, ss[7:0]);
    BCD60 m(clk, reset, inter1, mm[7:0]);
    BCD12 h(clk, reset, inter2, hh[7:0]);
endmodule

module BCD60 (input clk,input reset,input ena,output reg [7:0] Q);
    always@(posedge clk) begin
        if (reset) 
            Q <= 8'h0;
        else if (ena) begin
                if (Q == 8'h59)
                    Q <= 8'h0;
                else begin
                    if (Q[3:0] == 4'd9) begin
            			Q[3:0] <= 0;
            			Q[7:4] <= Q[7:4] + 4'd1;
              		end
              		else 
                  		Q[3:0] <= Q[3:0] + 4'd1; 
                end
        end
    end   
endmodule

module BCD12 (input clk,input reset,input ena,output reg [7:0] Q);
    always@(posedge clk) begin
        if (reset) 
            Q <= 8'h12;
        else if (ena)
            begin
                if (Q == 8'h12)
                    Q <= 8'h1;
                else begin
                    if (Q[3:0] == 4'd9) begin
            			Q[3:0] <= 0;
            			Q[7:4] <= Q[7:4] + 4'd1;
              		end
              		else 
                  		Q[3:0] <= Q[3:0] + 4'd1; 
                end
            end
    end   
endmodule
