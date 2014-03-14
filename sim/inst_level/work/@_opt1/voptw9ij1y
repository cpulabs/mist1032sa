library verilog;
use verilog.vl_types.all;
entity div_pipelined_latch is
    generic(
        N               : integer := 4
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iREMOVE         : in     vl_logic;
        iPREVIOUS_VALID : in     vl_logic;
        oPREVIOUS_BUSY  : out    vl_logic;
        iPREVIOUS_SIGN  : in     vl_logic;
        iPREVIOUS_DIVISOR: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_DIVIDEND: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_Q     : in     vl_logic_vector;
        iPREVIOUS_R     : in     vl_logic_vector(30 downto 0);
        oNEXT_VALID     : out    vl_logic;
        iNEXT_BUSY      : in     vl_logic;
        oNEXT_SIGN      : out    vl_logic;
        oNEXT_DIVISOR   : out    vl_logic_vector(31 downto 0);
        oNEXT_DIVIDEND  : out    vl_logic_vector(31 downto 0);
        oNEXT_Q         : out    vl_logic_vector;
        oNEXT_R         : out    vl_logic_vector(30 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
end div_pipelined_latch;
