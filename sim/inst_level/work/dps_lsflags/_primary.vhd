library verilog;
use verilog.vl_types.all;
entity dps_lsflags is
    port(
        iCLOCK          : in     vl_logic;
        inRESET         : in     vl_logic;
        iRESET_SYNC     : in     vl_logic;
        iSCI_VALID      : in     vl_logic;
        iSCI_SCITIE     : in     vl_logic;
        iSCI_SCIRIE     : in     vl_logic;
        iREAD_VALID     : in     vl_logic;
        oLSFLAGS_VALID  : out    vl_logic;
        oLSFLAGS        : out    vl_logic_vector(31 downto 0)
    );
end dps_lsflags;
