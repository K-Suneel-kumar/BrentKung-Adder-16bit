`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:42:08 08/05/2021 
// Design Name: 
// Module Name:    Brentkung_adder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////





module Brentkung_adder (X,Y,Cin,Cout,SUM);
input [15:0] X,Y;
input Cin;
output Cout;
output [15:0] SUM;
//stage 1


wire [15:0] g1,p1;
genvar k;
generate
	for (k=0;k<=15;k=k+1)
		begin : s1
			and  (g1[k],X[k],Y[k]);
			xor (p1[k],X[k],Y[k]);
	end
endgenerate

//stage 2
wire [7:0] g2,p2;
generate
	for (k=0;k<=7;k=k+1)
		begin :s2
			assign g2[k] = g1[2*k+1]  | ( p1[2*k+1] & g1[2*k] ) ;
			and (p2[k],p1[2*k +1],p1[2*k]);
		end
endgenerate
		
//stage 3
		
wire [3:0] g3,p3;
generate 
			for(k=0;k<=3;k=k+1)
				begin :s3	
					assign g3[k] = g2[2*k+1]  | ( p2[2*k+1] & g2[2*k] ) ;
					and (p3[k],p2[2*k +1],p2[2*k]);
				end
endgenerate

//stage 4
wire [1:0] g4,p4;
generate 
			for(k=0;k<=1;k=k+1)
				begin	:s4
						assign g4[k] = g3[2*k+1]  | ( p3[2*k+1] & g3[2*k] ) ;
					and (p4[k],p3[2*k +1],p3[2*k]);
				end
endgenerate


//stage 5
wire g5,p5;
assign g5 = g4[1] | ( p4[1] & g4[0] );
and (p5,p4[1],p4[0]);


wire [16:0] C;

assign C[0] = Cin;
assign C[1] = g1[0] | (p1[0]&C[0]);
assign C[2] = g2[0] | (p2[0]&C[0]);
assign C[4] = g3[0] | (p3[0]&C[0]);
assign C[8] = g4[0] | (p4[0]&C[0]);
assign C[16] = g5 | (p5&C[0]);

assign C[3] = g1[2] | (p1[2]&C[2]);
assign C[5] = g1[4] | (p1[4]&C[4]);
assign C[9] = g1[8] | (p1[8]&C[8]);
assign C[6] = g2[2] | (p2[2]&C[4]);
assign C[10] = g2[4] | (p2[4]&C[8]);
assign C[12] = g3[2] | (p3[2]&C[8]);

assign C[7] = g1[6] | (p1[6]&C[6]);
assign C[11] = g1[10] | (p1[10]&C[10]);
assign C[13] = g1[12] | (p1[12]&C[12]);
assign C[14] = g2[6] | (p2[6]&C[12]);
assign C[15] = g1[14] | (p1[14]&C[14]);

assign SUM[15:0] = p1[15:0] ^ C[15:0];

assign Cout = C[16];


endmodule
