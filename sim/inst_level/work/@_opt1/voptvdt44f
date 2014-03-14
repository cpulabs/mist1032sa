library verilog;
use verilog.vl_types.all;
entity l1_instruction_cache is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iREMOVE         : in     vl_logic;
        iCACHE_FLASH    : in     vl_logic;
        oINST_REQ       : out    vl_logic;
        iINST_LOCK      : in     vl_logic;
        oINST_MMUMOD    : out    vl_logic_vector(1 downto 0);
        oINST_ADDR      : out    vl_logic_vector(31 downto 0);
        iINST_VALID     : in     vl_logic;
        oINST_BUSY      : out    vl_logic;
        iINST_PAGEFAULT : in     vl_logic;
        iINST_DATA      : in     vl_logic_vector(63 downto 0);
        iINST_MMU_FLAGS : in     vl_logic_vector(27 downto 0);
        iNEXT_FETCH_REQ : in     vl_logic;
        oNEXT_FETCH_LOCK: out    vl_logic;
        iNEXT_MMUMOD    : in     vl_logic_vector(1 downto 0);
        iNEXT_FETCH_ADDR: in     vl_logic_vector(31 downto 0);
        oNEXT_0_INST_VALID: out    vl_logic;
        oNEXT_0_PAGEFAULT: out    vl_logic;
        oNEXT_0_MMU_FLAGS: out    vl_logic_vector(13 downto 0);
        oNEXT_0_INST    : out    vl_logic_vector(31 downto 0);
        oNEXT_1_INST_VALID: out    vl_logic;
        oNEXT_1_PAGEFAULT: out    vl_logic;
        oNEXT_1_MMU_FLAGS: out    vl_logic_vector(13 downto 0);
        oNEXT_1_INST    : out    vl_logic_vector(31 downto 0);
        iNEXT_LOCK      : in     vl_logic
    );
end l1_instruction_cache;
