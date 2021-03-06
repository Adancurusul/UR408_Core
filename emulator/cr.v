// File: cr.v
// Generated by MyHDL 0.11
// Date: Sat Jun 27 20:34:39 2020


`timescale 1ns/10ps

module cr (
    pc_next,
    branch_offset,
    r6_r7_data,
    cr_data,
    clk,
    rst,
    int0,
    int1,
    int2,
    int3,
    mem_read,
    mem_write,
    mem_ok,
    branch,
    selector,
    cr_write,
    ret,
    apc,
    jmp,
    bra,
    main_state
);
// :param clk: 1 in clk
// :param rst: 1 in rst
// :param int0: 1 in interrupt
// :param int1: 1 in interrupt
// :param int2: 1 in interrupt
// :param int3: 1 in interrupt
// :param mem_read: 1 in memory read
// :param mem_write: 1 in memory write
// :param mem_ok: 1 in memory ok
// :param branch:  1 in branch
// :param selector:  3 in selectors
// :param cr_write:1 in cr write
// :param ret: 1 in return
// :param apc: 1 in apc
// :param jmp: 1 in jmp
// :param bra: 1 in branch if
// :param main_state: 1 out main state
// :param pc_next: 16 out program counter next
// :param branch_offset: 16 in branch offset
// :param r6_r7_data: 16 in  data from r6 and r7 (pointer
// :param cr_data: 16 out cr register data
// :return:

output [15:0] pc_next;
reg [15:0] pc_next;
input [15:0] branch_offset;
input [15:0] r6_r7_data;
output [15:0] cr_data;
reg [15:0] cr_data;
input clk;
input rst;
input int0;
input int1;
input int2;
input int3;
input mem_read;
input mem_write;
input mem_ok;
input branch;
input [2:0] selector;
input cr_write;
input ret;
input apc;
input jmp;
input bra;
output main_state;
reg main_state;

reg [15:0] CPC = 0;
reg [15:0] EPC = 0;
reg GIE = 0;
reg IE0 = 0;
reg IE1 = 0;
reg IE2 = 0;
reg IE3 = 0;
reg [15:0] PC = 0;
reg PGIE = 0;
reg [15:0] TVEC0 = 0;
reg [15:0] TVEC1 = 0;
reg [15:0] TVEC2 = 0;
reg [15:0] TVEC3 = 0;
wire int0_acc;
wire int1_acc;
wire int2_acc;
wire int3_acc;
wire int_acc;
reg [15:0] tvec = 0;



always @(TVEC2, TVEC3, int2_acc, TVEC1, TVEC0, int0_acc, int1_acc) begin: CR_COMB_LOGIC
    if (int0_acc) begin
        tvec = TVEC0;
    end
    else if (int1_acc) begin
        tvec = TVEC1;
    end
    else if (int2_acc) begin
        tvec = TVEC2;
    end
    else begin
        tvec = TVEC3;
    end
end


always @(branch_offset, branch, PC, ret, jmp, r6_r7_data, EPC) begin: CR_COMB_LOGIC2
    if (ret) begin
        pc_next = EPC;
    end
    else if (branch) begin
        pc_next = (PC + branch_offset);
    end
    else if (jmp) begin
        pc_next = r6_r7_data;
    end
    else begin
        pc_next = PC;
    end
end


always @(TVEC2, IE1, TVEC3, IE3, IE0, CPC, TVEC1, PGIE, IE2, TVEC0, selector, GIE, EPC) begin: CR_COMB_LOGIC3
    case (selector)
        3'b000: begin
            cr_data[16-1:2] = 14'h0;
            cr_data[1] = PGIE;
            cr_data[0] = GIE;
        end
        3'b001: begin
            cr_data[16-1:4] = 12'h0;
            cr_data[3] = IE3;
            cr_data[2] = IE2;
            cr_data[1] = IE1;
            cr_data[0] = IE0;
        end
        3'b010: begin
            cr_data = EPC;
        end
        3'b011: begin
            cr_data = CPC;
        end
        3'b100: begin
            cr_data = TVEC0;
        end
        3'b101: begin
            cr_data = TVEC1;
        end
        3'b110: begin
            cr_data = TVEC2;
        end
        3'b111: begin
            cr_data = TVEC3;
        end
        default: begin
            cr_data = 0;
        end
    endcase
end


always @(posedge clk) begin: CR_CR_LOGIC
    if (rst == 1) begin
        main_state <= 0;
    end
    else begin
        if ((!main_state)) begin
            if ((mem_read | mem_write)) begin
                main_state <= (1 != 0);
            end
            else begin
                main_state <= (0 != 0);
            end
        end
        else if (main_state) begin
            if (mem_ok) begin
                main_state <= (0 != 0);
            end
            else begin
                main_state <= (1 != 0);
            end
        end
    end
end


always @(posedge clk) begin: CR_CR_LOGIC2
    if (rst == 1) begin
        GIE <= 0;
        PGIE <= 0;
    end
    else begin
        if (int_acc) begin
            GIE <= 0;
        end
        else if (ret) begin
            GIE <= PGIE;
        end
        else if (((selector == 3'b000) && cr_write)) begin
            GIE <= r6_r7_data[0];
        end
        if (int_acc) begin
            PGIE <= GIE;
        end
        else if (((selector == 3'b000) && cr_write)) begin
            PGIE <= r6_r7_data[1];
        end
    end
end


always @(posedge clk) begin: CR_CR_LOGIC3
    if (rst == 1) begin
        IE3 <= 0;
        IE0 <= 0;
        IE1 <= 0;
        IE2 <= 0;
    end
    else begin
        if (((selector == 3'b001) && cr_write)) begin
            IE0 <= r6_r7_data[0];
            IE1 <= r6_r7_data[1];
            IE2 <= r6_r7_data[2];
            IE3 <= r6_r7_data[3];
        end
    end
end


always @(posedge clk) begin: CR_CR_LOGIC4
    if (rst == 1) begin
        EPC <= 0;
    end
    else begin
        if (int_acc) begin
            EPC <= PC;
        end
        else if (((selector == 3'b010) && cr_write)) begin
            EPC <= r6_r7_data;
        end
    end
end


always @(posedge clk) begin: CR_CR_LOGIC5
    if (rst == 1) begin
        CPC <= 0;
    end
    else begin
        if (((selector == 3'b011) && cr_write)) begin
            CPC <= r6_r7_data;
        end
        else if (apc) begin
            CPC <= PC;
        end
    end
end


always @(posedge clk) begin: CR_CR_LOGIC6
    if (rst == 1) begin
        PC <= 0;
    end
    else begin
        if (int_acc) begin
            PC <= (tvec + 1);
        end
        else if (ret) begin
            PC <= (EPC + 1);
        end
        else if (jmp) begin
            PC <= (r6_r7_data + 1);
        end
        else if (branch) begin
            PC <= ((PC + branch_offset) + 1);
        end
        else begin
            if ((((!main_state) || (!(mem_read || mem_write))) || (main_state && mem_ok))) begin
                PC <= (PC + 1);
            end
            else begin
                PC <= PC;
            end
        end
    end
end


always @(posedge clk) begin: CR_CR_LOGIC7
    if (rst == 1) begin
        TVEC0 <= 0;
        TVEC1 <= 0;
        TVEC3 <= 0;
        TVEC2 <= 0;
    end
    else begin
        if (((selector == 3'b100) && cr_write)) begin
            TVEC0 <= r6_r7_data;
        end
        if (((selector == 3'b101) && cr_write)) begin
            TVEC1 <= r6_r7_data;
        end
        if (((selector == 3'b110) && cr_write)) begin
            TVEC2 <= r6_r7_data;
        end
        if (((selector == 3'b111) && cr_write)) begin
            TVEC3 <= r6_r7_data;
        end
    end
end



assign int0_acc = ((GIE & int0) & IE0);
assign int1_acc = ((GIE & int1) & IE1);
assign int2_acc = ((GIE & int2) & IE2);
assign int3_acc = ((GIE & int3) & IE3);



assign int_acc = (!(((((bra | jmp) | ret) | mem_read) | mem_write) & (((int0_acc | int1_acc) | int2_acc) | int3_acc)));

endmodule
