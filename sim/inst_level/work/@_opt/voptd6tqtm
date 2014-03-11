library verilog;
use verilog.vl_types.all;
entity mist1032sa_uart_transmitter is
    generic(
        BAUDRATE_FIXED  : vl_logic := Hi1;
        BAUDRATE_COUNTER: vl_logic_vector(0 to 19) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0)
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iEXTBAUD_COUNT  : in     vl_logic_vector(19 downto 0);
        iTX_REQ         : in     vl_logic;
        oTX_BUSY        : out    vl_logic;
        iTX_DATA        : in     vl_logic_vector(7 downto 0);
        oUART_TXD       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BAUDRATE_FIXED : constant is 1;
    attribute mti_svvh_generic_type of BAUDRATE_COUNTER : constant is 1;
end mist1032sa_uart_transmitter;
