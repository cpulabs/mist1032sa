library verilog;
use verilog.vl_types.all;
entity execute_load_store is
    port(
        iCMD            : in     vl_logic_vector(4 downto 0);
        iLOADSTORE_MODE : in     vl_logic;
        iSOURCE0        : in     vl_logic_vector(31 downto 0);
        iSOURCE1        : in     vl_logic_vector(31 downto 0);
        iADV_ACTIVE     : in     vl_logic;
        iADV_DATA       : in     vl_logic_vector(31 downto 0);
        iSPR            : in     vl_logic_vector(31 downto 0);
        iPC             : in     vl_logic_vector(31 downto 0);
        oOUT_SPR_VALID  : out    vl_logic;
        oOUT_SPR        : out    vl_logic_vector(31 downto 0);
        oOUT_DATA       : out    vl_logic_vector(31 downto 0);
        oLDST_RW        : out    vl_logic;
        oLDST_ADDR      : out    vl_logic_vector(31 downto 0);
        oLDST_DATA      : out    vl_logic_vector(31 downto 0);
        oLDST_ORDER     : out    vl_logic_vector(1 downto 0);
        oLOAD_SHIFT     : out    vl_logic_vector(1 downto 0);
        oLOAD_MASK      : out    vl_logic_vector(3 downto 0)
    );
end execute_load_store;
