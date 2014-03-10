library verilog;
use verilog.vl_types.all;
entity comparator_counter is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iMTIMER_WORKING : in     vl_logic;
        iMTIMER_COUNT   : in     vl_logic_vector(63 downto 0);
        iCONF_WRITE     : in     vl_logic;
        iCONF_ENA       : in     vl_logic;
        iCONF_IRQENA    : in     vl_logic;
        iCONF_64MODE    : in     vl_logic;
        iCONF_PERIODIC  : in     vl_logic;
        iCOUNT_WRITE    : in     vl_logic;
        inCOUNT_DQM     : in     vl_logic_vector(1 downto 0);
        iCOUNT_COUNTER  : in     vl_logic_vector(63 downto 0);
        oIRQ            : out    vl_logic
    );
end comparator_counter;
