library verilog;
use verilog.vl_types.all;
entity execute_port0 is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iFREE_RESTART   : in     vl_logic;
        iPREVIOUS_EX_BRANCH_VALID: in     vl_logic;
        iPREVIOUS_EX_BRANCH_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iPREVIOUS_EX_BRANCH_CMD: in     vl_logic_vector(4 downto 0);
        iPREVIOUS_EX_BRANCH_CC: in     vl_logic_vector(3 downto 0);
        iPREVIOUS_EX_BRANCH_FLAG: in     vl_logic_vector(4 downto 0);
        iPREVIOUS_EX_BRANCH_SOURCE: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_EX_BRANCH_PC: in     vl_logic_vector(31 downto 0);
        oPREVIOUS_EX_BRANCH_LOCK: out    vl_logic;
        oJUMP_ACTIVE    : out    vl_logic;
        oJUMP_ADDR      : out    vl_logic_vector(31 downto 0);
        oSWI_ACTIVE     : out    vl_logic;
        oSWI_NUMBER     : out    vl_logic_vector(10 downto 0);
        oINTR_ACTIVE    : out    vl_logic;
        oINTR_ADDR      : out    vl_logic_vector(31 downto 0);
        oIDTS_ACTIVE    : out    vl_logic;
        oIDTS_R_ADDR    : out    vl_logic_vector(31 downto 0);
        oIDTR_COMMIT_TAG: out    vl_logic_vector(5 downto 0);
        oSCHE1_EX_BRANCH_VALID: out    vl_logic;
        oSCHE1_EX_BRANCH_COMMIT_TAG: out    vl_logic_vector(5 downto 0);
        oSCHE2_EX_BRANCH_VALID: out    vl_logic;
        oSCHE2_EX_BRANCH_COMMIT_TAG: out    vl_logic_vector(5 downto 0)
    );
end execute_port0;
