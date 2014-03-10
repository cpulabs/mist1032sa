library verilog;
use verilog.vl_types.all;
entity execute_adder is
    generic(
        P_N             : integer := 32
    );
    port(
        iDATA_0         : in     vl_logic_vector;
        iDATA_1         : in     vl_logic_vector;
        iADDER_CMD      : in     vl_logic_vector(4 downto 0);
        oDATA           : out    vl_logic_vector;
        oSF             : out    vl_logic;
        oOF             : out    vl_logic;
        oCF             : out    vl_logic;
        oPF             : out    vl_logic;
        oZF             : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of P_N : constant is 1;
end execute_adder;
