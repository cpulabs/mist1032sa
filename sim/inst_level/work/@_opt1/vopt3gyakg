library verilog;
use verilog.vl_types.all;
entity sysreg_spr_register is
    generic(
        N               : integer := 32
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iREGIST_REQ     : in     vl_logic;
        iREGIST_DATA    : in     vl_logic_vector;
        oINFO_DATA      : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
end sysreg_spr_register;
