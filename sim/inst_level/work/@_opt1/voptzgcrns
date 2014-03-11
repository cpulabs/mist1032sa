library verilog;
use verilog.vl_types.all;
entity utim64 is
    port(
        iIF_CLOCK       : in     vl_logic;
        iTIMER_CLOCK    : in     vl_logic;
        inRESET         : in     vl_logic;
        iREQ_VALID      : in     vl_logic;
        oREQ_BUSY       : out    vl_logic;
        iREQ_RW         : in     vl_logic;
        iREQ_ADDR       : in     vl_logic_vector(3 downto 0);
        iREQ_DATA       : in     vl_logic_vector(31 downto 0);
        oREQ_VALID      : out    vl_logic;
        oREQ_DATA       : out    vl_logic_vector(31 downto 0);
        oIRQ_IRQ        : out    vl_logic_vector(3 downto 0)
    );
end utim64;
