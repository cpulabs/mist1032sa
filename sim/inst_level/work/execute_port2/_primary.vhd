library verilog;
use verilog.vl_types.all;
entity execute_port2 is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iFREE_EX        : in     vl_logic;
        iPREVIOUS_EX_ALU2_VALID: in     vl_logic;
        iPREVIOUS_EX_ALU2_WRITEBACK: in     vl_logic;
        iPREVIOUS_EX_ALU2_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iPREVIOUS_EX_ALU2_CMD: in     vl_logic_vector(4 downto 0);
        iPREVIOUS_EX_ALU2_AFE: in     vl_logic_vector(3 downto 0);
        iPREVIOUS_EX_ALU2_SYS_REG: in     vl_logic;
        iPREVIOUS_EX_ALU2_LOGIC: in     vl_logic;
        iPREVIOUS_EX_ALU2_SHIFT: in     vl_logic;
        iPREVIOUS_EX_ALU2_ADDER: in     vl_logic;
        iPREVIOUS_EX_ALU2_SOURCE0: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_EX_ALU2_SOURCE1: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_EX_ALU2_DESTINATION_SYSREG: in     vl_logic;
        iPREVIOUS_EX_ALU2_DESTINATION_REGNAME: in     vl_logic_vector(5 downto 0);
        iPREVIOUS_EX_ALU2_FLAGS_WRITEBACK: in     vl_logic;
        iPREVIOUS_EX_ALU2_FLAGS_REGNAME: in     vl_logic_vector(3 downto 0);
        oPREVIOUS_EX_ALU2_LOCK: out    vl_logic;
        oSCHE1_EX_ALU2_VALID: out    vl_logic;
        oSCHE1_EX_ALU2_COMMIT_TAG: out    vl_logic_vector(5 downto 0);
        oSCHE2_EX_ALU2_VALID: out    vl_logic;
        oSCHE2_EX_ALU2_COMMIT_TAG: out    vl_logic_vector(5 downto 0);
        oSCHE2_EX_ALU2_SYSREG: out    vl_logic;
        oSCHE2_EX_ALU2_DESTINATION_REGNAME: out    vl_logic_vector(5 downto 0);
        oSCHE2_EX_ALU2_WRITEBACK: out    vl_logic;
        oSCHE2_EX_ALU2_DATA: out    vl_logic_vector(31 downto 0);
        oSCHE2_EX_ALU2_FLAG: out    vl_logic_vector(4 downto 0);
        oSCHE2_EX_ALU2_FLAGS_WRITEBACK: out    vl_logic;
        oSCHE2_EX_ALU2_FLAGS_REGNAME: out    vl_logic_vector(3 downto 0)
    );
end execute_port2;
