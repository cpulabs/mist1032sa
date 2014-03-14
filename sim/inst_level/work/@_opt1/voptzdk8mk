library verilog;
use verilog.vl_types.all;
entity mmu_if is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iFREE_TLB_FLUSH : in     vl_logic;
        iCORE_REQ       : in     vl_logic;
        oCORE_LOCK      : out    vl_logic;
        iCORE_DATA_STORE_ACK: in     vl_logic;
        iCORE_MMU_MODE  : in     vl_logic_vector(1 downto 0);
        iCORE_PDT       : in     vl_logic_vector(31 downto 0);
        iCORE_ORDER     : in     vl_logic_vector(1 downto 0);
        iCORE_MASK      : in     vl_logic_vector(3 downto 0);
        iCORE_RW        : in     vl_logic;
        iCORE_ADDR      : in     vl_logic_vector(31 downto 0);
        iCORE_DATA      : in     vl_logic_vector(31 downto 0);
        oCORE_REQ       : out    vl_logic;
        iCORE_LOCK      : in     vl_logic;
        oCORE_STORE_ACK : out    vl_logic;
        oCORE_PAGE_FAULT: out    vl_logic;
        oCORE_QUEUE_FLUSH: out    vl_logic;
        oCORE_DATA      : out    vl_logic_vector(63 downto 0);
        oCORE_MMU_FLAGS : out    vl_logic_vector(27 downto 0);
        oMEMORY_REQ     : out    vl_logic;
        iMEMORY_LOCK    : in     vl_logic;
        oMEMORY_ORDER   : out    vl_logic_vector(1 downto 0);
        oMEMORY_MASK    : out    vl_logic_vector(3 downto 0);
        oMEMORY_RW      : out    vl_logic;
        oMEMORY_ADDR    : out    vl_logic_vector(31 downto 0);
        oMEMORY_DATA    : out    vl_logic_vector(31 downto 0);
        iMEMORY_REQ     : in     vl_logic;
        oMEMORY_LOCK    : out    vl_logic;
        iMEMORY_DATA    : in     vl_logic_vector(63 downto 0)
    );
end mmu_if;
