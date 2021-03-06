library verilog;
use verilog.vl_types.all;
entity decoder is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iRESET_SYNC     : in     vl_logic;
        iPREVIOUS_COMMON_VALID: in     vl_logic;
        iPREVIOUS_0_INST_VALID: in     vl_logic;
        iPREVIOUS_0_PAGEFAULT: in     vl_logic;
        iPREVIOUS_0_PAGING_ENA: in     vl_logic;
        iPREVIOUS_0_KERNEL_ACCESS: in     vl_logic;
        iPREVIOUS_0_BRANCH_PREDICT: in     vl_logic;
        iPREVIOUS_0_BRANCH_PREDICT_ADDR: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_0_INST: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_1_INST_VALID: in     vl_logic;
        iPREVIOUS_1_PAGEFAULT: in     vl_logic;
        iPREVIOUS_1_PAGING_ENA: in     vl_logic;
        iPREVIOUS_1_KERNEL_ACCESS: in     vl_logic;
        iPREVIOUS_1_BRANCH_PREDICT: in     vl_logic;
        iPREVIOUS_1_BRANCH_PREDICT_ADDR: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_1_INST: in     vl_logic_vector(31 downto 0);
        iPREVIOUS_PC    : in     vl_logic_vector(31 downto 0);
        oPREVIOUS_LOCK  : out    vl_logic;
        oNEXT_COMMON_VALID: out    vl_logic;
        oNEXT_0_VALID   : out    vl_logic;
        oNEXT_0_FAULT_PAGEFAULT: out    vl_logic;
        oNEXT_0_FAULT_PRIVILEGE_ERROR: out    vl_logic;
        oNEXT_0_FAULT_INVALID_INST: out    vl_logic;
        oNEXT_0_PAGING_ENA: out    vl_logic;
        oNEXT_0_KERNEL_ACCESS: out    vl_logic;
        oNEXT_0_BRANCH_PREDICT: out    vl_logic;
        oNEXT_0_BRANCH_PREDICT_ADDR: out    vl_logic_vector(31 downto 0);
        oNEXT_0_SOURCE0_ACTIVE: out    vl_logic;
        oNEXT_0_SOURCE1_ACTIVE: out    vl_logic;
        oNEXT_0_SOURCE0_SYSREG: out    vl_logic;
        oNEXT_0_SOURCE1_SYSREG: out    vl_logic;
        oNEXT_0_SOURCE0_SYSREG_RENAME: out    vl_logic;
        oNEXT_0_SOURCE1_SYSREG_RENAME: out    vl_logic;
        oNEXT_0_ADV_ACTIVE: out    vl_logic;
        oNEXT_0_DESTINATION_SYSREG: out    vl_logic;
        oNEXT_0_DEST_RENAME: out    vl_logic;
        oNEXT_0_WRITEBACK: out    vl_logic;
        oNEXT_0_FLAGS_WRITEBACK: out    vl_logic;
        oNEXT_0_FRONT_COMMIT_WAIT: out    vl_logic;
        oNEXT_0_CMD     : out    vl_logic_vector(4 downto 0);
        oNEXT_0_CC_AFE  : out    vl_logic_vector(3 downto 0);
        oNEXT_0_SOURCE0 : out    vl_logic_vector(4 downto 0);
        oNEXT_0_SOURCE1 : out    vl_logic_vector(31 downto 0);
        oNEXT_0_ADV_DATA: out    vl_logic_vector(5 downto 0);
        oNEXT_0_SOURCE0_FLAGS: out    vl_logic;
        oNEXT_0_SOURCE1_IMM: out    vl_logic;
        oNEXT_0_DESTINATION: out    vl_logic_vector(4 downto 0);
        oNEXT_0_EX_SYS_REG: out    vl_logic;
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
        oNEXT_1_FAULT_PAGEFAULT: out    vl_logic;
        oNEXT_1_FAULT_PRIVILEGE_ERROR: out    vl_logic;
        oNEXT_1_FAULT_INVALID_INST: out    vl_logic;
        oNEXT_1_PAGING_ENA: out    vl_logic;
        oNEXT_1_KERNEL_ACCESS: out    vl_logic;
        oNEXT_1_BRANCH_PREDICT: out    vl_logic;
        oNEXT_1_BRANCH_PREDICT_ADDR: out    vl_logic_vector(31 downto 0);
        oNEXT_1_SOURCE0_ACTIVE: out    vl_logic;
        oNEXT_1_SOURCE1_ACTIVE: out    vl_logic;
        oNEXT_1_SOURCE0_SYSREG: out    vl_logic;
        oNEXT_1_SOURCE1_SYSREG: out    vl_logic;
        oNEXT_1_SOURCE0_SYSREG_RENAME: out    vl_logic;
        oNEXT_1_SOURCE1_SYSREG_RENAME: out    vl_logic;
        oNEXT_1_ADV_ACTIVE: out    vl_logic;
        oNEXT_1_DESTINATION_SYSREG: out    vl_logic;
        oNEXT_1_DEST_RENAME: out    vl_logic;
        oNEXT_1_WRITEBACK: out    vl_logic;
        oNEXT_1_FLAGS_WRITEBACK: out    vl_logic;
        oNEXT_1_FRONT_COMMIT_WAIT: out    vl_logic;
        oNEXT_1_CMD     : out    vl_logic_vector(4 downto 0);
        oNEXT_1_CC_AFE  : out    vl_logic_vector(3 downto 0);
        oNEXT_1_SOURCE0 : out    vl_logic_vector(4 downto 0);
        oNEXT_1_SOURCE1 : out    vl_logic_vector(31 downto 0);
        oNEXT_1_ADV_DATA: out    vl_logic_vector(5 downto 0);
        oNEXT_1_SOURCE0_FLAGS: out    vl_logic;
        oNEXT_1_SOURCE1_IMM: out    vl_logic;
        oNEXT_1_DESTINATION: out    vl_logic_vector(4 downto 0);
        oNEXT_1_EX_SYS_REG: out    vl_logic;
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
end decoder;
