library verilog;
use verilog.vl_types.all;
entity l1_data_cache_counter is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iCACHE_VALID    : in     vl_logic;
        iCACHE_HIT      : in     vl_logic;
        oINFO_COUNT     : out    vl_logic_vector(6 downto 0)
    );
end l1_data_cache_counter;
