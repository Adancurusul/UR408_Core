// File: alu.v
// Generated by MyHDL 0.11
// Date: Fri Jun 26 12:34:01 2020


`timescale 1ns/10ps

module alu (
    ds1,
    ds2,
    imm,
    bra,
    branch,
    alu_out,
    alu_signal
);
// :param ds1: 8 in  distiation1
// :param ds2: 8 in distination2
// :param imm: 8 in imm
// :param unsign: 1 in
// :param bra: 1 in jump
// :param branch: 1 out allow jump
// :param alu_out: 4 out output of alu
// :param alu_signal: 11 in alu signals
// :return:

input [7:0] ds1;
input [7:0] ds2;
input [7:0] imm;
input bra;
output branch;
wire branch;
output [7:0] alu_out;
reg [7:0] alu_out;
input [4:0] alu_signal;

wire [7:0] shift_left;
wire [7:0] shift_num;
reg [7:0] shift_right_signed;
wire [7:0] shift_right_signed_temp;
reg [7:0] shift_right_unsigned;




assign shift_right_signed_temp = (ds1 >>> ds2);
assign shift_left = (ds1 << ds2);
assign shift_num = (255 << (7 + ((~ds2) + 1)));


always @(shift_num, shift_right_signed_temp, ds1, alu_signal) begin: ALU_SHIFT_RIGHT_LOGIC
    if ((alu_signal == 4'b0101)) begin
        if (ds1[7]) begin
            shift_right_signed = (shift_right_signed_temp | shift_num);
        end
        else begin
            shift_right_signed = shift_right_signed_temp;
        end
    end
    else begin
        shift_right_unsigned = shift_right_signed_temp;
    end
end



assign branch = (bra & ds1[0]);


always @(ds2, ds1, shift_left, shift_right_unsigned, alu_signal, imm, shift_right_signed) begin: ALU_ALU_LOGIC
    case (alu_signal)
        4'b0000: begin
            alu_out = (ds1 + ds2);
        end
        4'b0001: begin
            alu_out = (ds1 - ds2);
        end
        4'b0010: begin
            alu_out = (ds1 & ds2);
        end
        4'b0011: begin
            alu_out = (ds1 & ds2);
        end
        4'b0100: begin
            alu_out = (ds1 ^ ds2);
        end
        4'b0101: begin
            alu_out = shift_right_signed;
        end
        4'b0110: begin
            alu_out = shift_left;
        end
        4'b0111: begin
            alu_out = shift_right_unsigned;
        end
        4'b1000: begin
            if ((((ds1 < ds2) && (ds1[7] == 0) && (ds2[7] == 0)) || ((ds1[7-1:0] > ds2[7-1:0]) && (ds1[7] == 1) && (ds1[7] == 1)) || ((ds1[7] == 1) && (ds2[7] == 0)))) begin
                alu_out = 1;
            end
            else begin
                alu_out = 0;
            end
        end
        4'b1001: begin
            if ((ds1 < ds2)) begin
                alu_out = 1;
            end
            else begin
                alu_out = 0;
            end
        end
        4'b1010: begin
            if ((ds1 == ds2)) begin
                alu_out = 1;
            end
            else begin
                alu_out = 0;
            end
        end
        4'b1011: begin
            if ((ds1 == ds2)) begin
                alu_out = 0;
            end
            else begin
                alu_out = 1;
            end
        end
        default: begin
            alu_out = imm;
        end
    endcase
end

endmodule
