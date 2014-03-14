library verilog;
use verilog.vl_types.all;
entity mist1032sa_arbiter_matching_queue is
    generic(
        D               : integer := 8;
        DN              : integer := 3;
        FN              : integer := 1
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iFLASH          : in     vl_logic;
        iWR_REQ         : in     vl_logic;
        iWR_FLAG        : in     vl_logic_vector;
        oWR_FULL        : out    vl_logic;
        iRD_REQ         : in     vl_logic;
        oRD_VALID       : out    vl_logic;
        oRD_FLAG        : out    vl_logic_vector;
        oRD_EMPTY       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of D : constant is 1;
    attribute mti_svvh_generic_type of DN : constant is 1;
    attribute mti_svvh_generic_type of FN : constant is 1;
end mist1032sa_arbiter_matching_queue;
