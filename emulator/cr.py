from myhdl import *

@block
def cr(pc_next,branch_offset,r6_r7_data,cr_data,clk,rst,int0,int1,int2,int3,mem_read,mem_write,mem_ok,branch,selector,cr_write,ret,apc,jmp,bra
       ,main_state):

    '''

    :param clk: 1 in clk
    :param rst: 1 in rst
    :param int0: 1 in interrupt
    :param int1: 1 in interrupt
    :param int2: 1 in interrupt
    :param int3: 1 in interrupt
    :param mem_read: 1 in memory read
    :param mem_write: 1 in memory write
    :param mem_ok: 1 in memory ok
    :param branch:  1 in branch
    :param selector:  3 in selectors
    :param cr_write:1 in cr write
    :param ret: 1 in return
    :param apc: 1 in apc
    :param jmp: 1 in jmp
    :param bra: 1 in branch if
    :param main_state: 1 out main state
    :param pc_next: 16 out program counter next
    :param branch_offset: 16 in branch offset
    :param r6_r7_data: 16 in  data from r6 and r7 (pointer
    :param cr_data: 16 out cr register data
    :return:
    '''
    states = enum ('status','ie','epc','cpc','tvec0','tvec1','tvec2','tvec3')
    CPC = Signal(intbv(0)[16:])
    #TEMP = Signal(intbv(0)[16:])
    TVEC0 = Signal(intbv(0)[16:])
    TVEC1 = Signal(intbv(0)[16:])
    TVEC2 = Signal(intbv(0)[16:])
    TVEC3 = Signal(intbv(0)[16:])
    EPC = Signal(intbv(0)[16:])
    PC = Signal(intbv(0)[16:])
    GIE = Signal(bool(0))
    PGIE = Signal(bool(0))
    IE0 = Signal(bool(0))
    IE1 = Signal(bool(0))
    IE2 = Signal(bool(0))
    IE3 = Signal(bool(0))
    int_acc = Signal(bool(0))
    tvec = Signal(intbv(0)[16:])
    int0_acc = Signal(bool(0))
    int1_acc = Signal(bool(0))
    int2_acc = Signal(bool(0))
    int3_acc = Signal(bool(0))

    @always_comb
    def comb_logic():
        if int0_acc:
            tvec.next = TVEC0
        elif int1_acc:
            tvec.next = TVEC1
        elif int2_acc:
            tvec.next = TVEC2
        else:
            tvec.next = TVEC3

    @always_comb
    def comb_logic2():
        if ret:
            pc_next.next = EPC
        elif branch :
            pc_next.next = PC+ branch_offset
        elif jmp:
            pc_next.next = r6_r7_data
        else:

            pc_next.next = PC
    '''
    @always_comb
    def comb_logic3():
        if selector=='000000001':
            cr_data[16:2].next = intbv(0)[14:]
            cr_data[1].next = PGIE
            cr_data[0].next = GIE
        elif selector=='000000010':
            cr_data[16:4].next = intbv(0)[12:]
            cr_data[3].next = IE3
            cr_data[2].next = IE2
            cr_data[1].next = IE1
            cr_data[0].next = IE0
        elif selector=='000000100':
            cr_data.next = EPC
        elif selector=='000001000':
            cr_data.next = CPC
        elif selector == '000010000':
            cr_data.next = TVEC0
        elif selector == '000100000':
            cr_data.next = TVEC1
        elif selector == '001000000':
            cr_data.next = TVEC2
        elif selector == '010000000':
            cr_data.next = TVEC3
        else:
            cr_data.next = 0
    '''
    @always_comb
    def comb_logic3():
        if selector==states.status:#'000000001'
            cr_data[16:2].next = intbv(0)[14:]
            cr_data[1].next = PGIE
            cr_data[0].next = GIE
        elif selector==states.ie:
            cr_data[16:4].next = intbv(0)[12:]
            cr_data[3].next = IE3
            cr_data[2].next = IE2
            cr_data[1].next = IE1
            cr_data[0].next = IE0
        elif selector==states.epc:
            cr_data.next = EPC
        elif selector==states.cpc:
            cr_data.next = CPC
        elif selector == states.tvec0:
            cr_data.next = TVEC0
        elif selector == states.tvec1:
            cr_data.next = TVEC1
        elif selector == states.tvec2:
            cr_data.next = TVEC2
        elif selector == states.tvec3:
            cr_data.next = TVEC3
        else:
            cr_data.next = 0


    @always_seq(clk.posedge,reset = rst)
    def cr_logic():
        # main_state
        if not main_state:
            if mem_read | mem_write:
                main_state.next = intbv(bool(1))
            else:
                main_state.next = intbv(bool(0))
        elif main_state:
            if mem_ok:
                main_state.next = intbv(bool(0))
            else:
                main_state.next = intbv(bool(1))
        # status
    @always_seq(clk.posedge, reset=rst)
    def cr_logic2():
        if int_acc:
            GIE.next = 0
        elif ret:
            GIE.next = PGIE
        elif selector==states.status and cr_write:
            GIE.next  = r6_r7_data[0]

        if int_acc:
            PGIE.next = GIE
        elif selector == states.status and cr_write:
            PGIE.next = r6_r7_data[1]

    @always_seq(clk.posedge, reset=rst)
    def cr_logic3():
        #ie
        if selector == states.ie and cr_write:
            IE0.next = r6_r7_data[0]
            IE1.next = r6_r7_data[1]
            IE2.next = r6_r7_data[2]
            IE3.next = r6_r7_data[3]

    @always_seq(clk.posedge, reset=rst)
    def cr_logic4():
        # epc
        if int_acc:
            EPC.next = PC
        elif selector == states.epc and cr_write:
            EPC.next = r6_r7_data

    @always_seq(clk.posedge, reset=rst)
    def cr_logic5():
    # cpc
        if selector == states.cpc and cr_write:
            CPC.next = r6_r7_data
        elif apc:
            CPC.next = PC

    @always_seq(clk.posedge, reset=rst)
    def cr_logic6():
        # pc
        if int_acc:
            PC.next = tvec + 1
        elif ret:
            PC.next = EPC + 1
        elif jmp:
            PC.next = r6_r7_data + 1
        elif branch:
            PC.next = PC + branch_offset + 1
        else:
            if ((not main_state) or not (mem_read or mem_write)) or (main_state and mem_ok):
                PC.next = PC + 1
            else:
                PC.next = PC

    @always_seq(clk.posedge, reset=rst)
    def cr_logic7():
            #tvec0
        if selector == states.tvec0 and cr_write:
            TVEC0.next = r6_r7_data

            # tvec1
        if selector == states.tvec1 and cr_write:
            TVEC1.next = r6_r7_data

            # tvec2
        if selector == states.tvec2 and cr_write:
            TVEC2.next = r6_r7_data

            # tvec3
        if selector == states.tvec3 and cr_write:
            TVEC3.next = r6_r7_data

    @always_comb
    def int_logic():
        int0_acc.next = GIE & int0 & IE0
        int1_acc.next = GIE & int1 & IE1
        int2_acc.next = GIE & int2 & IE2
        int3_acc.next = GIE & int3 & IE3
    @always_comb
    def int_plus_logic():
        int_acc.next = not (bra | jmp | ret | mem_read | mem_write) & (int0_acc | int1_acc | int2_acc | int3_acc)


    return instances()
