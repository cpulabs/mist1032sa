library verilog;
use verilog.vl_types.all;
entity core_pipeline is
    generic(
        CORE_ID         : integer := 0
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        oFREE_TLB_FLUSH : out    vl_logic;
        oIO_IRQ_CONFIG_TABLE_REQ: out    vl_logic;
        oIO_IRQ_CONFIG_TABLE_ENTRY: out    vl_logic_vector(5 downto 0);
        oIO_IRQ_CONFIG_TABLE_FLAG_MASK: out    vl_logic;
        oIO_IRQ_CONFIG_TABLE_FLAG_VALID: out    vl_logic;
        oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL: out    vl_logic_vector(1 downto 0);
        oINST_REQ       : out    vl_logic;
        iINST_LOCK      : in     vl_logic;
        oINST_MMUMOD    : out    vl_logic_vector(1 downto 0);
        oINST_PDT       : out    vl_logic_vector(31 downto 0);
        oINST_ADDR      : out    vl_logic_vector(31 downto 0);
        iINST_VALID     : in     vl_logic;
        oINST_BUSY      : out    vl_logic;
        iINST_PAGEFAULT : in     vl_logic;
        iINST_QUEUE_FLUSH: in     vl_logic;
        iINST_DATA      : in     vl_logic_vector(63 downto 0);
        iINST_MMU_FLAGS : in     vl_logic_vector(27 downto 0);
        oDATA_REQ       : out    vl_logic;
        iDATA_LOCK      : in     vl_logic;
        oDATA_ORDER     : out    vl_logic_vector(1 downto 0);
        oDATA_MASK      : out    vl_logic_vector(3 downto 0);
        oDATA_RW        : out    vl_logic;
        oDATA_TID       : out    vl_logic_vector(13 downto 0);
        oDATA_MMUMOD    : out    vl_logic_vector(1 downto 0);
        oDATA_PDT       : out    vl_logic_vector(31 downto 0);
        oDATA_ADDR      : out    vl_logic_vector(31 downto 0);
        oDATA_DATA      : out    vl_logic_vector(31 downto 0);
        iDATA_VALID     : in     vl_logic;
        iDATA_PAGEFAULT : in     vl_logic;
        iDATA_DATA      : in     vl_logic_vector(63 downto 0);
        iDATA_MMU_FLAGS : in     vl_logic_vector(27 downto 0);
        oIO_REQ         : out    vl_logic;
        iIO_BUSY        : in     vl_logic;
        oIO_ORDER       : out    vl_logic_vector(1 downto 0);
        oIO_RW          : out    vl_logic;
        oIO_ADDR        : out    vl_logic_vector(31 downto 0);
        oIO_DATA        : out    vl_logic_vector(31 downto 0);
        iIO_VALID       : in     vl_logic;
        iIO_DATA        : in     vl_logic_vector(31 downto 0);
        iINTERRUPT_VALID: in     vl_logic;
        iINTERRUPT_NUM  : in     vl_logic_vector(5 downto 0);
        oINTERRUPT_ACK  : out    vl_logic;
        iSYSINFO_IOSR_VALID: in     vl_logic;
        iSYSINFO_IOSR   : in     vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CORE_ID : constant is 1;
end core_pipeline;
