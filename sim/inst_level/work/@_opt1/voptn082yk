library verilog;
use verilog.vl_types.all;
entity main_counter is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iCONF_WRITE     : in     vl_logic;
        iCONF_ENA       : in     vl_logic;
        iCOUNT_WRITE    : in     vl_logic;
        inCOUNT_DQM     : in     vl_logic_vector(1 downto 0);
        iCOUNT_COUNTER  : in     vl_logic_vector(63 downto 0);
        oWORKING        : out    vl_logic;
        oCOUNTER        : out    vl_logic_vector(63 downto 0)
    );
end main_counter;
