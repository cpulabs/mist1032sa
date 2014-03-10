library verilog;
use verilog.vl_types.all;
entity decode_mmucheck is
    port(
        iPAGING_ENA     : in     vl_logic;
        iKERNEL_ACCESS  : in     vl_logic;
        iMMU_FLAGS      : in     vl_logic_vector(13 downto 0);
        oIRQ40          : out    vl_logic_vector(2 downto 0);
        oIRQ41          : out    vl_logic_vector(2 downto 0);
        oIRQ42          : out    vl_logic_vector(2 downto 0)
    );
end decode_mmucheck;
