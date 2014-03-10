library verilog;
use verilog.vl_types.all;
entity mist1032sa_uart_receiver_async2sync is
    generic(
        N               : integer := 1
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iSIGNAL         : in     vl_logic_vector;
        oSIGNAL         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
end mist1032sa_uart_receiver_async2sync;
