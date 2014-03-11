library verilog;
use verilog.vl_types.all;
entity dps is
    port(
        iCLOCK          : in     vl_logic;
        iDPS_BASE_CLOCK : in     vl_logic;
        inRESET         : in     vl_logic;
        iDPS_IRQ_CONFIG_TABLE_REQ: in     vl_logic;
        iDPS_IRQ_CONFIG_TABLE_ENTRY: in     vl_logic_vector(1 downto 0);
        iDPS_IRQ_CONFIG_TABLE_FLAG_MASK: in     vl_logic;
        iDPS_IRQ_CONFIG_TABLE_FLAG_VALID: in     vl_logic;
        iDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL: in     vl_logic_vector(1 downto 0);
        iDPS_REQ        : in     vl_logic;
        oDPS_BUSY       : out    vl_logic;
        iDPS_RW         : in     vl_logic;
        iDPS_ADDR       : in     vl_logic_vector(31 downto 0);
        iDPS_DATA       : in     vl_logic_vector(31 downto 0);
        oDPS_VALID      : out    vl_logic;
        oDPS_DATA       : out    vl_logic_vector(31 downto 0);
        oDPS_IRQ_REQ    : out    vl_logic;
        oDPS_IRQ_NUM    : out    vl_logic_vector(5 downto 0);
        iDPS_IRQ_ACK    : in     vl_logic;
        oSCI_TXD        : out    vl_logic;
        iSCI_RXD        : in     vl_logic
    );
end dps;
