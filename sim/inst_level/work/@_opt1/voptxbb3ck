library verilog;
use verilog.vl_types.all;
entity dps_utim64 is
    generic(
        L_PARAM_MAIN_STT_IDLE: vl_logic := Hi0;
        L_PARAM_MAIN_STT_RD_WAIT: vl_logic := Hi1;
        L_PARAM_IRQ_STT_IDLE: vl_logic_vector(0 to 1) := (Hi0, Hi0);
        L_PARAM_IRQ_STT_IRQ: vl_logic_vector(0 to 1) := (Hi0, Hi1);
        L_PARAM_IRQ_STT_FLAG: vl_logic_vector(0 to 1) := (Hi1, Hi0)
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iTIMER_CLOCK    : in     vl_logic;
        iREQ_VALID      : in     vl_logic;
        oREQ_BUSY       : out    vl_logic;
        iREQ_RW         : in     vl_logic;
        iREQ_ADDR       : in     vl_logic_vector(4 downto 0);
        iREQ_DATA       : in     vl_logic_vector(31 downto 0);
        oREQ_VALID      : out    vl_logic;
        oREQ_DATA       : out    vl_logic_vector(31 downto 0);
        oIRQ_VALID      : out    vl_logic;
        iIRQ_ACK        : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of L_PARAM_MAIN_STT_IDLE : constant is 1;
    attribute mti_svvh_generic_type of L_PARAM_MAIN_STT_RD_WAIT : constant is 1;
    attribute mti_svvh_generic_type of L_PARAM_IRQ_STT_IDLE : constant is 1;
    attribute mti_svvh_generic_type of L_PARAM_IRQ_STT_IRQ : constant is 1;
    attribute mti_svvh_generic_type of L_PARAM_IRQ_STT_FLAG : constant is 1;
end dps_utim64;
