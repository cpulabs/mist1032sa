library verilog;
use verilog.vl_types.all;
entity tlb is
    generic(
        LRU_TIMER_N     : integer := 10
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iREMOVE         : in     vl_logic;
        iRD_REQ         : in     vl_logic;
        iRD_ADDR        : in     vl_logic_vector(31 downto 0);
        oRD_VALID       : out    vl_logic;
        oRD_HIT         : out    vl_logic;
        oRD_FLAGS       : out    vl_logic_vector(27 downto 0);
        oRD_PHYS_ADDR   : out    vl_logic_vector(63 downto 0);
        iWR_REQ         : in     vl_logic;
        iWR_ADDR        : in     vl_logic_vector(31 downto 0);
        iWR_FLAGS       : in     vl_logic_vector(27 downto 0);
        iWR_PHYS_ADDR   : in     vl_logic_vector(63 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LRU_TIMER_N : constant is 1;
end tlb;
