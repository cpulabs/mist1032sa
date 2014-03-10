library verilog;
use verilog.vl_types.all;
entity l1_cache_64entry_4way_line64b_bus_8b is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iREMOVE         : in     vl_logic;
        iRD_REQ         : in     vl_logic;
        oRD_BUSY        : out    vl_logic;
        iRD_ADDR        : in     vl_logic_vector(31 downto 0);
        oRD_VALID       : out    vl_logic;
        oRD_HIT         : out    vl_logic;
        iRD_BUSY        : in     vl_logic;
        oRD_DATA        : out    vl_logic_vector(63 downto 0);
        oRD_MMU_FLAGS   : out    vl_logic_vector(27 downto 0);
        iUP_REQ         : in     vl_logic;
        oUP_BUSY        : out    vl_logic;
        iUP_ORDER       : in     vl_logic_vector(1 downto 0);
        iUP_ADDR        : in     vl_logic_vector(31 downto 0);
        iUP_DATA        : in     vl_logic_vector(31 downto 0);
        iWR_REQ         : in     vl_logic;
        oWR_BUSY        : out    vl_logic;
        iWR_ADDR        : in     vl_logic_vector(31 downto 0);
        iWR_DATA        : in     vl_logic_vector(511 downto 0);
        iWR_MMU_FLAGS   : in     vl_logic_vector(255 downto 0)
    );
end l1_cache_64entry_4way_line64b_bus_8b;
