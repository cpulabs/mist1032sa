library verilog;
use verilog.vl_types.all;
entity register_renaming_table is
    generic(
        ENTRY_ID        : vl_logic_vector(0 to 4) := (Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iRESTART_VALID  : in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE0_VALID: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE0_LREGNAME: in     vl_logic_vector(4 downto 0);
        iROLLBACK_UPDATE_CANDIDATE0_PREGNAME: in     vl_logic_vector(5 downto 0);
        iROLLBACK_UPDATE_CANDIDATE1_VALID: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE1_LREGNAME: in     vl_logic_vector(4 downto 0);
        iROLLBACK_UPDATE_CANDIDATE1_PREGNAME: in     vl_logic_vector(5 downto 0);
        iROLLBACK_UPDATE_CANDIDATE2_VALID: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE2_LREGNAME: in     vl_logic_vector(4 downto 0);
        iROLLBACK_UPDATE_CANDIDATE2_PREGNAME: in     vl_logic_vector(5 downto 0);
        iROLLBACK_UPDATE_CANDIDATE3_VALID: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE3_LREGNAME: in     vl_logic_vector(4 downto 0);
        iROLLBACK_UPDATE_CANDIDATE3_PREGNAME: in     vl_logic_vector(5 downto 0);
        iLOCK           : in     vl_logic;
        iREGIST_0_VALID : in     vl_logic;
        iREGIST_0_LOGIC_DESTINATION: in     vl_logic_vector(4 downto 0);
        iREGIST_0_REGNAME: in     vl_logic_vector(5 downto 0);
        iREGIST_1_VALID : in     vl_logic;
        iREGIST_1_LOGIC_DESTINATION: in     vl_logic_vector(4 downto 0);
        iREGIST_1_REGNAME: in     vl_logic_vector(5 downto 0);
        oINFO_VALID     : out    vl_logic;
        oINFO_REGNAME   : out    vl_logic_vector(5 downto 0);
        oINFO_OLD_REGNAME: out    vl_logic_vector(5 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ENTRY_ID : constant is 1;
end register_renaming_table;
