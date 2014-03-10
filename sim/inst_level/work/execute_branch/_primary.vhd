library verilog;
use verilog.vl_types.all;
entity execute_branch is
    port(
        iDATA_0         : in     vl_logic_vector(31 downto 0);
        iDATA_1         : in     vl_logic_vector(31 downto 0);
        iPC             : in     vl_logic_vector(31 downto 0);
        iFLAG           : in     vl_logic_vector(4 downto 0);
        iCC             : in     vl_logic_vector(3 downto 0);
        iCMD            : in     vl_logic_vector(4 downto 0);
        oBRANCH_ADDR    : out    vl_logic_vector(31 downto 0);
        oJUMP_VALID     : out    vl_logic;
        oNOT_JUMP_VALID : out    vl_logic;
        oIB_VALID       : out    vl_logic;
        oIDTS_VALID     : out    vl_logic;
        oHALT_VALID     : out    vl_logic
    );
end execute_branch;
