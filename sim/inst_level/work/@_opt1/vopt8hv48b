library verilog;
use verilog.vl_types.all;
entity dps_sci is
    port(
        iIF_CLOCK       : in     vl_logic;
        iDPS_BASE_CLOCK : in     vl_logic;
        inRESET         : in     vl_logic;
        oLSFLAGS_TIRE_IRQ: out    vl_logic;
        oLSFLAGS_RIRE_IRQ: out    vl_logic;
        iREQ_VALID      : in     vl_logic;
        oREQ_BUSY       : out    vl_logic;
        iREQ_RW         : in     vl_logic;
        iREQ_ADDR       : in     vl_logic_vector(1 downto 0);
        iREQ_DATA       : in     vl_logic_vector(31 downto 0);
        oREQ_VALID      : out    vl_logic;
        oREQ_DATA       : out    vl_logic_vector(31 downto 0);
        oIRQ_VALID      : out    vl_logic;
        iIRQ_ACK        : in     vl_logic;
        oUART_TXD       : out    vl_logic;
        iUART_RXD       : in     vl_logic
    );
end dps_sci;
