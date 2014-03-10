library verilog;
use verilog.vl_types.all;
entity renaming is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iFREE_DEFAULT   : in     vl_logic;
        iFREE_RESTART   : in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE0_VALID: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE0_LREGNAME: in     vl_logic_vector(4 downto 0);
        iROLLBACK_UPDATE_CANDIDATE0_PREGNAME: in     vl_logic_vector(5 downto 0);
        iROLLBACK_UPDATE_CANDIDATE0_SYSREG: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE1_VALID: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE1_LREGNAME: in     vl_logic_vector(4 downto 0);
        iROLLBACK_UPDATE_CANDIDATE1_PREGNAME: in     vl_logic_vector(5 downto 0);
        iROLLBACK_UPDATE_CANDIDATE1_SYSREG: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE2_VALID: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE2_LREGNAME: in     vl_logic_vector(4 downto 0);
        iROLLBACK_UPDATE_CANDIDATE2_PREGNAME: in     vl_logic_vector(5 downto 0);
        iROLLBACK_UPDATE_CANDIDATE2_SYSREG: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE3_VALID: in     vl_logic;
        iROLLBACK_UPDATE_CANDIDATE3_LREGNAME: in     vl_logic_vector(4 downto 0);
        iROLLBACK_UPDATE_CANDIDATE3_PREGNAME: in     vl_logic_vector(5 downto 0);
        iROLLBACK_UPDATE_CANDIDATE3_SYSREG: in     vl_logic;
        iFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_VALID: in     vl_logic;
        iFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_PREGNAME: in     vl_logic_vector(3 downto 0);
        iFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_VALID: in     vl_logic;
        iFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_PREGNAME: in     vl_logic_vector(3 downto 0);
        iFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_VALID: in     vl_logic;
        iFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_PREGNAME: in     vl_logic_vector(3 downto 0);
        iFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_VALID: in     vl_logic;
        iFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_PREGNAME: in     vl_logic_vector(3 downto 0);
        oSTAGE_INFO_0_VALID: out    vl_logic;
        oSTAGE_INFO_1_VALID: out    vl_logic;
        iPREVIOUS_0_VALID: in     vl_logic;
        iPREVIOUS_0_SOURCE0_ACTIVE: in     vl_logic;
        iPREVIOUS_0_SOURCE1_ACTIVE: in     vl_logic;
        iPREVIOUS_0_SOURCE0_SYSREG: in     vl_logic;
        iPREVIOUS_0_SOURCE1_SYSREG: in     vl_logic;
        iPREVIOUS_0_SOURCE0_SYSREG_RENAME: in     vl_logic;
        iPREVIOUS_0_SOURCE1_SYSREG_RENAME: in     vl_logic;
        iPREVIOUS_0_ADV_ACTIVE: in     vl_logic;
        iPREVIOUS_0_DESTINATION_SYSREG: in     vl_logic;
        iPREVIOUS_0_DEST_RENAME: in     vl_logic;
        iPREVIOUS_0_WRITEBACK: in     vl_logic;
        iPREVIOUS_0_FLAGS_WRITEBACK: in     vl_logic;
        iPREVIOUS_0_CMD : in     vl_logic_vector(4 downto 0);
        iPREVIOUS_0_CC_AFE: in     vl_logic_vector(3 downto 0);
        iPREVIOUS_0_SOURCE0: in     vl_logic_vector(4 downto 0);
        iPREVIOUS_0_SOURCE1: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_0_ADV_DATA: in     vl_logic_vector(5 downto 0);
        iPREVIOUS_0_SOURCE0_FLAGS: in     vl_logic;
        iPREVIOUS_0_SOURCE1_IMM: in     vl_logic;
        iPREVIOUS_0_DESTINATION: in     vl_logic_vector(4 downto 0);
        iPREVIOUS_0_EX_LOGIC: in     vl_logic;
        iPREVIOUS_0_EX_SYS_ADDER: in     vl_logic;
        iPREVIOUS_0_EX_SYS_LDST: in     vl_logic;
        iPREVIOUS_0_EX_SHIFT: in     vl_logic;
        iPREVIOUS_0_EX_ADDER: in     vl_logic;
        iPREVIOUS_0_EX_MUL: in     vl_logic;
        iPREVIOUS_0_EX_SDIV: in     vl_logic;
        iPREVIOUS_0_EX_UDIV: in     vl_logic;
        iPREVIOUS_0_EX_LDST: in     vl_logic;
        iPREVIOUS_0_EX_BRANCH: in     vl_logic;
        iPREVIOUS_1_VALID: in     vl_logic;
        iPREVIOUS_1_SOURCE0_ACTIVE: in     vl_logic;
        iPREVIOUS_1_SOURCE1_ACTIVE: in     vl_logic;
        iPREVIOUS_1_SOURCE0_SYSREG: in     vl_logic;
        iPREVIOUS_1_SOURCE1_SYSREG: in     vl_logic;
        iPREVIOUS_1_SOURCE0_SYSREG_RENAME: in     vl_logic;
        iPREVIOUS_1_SOURCE1_SYSREG_RENAME: in     vl_logic;
        iPREVIOUS_1_ADV_ACTIVE: in     vl_logic;
        iPREVIOUS_1_DESTINATION_SYSREG: in     vl_logic;
        iPREVIOUS_1_DEST_RENAME: in     vl_logic;
        iPREVIOUS_1_WRITEBACK: in     vl_logic;
        iPREVIOUS_1_FLAGS_WRITEBACK: in     vl_logic;
        iPREVIOUS_1_CMD : in     vl_logic_vector(4 downto 0);
        iPREVIOUS_1_CC_AFE: in     vl_logic_vector(3 downto 0);
        iPREVIOUS_1_SOURCE0: in     vl_logic_vector(4 downto 0);
        iPREVIOUS_1_SOURCE1: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_1_ADV_DATA: in     vl_logic_vector(5 downto 0);
        iPREVIOUS_1_SOURCE0_FLAGS: in     vl_logic;
        iPREVIOUS_1_SOURCE1_IMM: in     vl_logic;
        iPREVIOUS_1_DESTINATION: in     vl_logic_vector(4 downto 0);
        iPREVIOUS_1_EX_SYS_ADDER: in     vl_logic;
        iPREVIOUS_1_EX_SYS_LDST: in     vl_logic;
        iPREVIOUS_1_EX_LOGIC: in     vl_logic;
        iPREVIOUS_1_EX_SHIFT: in     vl_logic;
        iPREVIOUS_1_EX_ADDER: in     vl_logic;
        iPREVIOUS_1_EX_MUL: in     vl_logic;
        iPREVIOUS_1_EX_SDIV: in     vl_logic;
        iPREVIOUS_1_EX_UDIV: in     vl_logic;
        iPREVIOUS_1_EX_LDST: in     vl_logic;
        iPREVIOUS_1_EX_BRANCH: in     vl_logic;
        iPREVIOUS_PC    : in     vl_logic_vector(31 downto 0);
        oPREVIOUS_LOCK  : out    vl_logic;
        oFLAG_REGISTER_0_RD: out    vl_logic;
        iFLAG_REGISTER_0_NUM: in     vl_logic_vector(3 downto 0);
        iFLAG_REGISTER_0_EMPTY: in     vl_logic;
        oFLAG_REGISTER_1_RD: out    vl_logic;
        iFLAG_REGISTER_1_NUM: in     vl_logic_vector(3 downto 0);
        iFLAG_REGISTER_1_EMPTY: in     vl_logic;
        oOTHER_REGISTER_0_RD: out    vl_logic;
        iOTHER_REGISTER_0_NUM: in     vl_logic_vector(5 downto 0);
        iOTHER_REGISTER_0_EMPTY: in     vl_logic;
        oOTHER_REGISTER_1_RD: out    vl_logic;
        iOTHER_REGISTER_1_NUM: in     vl_logic_vector(5 downto 0);
        iOTHER_REGISTER_1_EMPTY: in     vl_logic;
        oNEXT_0_VALID   : out    vl_logic;
        oNEXT_0_SOURCE0_ACTIVE: out    vl_logic;
        oNEXT_0_SOURCE1_ACTIVE: out    vl_logic;
        oNEXT_0_SOURCE0_SYSREG: out    vl_logic;
        oNEXT_0_SOURCE1_SYSREG: out    vl_logic;
        oNEXT_0_SOURCE0_SYSREG_RENAME: out    vl_logic;
        oNEXT_0_SOURCE1_SYSREG_RENAME: out    vl_logic;
        oNEXT_0_ADV_ACTIVE: out    vl_logic;
        oNEXT_0_DESTINATION_SYSREG: out    vl_logic;
        oNEXT_0_WRITEBACK: out    vl_logic;
        oNEXT_0_FLAGS_WRITEBACK: out    vl_logic;
        oNEXT_0_CMD     : out    vl_logic_vector(4 downto 0);
        oNEXT_0_CC_AFE  : out    vl_logic_vector(3 downto 0);
        oNEXT_0_FLAGS_REGNAME: out    vl_logic_vector(3 downto 0);
        oNEXT_0_DESTINATION_REGNAME: out    vl_logic_vector(5 downto 0);
        oNEXT_0_LOGIC_DESTINATION: out    vl_logic_vector(4 downto 0);
        oNEXT_0_SOURCE0 : out    vl_logic_vector(5 downto 0);
        oNEXT_0_SOURCE1 : out    vl_logic_vector(31 downto 0);
        oNEXT_0_ADV_DATA: out    vl_logic_vector(5 downto 0);
        oNEXT_0_SOURCE0_FLAGS: out    vl_logic;
        oNEXT_0_SOURCE1_IMM: out    vl_logic;
        oNEXT_0_EX_SYS_ADDER: out    vl_logic;
        oNEXT_0_EX_SYS_LDST: out    vl_logic;
        oNEXT_0_EX_LOGIC: out    vl_logic;
        oNEXT_0_EX_SHIFT: out    vl_logic;
        oNEXT_0_EX_ADDER: out    vl_logic;
        oNEXT_0_EX_MUL  : out    vl_logic;
        oNEXT_0_EX_SDIV : out    vl_logic;
        oNEXT_0_EX_UDIV : out    vl_logic;
        oNEXT_0_EX_LDST : out    vl_logic;
        oNEXT_0_EX_BRANCH: out    vl_logic;
        oNEXT_1_VALID   : out    vl_logic;
        oNEXT_1_SOURCE0_ACTIVE: out    vl_logic;
        oNEXT_1_SOURCE1_ACTIVE: out    vl_logic;
        oNEXT_1_SOURCE0_SYSREG: out    vl_logic;
        oNEXT_1_SOURCE1_SYSREG: out    vl_logic;
        oNEXT_1_SOURCE0_SYSREG_RENAME: out    vl_logic;
        oNEXT_1_SOURCE1_SYSREG_RENAME: out    vl_logic;
        oNEXT_1_ADV_ACTIVE: out    vl_logic;
        oNEXT_1_DESTINATION_SYSREG: out    vl_logic;
        oNEXT_1_WRITEBACK: out    vl_logic;
        oNEXT_1_FLAGS_WRITEBACK: out    vl_logic;
        oNEXT_1_CMD     : out    vl_logic_vector(4 downto 0);
        oNEXT_1_CC_AFE  : out    vl_logic_vector(3 downto 0);
        oNEXT_1_FLAGS_REGNAME: out    vl_logic_vector(3 downto 0);
        oNEXT_1_DESTINATION_REGNAME: out    vl_logic_vector(5 downto 0);
        oNEXT_1_LOGIC_DESTINATION: out    vl_logic_vector(4 downto 0);
        oNEXT_1_SOURCE0 : out    vl_logic_vector(5 downto 0);
        oNEXT_1_SOURCE1 : out    vl_logic_vector(31 downto 0);
        oNEXT_1_ADV_DATA: out    vl_logic_vector(5 downto 0);
        oNEXT_1_SOURCE0_FLAGS: out    vl_logic;
        oNEXT_1_SOURCE1_IMM: out    vl_logic;
        oNEXT_1_EX_SYS_ADDER: out    vl_logic;
        oNEXT_1_EX_SYS_LDST: out    vl_logic;
        oNEXT_1_EX_LOGIC: out    vl_logic;
        oNEXT_1_EX_SHIFT: out    vl_logic;
        oNEXT_1_EX_ADDER: out    vl_logic;
        oNEXT_1_EX_MUL  : out    vl_logic;
        oNEXT_1_EX_SDIV : out    vl_logic;
        oNEXT_1_EX_UDIV : out    vl_logic;
        oNEXT_1_EX_LDST : out    vl_logic;
        oNEXT_1_EX_BRANCH: out    vl_logic;
        oNEXT_PC        : out    vl_logic_vector(31 downto 0);
        iNEXT_LOCK      : in     vl_logic
    );
end renaming;
