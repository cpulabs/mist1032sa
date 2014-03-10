library verilog;
use verilog.vl_types.all;
entity decode_authcheck is
    port(
        iINSTRUCTION    : in     vl_logic_vector(31 downto 0);
        iKERNEL_ACCESS  : in     vl_logic;
        iMMU_FLAGS      : in     vl_logic_vector(13 downto 0);
        oIRQ41          : out    vl_logic_vector(2 downto 0)
    );
end decode_authcheck;
