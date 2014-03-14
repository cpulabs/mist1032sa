library verilog;
use verilog.vl_types.all;
entity decode_function is
    port(
        iINSTLUCTION    : in     vl_logic_vector(31 downto 0);
        oINF_ERROR      : out    vl_logic;
        oDECODE_SOURCE0_ACTIVE: out    vl_logic;
        oDECODE_SOURCE1_ACTIVE: out    vl_logic;
        oDECODE_SOURCE0_SYSREG: out    vl_logic;
        oDECODE_SOURCE1_SYSREG: out    vl_logic;
        oDECODE_SOURCE0_SYSREG_RENAME: out    vl_logic;
        oDECODE_SOURCE1_SYSREG_RENAME: out    vl_logic;
        oDECODE_ADV_ACTIVE: out    vl_logic;
        oDECODE_DESTINATION_SYSREG: out    vl_logic;
        oDECODE_DEST_RENAME: out    vl_logic;
        oDECODE_WRITEBACK: out    vl_logic;
        oDECODE_FLAGS_WRITEBACK: out    vl_logic;
        oDECODE_FRONT_COMMIT_WAIT: out    vl_logic;
        oDECODE_CMD     : out    vl_logic_vector(4 downto 0);
        oDECODE_CC_AFE  : out    vl_logic_vector(3 downto 0);
        oDECODE_SOURCE0 : out    vl_logic_vector(4 downto 0);
        oDECODE_SOURCE1 : out    vl_logic_vector(31 downto 0);
        oDECODE_ADV_DATA: out    vl_logic_vector(5 downto 0);
        oDECODE_SOURCE0_FLAGS: out    vl_logic;
        oDECODE_SOURCE1_IMM: out    vl_logic;
        oDECODE_DESTINATION: out    vl_logic_vector(4 downto 0);
        oDECODE_EX_SYS_REG: out    vl_logic;
        oDECODE_EX_SYS_LDST: out    vl_logic;
        oDECODE_EX_LOGIC: out    vl_logic;
        oDECODE_EX_SHIFT: out    vl_logic;
        oDECODE_EX_ADDER: out    vl_logic;
        oDECODE_EX_MUL  : out    vl_logic;
        oDECODE_EX_SDIV : out    vl_logic;
        oDECODE_EX_UDIV : out    vl_logic;
        oDECODE_EX_LDST : out    vl_logic;
        oDECODE_EX_BRANCH: out    vl_logic
    );
end decode_function;
