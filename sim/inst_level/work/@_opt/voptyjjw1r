library verilog;
use verilog.vl_types.all;
entity mmu is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iTLB_FLASH      : in     vl_logic;
        iLOGIC_REQ      : in     vl_logic;
        oLOGIC_LOCK     : out    vl_logic;
        iLOGIC_DATA_STORE_ACK: in     vl_logic;
        iLOGIC_MODE     : in     vl_logic_vector(1 downto 0);
        iLOGIC_PDT      : in     vl_logic_vector(31 downto 0);
        iLOGIC_ORDER    : in     vl_logic_vector(1 downto 0);
        iLOGIC_MASK     : in     vl_logic_vector(3 downto 0);
        iLOGIC_RW       : in     vl_logic;
        iLOGIC_ADDR     : in     vl_logic_vector(31 downto 0);
        iLOGIC_DATA     : in     vl_logic_vector(31 downto 0);
        oMMUFLAGS_REQ   : out    vl_logic;
        iMMUFLAGS_LOCK  : in     vl_logic;
        oMMUFLAGS_FLAGS : out    vl_logic_vector(27 downto 0);
        oPAGEFAULT_VALID: out    vl_logic;
        oMEMORY_REQ     : out    vl_logic;
        iMEMORY_LOCK    : in     vl_logic;
        oMEMORY_DATA_STORE_ACK: out    vl_logic;
        oMEMORY_MMU_USE : out    vl_logic;
        oMEMORY_ORDER   : out    vl_logic_vector(1 downto 0);
        oMEMORY_MASK    : out    vl_logic_vector(3 downto 0);
        oMEMORY_RW      : out    vl_logic;
        oMEMORY_ADDR    : out    vl_logic_vector(31 downto 0);
        oMEMORY_DATA    : out    vl_logic_vector(31 downto 0);
        iMEMORY_VALID   : in     vl_logic;
        oMEMORY_LOCK    : out    vl_logic;
        iMEMORY_DATA    : in     vl_logic_vector(63 downto 0)
    );
end mmu;
