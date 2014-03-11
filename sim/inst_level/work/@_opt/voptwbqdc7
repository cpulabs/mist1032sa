library verilog;
use verilog.vl_types.all;
entity pipelined_div_radix2 is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iREMOVE         : in     vl_logic;
        oSOURCE_BUSY    : out    vl_logic;
        iSOURCE_VALID   : in     vl_logic;
        iSOURCE_SIGN    : in     vl_logic;
        iSOURCE_DIVIDEND: in     vl_logic_vector(31 downto 0);
        iSOURCE_DIVISOR : in     vl_logic_vector(31 downto 0);
        iOUT_BUSY       : in     vl_logic;
        oOUT_VALID      : out    vl_logic;
        oOUT_DATA_Q     : out    vl_logic_vector(31 downto 0);
        oOUT_DATA_R     : out    vl_logic_vector(31 downto 0)
    );
end pipelined_div_radix2;
