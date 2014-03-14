library verilog;
use verilog.vl_types.all;
entity reservation_alu2_entry is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iREMOVE_VALID   : in     vl_logic;
        iREGISTER_VALID : in     vl_logic;
        oINFO_REGIST_LOCK: out    vl_logic;
        iREGISTER_DESTINATION_SYSREG: in     vl_logic;
        iREGISTER_WRITEBACK: in     vl_logic;
        iREGISTER_CMD   : in     vl_logic_vector(4 downto 0);
        iREGISTER_AFE   : in     vl_logic_vector(3 downto 0);
        iREGISTER_SYS_REG: in     vl_logic;
        iREGISTER_LOGIC : in     vl_logic;
        iREGISTER_SHIFT : in     vl_logic;
        iREGISTER_ADDER : in     vl_logic;
        iREGISTER_FLAGS_OPT_VALID: in     vl_logic;
        iREGISTER_FLAGS_REGNAME: in     vl_logic_vector(3 downto 0);
        iREGISTER_SOURCE0_VALID: in     vl_logic;
        iREGISTER_SOURCE0: in     vl_logic_vector(31 downto 0);
        iREGISTER_SOURCE1_VALID: in     vl_logic;
        iREGISTER_SOURCE1: in     vl_logic_vector(31 downto 0);
        iREGISTER_PCR   : in     vl_logic_vector(31 downto 0);
        iREGISTER_DESTINATION_REGNAME: in     vl_logic_vector(5 downto 0);
        iREGISTER_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iALU1_VALID     : in     vl_logic;
        iALU1_DESTINATION_REGNAME: in     vl_logic_vector(5 downto 0);
        iALU1_WRITEBACK : in     vl_logic;
        iALU1_DATA      : in     vl_logic_vector(31 downto 0);
        iALU2_VALID     : in     vl_logic;
        iALU2_DESTINATION_REGNAME: in     vl_logic_vector(5 downto 0);
        iALU2_WRITEBACK : in     vl_logic;
        iALU2_DATA      : in     vl_logic_vector(31 downto 0);
        iALU3_VALID     : in     vl_logic;
        iALU3_DESTINATION_REGNAME: in     vl_logic_vector(5 downto 0);
        iALU3_DATA      : in     vl_logic_vector(31 downto 0);
        iEXOUT_VALID    : in     vl_logic;
        oINFO_ENTRY_VALID: out    vl_logic;
        oINFO_MATCHING  : out    vl_logic;
        oINFO_DESTINATION_SYSREG: out    vl_logic;
        oINFO_WRITEBACK : out    vl_logic;
        oINFO_CMD       : out    vl_logic_vector(4 downto 0);
        oINFO_AFE       : out    vl_logic_vector(3 downto 0);
        oINFO_SYS_REG   : out    vl_logic;
        oINFO_LOGIC     : out    vl_logic;
        oINFO_SHIFT     : out    vl_logic;
        oINFO_ADDER     : out    vl_logic;
        oINFO_FLAGS_OPT_VALID: out    vl_logic;
        oINFO_FLAGS_REGNAME: out    vl_logic_vector(3 downto 0);
        oINFO_SOURCE0_VALID: out    vl_logic;
        oINFO_SOURCE0   : out    vl_logic_vector(31 downto 0);
        oINFO_SOURCE1_VALID: out    vl_logic;
        oINFO_SOURCE1   : out    vl_logic_vector(31 downto 0);
        oINFO_PCR       : out    vl_logic_vector(31 downto 0);
        oINFO_DESTINATION_REGNAME: out    vl_logic_vector(5 downto 0);
        oINFO_COMMIT_TAG: out    vl_logic_vector(5 downto 0)
    );
end reservation_alu2_entry;
