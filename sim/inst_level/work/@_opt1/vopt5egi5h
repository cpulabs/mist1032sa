library verilog;
use verilog.vl_types.all;
entity pipeline_register is
    generic(
        P_N             : integer := 32
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iRESET_SYNC     : in     vl_logic;
        iPREV_REQ       : in     vl_logic;
        oPREV_BUSY      : out    vl_logic;
        iPREV_DATA      : in     vl_logic_vector;
        oNEXT_REQ       : out    vl_logic;
        iNEXT_BUSY      : in     vl_logic;
        oNEXT_DATA      : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of P_N : constant is 1;
end pipeline_register;
