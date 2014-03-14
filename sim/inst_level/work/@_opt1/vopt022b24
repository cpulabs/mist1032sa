library verilog;
use verilog.vl_types.all;
entity scheduler1_commit_entry is
    generic(
        ENTRY_ID        : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iLOCK           : in     vl_logic;
        iRESTART_VALID  : in     vl_logic;
        iREGIST_POINTER : in     vl_logic_vector(5 downto 0);
        iREGIST_0_VALID : in     vl_logic;
        iREGIST_0_MAKE_FLAGS: in     vl_logic;
        iREGIST_0_WRITEBACK: in     vl_logic;
        iREGIST_0_FLAGS_PREG_POINTER: in     vl_logic_vector(3 downto 0);
        iREGIST_0_DEST_PREG_POINTER: in     vl_logic_vector(5 downto 0);
        iREGIST_0_DEST_LREG_POINTER: in     vl_logic_vector(4 downto 0);
        iREGIST_0_DEST_SYSREG: in     vl_logic;
        iREGIST_0_EX_BRANCH: in     vl_logic;
        iREGIST_1_VALID : in     vl_logic;
        iREGIST_1_MAKE_FLAGS: in     vl_logic;
        iREGIST_1_WRITEBACK: in     vl_logic;
        iREGIST_1_FLAGS_PREG_POINTER: in     vl_logic_vector(3 downto 0);
        iREGIST_1_DEST_PREG_POINTER: in     vl_logic_vector(5 downto 0);
        iREGIST_1_DEST_LREG_POINTER: in     vl_logic_vector(4 downto 0);
        iREGIST_1_DEST_SYSREG: in     vl_logic;
        iREGIST_1_EX_BRANCH: in     vl_logic;
        iREGIST_PC      : in     vl_logic_vector(31 downto 0);
        iCOMMIT_VALID   : in     vl_logic;
        iEXEND_ALU0_VALID: in     vl_logic;
        iEXEND_ALU0_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iEXEND_ALU1_VALID: in     vl_logic;
        iEXEND_ALU1_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iEXEND_ALU2_VALID: in     vl_logic;
        iEXEND_ALU2_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iEXEND_ALU3_VALID: in     vl_logic;
        iEXEND_ALU3_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        oINFO_VALID     : out    vl_logic;
        oINFO_MAKE_FLAGS_VALID: out    vl_logic;
        oINFO_WRITEBACK_VALID: out    vl_logic;
        oINFO_PC        : out    vl_logic_vector(31 downto 0);
        oINFO_FLAGS_PREG_POINTER: out    vl_logic_vector(3 downto 0);
        oINFO_DEST_PREG_POINTER: out    vl_logic_vector(5 downto 0);
        oINFO_DEST_LREG_POINTER: out    vl_logic_vector(4 downto 0);
        oINFO_DEST_SYSREG: out    vl_logic;
        oINFO_EX_BRANCH : out    vl_logic;
        oINFO_EX_END    : out    vl_logic;
        oINFO_FREE      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ENTRY_ID : constant is 1;
end scheduler1_commit_entry;
