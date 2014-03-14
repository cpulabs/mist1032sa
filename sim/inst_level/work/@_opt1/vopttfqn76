library verilog;
use verilog.vl_types.all;
entity dps_uart is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iBAUDRATE       : in     vl_logic_vector(3 downto 0);
        iTX_EN          : in     vl_logic;
        iTX_CLEAR       : in     vl_logic;
        iTX_REQ         : in     vl_logic;
        oTX_BUSY        : out    vl_logic;
        iTX_DATA        : in     vl_logic_vector(7 downto 0);
        oTX_BUFF_CNT    : out    vl_logic_vector(3 downto 0);
        oTX_TRANSMIT    : out    vl_logic;
        iRX_EN          : in     vl_logic;
        iRX_CLEAR       : in     vl_logic;
        iRX_REQ         : in     vl_logic;
        oRX_EMPTY       : out    vl_logic;
        oRX_DATA        : out    vl_logic_vector(7 downto 0);
        oRX_BUFF_CNT    : out    vl_logic_vector(3 downto 0);
        oRX_RECEIVE     : out    vl_logic;
        oIRQ_VALID      : out    vl_logic;
        oUART_TXD       : out    vl_logic;
        iUART_RXD       : in     vl_logic
    );
end dps_uart;
