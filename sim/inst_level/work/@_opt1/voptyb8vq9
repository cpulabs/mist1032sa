library verilog;
use verilog.vl_types.all;
entity flag_rename_management is
    generic(
        ENTRY_ID        : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0)
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iREMOVE_VALID   : in     vl_logic;
        iCOMMIT_VECTOR  : in     vl_logic_vector(63 downto 0);
        iREGIST_0_VALID : in     vl_logic;
        iREGIST_0_FLAGAS_REGNAME: in     vl_logic_vector(3 downto 0);
        iREGIST_0_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iREGIST_1_VALID : in     vl_logic;
        iREGIST_1_FLAGAS_REGNAME: in     vl_logic_vector(3 downto 0);
        iREGIST_1_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iALU1_VALID     : in     vl_logic;
        iALU1_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iALU1_FLAGS     : in     vl_logic_vector(4 downto 0);
        iALU2_VALID     : in     vl_logic;
        iALU2_COMMIT_TAG: in     vl_logic_vector(5 downto 0);
        iALU2_FLAGS     : in     vl_logic_vector(4 downto 0);
        iFREELIST_REGIST_VALID: in     vl_logic;
        oINFO_FREELIST_REQ: out    vl_logic;
        oINFO_FLAGS_VALID: out    vl_logic;
        oINFO_FLAGS     : out    vl_logic_vector(4 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ENTRY_ID : constant is 1;
end flag_rename_management;
