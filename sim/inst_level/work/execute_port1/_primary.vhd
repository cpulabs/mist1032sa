library verilog;
use verilog.vl_types.all;
entity execute_port1 is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iFREE_EX        : in     vl_logic;
        iPREVIOUS_EX_ALU1_VALID: in     vl_logic;
        iPREVIOUS_EX_ALU1_WRITEBACK: in     vl_logic;
        iPREVIOUS_EX_ALU1_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iPREVIOUS_EX_ALU1_CMD: in     vl_logic_vector(4 downto 0);
        iPREVIOUS_EX_ALU1_AFE: in     vl_logic_vector(3 downto 0);
        iPREVIOUS_EX_ALU1_SYS_REG: in     vl_logic;
        iPREVIOUS_EX_ALU1_LOGIC: in     vl_logic;
        iPREVIOUS_EX_ALU1_SHIFT: in     vl_logic;
        iPREVIOUS_EX_ALU1_ADDER: in     vl_logic;
        iPREVIOUS_EX_ALU1_MUL: in     vl_logic;
        iPREVIOUS_EX_ALU1_SDIV: in     vl_logic;
        iPREVIOUS_EX_ALU1_UDIV: in     vl_logic;
        iPREVIOUS_EX_ALU1_SOURCE0: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_EX_ALU1_SOURCE1: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_EX_ALU1_DESTINATION_SYSREG: in     vl_logic;
        iPREVIOUS_EX_ALU1_DESTINATION_REGNAME: in     vl_logic_vector(5 downto 0);
        iPREVIOUS_EX_ALU1_FLAGS_WRITEBACK: in     vl_logic;
        iPREVIOUS_EX_ALU1_FLAGS_REGNAME: in     vl_logic_vector(3 downto 0);
        iPREVIOUS_EX_ALU1_PCR: in     vl_logic_vector(31 downto 0);
        oPREVIOUS_EX_ALU1_LOCK: out    vl_logic;
        oINTERRUPT_ACTIVE: out    vl_logic;
        oINTERRUPT_NUM  : out    vl_logic_vector(10 downto 0);
        oSCHE1_EX_ALU1_VALID: out    vl_logic;
        oSCHE1_EX_ALU1_COMMIT_TAG: out    vl_logic_vector(5 downto 0);
        oSCHE2_EX_ALU1_VALID: out    vl_logic;
        oSCHE2_EX_ALU1_COMMIT_TAG: out    vl_logic_vector(5 downto 0);
        oSCHE2_EX_ALU1_SYSREG: out    vl_logic;
        oSCHE2_EX_ALU1_DESTINATION_REGNAME: out    vl_logic_vector(5 downto 0);
        oSCHE2_EX_ALU1_WRITEBACK: out    vl_logic;
        oSCHE2_EX_ALU1_DATA: out    vl_logic_vector(31 downto 0);
        oSCHE2_EX_ALU1_FLAG: out    vl_logic_vector(4 downto 0);
        oSCHE2_EX_ALU1_FLAGS_WRITEBACK: out    vl_logic;
        oSCHE2_EX_ALU1_FLAGS_REGNAME: out    vl_logic_vector(3 downto 0)
    );
end execute_port1;
