library verilog;
use verilog.vl_types.all;
entity reservation_search16to2 is
    port(
        iINFO0          : in     vl_logic;
        iINFO1          : in     vl_logic;
        iINFO2          : in     vl_logic;
        iINFO3          : in     vl_logic;
        iINFO4          : in     vl_logic;
        iINFO5          : in     vl_logic;
        iINFO6          : in     vl_logic;
        iINFO7          : in     vl_logic;
        iINFO8          : in     vl_logic;
        iINFO9          : in     vl_logic;
        iINFO10         : in     vl_logic;
        iINFO11         : in     vl_logic;
        iINFO12         : in     vl_logic;
        iINFO13         : in     vl_logic;
        iINFO14         : in     vl_logic;
        iINFO15         : in     vl_logic;
        oPICKUP_0_VALID : out    vl_logic;
        oPICLUP_0_NUM   : out    vl_logic_vector(3 downto 0);
        oPICKUP_1_VALID : out    vl_logic;
        oPICLUP_1_NUM   : out    vl_logic_vector(3 downto 0)
    );
end reservation_search16to2;
