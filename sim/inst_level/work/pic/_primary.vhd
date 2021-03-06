library verilog;
use verilog.vl_types.all;
entity pic is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        oSYSINFO_IOSR_VALID: out    vl_logic;
        oSYSINFO_IOSR   : out    vl_logic_vector(31 downto 0);
        iIO_REQ         : in     vl_logic;
        oIO_BUSY        : out    vl_logic;
        iIO_ORDER       : in     vl_logic_vector(1 downto 0);
        iIO_RW          : in     vl_logic;
        iIO_ADDR        : in     vl_logic_vector(31 downto 0);
        iIO_DATA        : in     vl_logic_vector(31 downto 0);
        oIO_VALID       : out    vl_logic;
        iIO_BUSY        : in     vl_logic;
        oIO_DATA        : out    vl_logic_vector(31 downto 0);
        oIO_INTERRUPT_VALID: out    vl_logic;
        oIO_INTERRUPT_NUM: out    vl_logic_vector(5 downto 0);
        iIO_INTERRUPT_ACK: in     vl_logic;
        oDPS_REQ        : out    vl_logic;
        iDPS_BUSY       : in     vl_logic;
        oDPS_RW         : out    vl_logic;
        oDPS_ADDR       : out    vl_logic_vector(31 downto 0);
        oDPS_DATA       : out    vl_logic_vector(31 downto 0);
        iDPS_REQ        : in     vl_logic;
        oDPS_BUSY       : out    vl_logic;
        iDPS_DATA       : in     vl_logic_vector(31 downto 0);
        iDPS_IRQ_REQ    : in     vl_logic;
        iDPS_IRQ_NUM    : in     vl_logic_vector(5 downto 0);
        oDPS_IRQ_ACK    : out    vl_logic;
        oGCI_REQ        : out    vl_logic;
        iGCI_BUSY       : in     vl_logic;
        oGCI_RW         : out    vl_logic;
        oGCI_ADDR       : out    vl_logic_vector(31 downto 0);
        oGCI_DATA       : out    vl_logic_vector(31 downto 0);
        iGCI_REQ        : in     vl_logic;
        oGCI_BUSY       : out    vl_logic;
        iGCI_DATA       : in     vl_logic_vector(31 downto 0);
        iGCI_IRQ_REQ    : in     vl_logic;
        iGCI_IRQ_NUM    : in     vl_logic_vector(5 downto 0);
        oGCI_IRQ_ACK    : out    vl_logic
    );
end pic;
