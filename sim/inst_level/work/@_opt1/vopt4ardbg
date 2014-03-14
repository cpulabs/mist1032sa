library verilog;
use verilog.vl_types.all;
entity fetch is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iEXCEPTION_INST_DISCARD: in     vl_logic;
        iEXCEPTION_EVENT: in     vl_logic;
        iEXCEPTION_ADDR_SET: in     vl_logic;
        iEXCEPTION_ADDR : in     vl_logic_vector(31 downto 0);
        iEXCEPTION_RESTART: in     vl_logic;
        iFETCH_STOP_LOOPBUFFER_LIMIT: in     vl_logic;
        iPREVIOUS_0_INST_VALID: in     vl_logic;
        iPREVIOUS_0_MMU_FLAGS: in     vl_logic_vector(5 downto 0);
        iPREVIOUS_0_INST: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_1_INST_VALID: in     vl_logic;
        iPREVIOUS_1_MMU_FLAGS: in     vl_logic_vector(5 downto 0);
        iPREVIOUS_1_INST: in     vl_logic_vector(31 downto 0);
        oPREVIOUS_LOCK  : out    vl_logic;
        oPREVIOUS_FETCH_REQ: out    vl_logic;
        oPREVIOUS_FETCH_ADDR: out    vl_logic_vector(31 downto 0);
        iPREVIOUS_FETCH_LOCK: in     vl_logic;
        oNEXT_0_INST_VALID: out    vl_logic;
        oNEXT_0_MMU_FLAGS: out    vl_logic_vector(5 downto 0);
        oNEXT_0_INST    : out    vl_logic_vector(31 downto 0);
        oNEXT_1_INST_VALID: out    vl_logic;
        oNEXT_1_MMU_FLAGS: out    vl_logic_vector(5 downto 0);
        oNEXT_1_INST    : out    vl_logic_vector(31 downto 0);
        oNEXT_PC        : out    vl_logic_vector(31 downto 0);
        iNEXT_LOCK      : in     vl_logic
    );
end fetch;
