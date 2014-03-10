library verilog;
use verilog.vl_types.all;
entity dps_irq is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iDPS_IRQ_CONFIG_TABLE_REQ: in     vl_logic;
        iDPS_IRQ_CONFIG_TABLE_ENTRY: in     vl_logic_vector(1 downto 0);
        iDPS_IRQ_CONFIG_TABLE_FLAG_MASK: in     vl_logic;
        iDPS_IRQ_CONFIG_TABLE_FLAG_VALID: in     vl_logic;
        iDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL: in     vl_logic_vector(1 downto 0);
        iUTIM64FLAGS_IRQ: in     vl_logic;
        oUTIM64FLAGS_ACK: out    vl_logic;
        iLSFLAGS_IRQ    : in     vl_logic;
        oLSFLAGS_ACK    : out    vl_logic;
        oIRQ_VALID      : out    vl_logic;
        oIRQ_NUM        : out    vl_logic;
        iIRQ_ACK        : in     vl_logic
    );
end dps_irq;
