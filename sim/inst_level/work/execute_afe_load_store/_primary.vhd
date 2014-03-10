library verilog;
use verilog.vl_types.all;
entity execute_afe_load_store is
    port(
        iAFE_CODE       : in     vl_logic_vector(3 downto 0);
        iDATA           : in     vl_logic_vector(31 downto 0);
        oDATA           : out    vl_logic_vector(31 downto 0)
    );
end execute_afe_load_store;
