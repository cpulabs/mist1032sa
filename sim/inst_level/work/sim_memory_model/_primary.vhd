library verilog;
use verilog.vl_types.all;
entity sim_memory_model is
    generic(
        P_MEM_INIT_LOAD : integer := 1;
        P_MEM_INIT_LOAD_FIEL: string  := "binary_file.bin";
        P_MEM_SIZE      : integer := 16777216
    );
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iMEMORY_REQ     : in     vl_logic;
        oMEMORY_LOCK    : out    vl_logic;
        iMEMORY_ORDER   : in     vl_logic_vector(1 downto 0);
        iMEMORY_MASK    : in     vl_logic_vector(3 downto 0);
        iMEMORY_RW      : in     vl_logic;
        iMEMORY_ADDR    : in     vl_logic_vector(31 downto 0);
        iMEMORY_DATA    : in     vl_logic_vector(31 downto 0);
        oMEMORY_VALID   : out    vl_logic;
        iMEMORY_LOCK    : in     vl_logic;
        oMEMORY_DATA    : out    vl_logic_vector(63 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of P_MEM_INIT_LOAD : constant is 1;
    attribute mti_svvh_generic_type of P_MEM_INIT_LOAD_FIEL : constant is 1;
    attribute mti_svvh_generic_type of P_MEM_SIZE : constant is 1;
end sim_memory_model;
