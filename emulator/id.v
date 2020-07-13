// File: id.v
// Generated by MyHDL 0.11
// Date: Sat Jun 27 00:01:08 2020


`timescale 1ns/10ps

module id (
    ins,
    alu_signal,
    mem_read,
    mem_write,
    register_write,
    rd_r0_mux,
    rd_r1_mux,
    ds1_rx,
    ds2_rx,
    rd_mux0,
    rd_mux1,
    cr_write,
    selector,
    imm,
    branch_offset,
    bra,
    ret,
    apc,
    jmp
);
// ins in 16
// alu_signal out 4
// mem_read out 1
// mem_write out 1
// register_write out 8
// rd_r0_mux out 1
// rd_r1_mux out 1
// selector out 3
// cr_write out 1
// ds1_rx out 3
// ds2_rx out 3
// imm out 8
// branch_offset out 16
// jmp out 1
// ret out 1
// apc out 1
// bra out 1

input [15:0] ins;
output [3:0] alu_signal;
reg [3:0] alu_signal;
output mem_read;
reg mem_read;
output mem_write;
reg mem_write;
output [7:0] register_write;
reg [7:0] register_write;
output rd_r0_mux;
reg rd_r0_mux;
output rd_r1_mux;
reg rd_r1_mux;
output [2:0] ds1_rx;
wire [2:0] ds1_rx;
output [2:0] ds2_rx;
wire [2:0] ds2_rx;
output rd_mux0;
wire rd_mux0;
output rd_mux1;
wire rd_mux1;
output cr_write;
reg cr_write;
output [2:0] selector;
wire [2:0] selector;
output [7:0] imm;
wire [7:0] imm;
output [15:0] branch_offset;
wire [15:0] branch_offset;
output bra;
reg bra;
output ret;
reg ret;
output apc;
reg apc;
output jmp;
reg jmp;

wire [3:0] funct4_0;
wire [3:0] funct4_1;
wire [3:0] funct4_2;
wire [3:0] funct4_3;
wire [3:0] funct4_4;
wire [3:0] funct4_5;
wire [3:0] funct4_8;
wire [3:0] funct4_9;
wire [2:0] ins20;
wire [2:0] ins96;
wire [1:0] opcode_ls;

assign funct4_0 = 4'd0;
assign funct4_1 = 4'd1;
assign funct4_2 = 4'd2;
assign funct4_3 = 4'd3;
assign funct4_4 = 4'd4;
assign funct4_5 = 4'd5;
assign funct4_8 = 4'd8;
assign funct4_9 = 4'd9;
assign opcode_ls = 2'd3;



assign ins20 = ins[2-1:0];
assign ins96 = ins[9-1:6];


always @(funct4_2, funct4_9, funct4_3, funct4_4, funct4_1, funct4_8, funct4_0, ins96, funct4_5, ins, ins20) begin: ID_ID_LOGIC
    if ((ins20 == 2'b00)) begin
        alu_signal = ins[6-1:2];
        register_write = ins[9-1:6];
    end
    else begin
        alu_signal = 0;
        register_write = 0;
    end
    if ((ins20 == 2'b01)) begin
        bra = (1 != 0);
    end
    else begin
        bra = (0 != 0);
    end
    if ((ins20 == 2'b10)) begin
        register_write[0] = (ins[6-1:2] == funct4_4);
        register_write[1] = (ins[6-1:2] == funct4_4);
        rd_r0_mux = (ins[6-1:2] == funct4_4);
        rd_r1_mux = (ins[6-1:2] == funct4_4);
        cr_write = (ins[6-1:2] == funct4_3);
        jmp = ((ins[6-1:2] == funct4_0) || (ins[6-1:2] == funct4_2));
        apc = ((ins[6-1:2] == funct4_0) || (ins[6-1:2] == funct4_1));
        ret = (ins[6-1:2] == funct4_5);
    end
    else begin
        register_write[0] = (0 != 0);
        register_write[1] = (0 != 0);
        rd_r0_mux = (0 != 0);
        rd_r1_mux = (0 != 0);
        cr_write = (0 != 0);
        jmp = (0 != 0);
        apc = (0 != 0);
        ret = (0 != 0);
    end
    if ((ins20 == 2'b11)) begin
        mem_read = (ins[6-1:2] == funct4_8);
        mem_write = (ins[6-1:2] == funct4_9);
        if (((ins[9-1:6] == funct4_9) | (ins[6-1:2] == funct4_0))) begin
            case (ins96)
                3'b000: begin
                    register_write[0] = 1;
                end
                3'b001: begin
                    register_write[1] = 1;
                end
                3'b010: begin
                    register_write[2] = 1;
                end
                3'b011: begin
                    register_write[3] = 1;
                end
                3'b100: begin
                    register_write[4] = 1;
                end
                3'b101: begin
                    register_write[5] = 1;
                end
                3'b110: begin
                    register_write[6] = 1;
                end
                3'b111: begin
                    register_write[7] = 1;
                end
                default: begin
                    register_write = 0;
                end
            endcase
        end
        else begin
            register_write = 0;
        end
    end
    else begin
        mem_read = (0 != 0);
        mem_write = (0 != 0);
        register_write = 0;
    end
end



assign rd_mux0 = (ins[6-1:2] == funct4_0);
assign rd_mux1 = (ins[2-1:0] == opcode_ls);



assign ds2_rx = ins[12-1:9];
assign ds1_rx = ins[12-1:9];



assign selector = ins[12-1:9];



assign imm[7] = 0;
assign imm[7-1:0] = ins[16-1:9];
assign branch_offset[15] = ins[15];
assign branch_offset[14] = ins[15];
assign branch_offset[13] = ins[15];
assign branch_offset[12] = ins[15];
assign branch_offset[11] = ins[15];
assign branch_offset[10] = ins[15];
assign branch_offset[9] = ins[15];
assign branch_offset[8] = ins[15];
assign branch_offset[8-1:4] = ins[15-1:12];
assign branch_offset[4-1:1] = ins[9-1:6];
assign branch_offset[0] = 0;

endmodule
