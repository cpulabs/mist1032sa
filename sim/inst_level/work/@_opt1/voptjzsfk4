library verilog;
use verilog.vl_types.all;
entity general_register_entry is
    generic(
        ENTRY_ID        : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iFREE_RESTART   : in     vl_logic;
        iCOMMIT_VECTOR  : in     vl_logic_vector(63 downto 0);
        iREGIST_0_VALID : in     vl_logic;
        iREGIST_0_DESTINATION_REGNAME: in     vl_logic_vector(5 downto 0);
        iREGIST_0_LOGIC_DESTINATION: in     vl_logic_vector(4 downto 0);
        iREGIST_0_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iREGIST_1_VALID : in     vl_logic;
        iREGIST_1_DESTINATION_REGNAME: in     vl_logic_vector(5 downto 0);
        iREGIST_1_LOGIC_DESTINATION: in     vl_logic_vector(4 downto 0);
        iREGIST_1_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iEXEND_ADDER_VALID: in     vl_logic;
        iEXEND_ADDER_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iEXEND_ADDER_REGNAME: in     vl_logic_vector(5 downto 0);
        iEXEND_ADDER_DATA: in     vl_logic_vector(31 downto 0);
        iEXEND_MULDIV_VALID: in     vl_logic;
        iEXEND_MULDIV_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iEXEND_MULDIV_REGNAME: in     vl_logic_vector(5 downto 0);
        iEXEND_MULDIV_DATA: in     vl_logic_vector(31 downto 0);
        iEXEND_LDST_VALID: in     vl_logic;
        iEXEND_LDST_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iEXEND_LDST_REGNAME: in     vl_logic_vector(5 downto 0);
        iEXEND_LDST_DATA: in     vl_logic_vector(31 downto 0);
        iFREELIST_REGIST_VALID: in     vl_logic;
        oINFO_FREELIST_REQ: out    vl_logic;
        oINFO_DATA_VALID: out    vl_logic;
        oINFO_DATA      : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ENTRY_ID : constant is 1;
end general_register_entry;
