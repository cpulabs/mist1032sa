library verilog;
use verilog.vl_types.all;
entity core_interrupt_manager is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iFREE_IRQ_SETCONDITION: in     vl_logic;
        iICT_VALID      : in     vl_logic;
        iICT_ENTRY      : in     vl_logic_vector(5 downto 0);
        iICT_CONF_MASK  : in     vl_logic;
        iICT_CONF_VALID : in     vl_logic;
        iICT_CONF_LEVEL : in     vl_logic_vector(1 downto 0);
        iSYSREGINFO_PSR : in     vl_logic_vector(31 downto 0);
        iEXT_ACTIVE     : in     vl_logic;
        iEXT_NUM        : in     vl_logic_vector(5 downto 0);
        oEXT_ACK        : out    vl_logic;
        iFAULT_ACTIVE   : in     vl_logic;
        iFAULT_NUM      : in     vl_logic_vector(6 downto 0);
        iFAULT_FI0R     : in     vl_logic_vector(31 downto 0);
        iEXCEPTION_LOCK : in     vl_logic;
        oEXCEPTION_ACTIVE: out    vl_logic;
        oEXCEPTION_IRQ_NUM: out    vl_logic_vector(6 downto 0);
        oEXCEPTION_IRQ_FI0R: out    vl_logic_vector(31 downto 0);
        iEXCEPTION_IRQ_ACK: in     vl_logic
    );
end core_interrupt_manager;
