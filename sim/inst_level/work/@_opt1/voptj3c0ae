library verilog;
use verilog.vl_types.all;
entity mist1032sa_sync_fifo is
    generic(
        N               : integer := 16;
        DEPTH           : integer := 4;
        D_N             : integer := 2
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iREMOVE         : in     vl_logic;
        oCOUNT          : out    vl_logic_vector;
        iWR_EN          : in     vl_logic;
        iWR_DATA        : in     vl_logic_vector;
        oWR_FULL        : out    vl_logic;
        iRD_EN          : in     vl_logic;
        oRD_DATA        : out    vl_logic_vector;
        oRD_EMPTY       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of DEPTH : constant is 1;
    attribute mti_svvh_generic_type of D_N : constant is 1;
end mist1032sa_sync_fifo;
